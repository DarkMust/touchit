import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/shape_widget.dart';
import '../widgets/score_display.dart';
import '../widgets/game_over_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  int score = 0;
  int highScore = 0;
  double timeLimit = 1.5;
  bool isGameOver = false;
  late Timer gameTimer;
  late AnimationController _animationController;
  final Random _random = Random();
  ShapeType? currentShape;
  Offset? currentPosition;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _startGame();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  Future<void> _saveHighScore() async {
    if (score > highScore) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('highScore', score);
      setState(() {
        highScore = score;
      });
    }
  }

  void _startGame() {
    setState(() {
      score = 0;
      timeLimit = 1.5;
      isGameOver = false;
    });
    _spawnNewShape();
  }

  void _spawnNewShape() {
    if (isGameOver) return;

    final screenSize = MediaQuery.of(context).size;
    final shapeSize = 60.0;
    
    setState(() {
      currentPosition = Offset(
        _random.nextDouble() * (screenSize.width - shapeSize),
        _random.nextDouble() * (screenSize.height - shapeSize),
      );
      currentShape = _random.nextBool() ? ShapeType.circle : ShapeType.square;
      if (_random.nextInt(5) == 0) {
        currentShape = ShapeType.danger;
      }
    });

    _animationController.forward(from: 0.0);
    gameTimer = Timer(Duration(milliseconds: (timeLimit * 1000).round()), () {
      if (!isGameOver) {
        _gameOver();
      }
    });
  }

  void _onShapeTap() {
    if (isGameOver) return;

    if (currentShape == ShapeType.danger) {
      _gameOver();
      return;
    }

    setState(() {
      score++;
      timeLimit = max(0.5, timeLimit - 0.1);
    });

    gameTimer.cancel();
    _spawnNewShape();
  }

  void _gameOver() {
    setState(() {
      isGameOver = true;
    });
    gameTimer.cancel();
    _saveHighScore();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialog(
        score: score,
        highScore: highScore,
        onRestart: () {
          Navigator.of(context).pop();
          _startGame();
        },
      ),
    );
  }

  @override
  void dispose() {
    gameTimer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                ],
              ),
            ),
          ),
          ScoreDisplay(score: score),
          if (currentPosition != null && currentShape != null)
            Positioned(
              left: currentPosition!.dx,
              top: currentPosition!.dy,
              child: GestureDetector(
                onTap: _onShapeTap,
                child: FadeTransition(
                  opacity: _animationController,
                  child: ShapeWidget(
                    type: currentShape!,
                    size: 60,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 