import 'package:flutter/material.dart';
import 'package:pocketread/features/bookshelf/presentation/bookshelf_page.dart';

final class AppRouter {
  const AppRouter._();

  static const String bookshelfRoute = '/';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case bookshelfRoute:
        return MaterialPageRoute<void>(
          builder: (_) => const BookshelfPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const BookshelfPage(),
          settings: settings,
        );
    }
  }
}
