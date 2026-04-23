import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketread/data/database/database_provider.dart';
import 'package:pocketread/data/parsers/book_file_metadata_parser.dart';
import 'package:pocketread/data/parsers/epub_book_parser.dart';
import 'package:pocketread/data/parsers/txt_book_parser.dart';
import 'package:pocketread/data/parsers/txt_chapter_splitter.dart';
import 'package:pocketread/data/parsers/txt_encoding_decoder.dart';
import 'package:pocketread/data/parsers/txt_text_normalizer.dart';
import 'package:pocketread/data/repositories/book_import_repository.dart';
import 'package:pocketread/data/services/book_file_picker_service.dart';
import 'package:pocketread/data/services/book_file_storage_service.dart';
import 'package:pocketread/data/services/file_hash_service.dart';
import 'package:pocketread/data/services/import_permission_service.dart';
import 'package:pocketread/features/importer/application/book_import_launcher.dart';
import 'package:pocketread/features/importer/application/import_books_use_case.dart';

final Provider<ImportPermissionService> importPermissionServiceProvider =
    Provider<ImportPermissionService>((Ref ref) {
      return const ImportPermissionService();
    });

final Provider<BookFilePickerService> bookFilePickerServiceProvider =
    Provider<BookFilePickerService>((Ref ref) {
      return const BookFilePickerService();
    });

final Provider<BookImportLauncher> bookImportLauncherProvider =
    Provider<BookImportLauncher>((Ref ref) {
      return BookImportLauncher(
        permissionService: ref.watch(importPermissionServiceProvider),
        filePickerService: ref.watch(bookFilePickerServiceProvider),
      );
    });

final Provider<BookFileMetadataParser> bookFileMetadataParserProvider =
    Provider<BookFileMetadataParser>((Ref ref) {
      return const BookFileMetadataParser();
    });

final Provider<EpubBookParser> epubBookParserProvider =
    Provider<EpubBookParser>((Ref ref) {
      return const EpubBookParser();
    });

final Provider<FileHashService> fileHashServiceProvider =
    Provider<FileHashService>((Ref ref) {
      return const FileHashService();
    });

final Provider<BookFileStorageService> bookFileStorageServiceProvider =
    Provider<BookFileStorageService>((Ref ref) {
      return const BookFileStorageService();
    });

final Provider<TxtEncodingDecoder> txtEncodingDecoderProvider =
    Provider<TxtEncodingDecoder>((Ref ref) {
      return const TxtEncodingDecoder();
    });

final Provider<TxtTextNormalizer> txtTextNormalizerProvider =
    Provider<TxtTextNormalizer>((Ref ref) {
      return const TxtTextNormalizer();
    });

final Provider<TxtChapterSplitter> txtChapterSplitterProvider =
    Provider<TxtChapterSplitter>((Ref ref) {
      return const TxtChapterSplitter();
    });

final Provider<TxtBookParser> txtBookParserProvider = Provider<TxtBookParser>((
  Ref ref,
) {
  return TxtBookParser(
    decoder: ref.watch(txtEncodingDecoderProvider),
    normalizer: ref.watch(txtTextNormalizerProvider),
    chapterSplitter: ref.watch(txtChapterSplitterProvider),
  );
});

final Provider<BookImportRepository> bookImportRepositoryProvider =
    Provider<BookImportRepository>((Ref ref) {
      return BookImportRepository(
        database: ref.watch(appDatabaseProvider),
        metadataParser: ref.watch(bookFileMetadataParserProvider),
        hashService: ref.watch(fileHashServiceProvider),
        storageService: ref.watch(bookFileStorageServiceProvider),
        txtBookParser: ref.watch(txtBookParserProvider),
        epubBookParser: ref.watch(epubBookParserProvider),
      );
    });

final Provider<ImportBooksUseCase> importBooksUseCaseProvider =
    Provider<ImportBooksUseCase>((Ref ref) {
      return ImportBooksUseCase(
        repository: ref.watch(bookImportRepositoryProvider),
      );
    });
