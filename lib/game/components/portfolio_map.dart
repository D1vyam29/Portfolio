import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PortfolioMap extends PositionComponent with HasGameRef {
  List<Vector2> stopPositions = [];
  int currentStopIndex = 0;
  Vector2 _carPosition = Vector2.zero();

  // Configuration
  final int totalStops = 6; // Intro, Edu, Skills, Exp, Proj, Contact
  final double carSpeed = 200.0; // Pixels per second

  // Paints
  final Paint _pathPaint = Paint()
    ..color = const Color(0xFFCCCCCC)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0
    ..strokeCap = StrokeCap.round;

  final Paint _stopPaint = Paint()
    ..color = const Color(0xFFAAAAAA)
    ..style = PaintingStyle.fill;

  final Paint _activeStopPaint = Paint()
    ..color = const Color(0xFF4CAF50)
    ..style = PaintingStyle.fill;

  final Paint _carPaint = Paint()
    ..color = const Color(0xFF2196F3) // Blue car
    ..style = PaintingStyle.fill;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _calculateStopPositions(size);
  }

  void _calculateStopPositions(Vector2 screenSize) {
    if (screenSize.x == 0) return;

    // Define a path across the top third of the screen
    double startX = screenSize.x * 0.1; // Start 10% in
    double endX = screenSize.x * 0.9; // End 90% in
    double yPos = screenSize.y * 0.25; // 25% down from top

    double stepX = (endX - startX) / (totalStops - 1);

    stopPositions.clear();
    for (int i = 0; i < totalStops; i++) {
      stopPositions.add(Vector2(startX + (i * stepX), yPos));
    }

    // Reset car to current stop if positions changed significantly or init
    if (stopPositions.isNotEmpty) {
      // If we are just resizing, we might want to snap the car to its target or current
      // depending on if it's moving. For simplicity, let's snap to target if close,
      // or re-calculate proportionate position.
      // Safest: Snap to the current known target stop for now to avoid lost car.
      if (currentStopIndex < stopPositions.length) {
        // If we're midway, this might jump, but acceptable for resize.
        // Better: Snap to current logical stop index.
        _carPosition = stopPositions[currentStopIndex].clone();
      }
    }
  }

  void animateToNextStop() {
    if (currentStopIndex < stopPositions.length - 1) {
      currentStopIndex++;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (stopPositions.isEmpty) return;

    // Move car towards target
    Vector2 target = stopPositions[currentStopIndex];
    Vector2 direction = target - _carPosition;
    double dist = direction.length;

    if (dist > 2.0) {
      // arbitrary small threshold
      direction.normalize();
      Vector2 move = direction * carSpeed * dt;

      // Don't overshoot
      if (move.length > dist) {
        _carPosition = target.clone();
      } else {
        _carPosition += move;
      }
    } else {
      _carPosition = target.clone();
    }
  }

  @override
  void render(Canvas canvas) {
    if (stopPositions.isEmpty) return;

    // Draw Path
    for (int i = 0; i < stopPositions.length - 1; i++) {
      canvas.drawLine(stopPositions[i].toOffset(),
          stopPositions[i + 1].toOffset(), _pathPaint);
    }

    // Draw Stops
    for (int i = 0; i < stopPositions.length; i++) {
      // A stop is "active" if the car has reached or passed it.
      // Logic: if currentStopIndex >= i, it's visited/target.
      // Strictly speaking, if we are moving towards i, it's not reached yet.
      // Let's paint visited stops green.
      // If currentStopIndex is the target we are moving TO, then i < currentStopIndex are definitely visited.
      // Let's say: i <= currentStopIndex means it's the current target or past.

      Paint paint = i <= currentStopIndex ? _activeStopPaint : _stopPaint;
      canvas.drawCircle(stopPositions[i].toOffset(), 12, paint); // Larger dots
    }

    // Draw Car
    canvas.drawCircle(_carPosition.toOffset(), 8, _carPaint);
  }
}
