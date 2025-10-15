import 'package:flutter/material.dart';
import 'dart:math';

class TankPreview extends StatelessWidget {
  final Color color;
  final double angle;
  const TankPreview({super.key, required this.color, required this.angle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(
        painter: _TankPreviewPainter(color: color, angle: angle),
      ),
    );
  }
}

class _TankPreviewPainter extends CustomPainter {
  final Color color;
  final double angle;
  const _TankPreviewPainter({required this.color, required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final tankRadius = 28.0;
    final barrelLength = 15.0;
    final barrelWidth = 7.0;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    final tankPaint = Paint()..color = color;
    canvas.drawCircle(Offset.zero, tankRadius, tankPaint);
    for (int i = 0; i < 12; i++) {
      final barrelAngle = 2 * pi * i / 12;
      canvas.save();
      canvas.rotate(barrelAngle);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(tankRadius + barrelLength / 2, 0),
          width: barrelLength,
          height: barrelWidth,
        ),
        Paint()..color = Colors.grey,
      );
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TankPreviewPainter oldDelegate) => true;
}
