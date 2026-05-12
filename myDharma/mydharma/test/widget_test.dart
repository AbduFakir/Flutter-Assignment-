import 'package:flutter_test/flutter_test.dart';

import 'package:mydharma/main.dart';

void main() {
  testWidgets('myDharma home renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MyDharmaApp());

    expect(find.text('Every moment of life is sacred.\nWe walk with you through each one.'), findsOneWidget);
    expect(find.text('Welcoming a Baby'), findsOneWidget);
  });
}
