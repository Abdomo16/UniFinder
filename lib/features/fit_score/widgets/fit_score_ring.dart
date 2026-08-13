import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class FitScoreRing extends StatelessWidget {
  final int score;
  final double size;
  final double strokeWidth;

  const FitScoreRing({
    super.key,
    required this.score,
    required this.size,
    this.strokeWidth = 8.0,
  });

  Color _getColorForScore(int score) {
    if (score >= 85) {
      return AppColors.primary; // Green/Teal
    } else if (score >= 60) {
      return AppColors.secondary; // Yellow/Orange
    } else {
      return AppColors.error; // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    final ringColor = _getColorForScore(score);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              score: score,
              color: ringColor,
              strokeWidth: strokeWidth,
            ),
          ),
          Text(
            '$score%',
            style: TextStyle(
              fontSize: size * 0.24,
              fontWeight: FontWeight.bold,
              color: ringColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final int score;
  final Color color;
  final double strokeWidth;

  _RingPainter({
    required this.score,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - (strokeWidth / 2);

    // Track circle (background gray)
    final trackPaint = Paint()
      ..color = AppColors.surfaceVariant.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final sweepAngle = (score / 100) * 2 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.score != score ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
