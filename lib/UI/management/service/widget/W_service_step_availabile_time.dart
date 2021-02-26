import 'package:Buytime/UI/management/service/class/service_slot_classes.dart';
import 'package:Buytime/reusable/checkbox/W_checkbox_parent_child.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:Buytime/reblox/model/service/service_time_slot_state.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

class StepAvailableTime extends StatefulWidget {
  StepAvailableTime({this.media});

  Size media;

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
  List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  List<bool> daysOfWeekValue = [false, false, false, false, false, false, false];
  final List<GlobalKey<FormState>> _formSlotTimeKey = [GlobalKey<FormState>()];

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
        daysOfWeekValue[indexDay] = true;
        // Checking if all other children are also selected -
        if (daysOfWeekValue.contains(false)) {
          // No. Parent -> tristate.
          switchWeek[indexInterval] = null;
        } else {
          // Yes. Select all.
          _checkAll(true, indexInterval);
        }
      } else {
        // unselected
        daysOfWeekValue[indexDay] = false;
        // Checking if all other children are also unselected -
        if (daysOfWeekValue.contains(true)) {
          // No. Parent -> tristate.
          switchWeek[indexInterval] = null;
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
      for (int i = 0; i < daysOfWeek.length; i++) {
        daysOfWeekValue[i] = value;
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
    final TimeOfDay picked = await showTimePicker(
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: TimeOfDay(hour: 0, minute: 0),
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
      });
    }
    return null;
  }

  Future<void> _selectStopTime(BuildContext context, int indexController) async {
    final TimeOfDay picked = await showTimePicker(
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: TimeOfDay(hour: 0, minute: 0),
    );
    if (picked != null) {
      String minute = picked.minute < 10 ? "0" + picked.minute.toString() : picked.minute.toString();
      String hour = picked.hour < 10 ? "0" + picked.hour.toString() : picked.hour.toString();
      String format24 = hour + ":" + minute;
      stopController[indexController].text = format24;
      List<String> controllerList = convertListTextEditingControllerToListString(stopController);
      StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartTime(controllerList));
      setState(() {
        stopTime[indexController] = picked;
        _formSlotTimeKey[indexController].currentState.validate();
      });
    }
    return null;
  }

  void setStartAndStopTime() {
    List<String> start = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.startTime;
    List<String> stop = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.stopTime;
    if(start.length == 0){
      TextEditingController textEditingControllerStart = TextEditingController();
      TextEditingController textEditingControllerStop = TextEditingController();
      startController.add(textEditingControllerStart);
      stopController.add(textEditingControllerStop);
      TimeOfDay timeOfDayStart = TimeOfDay.now();
      TimeOfDay timeOfDayStop = TimeOfDay.now();
      startTime.add(timeOfDayStart);
      stopTime.add(timeOfDayStop);
    }
    for (int i = 0; i < start.length; i++) {
      TextEditingController textEditingControllerStart = TextEditingController();
      TextEditingController textEditingControllerStop = TextEditingController();
      textEditingControllerStart.text = start[i];
      textEditingControllerStop.text = stop[i];
      startController.add(textEditingControllerStart);
      stopController.add(textEditingControllerStop);
      List<String> startString = start[i].split(":");
      List<String> stopString = stop[i].split(":");
      TimeOfDay timeOfDayStart = TimeOfDay(hour: int.parse(startString[0]), minute: int.parse(startString[1]));
      TimeOfDay timeOfDayStop = TimeOfDay(hour: int.parse(stopString[0]), minute: int.parse(stopString[1]));
      startTime.add(timeOfDayStart);
      stopTime.add(timeOfDayStop);
    }
  }

  @override
  Widget build(BuildContext context) {
    switchWeek = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.switchWeek;
    daysInterval = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.daysInterval;
    numberOfSlotTimeInterval = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.numberOfInterval;
    setStartAndStopTime();
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
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
                      return Form(
                        key: _formSlotTimeKey[i],
                        child: Column(
                          children: [
                            Container(
                                child: Row(
                              children: [
                                Text(
                                  (i + 1).toString() + ". Available time",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: widget.media.height * 0.018,
                                    color: BuytimeTheme.TextBlack,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )),

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
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                    labelText: "Start",
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
                                                  if (value.isEmpty) {
                                                    return 'Please insert time';
                                                  }
                                                  return null;
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
                                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                  labelText: "Stop",
                                                  //todo: trans
                                                  //hintText: "email *",
                                                  //hintStyle: TextStyle(color: Color(0xff666666)),
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
                                                if (startController[i].text.isEmpty) {
                                                  return "Insert start time first";
                                                } else if ((stopTime[i].hour + stopTime[i].minute / 60.0) - (startTime[i].hour + startTime[i].minute / 60.0) <= 0) {
                                                  return "Stop time is shorter than start";
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
                                  label: 'Every day',
                                  value: switchWeek[i],
                                  onChanged: (value) {
                                    setState(() {
                                      switchWeek[i] = value;
                                      StoreProvider.of<AppState>(context).dispatch(SetServiceSlotSwitchWeek(switchWeek));
                                    });
                                    if (value != null) {
                                      // Checked/Unchecked
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
                            ///TODO: sE everyday true metter tutti a true
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
                                        setState(() {
                                          daysInterval[i].everyDay[index] = value;
                                          StoreProvider.of<AppState>(context).dispatch(SetServiceSlotDaysInterval(daysInterval));
                                        });
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
                        List<String> listStart = convertListTextEditingControllerToListString(startController);
                        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStartTime(listStart));

                        ///Update startTime
                        startTime.add(TimeOfDay());

                        ///Update stopController
                        stopController.add(TextEditingController());
                        List<String> listStop = convertListTextEditingControllerToListString(stopController);
                        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotStopTime(listStop));

                        ///Update stopTime
                        stopTime.add(TimeOfDay());
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.add, color: BuytimeTheme.ManagerPrimary, size: widget.media.width * 0.06),
                          Text(
                            "ADD TIME SLOT", //todo: lang
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: widget.media.height * 0.022,
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
