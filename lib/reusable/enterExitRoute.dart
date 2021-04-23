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
/*import 'package:flutter/material.dart';
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
                begin: from ? Offset(0.0, 0.0) : Offset(-1.0, 0.0),
                end: from ? Offset(-1.0, 0.0) : Offset(0.0, 0.0),
              ).animate(animation),
              child: exitPage,
            ),
            SlideTransition(
              position: new Tween<Offset>(
                begin: from ? Offset(1.0, 0.0) : Offset(-1.0, 0.0),
                end: from ? Offset.zero : Offset(0.0, 0.0),
              ).animate(animation),
              child: enterPage,
            )
          ],
        ),
  );
}*/

