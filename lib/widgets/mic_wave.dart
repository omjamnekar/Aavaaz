import 'package:flutter/material.dart';

class MicWavePainter extends CustomPainter {
  final double progress;
  final Color color;

  MicWavePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final double waveProgress = (progress + i * 0.33) % 1.0;
      final radius = waveProgress * maxRadius;
      final opacity = (1 - waveProgress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
