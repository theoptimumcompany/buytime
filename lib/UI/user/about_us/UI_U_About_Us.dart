import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reusable/appbar/user_buytime_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';



class UI_U_AboutUs extends StatefulWidget {
  final String title = 'About Us';

  @override
  State<StatefulWidget> createState() => UI_U_AboutUsState();
}

class UI_U_AboutUsState extends State<UI_U_AboutUs> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;

    return StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, snapshot) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 20.0),
                        child: Text(
                          "About Us",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: media.height * 0.035,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                            child: Column(
                              children: [
                                Text(
                                  "Buytime was created in 2020 by an enthusiast group of tech people who loved to experiment with new technologies.",
                                  style: new TextStyle(
                                    fontSize: media.height * 0.028,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Image.asset('assets/img/aboutus.png', height: media.height * 0.4),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '''© The Optimum Company S.r.l, 2020          
                                   Icons by Freepick''',
                                    style: new TextStyle(
                                      fontSize: media.height * 0.025,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      )
                    ],
                  ));
            });
  }
}
