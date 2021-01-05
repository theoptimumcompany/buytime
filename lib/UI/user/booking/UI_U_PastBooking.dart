import 'dart:async';

import 'package:BuyTime/UI/user/booking/UI_U_BookingPage.dart';
import 'package:BuyTime/reusable/custom_bottom_button_widget.dart';
import 'package:BuyTime/reusable/past_booking_card_widget.dart';
import 'package:BuyTime/utils/size_config.dart';
import 'package:BuyTime/utils/theme/buytime_config.dart';
import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class PastBooking extends StatefulWidget {


  @override
  _PastBookingState createState() => _PastBookingState();
}

class _PastBookingState extends State<PastBooking> {

  List<PastBookingCardWidget> cards = new List();

  bool showList = false;
  Timer timer;
  @override
  void initState() {
    super.initState();
    cards.add(PastBookingCardWidget('Hotel Hermitage', '22 August - 29 August 2020', 'assets/img/hermitage.png', null));
    cards.add(PastBookingCardWidget('Ice Resort', '12 July - 19 July 2019', 'assets/img/iceresort.png', null));

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        showList = !showList;
      });
    });
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BuytimeTheme.BackgroundCerulean,
        elevation: 0,
        /*actions: [
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
            onPressed: (){

            },
          ),
        ],*/
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
          ),
          onPressed: () async{
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ///Past Bookings Text
              Expanded(
                flex: 3,
                child: Container(
                  color: BuytimeTheme.BackgroundCerulean,
                  //height: SizeConfig.safeBlockVertical * 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 25.0),
                        child: Text(
                          'Past bookings',
                          style: TextStyle(
                              fontFamily: BuytimeTheme.FontFamily,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.safeBlockHorizontal * 7
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 18,
                child: Column(
                  children: [
                    ///Card list
                    Expanded(
                      flex: 8,
                      child: showList ?
                        Container(
                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0),
                        alignment: Alignment.centerLeft,
                        child: MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: cards.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index){
                                PastBookingCardWidget pqstBooking = cards.elementAt(index);
                                return Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 8, right: SizeConfig.safeBlockHorizontal * 8, bottom: SizeConfig.safeBlockVertical * 3),
                                  child: _OpenContainerWrapper(
                                    index: index,
                                    closedBuilder: (BuildContext _, VoidCallback openContainer) {
                                      pqstBooking.callback = openContainer;
                                      return pqstBooking;
                                    },
                                  ),
                                );
                              },
                            )
                        ),
                      ) :
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: SizeConfig.safeBlockVertical * 28,
                            width: SizeConfig.safeBlockHorizontal * 80,
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                  image: AssetImage('assets/img/nobookings.png'),
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),
                          ///Description
                          Expanded(
                            flex: 3,
                            child: Container(
                                margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 8, right: SizeConfig.safeBlockHorizontal * 8, top: SizeConfig.safeBlockVertical * 5),
                                child: Text(
                                  'Your past booking with us will appear here.\n\n'
                                      'Would you want to know more about Buytime network? ',
                                  style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18//SizeConfig.safeBlockHorizontal * 4
                                  ),
                                )
                            ),
                          )
                        ],
                      )
                    ),
                    ///Contact
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.white,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async{
                              String url = BuytimeConfig.FlaviosNumber.trim();
                              debugPrint('Restaurant phonenumber: ' + url);
                              if (await canLaunch('tel:$url')) {
                                await launch('tel:$url');
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: CustomBottomButtonWidget(
                                'Contact Us',
                                'Have any question?',
                                Icon(
                                  Icons.call,
                                  color: Colors.grey,
                                )
                            ),
                          ),
                        ),
                      )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    this.closedBuilder,
    this.transitionType,
    this.onClosed,
    this.index
  });

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool> onClosed;
  final int index;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (BuildContext context, VoidCallback _) {
        return BookingPage();
      },
      onClosed: onClosed,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      tappable: false,
      closedBuilder: closedBuilder,
      transitionDuration: Duration(milliseconds: 800),
    );
  }
}