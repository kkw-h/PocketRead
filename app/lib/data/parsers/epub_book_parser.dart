import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:pocketread/features/importer/domain/epub_book.dart';
import 'package:xml/xml.dart';

class EpubBookParser {
  const EpubBookParser();

  Future<EpubParsedBook> parseFile(File file) async {
    final Archive archive = ZipDecoder().decodeBytes(await file.readAsBytes());
    final _ArchiveReader reader = _ArchiveReader(archive);
    final String containerXml = reader.readText('META-INF/container.xml');
    final XmlDocument container = XmlDocument.parse(containerXml);
    final String? opfPath = container
        .findAllElements('rootfile')
        .firstOrNull
        ?.getAttribute('full-path');
    if (opfPath == null || opfPath.isEmpty) {
      throw const EpubParseException('EPUB 缺少 OPF 入口');
    }

    final String opfText = reader.readText(opfPath);
    final XmlDocument opf = XmlDocument.parse(opfText);
    final String opfDirectory = p.posix.dirname(opfPath);
    final XmlElement package = opf.rootElement;
    final XmlElement? metadata = package.getElement('metadata');
    final XmlElement? manifest = package.getElement('manifest');
    final XmlElement? spine = package.getElement('spine');
    if (manifest == null || spine == null) {
      throw const EpubParseException('EPUB 缺少 manifest 或 spine');
    }

    final Map<String, _ManifestItem> manifestItems = <String, _ManifestItem>{
      for (final XmlElement item in manifest.findElements('item'))
        if (item.getAttribute('id') != null &&
            item.getAttribute('href') != null)
          item.getAttribute('id')!: _ManifestItem(
            id: item.getAttribute('id')!,
            href: item.getAttribute('href')!,
            mediaType: item.getAttribute('media-type') ?? '',
            properties: item.getAttribute('properties') ?? '',
          ),
    };
    final Map<String, _TocItem> tocItems = _readTocItems(
      reader: reader,
      opfDirectory: opfDirectory,
      manifestItems: manifestItems,
      spine: spine,
    );

    final List<EpubChapter> chapters = <EpubChapter>[];
    for (final XmlElement itemRef in spine.findElements('itemref')) {
      final String? idref = itemRef.getAttribute('idref');
      final _ManifestItem? item = idref == null ? null : manifestItems[idref];
      if (item == null || !item.mediaType.contains('xhtml')) {
        continue;
      }
      final String fullPath = _joinPath(opfDirectory, item.href);
      final String html = reader.readText(fullPath);
      final String normalizedHref = _normalizeHref(item.href);
      final _TocItem? tocItem = tocItems[normalizedHref];
      if (tocItem == null && item.href.toLowerCase().contains('cover')) {
        continue;
      }
      final String plainText = _extractPlainText(html);
      final String title =
          tocItem?.title ?? _extractTitle(html) ?? '第 ${chapters.length + 1} 章';
      chapters.add(
        EpubChapter(
          index: chapters.length,
          title: title,
          href: item.href,
          anchor: tocItem?.anchor,
          htmlContent: html,
          plainText: plainText,
          wordCount: _countWords(plainText),
          level: tocItem?.level ?? 1,
        ),
      );
    }

    return EpubParsedBook(
      title: _metadataText(metadata, 'title'),
      author: _metadataText(metadata, 'creator'),
      language: _metadataText(metadata, 'language'),
      cover: _readCover(
        reader: reader,
        opfDirectory: opfDirectory,
        metadata: metadata,
        manifestItems: manifestItems,
      ),
      chapters: chapters,
    );
  }

  Map<String, _TocItem> _readTocItems({
    required _ArchiveReader reader,
    required String opfDirectory,
    required Map<String, _ManifestItem> manifestItems,
    required XmlElement spine,
  }) {
    final String? tocId = spine.getAttribute('toc');
    final _ManifestItem? ncxItem = tocId == null ? null : manifestItems[tocId];
    if (ncxItem == null) {
      return <String, _TocItem>{};
    }

    final String ncxPath = _joinPath(opfDirectory, ncxItem.href);
    if (!reader.exists(ncxPath)) {
      return <String, _TocItem>{};
    }
    final XmlDocument ncx = XmlDocument.parse(reader.readText(ncxPath));
    final Map<String, _TocItem> toc = <String, _TocItem>{};
    for (final XmlElement navPoint in ncx.findAllElements('navPoint')) {
      final XmlElement? content = navPoint.getElement('content');
      final String? src = content?.getAttribute('src');
      if (src == null || src.isEmpty) {
        continue;
      }
      final String title =
          navPoint
              .getElement('navLabel')
              ?.getElement('text')
              ?.innerText
              .trim() ??
          '';
      final _HrefParts parts = _splitHref(src);
      toc[_normalizeHref(parts.path)] = _TocItem(
        title: title.isEmpty ? parts.path : title,
        anchor: parts.anchor,
        level: _tocLevel(navPoint),
      );
    }
    return toc;
  }

