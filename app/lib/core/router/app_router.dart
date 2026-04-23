import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketread/features/book_detail/presentation/book_detail_page.dart';
import 'package:pocketread/features/bookshelf/presentation/bookshelf_page.dart';
import 'package:pocketread/features/my/presentation/my_page.dart';
import 'package:pocketread/features/reader/presentation/reader_page.dart';
import 'package:pocketread/features/settings/presentation/settings_page.dart';

final Provider<GoRouter> goRouterProvider = Provider<GoRouter>((Ref ref) {
  return GoRouter(
    initialLocation: AppRoute.bookshelf.path,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoute.bookshelf.path,
        name: AppRoute.bookshelf.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage<void>(child: BookshelfPage());
        },
      ),
      GoRoute(
        path: AppRoute.bookDetail.path,
        name: AppRoute.bookDetail.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String bookId = state.pathParameters['bookId']!;

          return MaterialPage<void>(child: BookDetailPage(bookId: bookId));
        },
      ),
      GoRoute(
        path: AppRoute.my.path,
        name: AppRoute.my.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage<void>(child: MyPage());
        },
      ),
      GoRoute(
        path: AppRoute.reader.path,
        name: AppRoute.reader.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String bookId = state.pathParameters['bookId']!;

          return MaterialPage<void>(child: ReaderPage(bookId: bookId));
        },
      ),
      GoRoute(
        path: AppRoute.settings.path,
        name: AppRoute.settings.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage<void>(child: SettingsPage());
        },
      ),
    ],
  );
});

enum AppRoute {
  bookshelf(name: 'bookshelf', path: '/'),
  bookDetail(name: 'book-detail', path: '/book/:bookId'),
  my(name: 'my', path: '/my'),
  reader(name: 'reader', path: '/reader/:bookId'),
  settings(name: 'settings', path: '/settings');

  const AppRoute({
    required this.name,
    required this.path,
  });

  final String name;
  final String path;
}
