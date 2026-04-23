import 'package:pocketread/features/importer/domain/book_file_format.dart';

enum BookImportItemStatus { imported, duplicate, failed }

class BookImportItemResult {
  const BookImportItemResult({
    required this.sourcePath,
    required this.fileName,
    required this.status,
    required this.message,
    this.format,
    this.bookId,
    this.duplicateBookId,
  });

  final String sourcePath;
  final String fileName;
  final BookImportItemStatus status;
  final String message;
  final BookFileFormat? format;
  final String? bookId;
  final String? duplicateBookId;
}

class BookImportReport {
  const BookImportReport({required this.items});

  final List<BookImportItemResult> items;

  int get importedCount => items
      .where(
        (BookImportItemResult item) =>
            item.status == BookImportItemStatus.imported,
      )
      .length;

  int get duplicateCount => items
      .where(
        (BookImportItemResult item) =>
            item.status == BookImportItemStatus.duplicate,
      )
      .length;

  int get failedCount => items
      .where(
        (BookImportItemResult item) =>
            item.status == BookImportItemStatus.failed,
      )
      .length;

  String get summary {
    return '导入完成：成功 $importedCount，本地重复 $duplicateCount，失败 $failedCount';
  }
}
