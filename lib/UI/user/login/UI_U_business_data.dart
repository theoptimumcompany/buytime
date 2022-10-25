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

import 'package:Buytime/reusable/back_button_blue.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'UI_U_terms_and_conditions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BusinessData extends StatefulWidget {
  @override
  createState() => _BusinessDataState();
}

class _BusinessDataState extends State<BusinessData> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;
    TextStyle defaultStyle = TextStyle(color: Colors.black54, fontSize: 20.0);
    TextStyle linkStyle = TextStyle(
        color: Color.fromRGBO(1, 159, 224, 1.0),
        fontWeight: FontWeight.w700
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: SafeArea(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [BackButtonBlue(media: media, externalContext: context)])),
                  Container(
                    child: Image.asset('assets/img/img_buytime.png', height: media.height * 0.22),
                  ),
                  SizedBox(
                    height: media.height * .01,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        style: defaultStyle,
                        children: <TextSpan>[
                          TextSpan(text: AppLocalizations.of(context).hereYouFind),
                          TextSpan(
                              text: AppLocalizations.of(context).termsAndConditions,
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TermsAndConditions('')),
                                  );
                                }),
                          TextSpan(text: AppLocalizations.of(context).haveToAccept),

                        ],
                      ),
                    ),
                  ),
                  Form(

                  )
                ],
              )),
            ),
            /* )*/
          )),
    );
  }
}
