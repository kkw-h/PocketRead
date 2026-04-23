import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketread/core/router/app_router.dart';
import 'package:pocketread/core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: PocketReadApp()));
}

class PocketReadApp extends ConsumerWidget {
  const PocketReadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'PocketRead',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}
