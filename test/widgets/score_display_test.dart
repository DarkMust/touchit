import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:touchit/widgets/score_display.dart';

void main() {
  testWidgets('ScoreDisplay shows the correct score', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              ScoreDisplay(score: 42),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Score: 42'), findsOneWidget);
  });

  testWidgets('ScoreDisplay golden test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              ScoreDisplay(score: 99),
            ],
          ),
        ),
      ),
    );
    await expectLater(
      find.byType(ScoreDisplay),
      matchesGoldenFile('goldens/score_display_99.png'),
    );
  });
} 