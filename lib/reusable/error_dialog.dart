import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {

  String message;
  String closeMessage;

  ErrorDialog(String message, String closeMessage){
    this.message = message;
    this.closeMessage = closeMessage;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0)
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: _buildContent(context, media),
    );
  }

  _buildContent(BuildContext context, Size media) => Container(
    height: media.height * .4,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          this.message,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Colors.white,
          color: Colors.blue,
          padding: EdgeInsets.all(media.width * 0.03),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(500.0),
          ),
          child: Text(
            this.closeMessage,
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    ),
  );

}