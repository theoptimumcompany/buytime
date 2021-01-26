import 'package:Buytime/reusable/appbar/container_shape_bottom_circle.dart';
import 'package:Buytime/splash_screen.dart';
import 'package:flutter/material.dart';

class BuytimeAppbarUser extends StatelessWidget implements PreferredSizeWidget {
  List<Widget> children = [];
  final double _preferredHeight = 70.0;
  double width;
  double height;

  BuytimeAppbarUser({
    @required this.children,
    @required this.width,
    @required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    return Container(
        height: statusbarHeight + _preferredHeight,
        child: CustomPaint(
          painter: ContainerShapeBottomCircle(Color.fromRGBO(1, 159, 224, 1.0)),
          child: Padding(
            padding: new EdgeInsets.only(top: statusbarHeight),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children),
          ),
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}
