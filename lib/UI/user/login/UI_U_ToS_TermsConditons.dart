import 'dart:async';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class TosTermsConditons extends StatefulWidget {

  String route = 'ToSTermsConditions';
  String path;
  TosTermsConditons(this.path);

  @override
  createState() => _TosTermsConditonsState();

}

class _TosTermsConditonsState extends State<TosTermsConditons> with WidgetsBindingObserver{

  ///Controller
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();

  ///Pdf values
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;

  @override
  void initState() {
    super.initState();
    debugPrint('UI_U_ToS_TermsConditions - path 1 : ${widget.path}');
  } //PDFViewController _pdfViewController;



  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;
    debugPrint('UI_U_ToS_TermsConditions - path 2 : ${widget.path}');
    SizeConfig().init(context);

   widget.path ??= '/';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: BuytimeTheme.UserPrimary,
          ),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ///Logo & Buytime text & PDF
          Positioned(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///Logo & Buytime text
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
                                  blurRadius: 6,
                                  offset: Offset(0, 0), // changes position of shadow
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
                                  "Buytime",
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
                    ///PDF
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
                            defaultPage: _currentPage,
                            nightMode: false,
                            preventLinkNavigation: false, // if set to true the link is handled in flutter
                            onError: (e) {
                              print('UI_U_ToS_TermsConditions - path error : ' + e);
                            },
                            onRender: (_pages) {
                              debugPrint('UI_U_ToS_TermsConditions - path 3 : ${widget.path}');
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
          ///Circular progress bar
          !pdfReady
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Offstage()
        ],
      ),
      ///Floating button
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
      ,
    );
  }
}

