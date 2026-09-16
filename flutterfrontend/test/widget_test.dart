import 'package:flutter_test/flutter_test.dart';
import 'package:pharmgo/main.dart';

void main() {
  testWidgets('PharmGo app should render', (WidgetTester tester) async {
    await tester.pumpWidget(const PharmGoApp());
    expect(find.byType(PharmGoApp), findsOneWidget);
  });
}
