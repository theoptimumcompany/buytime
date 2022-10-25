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

class ErrorDialog extends StatelessWidget {

  String message;
  String closeMessage;

  ErrorDialog(String message, String closeMessage){
    this.message = message;
    this.closeMessage = closeMessage;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: _buildContent(context, media),
    );
  }

  _buildContent(BuildContext context, Size media) => Container(
    height: media.height * .4,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ///Error message
        Text(
          this.message,
          style: TextStyle(
            fontFamily: BuytimeTheme.FontFamily,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        ///OK button
        MaterialButton(
          elevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Colors.white,
          color: Colors.blue,
          padding: EdgeInsets.all(media.width * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          child: Text(
            this.closeMessage,
            style: TextStyle(
              fontSize: 24,
              fontFamily: BuytimeTheme.FontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    ),
  );

}