import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketread/data/database/app_database.dart';
import 'package:pocketread/data/database/database_provider.dart';
import 'package:pocketread/features/reader/presentation/reader_page.dart';

void main() {
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    await _insertReadableBook(database);
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('paginates text and advances with right-side tap', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: ReaderPage(bookId: 'reader-book')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PageView), findsOneWidget);
    final String firstIndicator = _pageIndicatorText(tester);
    expect(firstIndicator, startsWith('1 / '));

    await tester.tapAt(const Offset(360, 320));
    await tester.pumpAndSettle();

    expect(_pageIndicatorText(tester), isNot(firstIndicator));
    expect(_pageIndicatorText(tester), startsWith('2 / '));
  });

  testWidgets('opens quick settings from center tap', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: ReaderPage(bookId: 'reader-book')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(195, 320));
    await tester.pumpAndSettle();

    expect(find.text('阅读设置'), findsOneWidget);
    expect(find.text('字号'), findsOneWidget);
    expect(find.text('行高'), findsOneWidget);
  });
}

String _pageIndicatorText(WidgetTester tester) {
  final Iterable<Text> texts = tester.widgetList<Text>(find.byType(Text));
  return texts
      .map((Text widget) => widget.data)
      .whereType<String>()
      .firstWhere((String value) => RegExp(r'^\d+ / \d+$').hasMatch(value));
}

Future<void> _insertReadableBook(AppDatabase database) async {
  final int now = DateTime(2026, 4, 24).millisecondsSinceEpoch;
  await database
      .into(database.books)
      .insert(
        BooksCompanion.insert(
          id: 'reader-book',
          format: 'txt',
          title: '翻页测试书籍',
          sourceFilePath: '/source/reader-book.txt',
          localFilePath: '/local/reader-book.txt',
          fileName: 'reader-book.txt',
          fileExt: '.txt',
          fileSize: 4096,
          fileHash: 'reader-book-hash',
          totalChapters: const Value<int>(1),
          createdAt: now,
          updatedAt: now,
        ),
      );
  await database
      .into(database.bookChapters)
      .insert(
        BookChaptersCompanion.insert(
          id: 'reader-chapter-1',
          bookId: 'reader-book',
          chapterIndex: 0,
          title: '第一章 翻页',
          sourceType: 'txt',
          startOffset: const Value<int>(0),
          endOffset: const Value<int>(4096),
          plainText: Value<String>(_longChapterText()),
          wordCount: const Value<int>(4096),
          createdAt: now,
          updatedAt: now,
        ),
      );
}

String _longChapterText() {
  return List<String>.generate(
    48,
    (int index) =>
        '第 $index 段。这是一段用于测试左滑翻页的正文内容，包含足够多的中文字符，确保阅读器需要生成多个页面，并能在点击右侧区域后前进到下一页。',
  ).join('\n\n');
}
