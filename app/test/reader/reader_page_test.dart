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

  testWidgets('updates page indicator after horizontal swipe', (
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

    expect(_pageIndicatorText(tester), startsWith('1 / '));

    await tester.drag(find.byType(PageView), const Offset(-330, 0));
    await tester.pumpAndSettle();

    expect(_pageIndicatorText(tester), startsWith('2 / '));
  });

  testWidgets('opens bottom reading menu from center tap', (
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

    expect(find.text('目录'), findsWidgets);
    expect(find.text('背景'), findsOneWidget);
    expect(find.text('阅读设置'), findsOneWidget);
  });

  testWidgets('can set left-side tap to advance to next page', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
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

    final String firstIndicator = _pageIndicatorText(tester);

    await tester.tapAt(const Offset(195, 320));
    await tester.pumpAndSettle();
    await tester.tap(find.text('阅读设置'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('下一页'));
    await tester.tap(find.text('下一页'));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(30, 320));
    await tester.pumpAndSettle();

    expect(_pageIndicatorText(tester), isNot(firstIndicator));
    expect(_pageIndicatorText(tester), startsWith('2 / '));
  });

  testWidgets('toc chapter selection opens selected chapter first page', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
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
    await tester.tap(find.byIcon(Icons.list_alt_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('第二章 起始'));
    await tester.pumpAndSettle();

    expect(find.text('第二章 起始'), findsWidgets);
    expect(_pageIndicatorText(tester), startsWith('1 / '));
  });

  testWidgets('toc chapter selection resets page after reading later page', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
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

    await tester.tapAt(const Offset(360, 320));
    await tester.pumpAndSettle();
    expect(_pageIndicatorText(tester), startsWith('2 / '));

    await tester.tapAt(const Offset(195, 320));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.list_alt_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('第二章 起始'));
    await tester.pumpAndSettle();

    expect(find.text('第二章 起始'), findsWidgets);
    expect(_pageIndicatorText(tester), startsWith('1 / '));
  });

  testWidgets('can swipe to previous chapter after toc chapter selection', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
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
    await tester.tap(find.byIcon(Icons.list_alt_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('第二章 起始'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(PageView), const Offset(330, 0));
    await tester.pumpAndSettle();

    expect(find.textContaining('第一章'), findsWidgets);
  });

  testWidgets('can continue to next chapter after focused toc jump', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
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
    await tester.tap(find.byIcon(Icons.list_alt_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('第二章 起始'));
    await tester.pumpAndSettle();

    final int safetyLimit = _pageIndicatorTotal(tester) + 2;
    for (int index = 0; index < safetyLimit; index += 1) {
      if (find.text('第三章 继续').evaluate().isNotEmpty) {
        break;
      }
      await tester.drag(find.byType(PageView), const Offset(-330, 0));
      await tester.pumpAndSettle();
    }

    expect(find.text('第三章 继续'), findsWidgets);
    expect(_pageIndicatorText(tester), startsWith('1 / '));
  });

  testWidgets('can continue across chapter boundary with transition window', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
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

    final int firstChapterPages = _pageIndicatorTotal(tester);
    for (int index = 0; index < firstChapterPages + 2; index += 1) {
      if (find.text('第二章 起始').evaluate().isNotEmpty) {
        break;
      }
      await tester.tapAt(const Offset(360, 320));
      await tester.pumpAndSettle();
    }

    expect(find.text('第二章 起始'), findsWidgets);
    expect(_pageIndicatorText(tester), startsWith('1 / '));
  });

  testWidgets('restores non-first page without landing on chapter first page', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _insertProgress(database, chapterIndex: 0, chapterTextOffset: 700);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: ReaderPage(bookId: 'reader-book')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PageView), findsOneWidget);
    expect(_pageIndicatorText(tester), isNot(startsWith('1 / ')));
  });
}

String _pageIndicatorText(WidgetTester tester) {
  final Iterable<Text> texts = tester.widgetList<Text>(find.byType(Text));
  return texts
      .map((Text widget) => widget.data)
      .whereType<String>()
      .firstWhere((String value) => RegExp(r'^\d+ / \d+$').hasMatch(value));
}

int _pageIndicatorTotal(WidgetTester tester) {
  final String indicator = _pageIndicatorText(tester);
  return int.parse(indicator.split('/').last.trim());
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
          totalChapters: const Value<int>(3),
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
  await database
      .into(database.bookChapters)
      .insert(
        BookChaptersCompanion.insert(
          id: 'reader-chapter-2',
          bookId: 'reader-book',
          chapterIndex: 1,
          title: '第二章 起始',
          sourceType: 'txt',
          startOffset: const Value<int>(4096),
          endOffset: const Value<int>(8192),
          plainText: Value<String>(_chapterText('第二章')),
          wordCount: const Value<int>(4096),
          createdAt: now,
          updatedAt: now,
        ),
      );
  await database
      .into(database.bookChapters)
      .insert(
        BookChaptersCompanion.insert(
          id: 'reader-chapter-3',
          bookId: 'reader-book',
          chapterIndex: 2,
          title: '第三章 继续',
          sourceType: 'txt',
          startOffset: const Value<int>(8192),
          endOffset: const Value<int>(12288),
          plainText: Value<String>(_chapterText('第三章')),
          wordCount: const Value<int>(4096),
          createdAt: now,
          updatedAt: now,
        ),
      );
}

Future<void> _insertProgress(
  AppDatabase database, {
  required int chapterIndex,
  required int chapterTextOffset,
}) async {
  final int now = DateTime(2026, 4, 24, 12).millisecondsSinceEpoch;
  await database
      .into(database.readingProgress)
      .insert(
        ReadingProgressCompanion.insert(
          id: 'progress_reader-book',
          bookId: 'reader-book',
          currentChapterIndex: Value<int>(chapterIndex),
          chapterOffset: Value<int>(chapterTextOffset),
          progressPercent: const Value<double>(0.1),
          locatorType: const Value<String>('txt_offset'),
          locatorValue: Value<String>(
            'offset:$chapterIndex:$chapterTextOffset',
          ),
          lastReadAt: now,
          updatedAt: now,
        ),
      );
}

String _longChapterText() {
  return _chapterText('第一章');
}

String _chapterText(String chapterName) {
  return List<String>.generate(
    48,
    (int index) =>
        '$chapterName 第 $index 段。这是一段用于测试左滑翻页的正文内容，包含足够多的中文字符，确保阅读器需要生成多个页面，并能在点击右侧区域后前进到下一页。',
  ).join('\n\n');
}
