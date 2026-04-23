enum BookFileFormat {
  txt('txt', 'text/plain'),
  epub('epub', 'application/epub+zip');

  const BookFileFormat(this.value, this.mimeType);

  final String value;
  final String mimeType;
}

class BookFileMetadata {
  const BookFileMetadata({
    required this.format,
    required this.fileName,
    required this.fileExt,
    required this.title,
    required this.author,
  });

  final BookFileFormat format;
  final String fileName;
  final String fileExt;
  final String title;
  final String author;
}

class UnsupportedBookFormatException implements Exception {
  const UnsupportedBookFormatException(this.fileName);

  final String fileName;

  @override
  String toString() {
    return 'Unsupported book format: $fileName';
  }
}
