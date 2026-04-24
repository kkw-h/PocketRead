import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketread/data/database/database_provider.dart';
import 'package:pocketread/data/repositories/reader_repository.dart';
import 'package:pocketread/features/reader/application/reader_launch_warmup_service.dart';

final Provider<ReaderRepository> readerRepositoryProvider =
    Provider<ReaderRepository>((Ref ref) {
      return ReaderRepository(database: ref.watch(appDatabaseProvider));
    });

final Provider<ReaderLaunchWarmupService> readerLaunchWarmupServiceProvider =
    Provider<ReaderLaunchWarmupService>((Ref ref) {
      return ReaderLaunchWarmupService(
        repository: ref.watch(readerRepositoryProvider),
      );
    });
