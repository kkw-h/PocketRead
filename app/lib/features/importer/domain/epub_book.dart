import 'dart:typed_data';

class EpubParsedBook {
  const EpubParsedBook({
    required this.title,
    required this.author,
    required this.language,
    required this.chapters,
    this.cover,
  });

  final String title;
  final String author;
  final String language;
  final List<EpubChapter> chapters;
  final EpubCover? cover;
}

class EpubChapter {
  const EpubChapter({
    required this.index,
    required this.title,
    required this.href,
    required this.htmlContent,
    required this.plainText,
    required this.wordCount,
    this.anchor,
    this.level = 1,
  });

  final int index;
  final String title;
  final String href;
  final String? anchor;
  final String htmlContent;
  final String plainText;
  final int wordCount;
  final int level;
}

class EpubCover {
  const EpubCover({required this.fileName, required this.bytes});

  final String fileName;
  final Uint8List bytes;
}

class EpubParseException implements Exception {
  const EpubParseException(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}
