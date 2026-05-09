import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:setdeneme1/widgets/set_button.dart';

void main() {
  testWidgets('SetButton renders text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SetButton(text: 'Tap', onPressed: () {}),
        ),
      ),
    );
    expect(find.text('Tap'), findsOneWidget);
  });
}
