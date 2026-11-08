import 'package:flutter_test/flutter_test.dart';
import 'package:create_name/main.dart';

void main() {
  testWidgets('Namer app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Namer());

    // Verify that random idea text is present.
    expect(find.text('A random wonderful idea:'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
