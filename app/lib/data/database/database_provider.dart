import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketread/data/database/app_database.dart';

final Provider<AppDatabase> appDatabaseProvider = Provider<AppDatabase>((
  Ref ref,
) {
  final AppDatabase database = AppDatabase.defaults();
  ref.onDispose(database.close);
  return database;
});
