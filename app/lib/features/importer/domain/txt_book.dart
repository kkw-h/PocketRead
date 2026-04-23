class TxtDecodedContent {
  const TxtDecodedContent({required this.text, required this.charsetName});

  final String text;
  final String charsetName;
}

class TxtChapter {
  const TxtChapter({
    required this.index,
    required this.title,
    required this.startOffset,
    required this.endOffset,
    required this.plainText,
    required this.wordCount,
    this.level = 1,
  });

  final int index;
  final String title;
  final int startOffset;
  final int endOffset;
  final String plainText;
  final int wordCount;
  final int level;
}

class TxtParsedBook {
  const TxtParsedBook({
    required this.charsetName,
    required this.normalizedText,
    required this.chapters,
    required this.totalWords,
  });

  final String charsetName;
  final String normalizedText;
  final List<TxtChapter> chapters;
  final int totalWords;
}

class TxtDecodeException implements Exception {
  const TxtDecodeException(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}
