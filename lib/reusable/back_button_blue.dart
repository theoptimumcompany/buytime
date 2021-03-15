import 'package:flutter/material.dart';

class BackButtonBlue extends StatelessWidget {
  final BuildContext externalContext;

  const BackButtonBlue({
    Key key,
    @required this.media,
    @required this.externalContext,
  }) : super(key: key);

  final Size media;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      splashColor: Colors.white,
      highlightColor: Colors.white,
      color: Colors.transparent,
      onPressed: () {
        Navigator.pop(externalContext);
      },
      child: Image.asset(
        'assets/img/back_blue.png',
        height: media.width * 0.09,
      ),
    );
  }
}