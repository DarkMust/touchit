import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tappyshape/widgets/game_over_dialog.dart';

void main() {
  testWidgets('GameOverDialog shows score and high score', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => GameOverDialog(
                  score: 10,
                  highScore: 20,
                  onRestart: () {},
                ),
              );
            },
            child: const Text('Show Dialog'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();
    expect(find.text('Your Score: 10'), findsOneWidget);
    expect(find.text('High Score: 20'), findsOneWidget);
    expect(find.text('New High Score! 🎉'), findsNothing);
  });

  testWidgets('GameOverDialog shows new high score message', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => GameOverDialog(
                  score: 30,
                  highScore: 30,
                  onRestart: () {},
                ),
              );
            },
            child: const Text('Show Dialog'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();
    expect(find.text('Your Score: 30'), findsOneWidget);
    expect(find.text('High Score: 30'), findsOneWidget);
    expect(find.text('New High Score! 🎉'), findsOneWidget);
  });
} 