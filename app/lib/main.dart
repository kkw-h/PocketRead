import 'package:flutter/material.dart';
import 'package:pocketread/core/router/app_router.dart';
import 'package:pocketread/core/theme/app_theme.dart';

void main() {
  runApp(const PocketReadApp());
}

class PocketReadApp extends StatelessWidget {
  const PocketReadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketRead',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.bookshelfRoute,
    );
  }
}
