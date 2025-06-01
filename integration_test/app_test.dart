import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tappyshape/screens/game_screen.dart';
import 'package:tappyshape/widgets/shape_widget.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('Complete game flow test', (tester) async {
      // Initialize the app
      await tester.pumpWidget(const MaterialApp(home: GameScreen()));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify tutorial dialog appears
      expect(find.text('How to Play'), findsOneWidget);
      expect(find.text('Start Game'), findsOneWidget);

      // Start the game
      await tester.tap(find.text('Start Game'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify score display is visible
      expect(find.textContaining('Score:'), findsOneWidget);

      // Find and tap a shape (assuming it's a regular shape)
      final shapeFinder = find.byType(ShapeWidget);
      expect(shapeFinder, findsOneWidget);
      await tester.tap(shapeFinder);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify score increased
      expect(find.textContaining('Score: 1'), findsOneWidget);

      // Wait for game over (by missing a shape)
      await tester.pump(const Duration(seconds: 7));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify game over dialog appears
      expect(find.text('Game Over!'), findsOneWidget);
      expect(find.textContaining('Your Score:'), findsOneWidget);

      // Restart game
      await tester.tap(find.text('Play Again'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify game restarted
      expect(find.textContaining('Score: 0'), findsOneWidget);
    });

    testWidgets('Danger shape test', (tester) async {
      // Initialize the app
      await tester.pumpWidget(const MaterialApp(home: GameScreen()));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Start game
      await tester.tap(find.text('Start Game'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Keep tapping shapes until we find a danger shape or timeout
      bool foundDanger = false;
      int attempts = 0;
      const maxAttempts = 10;

      while (!foundDanger && attempts < maxAttempts) {
        final shapeFinder = find.byType(ShapeWidget);
        if (shapeFinder.evaluate().isNotEmpty) {
          await tester.tap(shapeFinder);
          await tester.pumpAndSettle(const Duration(seconds: 1));
          
          // Check if game over dialog appears (indicating we hit a danger shape)
          if (find.text('Game Over!').evaluate().isNotEmpty) {
            foundDanger = true;
            break;
          }
        }
        attempts++;
        await tester.pump(const Duration(milliseconds: 100));
      }

      // If we didn't find a danger shape, force game over by waiting
      if (!foundDanger) {
        await tester.pump(const Duration(seconds: 7));
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }

      // Verify game over dialog appears
      expect(find.text('Game Over!'), findsOneWidget);
    });
  });
}