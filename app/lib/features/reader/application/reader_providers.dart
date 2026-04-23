import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketread/data/database/database_provider.dart';
import 'package:pocketread/data/repositories/reader_repository.dart';

final Provider<ReaderRepository> readerRepositoryProvider =
    Provider<ReaderRepository>((Ref ref) {
      return ReaderRepository(database: ref.watch(appDatabaseProvider));
    });
