import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketread/data/database/database_provider.dart';
import 'package:pocketread/data/repositories/book_detail_repository.dart';
import 'package:pocketread/data/repositories/bookshelf_repository.dart';
import 'package:pocketread/features/book_detail/domain/book_detail_model.dart';

final Provider<BookDetailRepository> bookDetailRepositoryProvider =
    Provider<BookDetailRepository>((Ref ref) {
      return BookDetailRepository(database: ref.watch(appDatabaseProvider));
    });

final bookDetailProvider = FutureProvider.family<BookDetailModel?, String>((
  Ref ref,
  String bookId,
) {
  return ref.watch(bookDetailRepositoryProvider).getBookDetail(bookId);
});

final Provider<BookshelfRepository> deleteBookRepositoryProvider =
    Provider<BookshelfRepository>((Ref ref) {
      return BookshelfRepository(database: ref.watch(appDatabaseProvider));
    });
