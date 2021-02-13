import 'package:Buytime/reusable/appbar/container_shape_bottom_circle.dart';
import 'package:Buytime/splash_screen.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';

class BuytimeAppbarManager extends StatelessWidget implements PreferredSizeWidget {
  List<Widget> children = [];
  final double _preferredHeight = 70.0;
  double width;
  double height;
  Color background = BuytimeTheme.UserPrimary; //Color.fromRGBO(0, 103, 145, 1.0);

  BuytimeAppbarManager({
    @required this.children,
    @required this.width,
    @required this.height,
    this.background
  });

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    return Container(
        height: statusbarHeight + _preferredHeight,
        child: CustomPaint(
          painter: ContainerShapeBottomCircle(
            background,
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
