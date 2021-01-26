import 'package:Buytime/reusable/back_button_blue.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'UI_U_TermsAndConditions.dart';

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
                          TextSpan(text: 'Qui trovi i '),
                          TextSpan(
                              text: 'Termini e condizioni',
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TermsAndConditions('')),
                                  );
                                }),
                          TextSpan(text: ' che devi accettare per utilizzare il nostro servizio come business.'),

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
