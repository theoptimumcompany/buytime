import 'package:Buytime/UI/management/service/class/service_slot_classes.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:Buytime/reusable/checkbox/W_checkbox_parent_child.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
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
  List<TimeOfDay> startTime = [];
  List<TimeOfDay> stopTime = [];
  List<String> daysOfWeek = [];
  final List<GlobalKey<FormState>> _formSlotTimeKey = [GlobalKey<FormState>()];
  bool setStartAndStop = true;
  int duration = 0;
  List<bool> intervalIndexVisibility = [];

  @override
  void initState() {
    super.initState();
    daysOfWeek = [
      AppLocalizations.of(context).monday,
      AppLocalizations.of(context).tuesday,
      AppLocalizations.of(context).wednesday,
      AppLocalizations.of(context).thursday,
      AppLocalizations.of(context).friday,
      AppLocalizations.of(context).saturday,
      AppLocalizations.of(context).sunday
    ];
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
      return false;
    }
  }

  Future<void> _selectStartTime(BuildContext context, int indexController) async {
    print(StoreProvider.of<AppState>(context).state.serviceSlot.startTime.length);
    print(indexController);
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
    final TimeOfDay picked = await showTimePicker(
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: TimeOfDay(hour: startHour, minute: startMinute),
    );
    if (picked != null) {
      String minute = picked.minute < 10 ? "0" + picked.minute.toString() : picked.minute.toString();
      String hour = picked.hour < 10 ? "0" + picked.hour.toString() : picked.hour.toString();
      String format24 = hour + ":" + minute;
      startController[indexController].text = format24;
      List<String> controllerList = convertListTextEditingControllerToListString(startController);
      StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartTime(controllerList));

      setState(() {
        startTime[indexController] = picked;
        _formSlotTimeKey[indexController].currentState.validate();
      });
    }
    return null;
  }

  Future<void> _selectStopTime(BuildContext context, int indexController) async {
    String initStop = StoreProvider.of<AppState>(context).state.serviceSlot.stopTime[indexController];
    List<String> stop = [];
    int stopHour = 0;
    int stopMinute = 0;
    if (initStop.contains('null')) {
    } else {
      stop = initStop.split(":");
      stopHour = int.parse(stop[0]);
      stopMinute = int.parse(stop[1]);
    }
    final TimeOfDay picked = await showTimePicker(
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: TimeOfDay(hour: stopHour, minute: stopMinute),
    );
    if (picked != null) {
      String minute = picked.minute < 10 ? "0" + picked.minute.toString() : picked.minute.toString();
      String hour = picked.hour < 10 ? "0" + picked.hour.toString() : picked.hour.toString();
      String format24 = hour + ":" + minute;
      stopController[indexController].text = format24;
      List<String> controllerList = convertListTextEditingControllerToListString(stopController);
      StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopTime(controllerList));
      setState(() {
        stopTime[indexController] = picked;
        _formSlotTimeKey[indexController].currentState.validate();
      });
    }
    return null;
  }

  void setStartAndStopTime() {
    List<String> start = StoreProvider.of<AppState>(context).state.serviceSlot.startTime;
    List<String> stop = StoreProvider.of<AppState>(context).state.serviceSlot.stopTime;
    TimeOfDay timeOfDayStart;
    TimeOfDay timeOfDayStop;
    if (start.length == 0) {
      TextEditingController textEditingControllerStart = TextEditingController();
      startController.add(textEditingControllerStart);
      timeOfDayStart = TimeOfDay();
      startTime.add(timeOfDayStart);
      start.add(timeOfDayStart.hour.toString() + ":" + timeOfDayStart.minute.toString());
      debugPrint('W_service_step_availabile_time => start: $start');
      StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartTime(start));
    } else {
      for (int i = 0; i < start.length; i++) {
        TextEditingController textEditingControllerStart = TextEditingController();
        textEditingControllerStart.text = start[i];
        startController.add(textEditingControllerStart);
        List<String> startString = start[i].split(":");
        debugPrint('W_service_step_availabile_time => start: $start');
        timeOfDayStart = TimeOfDay(hour: int.parse(startString[0]), minute: int.parse(startString[1]));
        startTime.add(timeOfDayStart);
      }
    }

    if (stop.length == 0) {
      TextEditingController textEditingControllerStop = TextEditingController();
      stopController.add(textEditingControllerStop);
      timeOfDayStop = TimeOfDay();
      stopTime.add(timeOfDayStop);
      stop.add(timeOfDayStop.hour.toString() + ":" + timeOfDayStop.minute.toString());
      StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopTime(stop));
    } else {
      for (int i = 0; i < stop.length; i++) {
        TextEditingController textEditingControllerStop = TextEditingController();
        textEditingControllerStop.text = stop[i];
        stopController.add(textEditingControllerStop);
        List<String> stopString = stop[i].split(":");
        timeOfDayStop = TimeOfDay(hour: int.parse(stopString[0]), minute: int.parse(stopString[1]));
        stopTime.add(timeOfDayStop);
      }
    }
  }

  void setDuration() {
    if (StoreProvider.of<AppState>(context).state.serviceSlot.startTime.contains('null:null') || StoreProvider.of<AppState>(context).state.serviceSlot.stopTime.contains('null:null')) {
      return;
    } else {
      for (int i = 0; i < StoreProvider.of<AppState>(context).state.serviceSlot.numberOfInterval; i++) {
        List<String> start = StoreProvider.of<AppState>(context).state.serviceSlot.startTime[i].split(":");
        int startHour = int.parse(start[0]);
        int startMinute = int.parse(start[1]);
        List<String> stop = StoreProvider.of<AppState>(context).state.serviceSlot.stopTime[i].split(":");
        int stopHour = int.parse(stop[0]);
        int stopMinute = int.parse(stop[1]);
        int localDuration = (((stopHour * 60) + stopMinute) - ((startHour * 60) + startMinute));
        if (localDuration <= 9) {
          StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMinDuration(localDuration));
        } else if (duration == 10) {
          setState(() {
            duration = localDuration;
            StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMinDuration(duration));
          });
        } else if (localDuration < duration) {
          setState(() {
            duration = localDuration;
            StoreProvider.of<AppState>(context).dispatch(SetServiceSlotMinDuration(duration));
          });
        }
        ;
      }
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
          intervalIndexVisibility = List.generate(store.state.serviceSlot.numberOfInterval, (index) => index == 0 ? true : false);
        },
        builder: (context, snapshot) {
          switchWeek = snapshot.serviceSlot.switchWeek;
          daysInterval = snapshot.serviceSlot.daysInterval;
          numberOfSlotTimeInterval = snapshot.serviceSlot.numberOfInterval;
          duration = snapshot.serviceSlot.minDuration;
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
                      if (i > 0) {
                        ///Update keyForm
                        _formSlotTimeKey.add(GlobalKey<FormState>());
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                                  print(startController);
                                  print(snapshot.serviceSlot.startTime);
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                          child: Row(
                                        children: [
                                          Text(
                                            (i + 1).toString() + AppLocalizations.of(context).workingHours,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: widget.media.height * 0.018,
                                              color: BuytimeTheme.TextBlack,
                                              fontWeight: FontWeight.w500,
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
                                                              onTap: () async {
                                                                await _selectStartTime(context, i);
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(right: 5.0),
                                                                child: Container(
                                                                  child: TextFormField(
                                                                    enabled: false,
                                                                    controller: startController[i],
                                                                    textAlign: TextAlign.start,
                                                                    keyboardType: TextInputType.number,
                                                                    decoration: InputDecoration(
                                                                        filled: true,
                                                                        fillColor: BuytimeTheme.DividerGrey,
                                                                        enabledBorder:
                                                                            OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                        labelText: AppLocalizations.of(context).start,
                                                                        //todo trans
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
                                                                        suffixIcon: Icon(Icons.av_timer_outlined)),
                                                                    style: TextStyle(
                                                                      fontFamily: BuytimeTheme.FontFamily,
                                                                      color: Color(0xff666666),
                                                                      fontWeight: FontWeight.w800,
                                                                    ),
                                                                    validator: (value) {
                                                                      setDuration();
                                                                      if (startController[i].text.isEmpty) {
                                                                        return AppLocalizations.of(context).insertStartTimeFirst;
                                                                      } else if (stopController[i].text.isEmpty) {
                                                                      } else if ((stopTime[i].hour + stopTime[i].minute / 60.0) - (startTime[i].hour + startTime[i].minute / 60.0) <= 0) {
                                                                        return AppLocalizations.of(context).startTimeHigherStop;
                                                                      } else {
                                                                        List<String> controllerList = convertListTextEditingControllerToListString(startController);
                                                                        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartTime(controllerList));
                                                                      }
                                                                      return '';
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
                                                              onTap: () async {
                                                                if (startController[i].text.isEmpty) {
                                                                  validate(i);
                                                                  return;
                                                                }
                                                                await _selectStopTime(context, i);
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 5.0),
                                                                child: TextFormField(
                                                                  enabled: false,
                                                                  controller: stopController[i],
                                                                  textAlign: TextAlign.start,
                                                                  keyboardType: TextInputType.datetime,
                                                                  decoration: InputDecoration(
                                                                      filled: true,
                                                                      fillColor: BuytimeTheme.DividerGrey,
                                                                      enabledBorder:
                                                                          OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                      labelText: AppLocalizations.of(context).stop,
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
                                                                      suffixIcon: Icon(Icons.av_timer_outlined)),
                                                                  style: TextStyle(
                                                                    fontFamily: BuytimeTheme.FontFamily,
                                                                    color: Color(0xff666666),
                                                                    fontWeight: FontWeight.w800,
                                                                  ),
                                                                  validator: (value) {
                                                                    setDuration();

                                                                    if (startController[i].text.isEmpty) {
                                                                      return AppLocalizations.of(context).insertStartTimeFirst;
                                                                    } else if (stopController[i].text.isEmpty) {
                                                                    } else if ((stopTime[i].hour + stopTime[i].minute / 60.0) - (startTime[i].hour + startTime[i].minute / 60.0) <= 0) {
                                                                      return AppLocalizations.of(context).stopTimeShorterStart;
                                                                    } else {
                                                                      List<String> controllerList = convertListTextEditingControllerToListString(stopController);

                                                                      StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopTime(controllerList));
                                                                    }
                                                                    return '';
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
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
                        startController.add(TextEditingController());

                        ///Update startTime
                        TimeOfDay timeOfDayStart = TimeOfDay();
                        startTime.add(timeOfDayStart);
                        List<String> listStart = StoreProvider.of<AppState>(context).state.serviceSlot.startTime;
                        listStart.add(timeOfDayStart.hour.toString() + ":" + timeOfDayStart.minute.toString());
                        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartTime(listStart));

                        ///Update stopController
                        stopController.add(TextEditingController());

                        ///Update stopTime
                        stopTime.add(TimeOfDay());

                        TimeOfDay timeOfDayStop = TimeOfDay();
                        stopTime.add(timeOfDayStop);
                        List<String> listStop = StoreProvider.of<AppState>(context).state.serviceSlot.stopTime;
                        listStop.add(timeOfDayStop.hour.toString() + ":" + timeOfDayStop.minute.toString());
                        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopTime(listStop));

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
