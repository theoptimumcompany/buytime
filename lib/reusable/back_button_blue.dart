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