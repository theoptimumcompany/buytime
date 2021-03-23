import 'package:flutter/material.dart';
class EnterExitRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  final Offset enterBeginOffset;
  final Offset enterEndOffset;
  final Offset exitBeginOffset;
  final Offset exitEndOffset;
  EnterExitRoute({this.exitPage, this.enterPage, this.enterBeginOffset, this.enterEndOffset, this.exitBeginOffset, this.exitEndOffset})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    enterPage,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        Stack(
          children: <Widget>[
            SlideTransition(
              position: new Tween<Offset>(
                begin: enterBeginOffset,
                end: enterEndOffset,
              ).animate(animation),
              child: exitPage,
            ),
            SlideTransition(
              position: new Tween<Offset>(
                begin: exitBeginOffset,
                end: exitEndOffset,
              ).animate(animation),
              child: enterPage,
            )
          ],
        ),
  );
}