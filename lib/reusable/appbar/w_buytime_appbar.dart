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

import 'package:Buytime/reusable/appbar/container_shape_bottom_circle.dart';
import 'package:Buytime/splash_screen.dart';
import 'package:Buytime/reusable/appbar/w_container_shape_bottom_circle.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';

class BuytimeAppbar extends StatelessWidget implements PreferredSizeWidget {
  List<Widget> children = [];
  final double _preferredHeight = 65.0;
  double width;
  double height;
  Color background; //BuytimeTheme.ManagerPrimary;

  BuytimeAppbar({
    @required this.children,
    @required this.width,
    this.height,
    this.background
  });

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    return Container(
        height: statusbarHeight + _preferredHeight,
        child: CustomPaint(
          painter: ContainerShapeBottomCircle(
            background ?? BuytimeTheme.ManagerPrimary,
          ),
          child: Padding(
            padding: new EdgeInsets.only(top: statusbarHeight),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: children),
          ),
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}
