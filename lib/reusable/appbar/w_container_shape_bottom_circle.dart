import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';

class ContainerShapeBottomCircle extends CustomPainter {

  ContainerShapeBottomCircle(this.colour);

  Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = new Paint();
    paint.color = colour;
    //..color = BuytimeTheme.ManagerPrimary;

    Path path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, size.height * 1.08, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}