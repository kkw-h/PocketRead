class ReaderBookModel {
  const ReaderBookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.format,
    required this.totalChapters,
  });

  final String id;
  final String title;
  final String author;
  final String format;
  final int totalChapters;
}

class ReaderChapterModel {
  const ReaderChapterModel({
    required this.id,
    required this.chapterIndex,
    required this.title,
    required this.sourceType,
    required this.href,
    required this.anchor,
    required this.startOffset,
    required this.endOffset,
    required this.plainText,
    required this.htmlContent,
    required this.wordCount,
    required this.level,
    required this.parentId,
  });

  final String id;
  final int chapterIndex;
  final String title;
  final String sourceType;
  final String? href;
  final String? anchor;
  final int? startOffset;
  final int? endOffset;
  final String? plainText;
  final String? htmlContent;
  final int? wordCount;
  final int level;
  final String? parentId;
}

class ReaderProgressModel {
  const ReaderProgressModel({
    required this.currentChapterIndex,
    required this.chapterOffset,
    required this.scrollOffset,
    required this.progressPercent,
    required this.locatorType,
    required this.locatorValue,
    required this.startedAt,
    required this.lastReadAt,
    required this.totalReadingMinutes,
    required this.updatedAt,
  });

  final int currentChapterIndex;
  final int? chapterOffset;
  final double? scrollOffset;
  final double progressPercent;
  final String locatorType;
  final String? locatorValue;
  final DateTime? startedAt;
  final DateTime lastReadAt;
  final int totalReadingMinutes;
  final DateTime updatedAt;
}

class ReaderBookDetail {
  const ReaderBookDetail({
    required this.book,
    required this.chapters,
    required this.progress,
  });

  final ReaderBookModel book;
  final List<ReaderChapterModel> chapters;
  final ReaderProgressModel? progress;
}

class ReaderSettingsModel {
  const ReaderSettingsModel({
    required this.themeMode,
    required this.backgroundStyleId,
    required this.fontFamilyId,
    required this.fontSize,
    required this.lineHeight,
    required this.horizontalPadding,
  });

  factory ReaderSettingsModel.defaults() {
    return const ReaderSettingsModel(
      themeMode: 'day',
      backgroundStyleId: 'paper',
      fontFamilyId: 'system',
      fontSize: 18,
      lineHeight: 1.78,
      horizontalPadding: 26,
    );
  }

  final String themeMode;
  final String backgroundStyleId;
  final String fontFamilyId;
  final double fontSize;
  final double lineHeight;
  final double horizontalPadding;
}
