import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:touchit/main.dart' as app;
import 'package:touchit/widgets/shape_widget.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('Complete game flow test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify tutorial dialog appears
      expect(find.text('How to Play'), findsOneWidget);
      expect(find.text('Start Game'), findsOneWidget);

      // Start the game
      await tester.tap(find.text('Start Game'));
      await tester.pumpAndSettle();

      // Verify score display is visible
      expect(find.textContaining('Score:'), findsOneWidget);

      // Find and tap a shape (assuming it's a regular shape)
      final shapeFinder = find.byType(ShapeWidget);
      expect(shapeFinder, findsOneWidget);
      await tester.tap(shapeFinder);
      await tester.pumpAndSettle();

      // Verify score increased
      expect(find.textContaining('Score: 1'), findsOneWidget);

      // Wait for game over (by missing a shape)
      await tester.pump(const Duration(seconds: 7));
      await tester.pumpAndSettle();

      // Verify game over dialog appears
      expect(find.text('Game Over!'), findsOneWidget);
      expect(find.textContaining('Your Score:'), findsOneWidget);

      // Restart game
      await tester.tap(find.text('Play Again'));
      await tester.pumpAndSettle();

      // Verify game restarted
      expect(find.textContaining('Score: 0'), findsOneWidget);
    });

    testWidgets('Danger shape test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Start game
      await tester.tap(find.text('Start Game'));
      await tester.pumpAndSettle();

      // Keep tapping shapes until we find a danger shape
      bool foundDanger = false;
      for (int i = 0; i < 10 && !foundDanger; i++) {
        final shapeFinder = find.byType(ShapeWidget);
        if (shapeFinder.evaluate().isNotEmpty) {
          await tester.tap(shapeFinder);
          await tester.pumpAndSettle();
          
          // Check if game over dialog appears (indicating we hit a danger shape)
          if (find.text('Game Over!').evaluate().isNotEmpty) {
            foundDanger = true;
          }
        }
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Verify we either found a danger shape or the game ended normally
      expect(foundDanger || find.text('Game Over!').evaluate().isNotEmpty, isTrue);
    });
  });
}