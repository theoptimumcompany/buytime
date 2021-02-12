import 'dart:async';

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/appbar/manager_buytime_appbar.dart';
import 'package:Buytime/reusable/custom_bottom_button_widget.dart';
import 'package:Buytime/reusable/past_booking_card_widget.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingPage extends StatefulWidget {

  static String route = '/bookingPage';

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {

  TextEditingController _searchController = TextEditingController();

  BookingState bookingState;
  BusinessState businessState;
  ServiceListState serviceListState;
  List<ServiceState> serviceList = [];

  bool sameMonth = false;

  @override
  void initState() {
    super.initState();
  }

  String version1000(String imageUrl) {
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
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, snapshot) {

        bookingState = snapshot.booking;
        businessState = snapshot.business;
        serviceListState = snapshot.serviceList;
        serviceList = serviceListState.serviceListState;

        debugPrint('UI_U_BookingPage: business logo => ${businessState.logo}');
        debugPrint('UI_U_BookingPage: service list lenght => ${serviceList.length}');
        String startMonth = DateFormat('MM').format(bookingState.start_date);
        String endMonth = DateFormat('MM').format(bookingState.end_date);

        if(startMonth == endMonth)
          sameMonth = true;
        else
          sameMonth = false;


        return  WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            appBar: BuytimeAppbarManager(
              background: Color.fromRGBO(119, 148, 170, 1.0),
              width: media.width,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Buytime',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                            color: BuytimeTheme.TextWhite,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: BuytimeTheme.TextWhite,
                      size: 30.0,
                    ),
                    //tooltip: AppLocalizations.of(context).createBusinessPlain,
                    onPressed: () {
                      /*Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UI_M_CreateBusiness()),
                        );*/
                    },
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: Container(
                      width: double.infinity,
                      color: BuytimeTheme.DividerGrey,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///Business Logo
                          Container(
                            //margin: EdgeInsets.only(left: SizeConfig.safeBlockVertical * 1, right: SizeConfig.safeBlockHorizontal * 1),
                            width: SizeConfig.safeBlockVertical * 20, ///25%
                            height: SizeConfig.safeBlockVertical * 20, ///25%
                            decoration: BoxDecoration(
                              color: Color(0xffE6E7E8),
                              /*borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                          border: Border.all(
                              color: Color(0xffA694C6),
                              width: 4
                          ),*/
                            ),
                            child: CachedNetworkImage(
                              imageUrl: businessState.logo,
                              imageBuilder: (context, imageProvider) => Container(
                                //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                                decoration: BoxDecoration(
                                  //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                          ///Greetings & Portfolio
                          Container(
                            height: SizeConfig.safeBlockVertical * 18,
                            width: double.infinity,
                            color: BuytimeTheme.BackgroundWhite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///Greetings
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                                  child: Text(
                                    'Hi ${bookingState.user.first.name}',
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextBlack,
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizeConfig.safeBlockHorizontal * 7
                                    ),
                                  ),
                                ),
                                ///Portfolio
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                  child: Text(
                                    'Your holiday in Portoferraio',
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                ),
                                ///Date
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 0.5),
                                  child: Text(
                                    sameMonth ? '${DateFormat('dd').format(bookingState.start_date)}-${DateFormat('dd MMMM').format(bookingState.end_date)}' : '${DateFormat('dd MMMM').format(bookingState.start_date)}',
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ///Top Service
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                              padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                              color: BuytimeTheme.BackgroundWhite,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///Top Services
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                    child: Text(
                                      'Top Services',
                                      style: TextStyle(
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextDark,
                                          fontWeight: FontWeight.bold,
                                          fontSize: SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                  serviceList.isNotEmpty ? CustomScrollView(shrinkWrap: true, slivers: [
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate((context, index) {
                                        //MenuItemModel menuItem = menuItems.elementAt(index);
                                        ServiceState service = serviceList.elementAt(index);

                                        return Container(
                                          color: Colors.black54,
                                        );
                                      },
                                        childCount: serviceList.length > 5 ? serviceList.getRange(0, 5).length : serviceList.length,
                                      ),
                                    ),
                                  ]) : Container(
                                    height: SizeConfig.safeBlockVertical * 8,
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                    decoration: BoxDecoration(
                                        color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Center(
                                        child: Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                          alignment: Alignment.centerLeft,
                                          child:  Text(
                                            'No active service found',
                                            style: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextGrey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16
                                            ),
                                          ),
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          ///Search & Contact
                          Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                            height: SizeConfig.safeBlockVertical * 24,
                            width: double.infinity,
                            color: BuytimeTheme.BackgroundWhite,
                            child: Column(
                              children: [
                                ///Search
                                Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
                                  height: SizeConfig.safeBlockHorizontal * 20,
                                  child: TextFormField(
                                    controller: _searchController,
                                    textAlign: TextAlign.start,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xff666666)),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      ),
                                      errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.redAccent),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      ),
                                      labelText: 'What are you looking for?',
                                      helperText: 'Search for services and ideas around you',
                                      //hintText: "email *",
                                      //hintStyle: TextStyle(color: Color(0xff666666)),
                                      labelStyle: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: Color(0xff666666),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      helperStyle:  TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: Color(0xff666666),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      suffixIcon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        Icons.search,
                                        color: Color(0xff666666),
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: Color(0xff666666),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ///Contact
                                Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(50))
                                    ),
                                    child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          onTap: () async {
                                            String url = businessState.phone_number;
                                            debugPrint('Restaurant phonenumber: ' + url);
                                            if (await canLaunch('tel:$url')) {
                                              await launch('tel:$url');
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                ///Text
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        'Speak with ${businessState.responsible_person_name}',
                                                        style: TextStyle(
                                                            fontFamily: BuytimeTheme.FontFamily,
                                                            color: BuytimeTheme.TextBlack,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                                      child: Text(
                                                        'your dedicated advisor',
                                                        style: TextStyle(
                                                            fontFamily: BuytimeTheme.FontFamily,
                                                            color: BuytimeTheme.TextGrey,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                ///Icon
                                                Icon(
                                                  Icons.call,
                                                  color: BuytimeTheme.ActionButton,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                    )
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 2),
                            height: SizeConfig.safeBlockVertical * 30,
                            width: double.infinity,
                            color: BuytimeTheme.BackgroundWhite,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}