import 'dart:math';

import 'package:Buytime/reblox/enum/order_time_intervals.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class Utils {

  ///Image sizes
  static String imageSizing200 =  "_200x200";
  static String imageSizing600 =  "_600x600";
  static String imageSizing1000 =  "_1000x1000";

  ///Set image
  static String sizeImage(String image, String sizing) {
    int lastPoint = image.lastIndexOf('.');
    String extension = image.substring(lastPoint);
    image = image.replaceAll(extension, '');
    return image + sizing + extension;
  }

  ///Custom app bar bottom part
  static Widget bottomArc = CustomPaint(
    painter: ShapesPainter(),
    child: Container(height: 20),
  );

  ///Random booking code
  static String getRandomBookingCode(int strlen) {
    var chars       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  ///Get date
  static getDate(Timestamp date){
    if(date == null)
      date = Timestamp.fromDate(DateTime.now());
    return DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000).toUtc();
  }

  ///Set date
  static setDate(DateTime date){
    return date;
  }

  ///Convert enum to string
  static String enumToString(dynamic enumToTranslate){
    return enumToTranslate.toString().split('.').last;
  }

  ///App bar title
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

  ///Open google map
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
  static Future<void> openMapWithDirections(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static OrderTimeInterval getTimeInterval(OrderReservableState orderReservableState) {
    OrderTimeInterval orderTimeIntervalResult;
    DateTime closestTimeSlot;
    /// find the service time slot closest to today
    for (int i = 0; i < orderReservableState.itemList.length; i++) {
      DateTime timeSlotToCheck = orderReservableState.itemList[i].date; // || timeSlotToCheck.difference(closestTimeSlot)
      if (closestTimeSlot == null) {
        closestTimeSlot = timeSlotToCheck;
      } else if (timeSlotToCheck.difference(closestTimeSlot).isNegative){
        closestTimeSlot = timeSlotToCheck;
      }
    }
    /// check in which time interval the order has to be processed
    Duration nowToServiceDuration = DateTime.now().difference(closestTimeSlot);
    if (!nowToServiceDuration.isNegative) {
      /// TODO: error the service performance should be already happened
    } else if (nowToServiceDuration.inHours <= 48) { // TODO: make hardcoded variables readable from the configuration (we have to create a collection "configurationPublic"
      return OrderTimeInterval.directPayment;
    } else if (nowToServiceDuration.inHours >= 48 && nowToServiceDuration.inDays <= 7) {
      return OrderTimeInterval.holdAndReminder;
    } else if (nowToServiceDuration.inDays > 7) {
      return OrderTimeInterval.reminder;
    }
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
