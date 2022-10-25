/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

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

