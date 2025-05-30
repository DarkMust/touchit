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
    Color color;
    switch (type) {
      case ShapeType.circle:
        color = Colors.blue;
        break;
      case ShapeType.square:
        color = Colors.green;
        break;
      case ShapeType.danger:
        color = Colors.red;
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: type == ShapeType.square ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: type == ShapeType.square ? BorderRadius.circular(8) : null,
      ),
    );
  }
} 