// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pecs/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PecsApp(pecsImages: [
      {
        "category": "dairy product",
        "keyword": "Emmental cheese",
        "url": "https://api.arasaac.org/api/pictograms/38899?download=true"
      },
      {
        "category": "sports facility",
        "keyword": "calisthenics equipment",
        "url": "https://api.arasaac.org/api/pictograms/38898?download=true"
      },
      {
        "category": "animal anatomy",
        "keyword": "stinger",
        "url": "https://api.arasaac.org/api/pictograms/38902?download=true"
      },
      {
        "category": "verb",
        "keyword": "dunk",
        "url": "https://api.arasaac.org/api/pictograms/38904?download=true"
      },
      {
        "category": "orthopedic product",
        "keyword": "back brace",
        "url": "https://api.arasaac.org/api/pictograms/38903?download=true"
      },
      {
        "category": "medical device",
        "keyword": "pulse oximeter",
        "url": "https://api.arasaac.org/api/pictograms/38905?download=true"
      },
      {
        "category": "verb",
        "keyword": "validate wristband",
        "url": "https://api.arasaac.org/api/pictograms/38916?download=true"
      },
      {
        "category": "ultra-processed food",
        "keyword": "focaccia",
        "url": "https://api.arasaac.org/api/pictograms/38915?download=true"
      },
      {
        "category": "route",
        "keyword": "school route",
        "url": "https://api.arasaac.org/api/pictograms/38917?download=true"
      }
    ]));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
