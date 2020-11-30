import 'package:BuyTime/reusable/appbar/container_shape_bottom_circle.dart';
import 'package:BuyTime/splash_screen.dart';
import 'package:flutter/material.dart';

class BuyTimeAppbarUser extends StatelessWidget implements PreferredSizeWidget {
  List<Widget> children = [];
  final double _preferredHeight = 80.0;
  double width = 400.0;
  double height = 200.0;

  BuyTimeAppbarUser({
    @required this.children,
    @required this.width,
    @required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      child: SafeArea(
        child: CustomPaint(
          painter: ContainerShapeBottomCircle(
            Color.fromRGBO(1, 159, 224, 1.0)
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: children),
    ),
      )
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}