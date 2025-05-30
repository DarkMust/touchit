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
  double timeLimit = 6.0;
  bool isGameOver = false;
  Timer? gameTimer;
  late AnimationController _animationController;
  final Random _random = Random();
  ShapeType? currentShape;
  Offset? currentPosition;
  Size? screenSize;
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenSize = MediaQuery.of(context).size;
    
    if (_isFirstBuild) {
      _isFirstBuild = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTutorial();
      });
    }
  }

  void _showTutorial() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('How to Play'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome to Touch It!'),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Blue Circle: Tap for 1 point'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Green Square: Tap for 1 point'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Red Shape: Avoid it!'),
              ],
            ),
            const SizedBox(height: 16),
            const Text('• Tap shapes before they disappear'),
            const Text('• Each successful tap reduces the time limit'),
            const Text('• Try to get the highest score!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startGame();
            },
            child: const Text('Start Game'),
          ),
        ],
      ),
    );
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
      timeLimit = 6.0;
      isGameOver = false;
    });
    _spawnNewShape();
  }

  void _spawnNewShape() {
    if (isGameOver || screenSize == null) return;

    gameTimer?.cancel();

    final shapeSize = 60.0;
    
    setState(() {
      currentPosition = Offset(
        _random.nextDouble() * (screenSize!.width - shapeSize),
        _random.nextDouble() * (screenSize!.height - shapeSize),
      );
      currentShape = _random.nextBool() ? ShapeType.circle : ShapeType.square;
      if (_random.nextInt(5) == 0) {
        currentShape = ShapeType.danger;
      }
    });

    _animationController.forward(from: 0.0);
    
    // If it's a danger shape, make it disappear faster
    if (currentShape == ShapeType.danger) {
      gameTimer = Timer(const Duration(milliseconds: 1500), () {
        if (!isGameOver && mounted) {
          _spawnNewShape();
        }
      });
    } else {
      gameTimer = Timer(Duration(milliseconds: (timeLimit * 1000).round()), () {
        if (!isGameOver && mounted) {
          _gameOver();
        }
      });
    }
  }

  void _onShapeTap() {
    if (isGameOver) return;

    gameTimer?.cancel();

    if (currentShape == ShapeType.danger) {
      _gameOver();
      return;
    }

    setState(() {
      score++;
      timeLimit = max(1.0, timeLimit - 0.05);
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!isGameOver && mounted) {
        _spawnNewShape();
      }
    });
  }

  void _gameOver() {
    if (!mounted) return;
    
    setState(() {
      isGameOver = true;
    });
    
    gameTimer?.cancel();
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
    gameTimer?.cancel();
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