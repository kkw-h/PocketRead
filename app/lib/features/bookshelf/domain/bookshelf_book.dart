class BookshelfBook {
  const BookshelfBook({
    required this.id,
    required this.title,
    required this.author,
    required this.format,
    required this.coverImagePath,
    required this.progressPercent,
    required this.currentChapterIndex,
    required this.totalChapters,
    required this.createdAt,
    required this.updatedAt,
    required this.lastReadAt,
    required this.isFavorite,
    required this.isPinned,
  });

  final String id;
  final String title;
  final String author;
  final String format;
  final String? coverImagePath;
  final double progressPercent;
  final int currentChapterIndex;
  final int totalChapters;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastReadAt;
  final bool isFavorite;
  final bool isPinned;

  bool get isReading => progressPercent > 0 && progressPercent < 1;

  String get progressLabel {
    if (progressPercent >= 1) {
      return '已读 100%';
    }
    if (progressPercent <= 0) {
      return '未读';
    }
    return '已读 ${(progressPercent * 100).round()}%';
  }
}
