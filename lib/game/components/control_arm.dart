import 'package:beltofdestiny/game_config.dart';
import 'package:flame/components.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ControlArm extends PositionComponent {
  bool isSwitchedLeft = true;

  double get _rotationRadians => rotationAngle * math.pi / 180;

  void toggleDirection() {
    isSwitchedLeft = !isSwitchedLeft;
  }

  @override
  void render(Canvas canvas) {
    // super.render(canvas);
    final paint = Paint()..color = Colors.red; // Paint for the arm
    final rect = Rect.fromLTWH(
        0, 0, armWidth, armLength); // Rectangle representing the arm

    canvas.save(); // Save the current canvas state

    // Translate the canvas to the pivot point
    canvas.translate(isSwitchedLeft ? rect.left : rect.right, rect.top);

    // Rotate the canvas around the pivot point
    canvas.rotate(isSwitchedLeft ? -_rotationRadians : _rotationRadians);

    // Translate back by half the arm's width to center the pivot on the edge
    canvas.translate(-armWidth / 2, 0);

    // Draw the rectangle (arm) on the transformed canvas
    canvas.drawRect(rect, paint);

    canvas.restore(); // Restore the canvas to the saved state
  }
}
