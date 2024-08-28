library timeline_xp;

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as Material;
// import 'package:easy_localization/easy_localization.dart' hide TextDirection;

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
class CustomThumbShape extends SliderComponentShape {
  final Map<String, Color> colors;
  final IconData iconLeft;
  final IconData iconRight;

  CustomThumbShape(
      {required this.colors, required this.iconLeft, required this.iconRight});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    // Taille du cercle et du thumb
    return Size(40, 40);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Créer un gradient linéaire
    final gradient = LinearGradient(
      colors: <Color>[
        colors['warning']!,
        colors['primary']!,
        colors['primaryBackground']!,
      ],
      begin: Alignment(1, -1),
      end: Alignment.bottomLeft,
    );

    // Appliquer le dégradé avec un shader
    final paint = Paint()
      ..shader =
          gradient.createShader(Rect.fromCircle(center: center, radius: 25))
      ..style = PaintingStyle.fill;

    // Rayon du cercle
    final double radius = 25;

    // Appliquer le dégradé avec un shader
    final paintBackground = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Rayon du cercle
    final double radiusBackground = radius * 1.5;

    // Dessiner le cercle avec le dégradé
    canvas.drawCircle(center, radiusBackground, paintBackground);

    // Dessiner le cercle avec le dégradé
    canvas.drawCircle(center, radius, paint);

    // Dessiner l'icône au centre du thumb
    final iconPainterLeft = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(iconLeft.codePoint),
        style: TextStyle(
          fontSize: 25, // Taille de l'icône
          fontFamily: iconLeft.fontFamily,
          package: iconLeft.fontPackage,
          color: Colors.white, // Couleur de l'icône
        ),
      ),
      textDirection: textDirection,
    );
    iconPainterLeft.layout();
    iconPainterLeft.paint(
      canvas,
      center -
          Offset(4 * iconPainterLeft.width / 5, iconPainterLeft.height / 2),
    );

    final iconPainterRight = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(iconRight.codePoint),
        style: TextStyle(
          fontSize: 25, // Taille de l'icône
          fontFamily: iconRight.fontFamily,
          package: iconRight.fontPackage,
          color: Colors.white, // Couleur de l'icône
        ),
      ),
      textDirection: textDirection,
    );
    iconPainterRight.layout();
    iconPainterRight.paint(
      canvas,
      center -
          Offset(1 * iconPainterRight.width / 5, iconPainterRight.height / 2),
    );
  }
}