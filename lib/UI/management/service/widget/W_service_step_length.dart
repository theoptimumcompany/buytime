import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:flutter/cupertino.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

class StepLength extends StatefulWidget {
  StepLength({this.media});

  Size media;

  @override
  State<StatefulWidget> createState() => StepLengthState();
}

class StepLengthState extends State<StepLength> {

  ///Length vars
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();
  TextEditingController limitBookingController = TextEditingController();
  GlobalKey<FormState> _formSlotLengthKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    hourController.text = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.hour.toString();
    minuteController.text = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.minute.toString();
    limitBookingController.text = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.limitBooking.toString();
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          return Form(
            key: _formSlotLengthKey,
            child: Container(
                child: Column(
              children: [
                ///Service duration
                Row(
                  children: [
                    Container(
                      child: Flexible(
                        child: Text(
                          'Service duration', //TODO: <-- ADD TO LANGUAGE TRANSLATE
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: BuytimeTheme.TextBlack,
                            fontSize: media.height * 0.02,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///Hour
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: TextFormField(
                          enabled: true,
                          controller: hourController,
                          onChanged: (value) {
                            setState(() {
                              hourController.text = value;
                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotHour(int.parse(hourController.text)));
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              hourController.text = value;
                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotHour(int.parse(hourController.text)));
                            });
                          },
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: BuytimeTheme.DividerGrey,
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              labelText: 'Hour',
                              labelStyle: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w400,
                              ),
                              errorMaxLines: 2,
                              errorStyle: TextStyle(
                                color: BuytimeTheme.ErrorRed,
                                fontSize: 12.0,
                              ),
                              suffixText: 'h'),
                          style: TextStyle(
                            fontFamily: BuytimeTheme.FontFamily,
                            color: Color(0xff666666),
                            fontWeight: FontWeight.w800,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please insert an hour';
                            }
                            return null;
                          },
                        ),
                      )),
                      Container(
                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1),
                      ),

                      ///Minute
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: TextFormField(
                          enabled: true,
                          controller: minuteController,
                          onChanged: (value) {
                            setState(() {
                              minuteController.text = value;
                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMinute(int.parse(minuteController.text)));
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              minuteController.text = value;
                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMinute(int.parse(minuteController.text)));                            });
                          },
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: BuytimeTheme.DividerGrey,
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              labelText: 'Minute',
                              labelStyle: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w400,
                              ),
                              errorMaxLines: 2,
                              errorStyle: TextStyle(
                                color: BuytimeTheme.ErrorRed,
                                fontSize: 12.0,
                              ),
                              suffixText: 'm'),
                          style: TextStyle(
                            //fontSize: 12,
                            fontFamily: BuytimeTheme.FontFamily,
                            color: Color(0xff666666),
                            fontWeight: FontWeight.w800,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please insert a minute';
                            }
                            return null;
                          },
                        ),
                      ))
                    ],
                  ),
                ),

                /// Resume text time duration
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Container(
                        child: Flexible(
                          child: Text(
                            'This service offered to guests that lasts ___ minutes',
                            //TODO: <-- ADD TO LANGUAGE TRANSLATE
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: BuytimeTheme.TextBlack,
                              fontSize: media.height * 0.018,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                ///Title MultiBooking
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    children: [
                      Container(
                        child: Flexible(
                          child: Text(
                            'Multiple Bookings', //TODO: <-- ADD TO LANGUAGE TRANSLATE
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: BuytimeTheme.TextBlack,
                              fontSize: media.height * 0.02,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///Booking Limit
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: TextFormField(
                          enabled: true,
                          controller: limitBookingController,
                          onChanged: (value) {
                            setState(() {
                              limitBookingController.text = value;
                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotLimitBooking(int.parse(limitBookingController.text)));
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              limitBookingController.text = value;
                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotLimitBooking(int.parse(limitBookingController.text)));
                            });
                          },
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: BuytimeTheme.DividerGrey,
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              labelText: 'Booking limit',
                              labelStyle: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w400,
                              ),
                              errorMaxLines: 2,
                              errorStyle: TextStyle(
                                color: BuytimeTheme.ErrorRed,
                                fontSize: 12.0,
                              ),
                              suffixText: 'limit'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please insert a limit';
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontFamily: BuytimeTheme.FontFamily,
                            color: Color(0xff666666),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      )),
                      Container(
                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1),
                      ),

                      ///Empty
                      Flexible(
                          child: GestureDetector(
                        onTap: () async {},
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Container(),
                        ),
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Container(
                        child: Flexible(
                          child: Text(
                            'This service has a limit of bookings of ' + limitBookingController.text, //TODO: <-- ADD TO LANGUAGE TRANSLATE
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: BuytimeTheme.TextBlack,
                              fontSize: media.height * 0.02,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
          );
        });
  }
}
