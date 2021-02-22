import 'package:Buytime/reblox/model/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/service/service_time_slot_state.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/utils/size_config.dart';

import 'package:Buytime/utils/theme/buytime_theme.dart';

import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef OnFilePickedCallback = void Function();

class StepLength extends StatefulWidget {
  StepLength({this.media});

  Size media;

  @override
  State<StatefulWidget> createState() => StepLengthState();
}

class StepLengthState extends State<StepLength> {
  int indexStepper;

  ///Length vars
  TextEditingController _hourController = TextEditingController();
  TextEditingController _minuteController = TextEditingController();
  TextEditingController _limitBookingController = TextEditingController();
  var _formSlotLengthKey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    indexStepper = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.actualSlotIndex;
    _hourController = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.hourController[indexStepper];
    _minuteController = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.minuteController[indexStepper];
    _limitBookingController = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.limitBookingController[indexStepper];
    _formSlotLengthKey = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.formSlotLengthKey[indexStepper];

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
                          controller: _hourController,
                          onChanged: (value) {
                            setState(() {
                              _hourController.text = value;
                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotHourController(_hourController.text, indexStepper));
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              _hourController.text = value;
                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotHourController(_hourController.text, indexStepper));
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
                          controller: _minuteController,
                          onChanged: (value) {
                            setState(() {
                              _minuteController.text = value;
                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMinuteController(_minuteController.text, indexStepper));
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              _minuteController.text = value;
                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMinuteController(_minuteController.text, indexStepper));
                            });
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
                          controller: _limitBookingController,
                          onChanged: (value) {
                            setState(() {
                              _limitBookingController.text = value;
                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMinuteController(_limitBookingController.text, indexStepper));
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              _limitBookingController.text = value;
                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMinuteController(_limitBookingController.text, indexStepper));
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
                            'This service has a limit of bookings of ' + _limitBookingController.text, //TODO: <-- ADD TO LANGUAGE TRANSLATE
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
