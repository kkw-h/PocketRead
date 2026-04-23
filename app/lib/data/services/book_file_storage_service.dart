import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class BookFileStorageService {
  const BookFileStorageService({
    Future<Directory> Function()? rootDirectoryProvider,
  }) : _rootDirectoryProvider = rootDirectoryProvider;

  final Future<Directory> Function()? _rootDirectoryProvider;

  Future<String> copyIntoLibrary({
    required File sourceFile,
    required String bookId,
    required String fileName,
  }) async {
    final Directory appDirectory =
        await (_rootDirectoryProvider ?? getApplicationDocumentsDirectory)();
    final Directory booksDirectory = Directory(
      p.join(appDirectory.path, 'books', bookId),
    );
    if (!booksDirectory.existsSync()) {
      await booksDirectory.create(recursive: true);
    }

    final String destinationPath = p.join(booksDirectory.path, fileName);
    await sourceFile.copy(destinationPath);
    return destinationPath;
  }

  Future<String> writeCoverImage({
    required String bookId,
    required String fileName,
    required Uint8List bytes,
  }) async {
    final Directory appDirectory =
        await (_rootDirectoryProvider ?? getApplicationDocumentsDirectory)();
    final Directory coverDirectory = Directory(
      p.join(appDirectory.path, 'covers', bookId),
    );
    if (!coverDirectory.existsSync()) {
      await coverDirectory.create(recursive: true);
    }

    final String destinationPath = p.join(coverDirectory.path, fileName);
    await File(destinationPath).writeAsBytes(bytes, flush: true);
    return destinationPath;
  }
}
