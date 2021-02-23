import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/b_cube_grid_spinner.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
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
    debugPrint('image: ${serviceState.image1}');
  }


  @override
  void dispose() {
    super.dispose();
  }

  String version200(String imageUrl) {
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0 && imageUrl.contains("http")) {
      extension = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_1000x1000" + extension;
    }else {
      result = "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }
    return result;
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                                      image: NetworkImage(version200(serviceState.image1)),
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
                              margin: EdgeInsets.only(top: 10.0),
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
                ///Service Name
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///Service Name Text
                      Container(
                        margin: EdgeInsets.only(top:  SizeConfig.safeBlockVertical * 2.5),
                        child: Text(
                          serviceState.name ?? AppLocalizations.of(context).serviceName,
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
                          serviceState.name ?? AppLocalizations.of(context).serviceName,
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
                          serviceState.price != null ? '€ ${serviceState.price}' : '€ 99/ ' + AppLocalizations.of(context).hour,
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
                              AppLocalizations.of(context).addToCart,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                      ),
                      ///Description
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, bottom: SizeConfig.safeBlockVertical * 1),
                          alignment: Alignment.center,
                          child: Text(
                            serviceState.description != null ? serviceState.description : 'Lorem Ipsum ...',
                            style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: SizeConfig.safeBlockHorizontal * 4
                            ),
                          ),
                        ),
                      )
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
