import 'package:Buytime/splash_screen.dart';
import 'package:flutter/material.dart';

class BuytimeSpinner extends StatelessWidget {
  const BuytimeSpinner({
    Key key,
    @required this.spinnerX,
    @required this.spinnerY,
    @required AnimationController arrowAnimationController,
    @required Animation arrowAnimation,
  }) : _arrowAnimationController = arrowAnimationController, _arrowAnimation = arrowAnimation, super(key: key);

  final double spinnerX;
  final double spinnerY;
  final AnimationController _arrowAnimationController;
  final Animation _arrowAnimation;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      CustomPaint(
        size: Size(spinnerX, spinnerY),
        painter: CirclePainter(),
      ),
      AnimatedBuilder(
        animation: _arrowAnimationController,
        builder: (context, child) => Transform.rotate(
          angle: _arrowAnimation.value,
          child: CustomPaint(
            size: Size(spinnerX, spinnerY),
            painter: new Tock(),
          ),
        ),
      ),
    ]);
  }
}