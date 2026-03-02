import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketread/core/theme/app_theme.dart';
import 'package:pocketread/data/datasources/api_client.dart';
import 'package:pocketread/logic/blocs/auth/auth_bloc.dart';
import 'package:pocketread/logic/blocs/bookshelf/bookshelf_bloc.dart';
import 'package:pocketread/presentation/screens/auth_screen.dart';
import 'package:pocketread/presentation/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  await Hive.openBox('book_cache');

  final prefs = await SharedPreferences.getInstance();

  runApp(PocketReadApp(prefs: prefs));
}

class PocketReadApp extends StatelessWidget {
  final SharedPreferences prefs;

  const PocketReadApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(prefs)..add(AuthCheckRequested()),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketRead',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return BlocProvider(
              create: (context) => BookshelfBloc(
                ApiClient(baseUrl: state.serverUrl, apiKey: state.apiKey),
              )..add(BookshelfLoadRequested()),
              child: const HomeScreen(),
            );
          } else if (state is AuthUnauthenticated || state is AuthFailure) {
            return const AuthScreen();
          }
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
