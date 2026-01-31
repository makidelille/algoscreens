import 'dart:math';
import 'dart:ui';

class Vector2 {
  // Generate a random vector
  static Vector2 random(double minX, double maxX, double minY, double maxY) {
    final random = Random();
    double randomX = minX + random.nextDouble() * (maxX - minX);
    double randomY = minY + random.nextDouble() * (maxY - minY);
    return Vector2(randomX, randomY);
  }

  double x;
  double y;

  Vector2(this.x, this.y);

  // Addition
  Vector2 operator +(Vector2 other) => Vector2(x + other.x, y + other.y);

  // Subtraction
  Vector2 operator -(Vector2 other) => Vector2(x - other.x, y - other.y);

  // Modulo
  Vector2 operator %(Vector2 other) => Vector2(x % other.x, y % other.y);

  // Scalar multiplication
  Vector2 operator *(double scalar) => Vector2(x * scalar, y * scalar);

  // Scalar division
  Vector2 operator /(double scalar) => Vector2(x / scalar, y / scalar);

  // Magnitude
  double get magnitude => sqrt(x * x + y * y);

  static Vector2 get zero => Vector2(0, 0);

  // Clamp
  Vector2 clamp(Vector2 min, Vector2 max) {
    double clampedX = x.clamp(min.x, max.x);
    double clampedY = y.clamp(min.y, max.y);
    return Vector2(clampedX, clampedY);
  }

  // Normalize
  Vector2 normalize() {
    double mag = magnitude;
    return mag == 0 ? Vector2(0, 0) : this / mag;
  }

  @override
  String toString() => 'Vector2($x, $y)';

  // To Offset
  Offset toOffset() => Offset(x, y);
}
