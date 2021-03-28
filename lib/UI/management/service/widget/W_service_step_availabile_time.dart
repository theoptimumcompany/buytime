import 'package:Buytime/UI/management/service/class/service_slot_classes.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:Buytime/reusable/checkbox/W_checkbox_parent_child.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StepAvailableTime extends StatefulWidget {
  Size media;

  StepAvailableTime({this.media});

  @override
  State<StatefulWidget> createState() => StepAvailableTimeState();
}

class StepAvailableTimeState extends State<StepAvailableTime> {
  int numberOfSlotTimeInterval = 1;
  ServiceSlot baseAvailability = ServiceSlot().toEmpty();
  List<bool> switchWeek = [false];
  List<EveryDay> daysInterval = [];
  List<TextEditingController> startController = [];
  List<TextEditingController> stopController = [];
  List<String> startTime = [];
  List<String> stopTime = [];
  List<String> errorStartTime = [null];
  List<String> errorStopTime = [null];

  List<String> daysOfWeek = [];
  final List<GlobalKey<FormState>> _formSlotTimeKey = [GlobalKey<FormState>()];
  bool setStartAndStop = true;
  int maxDuration = 0;
  List<bool> intervalIndexVisibility = [];

  @override
  void initState() {
    super.initState();
  }

  List<String> convertListTextEditingControllerToListString(List<TextEditingController> controllerList) {
    List<String> list = [];
    controllerList.forEach((element) {
      list.add(element.text);
    });
    return list;
  }

