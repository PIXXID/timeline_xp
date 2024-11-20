import 'package:flutter/material.dart';

class HatchedBackgroundPainter extends CustomPainter {
  HatchedBackgroundPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.spacing = 12.0,
  });

  final Color color;
  final double strokeWidth;
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Dessine les lignes diagonales
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0), // Départ de la ligne
        Offset(i + size.height, size.height), // Fin de la ligne
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Pas besoin de repeindre si les paramètres n'ont pas changé
  }
}
