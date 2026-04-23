import 'dart:io';

import 'package:pocketread/data/repositories/book_import_repository.dart';
import 'package:pocketread/features/importer/domain/import_job.dart';
import 'package:pocketread/features/importer/domain/import_selection.dart';

class ImportBooksUseCase {
  const ImportBooksUseCase({required BookImportRepository repository})
    : _repository = repository;

  final BookImportRepository _repository;

  Future<BookImportReport> execute(ImportSelection selection) async {
    final List<String> paths = switch (selection.kind) {
      ImportPickKind.files => selection.paths,
      ImportPickKind.directory => await _collectBookFiles(
        selection.paths.first,
      ),
    };

    final List<BookImportItemResult> results = <BookImportItemResult>[];
    for (final String path in paths) {
      results.add(await _repository.importFile(path));
    }
    return BookImportReport(items: results);
  }

  Future<List<String>> _collectBookFiles(String directoryPath) async {
    final Directory directory = Directory(directoryPath);
    if (!await directory.exists()) {
      return <String>[];
    }

    final List<String> paths = <String>[];
    await for (final FileSystemEntity entity in directory.list(
      recursive: true,
    )) {
      if (entity is! File) {
        continue;
      }
      final String lowerPath = entity.path.toLowerCase();
      if (lowerPath.endsWith('.txt') || lowerPath.endsWith('.epub')) {
        paths.add(entity.path);
      }
    }
    paths.sort();
    return paths;
  }
}
