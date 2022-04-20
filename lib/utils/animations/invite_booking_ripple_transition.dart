import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InviteBookingRippleTransition extends StatefulWidget {
  static String route = '/inviteBookingRippleTransition';
  String booking;
  InviteBookingRippleTransition({Key key, this.booking}) : super(key: key);

  @override
  _InviteBookingRippleTransitionState createState() => _InviteBookingRippleTransitionState();
}


class _InviteBookingRippleTransitionState extends State<InviteBookingRippleTransition> {

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback((_) => bookingState = StoreProvider.of<AppState>(context).state.booking);
    //debugPrint('dynamic_links_helper => Post routing to invite booking ripple transition');
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        ///Check booking attivo per lo user
        print("ON INIT DISPATCH bookingRequestOnInvite");
        StoreProvider.of<AppState>(context).dispatch(BookingRequestOnInvite(widget.booking));
      },
      builder: (context, snapshot) {
        return Stack(children: [
          ///Ripple Effect
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: BuytimeTheme.BackgroundCerulean.withOpacity(.8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: SizeConfig.safeBlockVertical * 20,
                          height: SizeConfig.safeBlockVertical * 20,
                          child: Center(
                            child: SpinKitRipple(
                              color: Colors.white,
                              size: SizeConfig.safeBlockVertical * 18,
                            ),
                          ),
                        ),
                        Container(
                          // width: SizeConfig.safeBlockVertical * 20,
                          // height: SizeConfig.safeBlockVertical * 20,
                          child: Center(
                            child: Text(
                              'Checking the reservation for your account',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: BuytimeTheme.TextWhite,
                                  fontWeight: FontWeight.w800,
                                  //letterSpacing: 1.25
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ]);
      },
    );
  }
}
