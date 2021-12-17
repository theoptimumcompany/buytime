import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WFinancialDetail extends StatefulWidget {

  String title;
  String body;
  String value;
  WFinancialDetail(this.title, this.body, this.value);

  @override
  State<WFinancialDetail> createState() => _WFinancialDetailState();
}

class _WFinancialDetailState extends State<WFinancialDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //height: double.infinity,
      margin: EdgeInsets.only(top: 16, left: 16, right: 16),
      //alignment: Alignment.center,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 14, left: 12, right: 12),
              child: Text(
                widget.title,
                style: TextStyle(
                    fontFamily: BuytimeTheme.FontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: BuytimeTheme.ManagerPrimary
                ),
              ),
            ),
            widget.body.isNotEmpty ?
            Container(
              margin: EdgeInsets.only(top: 8, left: 12, right: 12),
              child: Text(
                widget.body,
                style: TextStyle(
                    fontFamily: BuytimeTheme.FontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                ),
              ),
            ) : Container(),
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 14, left: 12, right: 12),
              child: Text(
                widget.value,
                style: TextStyle(
                    fontFamily: BuytimeTheme.FontFamily,
                    fontSize: 25,
                    fontWeight: FontWeight.w500
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}