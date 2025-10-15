import 'dart:math';

class JoystickInput {
  double dx = 0;
  double dy = 0;

  void update(double x, double y, double radius) {
    dx = (x / radius).clamp(-1, 1);
    dy = (y / radius).clamp(-1, 1);
  }

  double get angle {
    if (dx == 0 && dy == 0) return 0;
    return atan2(dy, dx);
  }

  double get magnitude => sqrt(dx * dx + dy * dy).clamp(0, 1);
}
