import 'package:path/path.dart' as p;
import 'package:pocketread/features/importer/domain/book_file_format.dart';

class BookFileMetadataParser {
  const BookFileMetadataParser();

  BookFileMetadata parse(String sourcePath) {
    final String fileName = p.basename(sourcePath);
    final String extension = p
        .extension(fileName)
        .replaceFirst('.', '')
        .toLowerCase();
    final BookFileFormat format = switch (extension) {
      'txt' => BookFileFormat.txt,
      'epub' => BookFileFormat.epub,
      _ => throw UnsupportedBookFormatException(fileName),
    };

    final String baseName = p.basenameWithoutExtension(fileName).trim();
    final _TitleAuthor titleAuthor = _parseTitleAuthor(baseName);

    return BookFileMetadata(
      format: format,
      fileName: fileName,
      fileExt: extension,
      title: titleAuthor.title,
      author: titleAuthor.author,
    );
  }

  _TitleAuthor _parseTitleAuthor(String baseName) {
    final RegExpMatch? authorMatch = RegExp(
      r'作者[:：]\s*([^\s\]\)）]+)',
    ).firstMatch(baseName);
    final String author = authorMatch?.group(1)?.trim() ?? '';
    String title = baseName
        .replaceAll(RegExp(r'[《》]'), '')
        .replaceAll(RegExp(r'\s*作者[:：]\s*[^\s\]\)）]+'), '')
        .replaceAll(RegExp(r'[（(]精校版全本[）)]'), '')
        .trim();
    if (title.isEmpty) {
      title = baseName;
    }
    return _TitleAuthor(title: title, author: author);
  }
}

class _TitleAuthor {
  const _TitleAuthor({required this.title, required this.author});

  final String title;
  final String author;
}
