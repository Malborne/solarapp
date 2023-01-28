import 'dart:math';
import 'package:flutter/material.dart';

class SemiCircle extends CustomPainter {
  double completePercent;
  double width;
  Color fillColor;
  Color lineColor;
  SemiCircle(
      {required this.fillColor,
      required this.lineColor,
      required this.width,
      required this.completePercent});
  @override
  void paint(Canvas canvas, Size size) {
    double percentage = completePercent ;
    percentage = percentage > 100 ? 100 : percentage;
    double arcAngle = 2 * pi * (percentage / 100);
    Offset center =  Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    Paint line =  Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Paint outline =  Paint()
      ..color = Colors.white.withAlpha(20)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Paint complete = Paint()
      ..color = fillColor
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 10;
    canvas.drawCircle(center, radius, outline);

    if (percentage > 0) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0,
          arcAngle, false, line);
    }
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0, arcAngle,
        true, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
