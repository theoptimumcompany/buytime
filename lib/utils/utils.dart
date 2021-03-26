import 'dart:math';

import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  static getDate(Timestamp date){
    if(date == null)
      date = Timestamp.fromDate(DateTime.now());
    return DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000).toUtc();
  }
  static setDate(DateTime date){
    return date;
  }

  static String enumToString(dynamic enumToTranslate){
    return enumToTranslate.toString().split('.').last;
  }

  static Widget barTitle(String title){
    return Container(
      width: SizeConfig.safeBlockHorizontal * 60,
      child: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: BuytimeTheme.appbarTitle,
            ),
          )
      ),
    );
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