  EpubCover? _readCover({
    required _ArchiveReader reader,
    required String opfDirectory,
    required XmlElement? metadata,
    required Map<String, _ManifestItem> manifestItems,
  }) {
    final String? coverId = metadata
        ?.findElements('meta')
        .where((XmlElement element) => element.getAttribute('name') == 'cover')
        .firstOrNull
        ?.getAttribute('content');
    final _ManifestItem? coverItem = coverId == null
        ? null
        : manifestItems[coverId];
    final _ManifestItem? fallbackCover = manifestItems.values.where((
      _ManifestItem item,
    ) {
      return item.properties.split(' ').contains('cover-image') ||
          item.href.toLowerCase().contains('cover');
    }).firstOrNull;
    final _ManifestItem? item = coverItem ?? fallbackCover;
    if (item == null) {
      return null;
    }

    final String coverPath = _joinPath(opfDirectory, item.href);
    if (!reader.exists(coverPath)) {
      return null;
    }
    return EpubCover(
      fileName: p.posix.basename(item.href),
      bytes: reader.readBytes(coverPath),
    );
  }

  String _metadataText(XmlElement? metadata, String localName) {
    return metadata?.descendants
            .whereType<XmlElement>()
            .where((XmlElement element) => element.name.local == localName)
            .firstOrNull
            ?.innerText
            .trim() ??
        '';
  }

  String? _extractTitle(String html) {
    try {
      final XmlDocument document = XmlDocument.parse(html);
      for (final String tagName in <String>['h1', 'h2', 'h3', 'h4', 'title']) {
        final String? title = document
            .findAllElements(tagName)
            .firstOrNull
            ?.innerText
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
        if (title != null && title.isNotEmpty) {
          return title;
        }
      }
    } on XmlException {
      return null;
    }
    return null;
  }

  String _extractPlainText(String html) {
    try {
      final XmlDocument document = XmlDocument.parse(html);
      final XmlElement? body = document.findAllElements('body').firstOrNull;
      final String text = (body ?? document.rootElement).innerText;
      return text.replaceAll(RegExp(r'\s+'), ' ').trim();
    } on XmlException {
      return html
          .replaceAll(RegExp(r'<[^>]+>'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
    }
  }

  int _countWords(String text) {
    return text.replaceAll(RegExp(r'\s+'), '').length;
  }

  int _tocLevel(XmlElement navPoint) {
    int level = 1;
    XmlNode? parent = navPoint.parent;
    while (parent != null) {
      if (parent is XmlElement && parent.name.local == 'navPoint') {
        level += 1;
      }
      parent = parent.parent;
    }
    return level;
  }

  String _joinPath(String directory, String href) {
    if (directory == '.' || directory.isEmpty) {
      return p.posix.normalize(href);
    }
    return p.posix.normalize(p.posix.join(directory, href));
  }

  String _normalizeHref(String href) {
    return p.posix.normalize(Uri.decodeFull(href));
  }

  _HrefParts _splitHref(String href) {
    final int anchorIndex = href.indexOf('#');
    if (anchorIndex < 0) {
      return _HrefParts(path: href);
    }
    return _HrefParts(
      path: href.substring(0, anchorIndex),
      anchor: href.substring(anchorIndex + 1),
    );
  }
}

class _ArchiveReader {
  _ArchiveReader(Archive archive)
    : _files = <String, ArchiveFile>{
        for (final ArchiveFile file in archive.files)
          p.posix.normalize(file.name): file,
      };

  final Map<String, ArchiveFile> _files;

  bool exists(String path) {
    return _files.containsKey(p.posix.normalize(path));
  }

  String readText(String path) {
    return utf8.decode(readBytes(path), allowMalformed: true);
  }

  Uint8List readBytes(String path) {
    final ArchiveFile? file = _files[p.posix.normalize(path)];
    if (file == null) {
      throw EpubParseException('EPUB 缺少文件：$path');
    }
    return file.content;
  }
}

class _ManifestItem {
  const _ManifestItem({
    required this.id,
    required this.href,
    required this.mediaType,
    required this.properties,
  });

  final String id;
  final String href;
  final String mediaType;
  final String properties;
}

class _TocItem {
  const _TocItem({required this.title, required this.level, this.anchor});

  final String title;
  final String? anchor;
  final int level;
}

class _HrefParts {
  const _HrefParts({required this.path, this.anchor});

  final String path;
  final String? anchor;
}
