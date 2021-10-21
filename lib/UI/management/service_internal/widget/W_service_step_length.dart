import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:flutter/cupertino.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_picker/flutter_picker.dart';

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
  TextEditingController dayController = TextEditingController();
  TextEditingController maxController = TextEditingController();
  GlobalKey<FormState> _formSlotLengthKey = GlobalKey<FormState>();

  int hour = 0;
  int minute = 0;
  int limitBooking = 1;
  int day = 0;
  int maxQuantity = 1;

  //String errorDay = null;

  @override
  Future<void> initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      hour = StoreProvider.of<AppState>(context).state.serviceSlot.hour;
      minute = StoreProvider.of<AppState>(context).state.serviceSlot.minute;
      day = StoreProvider.of<AppState>(context).state.serviceSlot.day;
      maxQuantity = StoreProvider.of<AppState>(context).state.serviceSlot.maxQuantity == 0 ? 1 : StoreProvider.of<AppState>(context).state.serviceSlot.maxQuantity;
      limitBooking = StoreProvider.of<AppState>(context).state.serviceSlot.limitBooking;
      hourController.text = hour.toString();
      minuteController.text = minute.toString();
      limitBookingController.text = limitBooking.toString();
      dayController.text = day.toString();
      maxController.text = maxQuantity.toString();
    });
  }

  //Controllo su durata e calendario
  /*String showErrorDay(int value) {
    String checkIn = StoreProvider.of<AppState>(context).state.serviceSlot.checkIn;
    String checkOut = StoreProvider.of<AppState>(context).state.serviceSlot.checkOut;
    if (checkIn.contains("/") && checkOut.contains("/")) {
      List<String> convertedCheckIn = checkIn.split("/");
      List<String> convertedCheckOut = checkOut.split("/");
      DateTime dayFirst = DateTime.parse(convertedCheckIn[2] + "-" + convertedCheckIn[1] + "-" + convertedCheckIn[0]);
      DateTime dayLast = DateTime.parse(convertedCheckOut[2] + "-" + convertedCheckOut[1] + "-" + convertedCheckOut[0]);
      int durationDatetime = dayLast.difference(dayFirst).inDays;
      if(value > durationDatetime){
        return "Day duration overcome datetime interval chosen";
      }
    } else if (!checkIn.contains("/") && !checkOut.contains("/")) {
      return "No Check-In and Check-Out days set";
    } else if (checkIn.contains("/") && !checkOut.contains("/")) {
      return "No Check-Out day set";
    } else if (!checkIn.contains("/") && checkOut.contains("/")) {
      return "No Check-In day set";
    }
  }*/

  showPickerHour(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(initValue: hour, begin: 0, end: 24, jump: 1),
        ]),
        hideHeader: true,
        title: Text(AppLocalizations.of(context).pleaseSelectNumberOfHours,
            style: TextStyle(
              fontSize: widget.media.height * 0.022,
              color: BuytimeTheme.TextBlack,
              fontWeight: FontWeight.w500,
            )),
        confirmTextStyle: TextStyle(color: BuytimeTheme.ManagerPrimary),
        cancelTextStyle: TextStyle(color: BuytimeTheme.ManagerPrimary),
        selectedTextStyle: TextStyle(color:BuytimeTheme.ManagerPrimary),
        onCancel: () {
          return 0;
        },
        onConfirm: (Picker picker, List value) {
          setState(() {
            hourController.text = value[0].toString();
            hour = value[0];
            StoreProvider.of<AppState>(context).dispatch(SetServiceSlotHour(hour));
            if (StoreProvider.of<AppState>(context).state.serviceSlot.day > 0) {
              setStopTimeOvercome24h();
            }
          });
        }).showDialog(context);
  }

  showPickerMinute(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(initValue: minute, begin: 0, end: 60, jump: 1),
        ]),
        hideHeader: true,
        title: Text(AppLocalizations.of(context).pleaseSelectNumberOfMinutes,
            style: TextStyle(
              fontSize: widget.media.height * 0.022,
              color: BuytimeTheme.TextBlack,
              fontWeight: FontWeight.w500,
            )),
        confirmTextStyle: TextStyle(color: BuytimeTheme.ManagerPrimary),
        cancelTextStyle: TextStyle(color: BuytimeTheme.ManagerPrimary),
        selectedTextStyle: TextStyle(color:BuytimeTheme.ManagerPrimary),
        onCancel: () {
          return 0;
        },
        onConfirm: (Picker picker, List value) {
          setState(() {
            minuteController.text = value[0].toString();
            minute = value[0];
            StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMinute(minute));
            if (StoreProvider.of<AppState>(context).state.serviceSlot.day > 0) {
              setStopTimeOvercome24h();
            }
          });
        }).showDialog(context);
  }

  showPickerDay(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(initValue: day, begin: 0, end: 60, jump: 1),
        ]),
        hideHeader: true,
        title: Text(AppLocalizations.of(context).pleaseSelectNumberOfDays,
            style: TextStyle(
              fontSize: widget.media.height * 0.022,
              color: BuytimeTheme.TextBlack,
              fontWeight: FontWeight.w500,
            )),
        confirmTextStyle: TextStyle(color: BuytimeTheme.ManagerPrimary),
        cancelTextStyle: TextStyle(color: BuytimeTheme.ManagerPrimary),
        selectedTextStyle: TextStyle(color:BuytimeTheme.ManagerPrimary),
        onCancel: () {
          return 0;
        },
        onConfirm: (Picker picker, List value) {
          setState(() {
            dayController.text = value[0].toString();
            day = value[0];
            StoreProvider.of<AppState>(context).dispatch(SetServiceSlotDay(day));
            if (StoreProvider.of<AppState>(context).state.serviceSlot.day > 0) {
              setStopTimeOvercome24h();
            }
          });
        }).showDialog(context);
  }

  setStopTimeOvercome24h() {
    List<String> startTimeList = StoreProvider.of<AppState>(context).state.serviceSlot.startTime;
    List<String> stopTimeList = StoreProvider.of<AppState>(context).state.serviceSlot.stopTime;
    if (startTimeList.length > 0) {
      for (int i = 0; i < startTimeList.length; i++) {
        DateTime initialDate = DateTime(2021, 09, 01, int.parse(startTimeList[i].split(":")[0]), int.parse(startTimeList[i].split(":")[1]));
        int hourDuration = StoreProvider.of<AppState>(context).state.serviceSlot.hour;
        int minuteDuration = StoreProvider.of<AppState>(context).state.serviceSlot.minute;
        DateTime finalDate = initialDate.add(Duration(hours: hourDuration, minutes: minuteDuration));
        String finalDateString = finalDate.hour.toString() + ":" + finalDate.minute.toString();
        stopTimeList[i] = finalDateString;
        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopTime(stopTimeList));
      }
    }
  }

  showPickerLimitBookings(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(initValue: limitBooking, begin: 1, end: 999, jump: 1),
        ]),
        hideHeader: true,
        title: Text(AppLocalizations.of(context).pleaseSelectNumberOfMaxBookings,
            style: TextStyle(
              fontSize: widget.media.height * 0.022,
              color: BuytimeTheme.TextBlack,
              fontWeight: FontWeight.w500,
            )),
        confirmTextStyle: TextStyle(color: BuytimeTheme.ManagerPrimary),
        cancelTextStyle: TextStyle(color: BuytimeTheme.ManagerPrimary),
        selectedTextStyle: TextStyle(color:BuytimeTheme.ManagerPrimary),
        onCancel: () {
          return 0;
        },
        onConfirm: (Picker picker, List value) {
          setState(() {
            limitBookingController.text = (value[0] + 1).toString();
            limitBooking = (value[0] + 1);
            StoreProvider.of<AppState>(context).dispatch(SetServiceSlotLimitBooking(limitBooking));
          });
        }).showDialog(context);
  }

  showPickerMaxQuantity(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(initValue: maxQuantity, begin: 1, end: 60, jump: 1),
        ]),
        hideHeader: true,
        title: Text(AppLocalizations.of(context).pleaseSelectNumberOfMaxCapacity,
            style: TextStyle(
              fontSize: widget.media.height * 0.022,
              color: BuytimeTheme.TextBlack,
              fontWeight: FontWeight.w500,
            )),
        confirmTextStyle: TextStyle(color: BuytimeTheme.ManagerPrimary),
        cancelTextStyle: TextStyle(color: BuytimeTheme.ManagerPrimary),
        selectedTextStyle: TextStyle(color:BuytimeTheme.ManagerPrimary),
        onCancel: () {
          return 0;
        },
        onConfirm: (Picker picker, List value) {
          setState(() {
            maxController.text = (value[0] + 1).toString();
            maxQuantity = (value[0] + 1);
            debugPrint('W_service_step_length => MAX QUANTITY: $maxQuantity');
            StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMaxQuantity(maxQuantity));
          });
        }).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
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
                              AppLocalizations.of(context).serviceDuration,
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
                          ///Days
                          Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  showPickerDay(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Container(
                                    // /width: 142,
                                    height: 56,
                                    child: TextFormField(
                                      enabled: false,
                                      controller: dayController,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: BuytimeTheme.DividerGrey,
                                          disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.ErrorRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          // errorMaxLines: 3,
                                          // errorText: errorDay,
                                          errorStyle: TextStyle(
                                            color: BuytimeTheme.ErrorRed,
                                            fontSize: 12.0,
                                          ),
                                          suffixText: AppLocalizations.of(context).days),
                                      style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: Color(0xff666666),
                                        fontWeight: FontWeight.w800,
                                      ),
                                      // validator: (value) {
                                      //  return errorDay = showErrorDay(int.parse(value));
                                      // },
                                    ),
                                  ),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1),
                          ),
                          Flexible(child: SizedBox()),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///Hour
                          Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  showPickerHour(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Container(
                                    //width: 142,
                                    height: 56,
                                    child: TextFormField(
                                      enabled: false,
                                      controller: hourController,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: BuytimeTheme.DividerGrey,
                                          disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.ErrorRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          errorMaxLines: 2,
                                          errorStyle: TextStyle(
                                            color: BuytimeTheme.ErrorRed,
                                            fontSize: 12.0,
                                          ),
                                          suffixText: AppLocalizations.of(context).hour),
                                      style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: Color(0xff666666),
                                        fontWeight: FontWeight.w800,
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return AppLocalizations.of(context).pleaseInsertHour;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1),
                          ),

                          ///Minute
                          Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  showPickerMinute(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Container(
                                    //width: 142,
                                    height: 56,
                                    child: TextFormField(
                                      enabled: false,
                                      controller: minuteController,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: BuytimeTheme.DividerGrey,
                                          disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.ErrorRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          errorMaxLines: 2,
                                          errorStyle: TextStyle(
                                            color: BuytimeTheme.ErrorRed,
                                            fontSize: 12.0,
                                          ),
                                          suffixText: AppLocalizations.of(context).min),
                                      style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: Color(0xff666666),
                                        fontWeight: FontWeight.w800,
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return AppLocalizations.of(context).pleaseInsertMinute;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),

                    ///Parallel Bookings
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          Container(
                            child: Flexible(
                              child: Text(
                                AppLocalizations.of(context).parallelBookings,
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
                          Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  showPickerLimitBookings(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Container(
                                    height: 56,
                                    child: TextFormField(
                                      enabled: false,
                                      controller: limitBookingController,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: BuytimeTheme.DividerGrey,
                                          disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.ErrorRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          errorMaxLines: 2,
                                          errorStyle: TextStyle(
                                            color: BuytimeTheme.ErrorRed,
                                            fontSize: 12.0,
                                          ),
                                          suffixText:  AppLocalizations.of(context).limit),
                                      style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: Color(0xff666666),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1),
                          ),
                          Flexible(child: SizedBox()),
                        ],
                      ),
                    ),

                    ///Max Quantity Per Service
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          Container(
                            child: Flexible(
                              child: Text(
                                AppLocalizations.of(context).maxQuantityService,
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
                          Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  showPickerMaxQuantity(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Container(
                                    height: 56,
                                    child: TextFormField(
                                      enabled: false,
                                      controller: maxController,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: BuytimeTheme.DividerGrey,
                                          disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.ErrorRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          errorMaxLines: 2,
                                          errorStyle: TextStyle(
                                            color: BuytimeTheme.ErrorRed,
                                            fontSize: 12.0,
                                          ),
                                          suffixText:  AppLocalizations.of(context).numberOf),
                                      style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: Color(0xff666666),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1),
                          ),
                          Flexible(child: SizedBox()),
                        ],
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0),
                    //   child: Row(
                    //     children: [
                    //       CustomLabeledCheckbox(
                    //         label: '∞',
                    //         value: bookingInfinity,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             bookingInfinity = value;
                    //             StoreProvider.of<AppState>(context).dispatch(SetServiceSlotNoLimitBooking(bookingInfinity));
                    //           });
                    //         },
                    //         checkboxType: CheckboxType.Child,
                    //         activeColor: Colors.indigo,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0),
                    //   child: Row(
                    //     children: [
                    //       Container(
                    //         child: Flexible(
                    //           child: Text(
                    //             !bookingInfinity ? AppLocalizations.of(context).serviceHasALimitOfBookings + bookingSlider.toString() : AppLocalizations.of(context).serviceHasNoLimitOfBookings,
                    //             textAlign: TextAlign.start,
                    //             overflow: TextOverflow.clip,
                    //             style: TextStyle(
                    //               color: BuytimeTheme.TextBlack,
                    //               fontSize: media.height * 0.02,
                    //               fontWeight: FontWeight.w400,
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                )),
          );
        });
  }
}
