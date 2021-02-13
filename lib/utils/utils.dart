import 'dart:math';

import 'package:flutter/material.dart';

class Utils {

  static String imageSizing200 =  "_200x200";
  static String imageSizing600 =  "_600x600";
  static String imageSizing1000 =  "_1000x1000";

  static String sizeImage(String image, String sizing) {
    int lastPoint = image.lastIndexOf('.');
    String extension = image.substring(lastPoint);
    image = image.replaceAll(extension, '');
    return image + sizing + extension;
  }

  static Widget bottomArc = CustomPaint(
    painter: ShapesPainter(),
    child: Container(height: 20),
  );

  static String getRandomBookingCode(int strlen) {
    var chars       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }


}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    p.lineTo(0, 10);
    p.relativeQuadraticBezierTo(size.width / 2, 10.0, size.width, 0);
    p.lineTo(size.width, 0);
    p.close();

    canvas.drawPath(p, Paint()..color = Color(0xff006791));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
