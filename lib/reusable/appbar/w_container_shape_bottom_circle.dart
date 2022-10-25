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

import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';

class ContainerShapeBottomCircle extends CustomPainter {

  ContainerShapeBottomCircle(this.colour);

  Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = new Paint();
    paint.color = colour;
    //..color = BuytimeTheme.ManagerPrimary;

    Path path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, size.height * 1.08, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}