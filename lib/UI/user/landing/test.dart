// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:BuyTime/utils/b_cube_grid_spinner.dart';
import 'package:BuyTime/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';


/// The demo page for [OpenContainerTransform].
class Test extends StatefulWidget {
  @override
  _TestState createState() {
    return _TestState();
  }
}

class _TestState extends State<Test> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 10),
                alignment: Alignment.center,
                child: BCubeGridSpinner(
                  color: Colors.white,
                  size: 100,
                )
            ),
          ],
        )
      ),
    );
  }
}