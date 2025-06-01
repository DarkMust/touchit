import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tappyshape/widgets/shape_widget.dart';

void main() {
  testWidgets('ShapeWidget renders blue circle', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ShapeWidget(type: ShapeType.circle, size: 60),
      ),
    );
    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, Colors.blue);
    expect(decoration.shape, BoxShape.circle);
  });

  testWidgets('ShapeWidget renders green square', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ShapeWidget(type: ShapeType.square, size: 60),
      ),
    );
    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, Colors.green);
    expect(decoration.shape, BoxShape.rectangle);
  });

  testWidgets('ShapeWidget renders red danger shape', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ShapeWidget(type: ShapeType.danger, size: 60),
      ),
    );
    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, Colors.red);
  });
} 