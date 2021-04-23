import 'dart:io';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/app_reducer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ShowErrorDialogToDismiss extends StatelessWidget {
  final String content;
  final String title;
  final String buttonText;

  ShowErrorDialogToDismiss({this.title, this.buttonText, this.content});

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return AlertDialog(
        title: new Text(
          title,
        ),
        content: new Text(
          this.content,
        ),
        actions: <Widget>[
          new ElevatedButton(
            child: new Text(
              buttonText,
            ),
            onPressed: () {
              StoreProvider.of<AppState>(context).dispatch(ErrorReset());
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
          title: Text(
            title,
          ),
          content: new Text(
            this.content,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(
                buttonText[0].toUpperCase() + buttonText.substring(1).toLowerCase(),
              ),
              onPressed: () {
                StoreProvider.of<AppState>(context).dispatch(ErrorReset());
                Navigator.of(context).pop();
              },
            )
          ]);
    }
  }
}