  void _manageTristate(int indexDay, bool value, int indexInterval) {
    setState(() {
      if (value) {
        // selected
        daysInterval[indexInterval].everyDay[indexDay] = true;
        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotDaysInterval(daysInterval));
        // Checking if all other children are also selected -
        if (daysInterval[indexInterval].everyDay.contains(false)) {
          // No. Parent -> tristate.
          switchWeek[indexInterval] = null;
          StoreProvider.of<AppState>(context).dispatch(SetServiceSlotSwitchWeek(switchWeek));
        } else {
          // Yes. Select all.
          _checkAll(true, indexInterval);
        }
      } else {
        // unselected
        daysInterval[indexInterval].everyDay[indexDay] = false;
        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotDaysInterval(daysInterval));
        // Checking if all other children are also unselected -
        if (daysInterval[indexInterval].everyDay.contains(true)) {
          // No. Parent -> tristate.
          switchWeek[indexInterval] = null;
          StoreProvider.of<AppState>(context).dispatch(SetServiceSlotSwitchWeek(switchWeek));
        } else {
          // Yes. Unselect all.
          _checkAll(false, indexInterval);
        }
      }
    });
  }

  void _checkAll(bool value, int index) {
    setState(() {
      switchWeek[index] = value;
      StoreProvider.of<AppState>(context).dispatch(SetServiceSlotSwitchWeek(switchWeek));
      for (int i = 0; i < daysOfWeek.length; i++) {
        daysInterval[index].everyDay[i] = value;
        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotDaysInterval(daysInterval));
      }
    });
  }

  bool validate(int indexInterval) {
    final FormState form = _formSlotTimeKey[indexInterval].currentState;
    if (form.validate()) {
      return true;
    } else {
      errorStartTime[indexInterval] = showErrorStartTime(indexInterval);
      errorStopTime[indexInterval] = showErrorStopTime(indexInterval);
      return false;
    }
  }

  showPickerStartTime(BuildContext context, int indexController) {
    String initStart = StoreProvider.of<AppState>(context).state.serviceSlot.startTime[indexController];
    List<String> start = [];
    int startHour = 0;
    int startMinute = 0;
    if (initStart.contains('null:null')) {
    } else {
      start = initStart.split(":");
      startHour = int.parse(start[0]);
      startMinute = int.parse(start[1]);
    }
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(initValue: startHour, begin: 0, end: 23, jump: 1),
          NumberPickerColumn(initValue: startMinute, begin: 0, end: 59, jump: 1),
        ]),
        delimiter: [
          PickerDelimiter(
              child: Container(
            alignment: Alignment.center,
            child: Text(":"),
          ))
        ],
        hideHeader: true,
        title: Text(
          "Please select start time",
          style: TextStyle(
            fontSize: widget.media.height * 0.022,
            color: BuytimeTheme.TextBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onCancel: (){return 0;},
        onConfirm: (Picker picker, List value) {
          if (picker != null) {
            String minute = value[1] < 10 ? "0" + value[1].toString() : value[1].toString();
            String hour = value[0] < 10 ? "0" + value[0].toString() : value[0].toString();
            String format24 = hour + ":" + minute;
            startController[indexController].text = format24;
            List<String> controllerList = convertListTextEditingControllerToListString(startController);
            StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartTime(controllerList));

            setState(() {
              startTime[indexController] = format24;
              _formSlotTimeKey[indexController].currentState.validate();

              //TODO : Calcolare orario di arrivo in base alla durata dei giorni
              if(StoreProvider.of<AppState>(context).state.serviceSlot.day > 0){
                setStopTimeOvercome24h(startTime[indexController]);
              }
            });
          }
        }).showDialog(context);
  }

  setStopTimeOvercome24h(String startTimeString){
    DateTime initialDate = DateTime(2021,09,01,int.parse(startTimeString.split(":")[0]),int.parse(startTimeString.split(":")[1]));
    print(initialDate);
    int hourDuration = StoreProvider.of<AppState>(context).state.serviceSlot.hour;
    print(hourDuration);
    int minuteDuration = StoreProvider.of<AppState>(context).state.serviceSlot.minute;
    print(minuteDuration);
    DateTime finalDate = initialDate.add(Duration(hours: hourDuration,minutes: minuteDuration));
    print(finalDate);
  }

  showPickerStopTime(BuildContext context, int indexController) {
    String initStop = StoreProvider.of<AppState>(context).state.serviceSlot.stopTime[indexController];
    List<String> stop = [];
    int stopHour = 0;
    int stopMinute = 0;
    if (initStop.contains('null:null')) {
    } else {
      stop = initStop.split(":");
      stopHour = int.parse(stop[0]);
      stopMinute = int.parse(stop[1]);
    }
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(initValue: stopHour, begin: 0, end: 23, jump: 1),
          NumberPickerColumn(initValue: stopMinute, begin: 0, end: 59, jump: 1),
        ]),
        delimiter: [
          PickerDelimiter(
              child: Container(
            alignment: Alignment.center,
            child: Text(":"),
          ))
        ],
        hideHeader: true,
        title: Text(
          "Please select stop time",
          style: TextStyle(
            fontSize: widget.media.height * 0.022,
            color: BuytimeTheme.TextBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onCancel: (){return 0;},
        onConfirm: (Picker picker, List value) {
          if (picker != null) {
            String minute = value[1] < 10 ? "0" + value[1].toString() : value[1].toString();
            String hour = value[0] < 10 ? "0" + value[0].toString() : value[0].toString();
            String format24 = hour + ":" + minute;
            stopController[indexController].text = format24;
            List<String> controllerList = convertListTextEditingControllerToListString(stopController);
            StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopTime(controllerList));
            setState(() {
              stopTime[indexController] = format24;
              _formSlotTimeKey[indexController].currentState.validate();
            });
          }
        }).showDialog(context);
  }

  // Future<void> _selectStartTime(BuildContext context, int indexController) async {
  //   String initStart = StoreProvider
  //       .of<AppState>(context)
  //       .state
  //       .serviceSlot
  //       .startTime[indexController];
  //   List<String> start = [];
  //   int startHour = 0;
  //   int startMinute = 0;
  //   if (initStart.contains('null:null')) {} else {
  //     start = initStart.split(":");
  //     startHour = int.parse(start[0]);
  //     startMinute = int.parse(start[1]);
  //   }
  //   final TimeOfDay picked = await showTimePicker(
  //     builder: (BuildContext context, Widget child) {
  //       return MediaQuery(
  //         data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
  //         child: child,
  //       );
  //     },
  //     context: context,
  //     initialEntryMode: TimePickerEntryMode.dial,
  //     initialTime: TimeOfDay(hour: startHour, minute: startMinute),
  //   );
  //   if (picked != null) {
  //     String minute = picked.minute < 10 ? "0" + picked.minute.toString() : picked.minute.toString();
  //     String hour = picked.hour < 10 ? "0" + picked.hour.toString() : picked.hour.toString();
  //     String format24 = hour + ":" + minute;
  //     startController[indexController].text = format24;
  //     List<String> controllerList = convertListTextEditingControllerToListString(startController);
  //     StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartTime(controllerList));
  //
  //     setState(() {
  //       startTime[indexController] = picked;
  //       _formSlotTimeKey[indexController].currentState.validate();
  //     });
  //   }
  //   return null;
  // }
  //
  // Future<void> _selectStopTime(BuildContext context, int indexController) async {
  //   String initStop = StoreProvider.of<AppState>(context).state.serviceSlot.stopTime[indexController];
  //   List<String> stop = [];
  //   int stopHour = 0;
  //   int stopMinute = 0;
  //   if (initStop.contains('null')) {
  //   } else {
  //     stop = initStop.split(":");
  //     stopHour = int.parse(stop[0]);
  //     stopMinute = int.parse(stop[1]);
  //   }
  //   final TimeOfDay picked = await showTimePicker(
  //     builder: (BuildContext context, Widget child) {
  //       return MediaQuery(
  //         data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
  //         child: child,
  //       );
  //     },
  //     context: context,
  //     initialEntryMode: TimePickerEntryMode.dial,
  //     initialTime: TimeOfDay(hour: stopHour, minute: stopMinute),
  //   );
  //   if (picked != null) {
  //     String minute = picked.minute < 10 ? "0" + picked.minute.toString() : picked.minute.toString();
  //     String hour = picked.hour < 10 ? "0" + picked.hour.toString() : picked.hour.toString();
  //     String format24 = hour + ":" + minute;
  //     stopController[indexController].text = format24;
  //     List<String> controllerList = convertListTextEditingControllerToListString(stopController);
  //     StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopTime(controllerList));
  //     setState(() {
  //       stopTime[indexController] = format24;
  //       _formSlotTimeKey[indexController].currentState.validate();
  //     });
  //   }
  //   return null;
  // }

  void setStartAndStopTime() {
    List<String> start = StoreProvider.of<AppState>(context).state.serviceSlot.startTime;
    List<String> stop = StoreProvider.of<AppState>(context).state.serviceSlot.stopTime;

    if (start.length == 0) {
      TextEditingController textEditingControllerStart = TextEditingController();
      startController.add(textEditingControllerStart);
      startTime.add('00:00');
      StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartTime(startTime));
    } else {
      for (int i = 0; i < start.length; i++) {
        TextEditingController textEditingControllerStart = TextEditingController();
        textEditingControllerStart.text = start[i];
        startController.add(textEditingControllerStart);
        startTime.add(start[i]);
        errorStartTime.add(null);
      }
    }

    if (stop.length == 0) {
      TextEditingController textEditingControllerStop = TextEditingController();
      stopController.add(textEditingControllerStop);
      stopTime.add('00:00');
      StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopTime(stopTime));
    } else {
      for (int i = 0; i < stop.length; i++) {
        TextEditingController textEditingControllerStop = TextEditingController();
        textEditingControllerStop.text = stop[i];
        stopController.add(textEditingControllerStop);
        stopTime.add(stop[i]);
        errorStopTime.add(null);
      }
    }
  }

  // void setMaxDuration() {
  //   if (StoreProvider
  //       .of<AppState>(context)
  //       .state
  //       .serviceSlot
  //       .startTime
  //       .contains('null:null') || StoreProvider
  //       .of<AppState>(context)
  //       .state
  //       .serviceSlot
  //       .stopTime
  //       .contains('null:null')) {
  //     return;
  //   } else {
  //     for (int i = 0; i < StoreProvider
  //         .of<AppState>(context)
  //         .state
  //         .serviceSlot
  //         .numberOfInterval; i++) {
  //       List<String> start = StoreProvider
  //           .of<AppState>(context)
  //           .state
  //           .serviceSlot
  //           .startTime[i].split(":");
  //       int startHour = int.parse(start[0]);
  //       int startMinute = int.parse(start[1]);
  //       List<String> stop = StoreProvider
  //           .of<AppState>(context)
  //           .state
  //           .serviceSlot
  //           .stopTime[i].split(":");
  //       int stopHour = int.parse(stop[0]);
  //       int stopMinute = int.parse(stop[1]);
  //       int localDuration = (((stopHour * 60) + stopMinute) - ((startHour * 60) + startMinute));
  //       if (localDuration <= 0) {
  //         StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMaxDuration(60));
  //       } else if (maxDuration == 0) {
  //         maxDuration = localDuration;
  //         StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMaxDuration(maxDuration));
  //         if (maxDuration < StoreProvider
  //             .of<AppState>(context)
  //             .state
  //             .serviceSlot
  //             .duration) {
  //           StoreProvider.of<AppState>(context).dispatch(SetServiceSlotDuration(maxDuration));
  //         }
  //       } else if (localDuration < maxDuration) {
  //         maxDuration = localDuration;
  //         StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMaxDuration(maxDuration));
  //         if (maxDuration < StoreProvider
  //             .of<AppState>(context)
  //             .state
  //             .serviceSlot
  //             .duration) {
  //           StoreProvider.of<AppState>(context).dispatch(SetServiceSlotDuration(maxDuration));
  //         }
  //       }
  //       ;
  //     }
  //   }
  // }

  String showErrorStartTime(int i) {
    int startHour = int.parse(startTime[i].split(":")[0]);
    int startMinute = int.parse(startTime[i].split(":")[1]);
    int stopHour = int.parse(stopTime[i].split(":")[0]);
    int stopMinute = int.parse(stopTime[i].split(":")[1]);
    if (stopController[i].text.isEmpty && startController[i].text.isEmpty) {
      return AppLocalizations.of(context).insertStartTimeFirst;
    } else if ((stopHour + stopMinute / 60.0) - (startHour + startMinute / 60.0) <= 0) {
      return AppLocalizations.of(context).startTimeHigherStop;
    } else {
      List<String> controllerList = convertListTextEditingControllerToListString(startController);
      StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartTime(controllerList));
    }
  }

  String showErrorStopTime(int i) {
    int startHour = int.parse(startTime[i].split(":")[0]);
    int startMinute = int.parse(startTime[i].split(":")[1]);
    int stopHour = int.parse(stopTime[i].split(":")[0]);
    int stopMinute = int.parse(stopTime[i].split(":")[1]);

    if (stopController[i].text.isEmpty) {
    } else if ((stopHour + stopMinute / 60.0) - (startHour + startMinute / 60.0) <= 0) {
      return AppLocalizations.of(context).stopTimeShorterStart;
    } else {
      List<String> controllerList = convertListTextEditingControllerToListString(stopController);
      StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopTime(controllerList));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (setStartAndStop) {
      setStartAndStop = false;
      setStartAndStopTime();
    }
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) {
          //setMaxDuration();
          intervalIndexVisibility = List.generate(store.state.serviceSlot.numberOfInterval, (index) => index == 0 ? true : false);
        },
        builder: (context, snapshot) {
          switchWeek = snapshot.serviceSlot.switchWeek;
          daysInterval = snapshot.serviceSlot.daysInterval;
          numberOfSlotTimeInterval = snapshot.serviceSlot.numberOfInterval;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: numberOfSlotTimeInterval,
                    itemBuilder: (context, i) {
                      daysOfWeek = [
                        AppLocalizations.of(context).monday,
                        AppLocalizations.of(context).tuesday,
                        AppLocalizations.of(context).wednesday,
                        AppLocalizations.of(context).thursday,
                        AppLocalizations.of(context).friday,
                        AppLocalizations.of(context).saturday,
                        AppLocalizations.of(context).sunday
                      ];

                      if (i > 0) {
                        ///Update keyForm
                        _formSlotTimeKey.add(GlobalKey<FormState>());
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              for (int z = 0; z < intervalIndexVisibility.length; z++) {
                                intervalIndexVisibility[z] = false;
                              }
                            });
                            setState(() {
                              intervalIndexVisibility[i] = true;
                            });
                            StoreProvider.of<AppState>(context).dispatch(SetServiceSlotIntervalVisibility(intervalIndexVisibility));
                          },
                          child: Form(
                            key: _formSlotTimeKey[i],
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.delete,
                                  color: BuytimeTheme.SymbolWhite,
                                ),
                              ),
                              onDismissed: (direction) {
                                setState(() {
                                  ///Deleting Interval
                                  if (numberOfSlotTimeInterval > 1) {
                                    print("Delete Interval " + i.toString());
                                    numberOfSlotTimeInterval = numberOfSlotTimeInterval - 1;
                                    StoreProvider.of<AppState>(context).dispatch(SetServiceSlotNumberOfInterval(numberOfSlotTimeInterval));
                                    switchWeek.removeAt(i);
                                    StoreProvider.of<AppState>(context).dispatch(SetServiceSlotSwitchWeek(switchWeek));
                                    daysInterval.removeAt(i);
                                    StoreProvider.of<AppState>(context).dispatch(SetServiceSlotDaysInterval(daysInterval));
                                    startController.removeAt(i);
                                    debugPrint('W_service_step_availabile_time => startController: $startController');
                                    List<String> listStart = [];
                                    startController.forEach((element) {
                                      if (element.text.isEmpty)
                                        listStart.add('00:00');
                                      else
                                        listStart.add(element.text);
                                    });
                                    debugPrint('W_service_step_availabile_time => listStart: $listStart');
                                    StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartTime(listStart));
                                    stopController.removeAt(i);
                                    List<String> listStop = [];
                                    stopController.forEach((element) {
                                      if (element.text.isEmpty)
                                        listStop.add('00:00');
                                      else
                                        listStop.add(element.text);
                                    });
                                    StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopTime(listStop));
                                    startTime.removeAt(i);
                                    stopTime.removeAt(i);
                                    errorStartTime.removeAt(i);
                                    errorStopTime.removeAt(i);
                                    setState(() {
                                      setStartAndStop = true;
                                    });
                                    intervalIndexVisibility.removeAt(i);
                                    StoreProvider.of<AppState>(context).dispatch(SetServiceSlotIntervalVisibility(intervalIndexVisibility));
                                    _formSlotTimeKey.removeAt(i);
                                  }
                                });
                              },
                              child: Card(
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Container(
                                          child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text(
                                              (i + 1).toString() + AppLocalizations.of(context).workingHours,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: widget.media.height * 0.018,
                                                color: BuytimeTheme.TextBlack,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                      //TODO: Controllo che le settimane si accorpino quando si scelgono i giorni complementari per stessi orari
                                      //TODO: Controllo che durata non sia maggiore dello slot orario scelto
                                      intervalIndexVisibility[i]
                                          ? Column(
                                              children: [
                                                ///Time Range
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5.0),
                                                  child: Container(
                                                      child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ///Start Time
                                                      Flexible(
                                                        child: Column(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                showPickerStartTime(context, i);
                                                                //await _selectStartTime(context, i);
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(right: 5.0),
                                                                child: Container(
                                                                  child: TextFormField(
                                                                    enabled: false,
                                                                    controller: startController[i],
                                                                    textAlign: TextAlign.start,
                                                                    decoration: InputDecoration(
                                                                        filled: true,
                                                                        labelText: AppLocalizations.of(context).start,
                                                                        labelStyle: TextStyle(
                                                                          fontFamily: BuytimeTheme.FontFamily,
                                                                          color: Color(0xff666666),
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                        fillColor: BuytimeTheme.DividerGrey,
                                                                        disabledBorder:
                                                                            OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                        errorBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(color: BuytimeTheme.ErrorRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                        errorMaxLines: 2,
                                                                        errorText: errorStartTime[i],
                                                                        errorStyle: TextStyle(
                                                                          color: BuytimeTheme.ErrorRed,
                                                                          fontSize: 11.0,
                                                                        ),
                                                                        suffixIcon: Icon(Icons.av_timer_outlined)),
                                                                    style: TextStyle(
                                                                      fontFamily: BuytimeTheme.FontFamily,
                                                                      color: Color(0xff666666),
                                                                      fontWeight: FontWeight.w800,
                                                                    ),
                                                                    validator: (value) {
                                                                      errorStartTime[i] = showErrorStartTime(i);
                                                                      return value;
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      ///Stop Time
                                                      Flexible(
                                                        child: Column(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                if(snapshot.serviceSlot.day > 0){
                                                                  return;
                                                                }
                                                                else if (startController[i].text.isEmpty) {
                                                                  errorStartTime[i] = showErrorStartTime(i);
                                                                  return;
                                                                }
                                                                showPickerStopTime(context, i);
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(right: 5.0),
                                                                child: Container(
                                                                  child: TextFormField(
                                                                    enabled: false,
                                                                    controller: stopController[i],
                                                                    textAlign: TextAlign.start,
                                                                    decoration: InputDecoration(
                                                                        filled: true,
                                                                        labelText: AppLocalizations.of(context).stop,
                                                                        labelStyle: TextStyle(
                                                                          fontFamily: BuytimeTheme.FontFamily,
                                                                          color: Color(0xff666666),
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                        fillColor: BuytimeTheme.DividerGrey,
                                                                        disabledBorder:
                                                                            OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                        errorBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(color: BuytimeTheme.ErrorRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                        errorMaxLines: 2,
                                                                        errorText: errorStopTime[i],
                                                                        errorStyle: TextStyle(
                                                                          color: BuytimeTheme.ErrorRed,
                                                                          fontSize: 11.0,
                                                                        ),
                                                                        suffixIcon: Icon(Icons.av_timer_outlined)),
                                                                    style: TextStyle(
                                                                      fontFamily: BuytimeTheme.FontFamily,
                                                                      color: Color(0xff666666),
                                                                      fontWeight: FontWeight.w800,
                                                                    ),
                                                                    validator: (value) {
                                                                      errorStopTime[i] = showErrorStopTime(i);
                                                                      return value;
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                ),

                                                Row(
                                                  children: <Widget>[
                                                    // Parent
                                                    CustomLabeledCheckbox(
                                                      label: AppLocalizations.of(context).everyDay,
                                                      value: switchWeek[i],
                                                      onChanged: (value) {
                                                        if (value != null) {
                                                          /// Checked/Unchecked
                                                          _checkAll(value, i);
                                                        } else {
                                                          // Tristate
                                                          _checkAll(true, i);
                                                        }
                                                      },
                                                      checkboxType: CheckboxType.Parent,
                                                      activeColor: Colors.indigo,
                                                    ),
                                                  ],
                                                ),
                                                // Children
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: ListView.builder(
                                                        itemCount: daysOfWeek.length,
                                                        itemBuilder: (context, index) => CustomLabeledCheckbox(
                                                          label: daysOfWeek[index],
                                                          value: daysInterval[i].everyDay[index],
                                                          onChanged: (value) {
                                                            _manageTristate(index, value, i);
                                                          },
                                                          checkboxType: CheckboxType.Child,
                                                          activeColor: Colors.indigo,
                                                        ),
                                                        shrinkWrap: true,
                                                        physics: ClampingScrollPhysics(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.00),
                child: Container(
                  width: widget.media.width * 0.50,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        ///Update Switch EveryDay
                        switchWeek.add(true);
                        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotSwitchWeek(switchWeek));

                        ///Update List Of Days
                        daysInterval.add(EveryDay().toEmpty());
                        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotDaysInterval(daysInterval));

                        ///Update Number of Internal Interval
                        numberOfSlotTimeInterval = numberOfSlotTimeInterval + 1;
                        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotNumberOfInterval(numberOfSlotTimeInterval));

                        ///Update startController
                        startController.add(TextEditingController(text: "00:00"));

                        ///Update startTime
                        String newStartTime = "00:00";
                        startTime.add(newStartTime);
                        List<String> listStart = StoreProvider.of<AppState>(context).state.serviceSlot.startTime;
                        listStart.add(newStartTime);
                        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartTime(listStart));
                        errorStartTime.add(null);

                        ///Update stopController
                        stopController.add(TextEditingController(text: "00:00"));

                        ///Update stopTime
                        String newStopTime = "00:00";
                        stopTime.add(newStopTime);
                        List<String> listStop = StoreProvider.of<AppState>(context).state.serviceSlot.stopTime;
                        listStop.add(newStopTime);
                        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopTime(listStop));
                        errorStopTime.add(null);

                        ///Update keyForm
                        _formSlotTimeKey.add(GlobalKey<FormState>());

                        ///Update Interval Visibility
                        for (int z = 0; z < intervalIndexVisibility.length; z++) {
                          intervalIndexVisibility[z] = false;
                        }
                        intervalIndexVisibility.add(true);
                        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotIntervalVisibility(intervalIndexVisibility));
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.add, color: BuytimeTheme.ManagerPrimary, size: widget.media.width * 0.06),
                          Text(
                            AppLocalizations.of(context).addTimeSlot,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: widget.media.width * 0.04,
                              color: BuytimeTheme.ManagerPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
