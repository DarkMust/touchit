import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedEmojiBackground extends StatefulWidget {
  const AnimatedEmojiBackground({super.key});

  @override
  State<AnimatedEmojiBackground> createState() => _AnimatedEmojiBackgroundState();
}

class _AnimatedEmojiBackgroundState extends State<AnimatedEmojiBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<EmojiParticle> _particles = [];
  final _random = Random();
  final List<String> _emojis = ['🎮', '🏆', '👾', '🎯', '🕹️', '🎲'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createParticles(context);
      _controller.addListener(() {
        setState(() {
          _updateParticles();
        });
      });
    });
  }

  void _createParticles(BuildContext context) {
    final size = MediaQuery.of(context).size;
    for (int i = 0; i < 30; i++) {
      _particles.add(
        EmojiParticle(
          emoji: _emojis[_random.nextInt(_emojis.length)],
          position: Offset(
            _random.nextDouble() * size.width,
            _random.nextDouble() * size.height,
          ),
          velocity: Offset(
            (_random.nextDouble() * 2 - 1) * 0.5,
            (_random.nextDouble() * 2 - 1) * 0.5,
          ),
          size: _random.nextDouble() * 20 + 20,
        ),
      );
    }
  }

  void _updateParticles() {
    final size = MediaQuery.of(context).size;
    for (var particle in _particles) {
      particle.position += particle.velocity;
      if (particle.position.dx < 0 || particle.position.dx > size.width) {
        particle.velocity = Offset(-particle.velocity.dx, particle.velocity.dy);
      }
      if (particle.position.dy < 0 || particle.position.dy > size.height) {
        particle.velocity = Offset(particle.velocity.dx, -particle.velocity.dy);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _particles.map((p) {
        return Positioned(
          left: p.position.dx,
          top: p.position.dy,
          child: Text(
            p.emoji,
            style: TextStyle(fontSize: p.size),
          ),
        );
      }).toList(),
    );
  }
}

class EmojiParticle {
  String emoji;
  Offset position;
  Offset velocity;
  double size;

  EmojiParticle({
    required this.emoji,
    required this.position,
    required this.velocity,
    required this.size,
  });
} 