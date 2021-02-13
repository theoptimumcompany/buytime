import 'package:flutter/material.dart';

class ContainerShapeBottomCircle extends CustomPainter {

  ContainerShapeBottomCircle(this.colour);

  Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [colour, /*Color.fromARGB(255, 55, 160, 224)*/ colour],
      tileMode: TileMode.clamp,
    );

    final Rect colorBounds = Rect.fromLTRB(0, 0, size.width, size.height);
    final Paint paint = Paint();
    //  ..shader = gradient.createShader(colorBounds);

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