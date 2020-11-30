import 'package:BuyTime/reusable/back_button_blue.dart';
import 'package:flutter/material.dart';


class TermsAndConditions extends StatefulWidget {
  @override
  createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> with SingleTickerProviderStateMixin {
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
                    height: media.height * .005,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('testo molto lungo riguardo termini e condizioni'),
                  ),
                ],
              )),
            ),
            /* )*/
          )),
    );
  }
}
