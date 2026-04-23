import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketread/main.dart';

void main() {
  testWidgets('shows bookshelf shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PocketReadApp()));

    expect(find.text('全部 128'), findsOneWidget);
    expect(find.text('大秦帝国（全六部）'), findsOneWidget);
    expect(find.text('发现'), findsOneWidget);
  });
}
