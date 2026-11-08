import 'package:flutter_test/flutter_test.dart';
import 'package:create_name/main.dart';

void main() {
  testWidgets('Namer app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Namer());

    // Verify that navigation and buttons are present.
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Favorites'), findsWidgets);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Like'), findsOneWidget);
    expect(find.text('Font'), findsOneWidget);
  });
}
