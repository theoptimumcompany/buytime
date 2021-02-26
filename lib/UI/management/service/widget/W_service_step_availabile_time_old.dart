// import 'package:Buytime/UI/management/service/class/service_slot_classes.dart';
// import 'package:Buytime/reblox/model/app_state.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:Buytime/reblox/model/service/service_time_slot_state.dart';
// import 'package:Buytime/reblox/reducer/service_reducer.dart';
// import 'package:Buytime/utils/size_config.dart';
//
// import 'package:Buytime/utils/theme/buytime_theme.dart';
//
// import 'package:flutter_redux/flutter_redux.dart';
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// typedef OnFilePickedCallback = void Function();
//
// class StepAvailableTime extends StatefulWidget {
//   StepAvailableTime({this.media});
//
//   Size media;
//
//   @override
//   State<StatefulWidget> createState() => StepAvailableTimeState();
// }
//
// class StepAvailableTimeState extends State<StepAvailableTime> {
//   List<int> numberOfAvailableInterval = [1];
//   ServiceSlot baseAvailability = ServiceSlot().toEmpty();
//   List<ListWeek> switchWeek = [];
//   List<ListEveryDay> daysInterval = [];
//   List<ListTextEditingController> _startController = [ListTextEditingController().toEmpty()];
//   List<ListTextEditingController> _stopController = [ListTextEditingController().toEmpty()];
//   List<EveryTime> startTime = [EveryTime().toEmpty()];
//   List<EveryTime> stopTime = [EveryTime().toEmpty()];
//
//   int indexStepper;
//   var _formSlotTimeKey;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Widget weekSwitchDay(Size media, String dayName, int listNumber, int dayNumber) {
//     return Row(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(
//             left: media.width * 0.05,
//           ),
//           child: Container(
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 10.0),
//               child: Checkbox(
//                   value: daysInterval[indexStepper].listEveryDay[listNumber].everyDay[dayNumber],
//                   onChanged: (value) {
//                     setState(() {
//                       daysInterval[indexStepper].listEveryDay[listNumber].everyDay[dayNumber] = value;
//                       StoreProvider.of<AppState>(context).dispatch(SetServiceSlotSwitchDay(daysInterval));
//                     });
//                   }),
//             ),
//           ),
//         ),
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(width: 1.0, color: BuytimeTheme.DividerGrey),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                     child: Padding(
//                   padding: const EdgeInsets.only(bottom: 10.0),
//                   child: Text(
//                     dayName,
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       color: BuytimeTheme.TextBlack,
//                       fontSize: media.height * 0.018,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 )),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   bool validate() {
//     final FormState form = _formSlotTimeKey.currentState;
//     if (form.validate()) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   Future<void> _selectStartTime(BuildContext context, int indexController) async {
//     final TimeOfDay picked = await showTimePicker(
//       builder: (BuildContext context, Widget child) {
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//           child: child,
//         );
//       },
//       context: context,
//       initialEntryMode: TimePickerEntryMode.dial,
//       initialTime: TimeOfDay(hour: 0, minute: 0),
//     );
//     if (picked != null) {
//       String minute = picked.minute < 10 ? "0" + picked.minute.toString() : picked.minute.toString();
//       String hour = picked.hour < 10 ? "0" + picked.hour.toString() : picked.hour.toString();
//       String format24 = hour + ":" + minute;
//       _startController[indexStepper].listTextEditingController[indexController].text = format24;
//       StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartController(_startController));
//
//       setState(() {
//         startTime[indexStepper].everyTime[indexController] = picked;
//         StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartTime(startTime));
//       });
//     }
//     return null;
//   }
//
//   Future<void> _selectStopTime(BuildContext context, int indexController) async {
//     final TimeOfDay picked = await showTimePicker(
//       builder: (BuildContext context, Widget child) {
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//           child: child,
//         );
//       },
//       context: context,
//       initialEntryMode: TimePickerEntryMode.dial,
//       initialTime: TimeOfDay(hour: 0, minute: 0),
//     );
//     if (picked != null) {
//       String minute = picked.minute < 10 ? "0" + picked.minute.toString() : picked.minute.toString();
//       String hour = picked.hour < 10 ? "0" + picked.hour.toString() : picked.hour.toString();
//       String format24 = hour + ":" + minute;
//       _stopController[indexStepper].listTextEditingController[indexController].text = format24;
//       StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopController(_stopController));
//       setState(() {
//         stopTime[indexStepper].everyTime[indexController] = picked;
//         StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopTime(stopTime));
//         _formSlotTimeKey.currentState.validate();
//       });
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var media = MediaQuery.of(context).size;
//     indexStepper = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.actualSlotIndex;
//     switchWeek = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.switchWeek;
//     daysInterval = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.daysInterval;
//     numberOfAvailableInterval = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.numberOfInterval;
//     _startController = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.startController;
//     _stopController = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.stopController;
//     startTime = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.startTime;
//     stopTime = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.stopTime;
//     _formSlotTimeKey = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.formSlotTimeKey[indexStepper];
//     return StoreConnector<AppState, AppState>(
//         converter: (store) => store.state,
//         builder: (context, snapshot) {
//           return Form(
//             key: _formSlotTimeKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Flexible(
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: numberOfAvailableInterval[indexStepper],
//                       itemBuilder: (context, i) {
//                         return Column(
//                           children: [
//                             Container(
//                                 child: Row(
//                               children: [
//                                 Text(
//                                   (i + 1).toString() + ". Available time",
//                                   textAlign: TextAlign.start,
//                                   style: TextStyle(
//                                     fontSize: widget.media.height * 0.018,
//                                     color: BuytimeTheme.TextBlack,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             )),
//
//                             ///Time Range
//                             Padding(
//                               padding: const EdgeInsets.only(top: 5.0),
//                               child: Container(
//                                   child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   ///Start Time
//                                   Flexible(
//                                     child: Column(
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () async {
//                                             await _selectStartTime(context, i);
//                                           },
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(right: 5.0),
//                                             child: Container(
//                                               child: TextFormField(
//                                                 enabled: false,
//                                                 controller: _startController[indexStepper].listTextEditingController[i],
//                                                 textAlign: TextAlign.start,
//                                                 keyboardType: TextInputType.number,
//                                                 decoration: InputDecoration(
//                                                     filled: true,
//                                                     fillColor: BuytimeTheme.DividerGrey,
//                                                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                                                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                                                     labelText: "Start",
//                                                     //todo trans
//                                                     labelStyle: TextStyle(
//                                                       fontFamily: BuytimeTheme.FontFamily,
//                                                       color: Color(0xff666666),
//                                                       fontWeight: FontWeight.w400,
//                                                     ),
//                                                     errorMaxLines: 2,
//                                                     errorStyle: TextStyle(
//                                                       color: BuytimeTheme.ErrorRed,
//                                                       fontSize: 12.0,
//                                                     ),
//                                                     suffixIcon: Icon(Icons.av_timer_outlined)),
//                                                 style: TextStyle(
//                                                   fontFamily: BuytimeTheme.FontFamily,
//                                                   color: Color(0xff666666),
//                                                   fontWeight: FontWeight.w800,
//                                                 ),
//                                                 validator: (value) {
//                                                   if (value.isEmpty) {
//                                                     return 'Please insert time';
//                                                   }
//                                                   return null;
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//
//                                   ///Stop Time
//                                   Flexible(
//                                     child: Column(
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () async {
//                                             if (_startController[indexStepper].listTextEditingController[i].text.isEmpty) {
//                                               validate();
//                                               return;
//                                             }
//                                             await _selectStopTime(context, i);
//                                           },
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(left: 5.0),
//                                             child: TextFormField(
//                                               enabled: false,
//                                               controller: _stopController[indexStepper].listTextEditingController[i],
//                                               textAlign: TextAlign.start,
//                                               keyboardType: TextInputType.datetime,
//                                               decoration: InputDecoration(
//                                                   filled: true,
//                                                   fillColor: BuytimeTheme.DividerGrey,
//                                                   enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                                                   focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                                                   labelText: "Stop",
//                                                   //todo: trans
//                                                   //hintText: "email *",
//                                                   //hintStyle: TextStyle(color: Color(0xff666666)),
//                                                   labelStyle: TextStyle(
//                                                     fontFamily: BuytimeTheme.FontFamily,
//                                                     color: Color(0xff666666),
//                                                     fontWeight: FontWeight.w400,
//                                                   ),
//                                                   errorMaxLines: 2,
//                                                   errorStyle: TextStyle(
//                                                     color: BuytimeTheme.ErrorRed,
//                                                     fontSize: 12.0,
//                                                   ),
//                                                   suffixIcon: Icon(Icons.av_timer_outlined)),
//                                               style: TextStyle(
//                                                 fontFamily: BuytimeTheme.FontFamily,
//                                                 color: Color(0xff666666),
//                                                 fontWeight: FontWeight.w800,
//                                               ),
//                                               validator: (value) {
//                                                 if (_startController[indexStepper].listTextEditingController[i].text.isEmpty) {
//                                                   return "Insert start time first";
//                                                 } else if ((stopTime[indexStepper].everyTime[i].hour + stopTime[indexStepper].everyTime[i].minute / 60.0) -
//                                                         (startTime[indexStepper].everyTime[i].hour + startTime[indexStepper].everyTime[i].minute / 60.0) <=
//                                                     0) {
//                                                   return "Stop time is shorter than start";
//                                                 }
//                                                 return '';
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               )),
//                             ),
//
//                             ///Switch Every Day
//                             Padding(
//                               padding: const EdgeInsets.only(top: 8.0, left: 0.0, right: 20.0),
//                               child: Container(
//                                 child: Row(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(right : 10.0),
//                                       child: SizedBox(
//                                         width: 20,
//                                         child: Checkbox(
//                                             value: switchWeek[indexStepper].listWeek[i],
//                                             onChanged: (value) {
//                                               setState(() {
//                                                 switchWeek[indexStepper].listWeek[i] = value;
//                                                 StoreProvider.of<AppState>(context).dispatch(SetServiceSlotSwitchWeek(switchWeek));
//                                               });
//                                             }),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           border: Border(
//                                             bottom: BorderSide(width: 1.0, color: BuytimeTheme.DividerGrey),
//                                           ),
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                                 child: Padding(
//                                               padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
//                                               child: Text(
//                                                 'Every day',
//                                                 textAlign: TextAlign.start,
//                                                 style: TextStyle(
//                                                   color: BuytimeTheme.TextBlack,
//                                                   fontSize: widget.media.height * 0.02,
//                                                   fontWeight: FontWeight.w400,
//                                                 ),
//                                               ),
//                                             )),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             !switchWeek[indexStepper].listWeek[i]
//                                 ? Column(
//                                     children: [
//                                       weekSwitchDay(widget.media, 'Monday', i, 0), //todo: lang
//                                       weekSwitchDay(widget.media, 'Tuesday', i, 1), //todo: lang
//                                       weekSwitchDay(widget.media, 'Wednesday', i, 2), //todo: lang
//                                       weekSwitchDay(widget.media, 'Thursday', i, 3), //todo: lang
//                                       weekSwitchDay(widget.media, 'Friday', i, 4), //todo: lang
//                                       weekSwitchDay(widget.media, 'Saturday', i, 5), //todo: lang
//                                       weekSwitchDay(widget.media, 'Sunday', i, 6), //todo: lang
//                                     ],
//                                   )
//                                 : Container(),
//                           ],
//                         );
//                       }),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.00),
//                   child: Container(
//                     width: widget.media.width * 0.50,
//                     child: OutlinedButton(
//                       onPressed: () {
//                         setState(() {
//                           ///Update Switch EveryDay
//                           switchWeek[indexStepper].listWeek.add(true);
//                           StoreProvider.of<AppState>(context).dispatch(SetServiceSlotSwitchWeek(switchWeek));
//                           ///Update List Of Days
//                           daysInterval[indexStepper].listEveryDay.add(EveryDay().toEmpty());
//                           StoreProvider.of<AppState>(context).dispatch(SetServiceSlotDaysInterval(daysInterval));
//                           ///Update Number of Internal Interval
//                           numberOfAvailableInterval[indexStepper] = numberOfAvailableInterval[indexStepper] + 1;
//                           StoreProvider.of<AppState>(context).dispatch(SetServiceSlotNumberOfInterval(numberOfAvailableInterval));
//                           ///Update startController
//                           _startController[indexStepper].listTextEditingController.add(TextEditingController());
//                           StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartController(_startController));
//                           ///Update startTime
//                           startTime[indexStepper].everyTime.add(TimeOfDay());
//                           StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartTime(startTime));
//                           ///Update stopController
//                           _stopController[indexStepper].listTextEditingController.add(TextEditingController());
//                           StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopController(_stopController));
//                           ///Update stopTime
//                           stopTime[indexStepper].everyTime.add(TimeOfDay());
//                           StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopTime(stopTime));
//                         });
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Icon(Icons.add, color: BuytimeTheme.ManagerPrimary, size: widget.media.width * 0.06),
//                             Text(
//                               "ADD TIME SLOT", //todo: lang
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                 fontSize: widget.media.height * 0.022,
//                                 color: BuytimeTheme.ManagerPrimary,
//                                 fontWeight: FontWeight.w900,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }
