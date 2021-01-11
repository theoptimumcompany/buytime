
import 'dart:async';

import 'package:BuyTime/reblox/model/service/service_state.dart';
import 'package:BuyTime/utils/b_cube_grid_spinner.dart';
import 'package:BuyTime/utils/size_config.dart';
import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class ServiceDetails extends StatefulWidget {
  final ServiceState serviceState;

  ServiceDetails({@required this.serviceState});

  @override
  createState() => _ServiceDetailsState();

}

class _ServiceDetailsState extends State<ServiceDetails> with SingleTickerProviderStateMixin {

  ServiceState serviceState;

  @override
  void initState() {
    super.initState();
    serviceState = widget.serviceState;
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

    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ///Background Image
                Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        ///Background image
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/img/golfCourt.png'),
                                      fit: BoxFit.fill
                                  )
                              ),
                            ),
                          ),
                        ),
                        ///Back button
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(top: 25.0),
                              child: IconButton(
                                iconSize: 30,
                                icon: Icon(
                                  Icons.keyboard_arrow_left,
                                  color: Colors.white,
                                ),
                                onPressed: () async{
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                ///Sign up & Sign in & ToS % Privacy policy
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///Service Name Text
                      Container(
                        margin: EdgeInsets.only(top:  SizeConfig.safeBlockVertical * 2.5),
                        child: Text(
                          serviceState.name ?? 'ServiceName',
                          style: TextStyle(
                              fontFamily: BuytimeTheme.FontFamily,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.safeBlockHorizontal * 4
                          ),
                        ),
                      ),
                      ///Service Name Text
                      Container(
                        child: Text(
                          serviceState.name ?? 'ServiceName',
                          style: TextStyle(
                              fontFamily: BuytimeTheme.FontFamily,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.safeBlockHorizontal * 4
                          ),
                        ),
                      ),
                      ///Amount
                      Container(
                        child: Text(
                          serviceState.price != null ? '€ ${serviceState.price}' : '€ 99/ Hour',
                          style: TextStyle(
                              fontFamily: BuytimeTheme.FontFamily,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.safeBlockHorizontal * 4
                          ),
                        ),
                      ),
                      ///Add to card
                      Container(
                          width: SizeConfig.safeBlockHorizontal * 55,
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 2),
                          child: RaisedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return  WillPopScope(
                                        onWillPop: () async {
                                          FocusScope.of(context).unfocus();
                                          return false;
                                        },
                                        child: Container(
                                            height: SizeConfig.safeBlockVertical * 100,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(.8),
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: SizeConfig.safeBlockVertical * 20,
                                                    height: SizeConfig.safeBlockVertical * 20,
                                                    child: Center(
                                                      child: BCubeGridSpinner(
                                                        color: Colors.transparent,
                                                        size: SizeConfig.safeBlockVertical * 15,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                        )
                                    );
                                  });

                              Timer(Duration(milliseconds: 10000), (){
                                Navigator.of(context).pop();
                                /*Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ConfirmBooking()),
                                    );*/
                              });
                            },
                            textColor: BuytimeTheme.TextWhite,
                            color: BuytimeTheme.UserPrimary,
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5),
                            ),
                            child: Text(
                              "ADD TO CART",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                      ),
                      ///Description
                      Container(
                          margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 10),
                          alignment: Alignment.center,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: (){
                                },
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    serviceState.description != null ? serviceState.description : 'Lorem Ipsum ...',
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.UserPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                )
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
      /* )*/
    );
  }
}
