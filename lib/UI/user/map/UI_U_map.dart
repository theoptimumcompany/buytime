import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/UI/user/login/UI_U_t_o_s_terms_conditons.dart';
import 'package:Buytime/UI/user/login/UI_U_login.dart';
import 'package:Buytime/UI/user/login/UI_U_registration.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:Buytime/UI/user/map/maps_sheet.dart';

class BuytimeMap extends StatefulWidget {
  bool user;
  String title;
  BusinessState businessState;
  BuytimeMap({@required this.user, this.title, this.businessState});

  @override
  createState() => _BuytimeMapState();
}

class _BuytimeMapState extends State<BuytimeMap> with SingleTickerProviderStateMixin, TickerProviderStateMixin {
  Animation _containerRadiusAnimation, _containerSizeAnimation, _containerColorAnimation;

  AnimationController _containerAnimationController;
  GoogleMapController mapController;

  LatLng _center;

  ///Animations
  Animation _animation;
  Animation _animation2;
  Animation _animation3;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    controller.setMapStyle(_mapStyle);
  }

  Set<Marker> markers = {};
  String _mapStyle = '';
  double lat = 0.0;
  double lng = 0.0;
  String address = '';
  @override
  void initState() {

    super.initState();
    _containerAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));

    _animation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(parent: _containerAnimationController, curve: new Interval(0.35, 1.0, curve: Curves.ease)));

    _animation2 = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(parent: _containerAnimationController, curve: new Interval(1.0, 1.25, curve: Curves.ease)));


    _containerRadiusAnimation = BorderRadiusTween(
        begin: BorderRadius.circular(100.0),
        end: BorderRadius.circular(0.0))
        .animate(CurvedAnimation(
        curve: Curves.ease, parent: _containerAnimationController));

    _containerSizeAnimation = Tween(begin: 0.0, end: 2.0).animate(
        CurvedAnimation(
            curve: Curves.ease, parent: _containerAnimationController));

    _containerColorAnimation =
        ColorTween(begin: BuytimeTheme.BackgroundWhite, end: BuytimeTheme.SymbolLightGrey).animate(
            CurvedAnimation(
                curve: Curves.ease, parent: _containerAnimationController));

    _containerAnimationController.forward();

    if(widget.businessState.coordinate.isNotEmpty){
      List<String> latLng = widget.businessState.coordinate.replaceAll(' ', '').split(',');
      if(latLng.length == 2){
        lat = double.parse(latLng[0]);
        lng = double.parse(latLng[1]);
      }
    }
    _center = LatLng(lat, lng);
    markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(LatLng(lat, lng).toString()),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: '${widget.businessState.name}',
        //snippet: '5 Star Rating',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(197),
    ));
    rootBundle.loadString('assets/json/grey_map.txt').then((string) {
      _mapStyle = string;
    });

    address = widget.businessState.street + ', ' + widget.businessState.street_number + ', ' + widget.businessState.ZIP + ', ' + widget.businessState.state_province;
  }

  @override
  void dispose() {
    _containerAnimationController?.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: BuytimeAppbar(
        background: !widget.user ? BuytimeTheme.ManagerPrimary : BuytimeTheme.UserPrimary,
        width: media.width,
        children: [
          ///Back Button
          IconButton(
            icon: Icon(Icons.chevron_left, color: BuytimeTheme.TextWhite),
            onPressed: () => Future.delayed(Duration.zero, () {
              Navigator.of(context).pop();
            }),
          ),
          ///Order ConfirmedTitle
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Text(
                widget.title,
                textAlign: TextAlign.start,
                style: BuytimeTheme.appbarTitle,
              ),
            ),
          ),
          SizedBox(
            width: 50.0,
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _containerAnimationController,
            builder: (context, index) {
              return Container(
                //transform: Matrix4.translationValues(_containerSizeAnimation.value * width - 200.0, 0.0, 0.0),
                width: _containerSizeAnimation.value * height,
                height: _containerSizeAnimation.value * height,
                decoration: BoxDecoration(
                    borderRadius: _containerRadiusAnimation.value,
                    color: _containerColorAnimation.value),
                child: Container(
                  height: (SizeConfig.safeBlockVertical * 100) - 60,
                  child: FadeTransition(
                    opacity: _animation,
                    child: Stack(
                      children: [
                        ///Google maps
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: GoogleMap(
                              onMapCreated: _onMapCreated,
                              markers: markers,
                              initialCameraPosition: CameraPosition(
                                target: _center,
                                zoom: 18.0,
                              ),
                            ),
                          ),
                        ),
                        ///Action buttons
                        Positioned.fill(
                          bottom: SizeConfig.safeBlockVertical * 2,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ///Open in Google maps
                                Container(
                                    width: 247,
                                    /// media.width * .6 | 247 | SizeConfig.safeBlockHorizontal * 68
                                    height: 44,
                                    /// 50 | SizeConfig.safeBlockVertical * 8.5
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5)
                                      ),
                                    ),
                                    child:  MaterialButton(
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      onPressed: () {
                                        //Utils.openMap(lat, lng);
                                        MapsSheet.show(
                                          context: context,
                                          onMapTap: (map) {
                                            map.showMarker(
                                              coords: Coords(lat, lng),
                                              title: widget.businessState.name,
                                              zoom: 18,
                                            );
                                          },
                                        );
                                      },
                                      textColor: BuytimeTheme.UserPrimary.withOpacity(0.3),
                                      color: Colors.white.withOpacity(0.9),
                                      //padding: EdgeInsets.all(media.width * 0.03),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5)
                                        ),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context).openInGoogleMaps,
                                        style: TextStyle(
                                            letterSpacing: 1.25,
                                            fontSize: 14,
                                            ///18 | SizeConfig.safeBlockHorizontal * 5
                                            fontFamily: BuytimeTheme.FontFamily,
                                            fontWeight: FontWeight.w500,
                                            color: widget.user? BuytimeTheme.UserPrimary :  BuytimeTheme.ButtonMalibu
                                        ),
                                      ),
                                    )
                                ),
                                ///Copy address
                                Container(
                                    width: 247,
                                    /// media.width * .6 | 247 | SizeConfig.safeBlockHorizontal * 68
                                    height: 44,
                                    /// 50 | SizeConfig.safeBlockVertical * 8.5
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0.1),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          bottomRight: Radius.circular(5)
                                      ),
                                    ),
                                    child:  MaterialButton(
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: address));
                                        Flushbar(
                                          padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
                                          margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2, left: SizeConfig.blockSizeHorizontal * 20, right: SizeConfig.blockSizeHorizontal * 20), ///2% - 20% - 20%
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          backgroundColor: BuytimeTheme.SymbolGrey,
                                          boxShadows: [
                                            BoxShadow(
                                              color: Colors.black45,
                                              offset: Offset(3, 3),
                                              blurRadius: 3,
                                            ),
                                          ],
                                          // All of the previous Flushbars could be dismissed by swiping down
                                          // now we want to swipe to the sides
                                          //dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                                          // The default curve is Curves.easeOut
                                          duration:  Duration(seconds: 2),
                                          forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                                          messageText: Text(
                                            AppLocalizations.of(context).copiedToClipboard,
                                            style: TextStyle(
                                                color: BuytimeTheme.TextWhite,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )..show(context);
                                      },
                                      textColor: BuytimeTheme.UserPrimary,
                                      color: Colors.white.withOpacity(0.9),
                                      //padding: EdgeInsets.all(media.width * 0.03),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5)
                                          )
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context).copyAddress,
                                        style: TextStyle(
                                            letterSpacing: 1.25,
                                            fontSize: 14,
                                            ///18 | SizeConfig.safeBlockHorizontal * 5
                                            fontFamily: BuytimeTheme.FontFamily,
                                            fontWeight: FontWeight.w500,
                                            color: widget.user? BuytimeTheme.UserPrimary :  BuytimeTheme.ButtonMalibu
                                        ),
                                      ),
                                    )
                                ),
                                ///Get Directions
                                Container(
                                    width: 247,
                                    /// media.width * .6 | 247 | SizeConfig.safeBlockHorizontal * 68
                                    height: 44,
                                    /// 50 | SizeConfig.safeBlockVertical * 8.5
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                    decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.circular(5),
                                        border: Border.all(
                                            color: BuytimeTheme.SymbolLightGrey
                                        )
                                    ),
                                    child:  MaterialButton(
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      onPressed: () async{
                                        //Utils.openMapWithDirections(lat, lng);
                                        MapsSheet.show(
                                          context: context,
                                          onMapTap: (map) {
                                            map.showDirections(
                                                destination: Coords(lat, lng),
                                                destinationTitle: widget.businessState.name
                                            );
                                          },
                                        );
                                      },
                                      textColor: BuytimeTheme.UserPrimary.withOpacity(0.3),
                                      color: widget.user ? BuytimeTheme.UserPrimary : BuytimeTheme.ManagerPrimary,
                                      //padding: EdgeInsets.all(media.width * 0.03),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context).getDirections.toUpperCase(),
                                        style: TextStyle(
                                            letterSpacing: 1.25,
                                            fontSize: 14,

                                            ///18 | SizeConfig.safeBlockHorizontal * 5
                                            fontFamily: BuytimeTheme.FontFamily,
                                            fontWeight: FontWeight.w500,
                                            color: BuytimeTheme.TextWhite),
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}