class BookDetailModel {
  const BookDetailModel({
    required this.id,
    required this.title,
    required this.author,
    required this.format,
    required this.sourceFilePath,
    required this.localFilePath,
    required this.fileName,
    required this.fileSizeLabel,
    required this.fileHash,
    required this.coverImagePath,
    required this.coverSourceType,
    required this.charsetName,
    required this.language,
    required this.totalChapters,
    required this.totalWords,
    required this.isFavorite,
    required this.isPinned,
    required this.importStatus,
    required this.createdAtLabel,
    required this.updatedAtLabel,
    required this.lastReadAtLabel,
    required this.progressPercent,
    required this.progressLabel,
    required this.lastReadChapterLabel,
    required this.importRecordLabel,
    required this.description,
  });

  final String id;
  final String title;
  final String author;
  final String format;
  final String sourceFilePath;
  final String localFilePath;
  final String fileName;
  final String fileSizeLabel;
  final String fileHash;
  final String? coverImagePath;
  final String? coverSourceType;
  final String? charsetName;
  final String? language;
  final int totalChapters;
  final int? totalWords;
  final bool isFavorite;
  final bool isPinned;
  final String importStatus;
  final String createdAtLabel;
  final String updatedAtLabel;
  final String? lastReadAtLabel;
  final double progressPercent;
  final String progressLabel;
  final String? lastReadChapterLabel;
  final String importRecordLabel;
  final String? description;
}
