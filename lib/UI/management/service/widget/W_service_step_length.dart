import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:Buytime/reusable/checkbox/W_checkbox_parent_child.dart';
import 'package:flutter/cupertino.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

class StepLength extends StatefulWidget {
  Size media;

  StepLength({this.media});

  @override
  State<StatefulWidget> createState() => StepLengthState();
}

class StepLengthState extends State<StepLength> {
  ///Length vars
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();
  TextEditingController limitBookingController = TextEditingController();
  GlobalKey<FormState> _formSlotLengthKey = GlobalKey<FormState>();

  String hour = '';
  String minute = '';
  String limitBooking = '';
  int durationSlider = 10;
  int bookingSlider = 1;
  bool bookingInfinity = false;
  int duration = 0;

  @override
  void initState() {
    super.initState();
  }

  void setDuration(){
   for(int i = 0; i < StoreProvider.of<AppState>(context).state.serviceSlot.numberOfInterval; i++){
     List<String> start = StoreProvider.of<AppState>(context).state.serviceSlot.startTime[i].split(":");
     int startHour = int.parse(start[0]);
     int startMinute = int.parse(start[1]);
     List<String> stop = StoreProvider.of<AppState>(context).state.serviceSlot.stopTime[i].split(":");
     int stopHour = int.parse(stop[0]);
     int stopMinute = int.parse(stop[1]);
     int localDuration = (((stopHour * 60) + stopMinute) - ((startHour * 60) + startMinute));
     if(duration == 0){
       duration = localDuration;
     }
     else{
       if(localDuration < duration){
         duration = localDuration;
       }
     }
   };
  }

