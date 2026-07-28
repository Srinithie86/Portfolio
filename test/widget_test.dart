import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:srinithi_portfolio/main.dart';

void main() {
  testWidgets('Portfolio app loads smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const SrinithiPortfolioApp());
    await tester.pump(const Duration(seconds: 1));

    // Verify that the brand title is found.
    expect(find.textContaining('SRINITHI'), findsWidgets);
  });
}
