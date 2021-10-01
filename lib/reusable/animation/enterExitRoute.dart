import 'package:flutter/material.dart';

class EnterExitRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  final bool from;

  EnterExitRoute({this.exitPage, this.enterPage, this.from})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    enterPage,
    transitionsBuilder:
        (context, animation, anotherAnimation, child) {
      return  SlideTransition(
        position: Tween(
            begin: Offset(from ? 1.0 : -1.0, 0.0),
            end: Offset(0.0, 0.0))
            .animate(animation),
        child: child,
      );
    },
  );
}
