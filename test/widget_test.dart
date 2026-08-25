import 'package:flutter_test/flutter_test.dart';
import 'package:messanger_ax/exports.dart';

void main() {
  testWidgets('Sign In screen matches auth entry', (WidgetTester tester) async {
    await tester.pumpWidget(const MessangerApp());
    await tester.pump(); // first frame
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsWidgets);
    expect(find.text('Welcome back to the platform'), findsOneWidget);
  });
}
