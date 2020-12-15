import 'package:BuyTime/reusable/appbar/container_shape_bottom_circle.dart';
import 'package:BuyTime/splash_screen.dart';
import 'package:flutter/material.dart';

class BuyTimeAppbarUser extends StatelessWidget implements PreferredSizeWidget {
  List<Widget> children = [];
  final double _preferredHeight = 200.0;
  double width;
  double height;

  BuyTimeAppbarUser({
    @required this.children,
    @required this.width,
    @required this.height,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    var mediaWidth = media.width;
    return Container(
        height: mediaHeight * 0.12,
        child: CustomPaint(
          painter: ContainerShapeBottomCircle(Color.fromRGBO(1, 159, 224, 1.0)),
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children),
          ),
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}
