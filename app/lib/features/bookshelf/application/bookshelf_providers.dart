import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketread/data/database/database_provider.dart';
import 'package:pocketread/data/repositories/bookshelf_repository.dart';
import 'package:pocketread/features/bookshelf/domain/bookshelf_book.dart';

final Provider<BookshelfRepository> bookshelfRepositoryProvider =
    Provider<BookshelfRepository>((Ref ref) {
      return BookshelfRepository(database: ref.watch(appDatabaseProvider));
    });

final StreamProvider<List<BookshelfBook>> bookshelfBooksProvider =
    StreamProvider<List<BookshelfBook>>((Ref ref) {
      return ref.watch(bookshelfRepositoryProvider).watchBooks();
    });
