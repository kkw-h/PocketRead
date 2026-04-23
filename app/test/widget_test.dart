import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketread/features/bookshelf/application/bookshelf_providers.dart';
import 'package:pocketread/features/bookshelf/domain/bookshelf_book.dart';
import 'package:pocketread/main.dart';

void main() {
  testWidgets('shows bookshelf empty shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookshelfBooksProvider.overrideWith(
            (Ref ref) =>
                Stream<List<BookshelfBook>>.value(const <BookshelfBook>[]),
          ),
        ],
        child: const PocketReadApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('全部 0'), findsOneWidget);
    expect(find.text('书架还空着'), findsOneWidget);
    expect(find.text('支持 TXT / EPUB'), findsOneWidget);
    expect(find.text('导入书籍'), findsOneWidget);
    expect(find.text('书架'), findsNWidgets(2));
    expect(find.text('我的'), findsOneWidget);
  });
}
