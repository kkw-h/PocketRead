import 'package:flutter_test/flutter_test.dart';
import 'package:pocketread/main.dart';

void main() {
  testWidgets('shows bookshelf shell', (WidgetTester tester) async {
    await tester.pumpWidget(const PocketReadApp());

    expect(find.text('PocketRead'), findsOneWidget);
    expect(find.text('Bookshelf'), findsOneWidget);
  });
}