  @override
  Widget build(BuildContext context) {
    setDuration();
    hour = StoreProvider.of<AppState>(context).state.serviceSlot.hour.toString();
    minute = StoreProvider.of<AppState>(context).state.serviceSlot.minute.toString();
    limitBooking = StoreProvider.of<AppState>(context).state.serviceSlot.limitBooking.toString();
    hourController.text = hour;
    minuteController.text = minute;
    limitBookingController.text = limitBooking;
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
                    children: [
                      // Text(
                      //   '10 m',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontSize: media.height * 0.02,
                      //     fontWeight: FontWeight.w700,
                      //     color: BuytimeTheme.TextGrey,
                      //   ),
                      // ),
                      Flexible(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: BuytimeTheme.UserPrimary[700],
                            inactiveTrackColor: BuytimeTheme.UserPrimary[100],
                            trackShape: RoundedRectSliderTrackShape(),
                            trackHeight: 4.0,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            thumbColor: BuytimeTheme.ManagerPrimary,
                            overlayColor: BuytimeTheme.ManagerPrimary.withAlpha(32),
                            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                            tickMarkShape: RoundSliderTickMarkShape(),
                            activeTickMarkColor: BuytimeTheme.ManagerPrimary,
                            inactiveTickMarkColor: BuytimeTheme.UserPrimary[100],
                            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: BuytimeTheme.ManagerPrimary,
                            valueIndicatorTextStyle: TextStyle(
                              color: BuytimeTheme.TextWhite,
                            ),
                          ),
                          child: Slider(
                            min: 10,
                            max: duration.toDouble(),
                            divisions: duration~/10,
                            label: '$durationSlider',
                            value: durationSlider.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                durationSlider = value.toInt();
                                StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMinute(durationSlider));
                              });
                            },
                          ),
                        ),
                      ),
                      // Text(
                      //   '100 m',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontSize: media.height * 0.02,
                      //     fontWeight: FontWeight.w700,
                      //     color: BuytimeTheme.TextGrey,
                      //   ),
                      // ),
                      // CustomLabeledCheckbox(
                      //   label: '∞',
                      //   value: durationInfinity,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       durationInfinity = value;
                      //     });
                      //   },
                      //   checkboxType: CheckboxType.Child,
                      //   activeColor: Colors.indigo,
                      // ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       ///Hour
                //       Flexible(
                //           child: Padding(
                //         padding: const EdgeInsets.only(top: 5.0),
                //         child: TextFormField(
                //           enabled: true,
                //           controller: hourController,
                //           onChanged: (value) {
                //             setState(() {
                //               StoreProvider.of<AppState>(context).dispatch(SetServiceSlotHour(int.parse(hourController.text)));
                //             });
                //           },
                //           onSaved: (value) {
                //             setState(() {
                //               StoreProvider.of<AppState>(context).dispatch(SetServiceSlotHour(int.parse(hourController.text)));
                //             });
                //           },
                //           textAlign: TextAlign.start,
                //           keyboardType: TextInputType.number,
                //           decoration: InputDecoration(
                //               filled: true,
                //               fillColor: BuytimeTheme.DividerGrey,
                //               enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                //               focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                //               // labelText: 'Hour',
                //               // labelStyle: TextStyle(
                //               //   fontFamily: BuytimeTheme.FontFamily,
                //               //   color: Color(0xff666666),
                //               //   fontWeight: FontWeight.w400,
                //               // ),
                //               errorMaxLines: 2,
                //               errorStyle: TextStyle(
                //                 color: BuytimeTheme.ErrorRed,
                //                 fontSize: 12.0,
                //               ),
                //               suffixText: 'h'),
                //           style: TextStyle(
                //             fontFamily: BuytimeTheme.FontFamily,
                //             color: Color(0xff666666),
                //             fontWeight: FontWeight.w800,
                //           ),
                //           validator: (value) {
                //             if (value.isEmpty) {
                //               return 'Please insert an hour';
                //             }
                //             return null;
                //           },
                //         ),
                //       )),
                //       Container(
                //         margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1),
                //       ),
                //
                //       ///Minute
                //       Flexible(
                //           child: Padding(
                //         padding: const EdgeInsets.only(top: 5.0),
                //         child: TextFormField(
                //           enabled: true,
                //           controller: minuteController,
                //           onChanged: (value) {
                //             setState(() {
                //               StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMinute(int.parse(minuteController.text)));
                //             });
                //           },
                //           onSaved: (value) {
                //             setState(() {
                //               StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMinute(int.parse(minuteController.text)));
                //             });
                //           },
                //           textAlign: TextAlign.start,
                //           keyboardType: TextInputType.number,
                //           decoration: InputDecoration(
                //               filled: true,
                //               fillColor: BuytimeTheme.DividerGrey,
                //               enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                //               focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                //               // labelText: 'Minute',
                //               // labelStyle: TextStyle(
                //               //   fontFamily: BuytimeTheme.FontFamily,
                //               //   color: Color(0xff666666),
                //               //   fontWeight: FontWeight.w400,
                //               // ),
                //               errorMaxLines: 2,
                //               errorStyle: TextStyle(
                //                 color: BuytimeTheme.ErrorRed,
                //                 fontSize: 12.0,
                //               ),
                //               suffixText: 'm'),
                //           style: TextStyle(
                //             //fontSize: 12,
                //             fontFamily: BuytimeTheme.FontFamily,
                //             color: Color(0xff666666),
                //             fontWeight: FontWeight.w800,
                //           ),
                //           validator: (value) {
                //             if (value.isEmpty) {
                //               return 'Please insert a minute';
                //             }
                //             return null;
                //           },
                //         ),
                //       ))
                //     ],
                //   ),
                // ),

                /// Resume text time duration
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Container(
                        child: Flexible(
                          child: Text(
                            'This service offered to guests that lasts $durationSlider minutes',
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
                // Padding(
                //   padding: const EdgeInsets.only(top: 5.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       ///Booking Limit
                //       Flexible(
                //           child: Padding(
                //         padding: const EdgeInsets.only(top: 5.0),
                //         child: TextFormField(
                //           enabled: true,
                //           controller: limitBookingController,
                //           onChanged: (value) {
                //             setState(() {
                //               StoreProvider.of<AppState>(context).dispatch(SetServiceSlotLimitBooking(int.parse(limitBookingController.text)));
                //             });
                //           },
                //           onSaved: (value) {
                //             setState(() {
                //               StoreProvider.of<AppState>(context).dispatch(SetServiceSlotLimitBooking(int.parse(limitBookingController.text)));
                //             });
                //           },
                //           textAlign: TextAlign.start,
                //           keyboardType: TextInputType.number,
                //           decoration: InputDecoration(
                //               filled: true,
                //               fillColor: BuytimeTheme.DividerGrey,
                //               enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                //               focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                //               // labelText: 'Booking limit',
                //               // labelStyle: TextStyle(
                //               //   fontFamily: BuytimeTheme.FontFamily,
                //               //   color: Color(0xff666666),
                //               //   fontWeight: FontWeight.w400,
                //               // ),
                //               errorMaxLines: 2,
                //               errorStyle: TextStyle(
                //                 color: BuytimeTheme.ErrorRed,
                //                 fontSize: 12.0,
                //               ),
                //               suffixText: 'limit'),
                //           validator: (value) {
                //             if (value.isEmpty) {
                //               return 'Please insert a limit';
                //             }
                //             return null;
                //           },
                //           style: TextStyle(
                //             fontFamily: BuytimeTheme.FontFamily,
                //             color: Color(0xff666666),
                //             fontWeight: FontWeight.w800,
                //           ),
                //         ),
                //       )),
                //       Container(
                //         margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1),
                //       ),
                //
                //       ///Empty
                //       Flexible(
                //           child: GestureDetector(
                //         onTap: () async {},
                //         child: Padding(
                //           padding: const EdgeInsets.only(top: 5.0),
                //           child: Container(),
                //         ),
                //       ))
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      // Text(
                      //   '10 m',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontSize: media.height * 0.02,
                      //     fontWeight: FontWeight.w700,
                      //     color: BuytimeTheme.TextGrey,
                      //   ),
                      // ),
                      Flexible(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: BuytimeTheme.UserPrimary[700],
                            inactiveTrackColor: BuytimeTheme.UserPrimary[100],
                            disabledThumbColor: BuytimeTheme.SymbolGrey,
                            disabledActiveTrackColor: BuytimeTheme.SymbolGrey,
                            trackShape: RoundedRectSliderTrackShape(),
                            trackHeight: 4.0,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            thumbColor: BuytimeTheme.ManagerPrimary,
                            overlayColor: BuytimeTheme.ManagerPrimary.withAlpha(32),
                            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                            tickMarkShape: RoundSliderTickMarkShape(),
                            activeTickMarkColor: BuytimeTheme.ManagerPrimary,
                            inactiveTickMarkColor: BuytimeTheme.UserPrimary[100],
                            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: BuytimeTheme.ManagerPrimary,
                            valueIndicatorTextStyle: TextStyle(
                              color: BuytimeTheme.TextWhite,
                            ),
                          ),
                          child: Slider(
                            min: 1,
                            max: 10,
                            divisions: 9,
                            label: '$bookingSlider',
                            value: bookingSlider.toDouble(),
                            onChanged: bookingInfinity
                                ? null
                                : (value) {
                                    setState(() {
                                      bookingSlider = value.toInt();
                                      StoreProvider.of<AppState>(context).dispatch(SetServiceSlotLimitBooking(bookingSlider));
                                    });
                                  },
                          ),
                        ),
                      ),
                      // Text(
                      //   '100 m',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontSize: media.height * 0.02,
                      //     fontWeight: FontWeight.w700,
                      //     color: BuytimeTheme.TextGrey,
                      //   ),
                      // ),
                      CustomLabeledCheckbox(
                        label: '∞',
                        value: bookingInfinity,
                        onChanged: (value) {
                          setState(() {
                            bookingInfinity = value;
                            //TODO: Var no duration
                          });
                        },
                        checkboxType: CheckboxType.Child,
                        activeColor: Colors.indigo,
                      ),
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
                            !bookingInfinity?'This service has a limit of bookings of ' + bookingSlider.toString(): 'This service has no limit of bookings', //TODO: <-- ADD TO LANGUAGE TRANSLATE
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