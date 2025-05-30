import 'package:flutter/material.dart';

class GameOverDialog extends StatelessWidget {
  final int score;
  final int highScore;
  final VoidCallback onRestart;

  const GameOverDialog({
    super.key,
    required this.score,
    required this.highScore,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Game Over!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your Score: $score',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'High Score: $highScore',
            style: TextStyle(
              fontSize: 18,
              color: score >= highScore ? Colors.green : Colors.grey,
            ),
          ),
          if (score >= highScore) ...[
            const SizedBox(height: 16),
            const Text(
              'New High Score! 🎉',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: onRestart,
          child: const Text('Play Again'),
        ),
      ],
    );
  }
} 