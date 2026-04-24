part of 'reader_page.dart';

class _ReaderPerformanceLog {
  const _ReaderPerformanceLog._();

  static bool get enabled => kDebugMode;

  static T track<T>(
    String event,
    T Function() action, {
    Map<String, Object?> fields = const <String, Object?>{},
  }) {
    if (!enabled) {
      return action();
    }
    final Stopwatch stopwatch = Stopwatch()..start();
    try {
      final T result = action();
      stopwatch.stop();
      log(
        event,
        fields: <String, Object?>{
          ...fields,
          'durationMs': stopwatch.elapsedMilliseconds,
        },
      );
      return result;
    } catch (error) {
      stopwatch.stop();
      log(
        '$event failed',
        fields: <String, Object?>{
          ...fields,
          'durationMs': stopwatch.elapsedMilliseconds,
          'error': error.runtimeType,
        },
      );
      rethrow;
    }
  }

  static void log(
    String event, {
    Map<String, Object?> fields = const <String, Object?>{},
  }) {
    if (!enabled) {
      return;
    }
    final String metadata = fields.entries
        .where((MapEntry<String, Object?> entry) => entry.value != null)
        .map((MapEntry<String, Object?> entry) {
          return '${entry.key}=${entry.value}';
        })
        .join(' ');
    debugPrint(
      metadata.isEmpty
          ? '[ReaderPerf] $event'
          : '[ReaderPerf] $event $metadata',
    );
  }
}
