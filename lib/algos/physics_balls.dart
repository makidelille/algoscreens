import 'dart:ui';

import 'package:algoscreens/algos/algo_visualiser_widget.dart';
import 'package:algoscreens/vector2.dart';
import 'package:flutter/material.dart';

const saturationLevel = 0.7;
const lightLevel = 0.7;

const debounceTime = 10 * 1000;
const lifeTime = 5 * debounceTime;

class Ball {
  Vector2 pos;
  Vector2 vel;

  double size;

  HSLColor color;

  int created = DateTime.now().millisecondsSinceEpoch;
  int currentLifeTime = 0;

  bool get isOld => currentLifeTime > lifeTime;

  Ball({
    required this.pos,
    required this.vel,
    required this.size,
    required this.color,
  });

  void update(double dt, Size s) {
    pos += vel;
    if ((pos.x) < 0 || (pos.x + size) > s.width) {
      vel.x = -vel.x;
      pos.x = clampDouble(pos.x, 0, s.width);
    }
    if ((pos.y) < 0 || (pos.y + size) > s.height) {
      vel.y = -vel.y;
      pos.y = clampDouble(pos.y, 0, s.height);
    }

    vel += Vector2.random(-1, 1, -1, 1) * 0.5;

    pos = pos.clamp(Vector2.zero, Vector2(s.width - size, s.height - size));
    vel = vel.clamp(Vector2(-10, -10), Vector2(10, 10)) * 0.99;

    currentLifeTime = DateTime.now().millisecondsSinceEpoch - created;

    final ratio = lerpDouble(1, 0, (currentLifeTime.toDouble() / lifeTime))!;
    color = color.withAlpha(ratio);
  }

  // Intersection detection
  bool intersects(Ball other) {
    if (DateTime.now().millisecondsSinceEpoch - created < debounceTime) {
      return false;
    }

    final distance = ((pos - other.pos).magnitude);
    return distance < (size + other.size);
  }

  void draw(Canvas canvas) {
    final paint = Paint()
      ..color = color.toColor()
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      pos.toOffset().translate(size / 2, size / 2),
      size,
      paint,
    );
  }
}

class PhysicsBalls2 extends AlgoVisualiserPainter<List<Ball>> {
  PhysicsBalls2({required super.state, super.repaint});

  @override
  initState() {
    state = [];
    state!.add(
      Ball(
        pos: Vector2(50, 50),
        vel: Vector2(-2, 5),
        size: 50,
        color: HSLColor.fromAHSL(1, 0, saturationLevel, lightLevel),
      ),
    );

    state!.add(
      Ball(
        pos: Vector2(500, 250),
        vel: Vector2(1, -2),
        size: 40,
        color: HSLColor.fromAHSL(1, 120, saturationLevel, lightLevel),
      ),
    );

    state!.add(
      Ball(
        pos: Vector2(250, 250),
        vel: Vector2(8, -3),
        size: 40,
        color: HSLColor.fromAHSL(1, 240, saturationLevel, lightLevel),
      ),
    );

    return state!;
  }

  @override
  onUpdate(BuildContext context) {
    final List<Ball> toAdd = [];

    for (int i = state!.length - 1; i > 0; i--) {
      final ball = state![i];
      for (int j = state!.length - 1; j > i; j--) {
        final other = state![j];
        if (ball.intersects(other)) {
          ball.created = DateTime.now().millisecondsSinceEpoch;
          other.created = DateTime.now().millisecondsSinceEpoch;

          final otherVelScaled = other.vel * (other.size / ball.size);
          final ballVelScaled = ball.vel * (ball.size / other.size);
          other.vel = other.vel - ballVelScaled;
          ball.vel = ball.vel - otherVelScaled;

          final c1 = ball.color;
          final c2 = other.color;

          toAdd.add(
            Ball(
              pos: (ball.pos + other.pos) / 2,
              vel: (ball.vel + other.vel) / 2 + Vector2.random(0, 1, 0, 1),
              size: (ball.size + other.size) / 2,
              color: HSLColor.fromAHSL(
                1,
                (c1.hue + c2.hue) / 2,
                saturationLevel,
                lightLevel,
              ),
            ),
          );
        }
      }

      ball.update(1 / 60, MediaQuery.sizeOf(context));

      if (ball.isOld) {
        state!.remove(ball);
      }
    }

    state!.addAll(toAdd);

    while (state!.length > 32) {
      state!.removeAt(0);
    }

    return state!;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 82, 82, 82)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    for (final ball in state!) {
      ball.draw(canvas);
    }
  }

  @override
  String get name => "Physics Balls";

  @override
  Duration get duration => Duration(seconds: 1);
}
