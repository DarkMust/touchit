import 'package:flutter/material.dart';

enum ShapeType {
  circle,
  square,
  danger,
}

class ShapeWidget extends StatelessWidget {
  final ShapeType type;
  final double size;

  const ShapeWidget({
    super.key,
    required this.type,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getColor(),
        shape: type == ShapeType.circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: type == ShapeType.square
            ? BorderRadius.circular(12)
            : null,
        boxShadow: [
          BoxShadow(
            color: _getColor().withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (type) {
      case ShapeType.circle:
        return Colors.blue;
      case ShapeType.square:
        return Colors.green;
      case ShapeType.danger:
        return Colors.red;
    }
  }
} 