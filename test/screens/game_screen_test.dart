import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:touchit/screens/game_screen.dart';

void main() {
  testWidgets('GameScreen shows tutorial dialog and starts game', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: GameScreen()));
    await tester.pumpAndSettle();
    // Tutorial dialog should be visible
    expect(find.text('How to Play'), findsOneWidget);
    expect(find.text('Start Game'), findsOneWidget);
    // Tap the Start Game button
    await tester.tap(find.text('Start Game'));
    await tester.pumpAndSettle();
    // Score display should be visible
    expect(find.textContaining('Score:'), findsOneWidget);
  });
} 