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

import 'dart:async';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class TermsAndConditions extends StatefulWidget {
  String path;
  TermsAndConditions(this.path);
  @override
  createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> with SingleTickerProviderStateMixin {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  ///Pdf values
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;

  @override
  void initState() {
    super.initState();
    debugPrint('UI_U_terms_conditions => path: ${widget.path}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: BuytimeTheme.UserPrimary,
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
            body: SafeArea(
              child: Center(
                  child: Stack(
                    children: <Widget>[
                      ///Logo & Buytime text
                      Positioned(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      ///Logo
                                      Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black54.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 3,
                                              offset: Offset(0, 3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Image.asset('assets/img/img_buytime.png',
                                            height: media.height * 0.12),
                                      ),
                                      SizedBox(
                                        height: media.height * .03,
                                      ),
                                      ///Buytime text
                                      Container(
                                        // width: media.width * .8,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                            child: Text(
                                              AppLocalizations.of(context).buytime,
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: SizeConfig.safeBlockVertical * 5,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 6,
                                    child: Container(
                                      color: Colors.white,
                                      child: PDFView(
                                        filePath: widget.path,
                                        fitPolicy: FitPolicy.BOTH,
                                        autoSpacing: true,
                                        enableSwipe: true,
                                        pageSnap: true,
                                        swipeHorizontal: true,
                                        nightMode: false,
                                        onError: (e) {
                                          print(e);
                                        },
                                        onRender: (_pages) {
                                          setState(() {
                                            _totalPages = _pages;
                                            pdfReady = true;
                                          });
                                        },
                                        onViewCreated: (PDFViewController pdfViewController) {
                                          _controller.complete(pdfViewController);
                                        },
                                        onPageChanged: (int page, int total) {
                                          setState(() {
                                            _currentPage = page;
                                          });
                                        },
                                        onPageError: (page, e) {},
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      !pdfReady
                          ? Center(
                        child: CircularProgressIndicator(),
                      )
                          : Offstage()
                    ],
                  )
              ),
            ),
              floatingActionButton: FutureBuilder<PDFViewController>(
                future: _controller.future,
                builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        _currentPage > 0
                            ? FloatingActionButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)
                              )
                          ),
                          heroTag: "bt_back",
                          mini: true,
                          backgroundColor: Colors.redAccent,
                          child: Icon(CupertinoIcons.back,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            _currentPage -= 1;
                            await snapshot.data.setPage(_currentPage);
                          },
                        )
                            : Offstage(),
                        _currentPage+1 < _totalPages
                            ? FloatingActionButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)
                              )
                          ),
                          heroTag: "bt_forward",
                          mini: true,
                          backgroundColor: BuytimeTheme.UserPrimary,
                          child: Icon(CupertinoIcons.forward,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            _currentPage += 1;
                            //_pdfViewController.setPage(_currentPage);
                            await snapshot.data.setPage(_currentPage);
                          },
                        )
                            : Offstage(),
                      ],
                    );
                  }

                  return Container();
                },
              )
            /* )*/
          )),
    );
  }
}
