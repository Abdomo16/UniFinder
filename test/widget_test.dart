import 'package:flutter_test/flutter_test.dart';
import 'package:uniifinder/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const UniFinderApp());
    expect(find.byType(UniFinderApp), findsOneWidget);
  });
}
