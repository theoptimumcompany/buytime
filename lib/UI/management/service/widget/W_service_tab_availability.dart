import 'package:Buytime/reblox/model/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/service/tab_availability_state.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/utils/size_config.dart';

import 'package:Buytime/utils/theme/buytime_theme.dart';

import 'package:flutter_redux/flutter_redux.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef OnFilePickedCallback = void Function();

class TabAvailability extends StatefulWidget {
  TabAvailability({this.media});

  Size media;

  @override
  State<StatefulWidget> createState() => TabAvailabilityState();
}

class TabAvailabilityState extends State<TabAvailability> {
  int numberOfAvailableInterval = 1;
  TabAvailabilityStoreState baseAvailability = TabAvailabilityStoreState().toEmpty();

  List<bool> switchWeek = [];
  List<EveryDay> daysInterval = [];
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _stopController = TextEditingController();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay stopTime = TimeOfDay.now();
  bool errorStart = false;
  bool errorStop = false;
  String errorTextStart = "";
  String errorTextStop = "";

  @override
  void initState() {
    super.initState();
  }



  Widget weekSwitchDay(Size media, String dayName, int listNumber, int dayNumber) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: media.width * 0.05,
          ),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Switch(
                  value: daysInterval[listNumber].everyDay[dayNumber],
                  onChanged: (value) {
                    setState(() {
                      daysInterval[listNumber].everyDay[dayNumber] = value;
                      StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilitySwitchDay(daysInterval));
                    });
                  }),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: BuytimeTheme.DividerGrey),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    dayName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: BuytimeTheme.TextBlack,
                      fontSize: media.height * 0.018,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectStartTime(BuildContext context) async {

    final TimeOfDay picked = await  showTimePicker(
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
        context: context,
        initialEntryMode: TimePickerEntryMode.dial,
        initialTime: TimeOfDay(hour: 0, minute: 0),
    );
     if (picked != null) {
       String minute = picked.minute < 10 ? "0" + picked.minute.toString() : picked.minute.toString();
       String format24 = picked.hour.toString() + ":" + minute;
       _startController.text = format24;
      setState(() {
        startTime = picked;
      });
    }
    return null;
  }

  Future<void> _selectStopTime(BuildContext context) async {
    final TimeOfDay picked = await  showTimePicker(
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,

      initialTime: TimeOfDay(hour: 0, minute: 0),
    );
    if (picked != null) {
      String minute = picked.minute < 10 ? "0" + picked.minute.toString() : picked.minute.toString();
      String format24 = picked.hour.toString() + ":" + minute;
      _stopController.text = format24;
      setState(() {
        stopTime = picked;

        if((stopTime.hour + stopTime.minute/60.0) - (startTime.hour + startTime.minute/60.0) <= 0){
          errorStop = true;
          errorTextStop = "Non si può";
        }else
        {
          errorStop = true;
          errorTextStop = "Ok periodo decente";
        }
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          switchWeek = snapshot.serviceState.tabAvailability.switchWeek != null && snapshot.serviceState.tabAvailability.switchWeek.isNotEmpty
              ? snapshot.serviceState.tabAvailability.switchWeek
              : baseAvailability.switchWeek;
          daysInterval = snapshot.serviceState.tabAvailability.daysInterval != null && snapshot.serviceState.tabAvailability.daysInterval.isNotEmpty
              ? snapshot.serviceState.tabAvailability.daysInterval
              : baseAvailability.daysInterval;
          numberOfAvailableInterval = snapshot.serviceState.tabAvailability.numberOfInterval;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: numberOfAvailableInterval,
                    itemBuilder: (context, i) {
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.red,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                              child: Container(
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
                            ),
                            ///Time Range
                            Container(
                                margin: EdgeInsets.only( left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ///Start Time
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: ()async{
                                            setState(() {
                                              errorStart = false;
                                            });
                                            await _selectStartTime(context);

                                          },
                                          child: Container(
                                            width: media.width * 0.43,
                                            child: TextFormField(
                                              enabled: false,
                                              controller: _startController,
                                              textAlign: TextAlign.start,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: BuytimeTheme.DividerGrey,
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Color(0xff666666)),
                                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                  ),
                                                  labelText: "Start", //todo trans
                                                  labelStyle: TextStyle(
                                                    fontFamily: BuytimeTheme.FontFamily,
                                                    color: Color(0xff666666),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  suffixIcon: Icon(
                                                      Icons.av_timer_outlined
                                                  )
                                              ),
                                              style: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: Color(0xff666666),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ),
                                        errorStart
                                            ? Container(
                                          width: media.width * 0.43,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10.0),
                                            child: Container(
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        errorTextStart,
                                                        style: TextStyle(
                                                          fontSize: media.height * 0.017,
                                                          color: BuytimeTheme.ErrorRed,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        overflow: TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        )
                                            : Container(),
                                      ],
                                    ),
                                    ///Stop Time
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async{
                                            if(_startController.text == ''){
                                              setState(() {
                                                errorStart = true;
                                                errorTextStart = "Select start time first";
                                              });
                                            }
                                            else{
                                              await _selectStopTime(context);
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 15.0),
                                            child: Container(
                                              width: media.width * 0.43,
                                              child: TextFormField(
                                                enabled: false,
                                                controller: _stopController,
                                                textAlign: TextAlign.start,
                                                keyboardType: TextInputType.datetime,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: BuytimeTheme.DividerGrey,
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Color(0xff666666)),
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                    ),
                                                    labelText:  "Stop", //todo: trans
                                                    //hintText: "email *",
                                                    //hintStyle: TextStyle(color: Color(0xff666666)),
                                                    labelStyle: TextStyle(
                                                      fontFamily: BuytimeTheme.FontFamily,
                                                      color: Color(0xff666666),
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                    suffixIcon: Icon(
                                                        Icons.av_timer_outlined
                                                    )
                                                ),
                                                style: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: Color(0xff666666),
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        errorStop
                                            ? Container(
                                          width: media.width * 0.43,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10.0,left: 10.0),
                                            child: Container(
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        errorTextStop,
                                                        style: TextStyle(
                                                          fontSize: media.height * 0.017,
                                                          color: BuytimeTheme.ErrorRed,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        overflow: TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        )
                                            : Container(),
                                      ],
                                    )
                                  ],
                                )
                            ),

                            ///Switch Every Day
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
                              child: Container(
                                child: Row(
                                  children: [
                                    Switch(
                                        value: switchWeek[i],
                                        onChanged: (value) {
                                          setState(() {
                                            switchWeek[i] = value;
                                            StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilitySwitchWeek(switchWeek));
                                          });
                                        }),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(width: 1.0, color: BuytimeTheme.DividerGrey),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                                  child: Text(
                                                    'Every day',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: BuytimeTheme.TextBlack,
                                                      fontSize: widget.media.height * 0.02,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            !switchWeek[i]
                                ? Column(
                              children: [
                                weekSwitchDay(widget.media, 'Monday', i, 0), //todo: lang
                                weekSwitchDay(widget.media, 'Tuesday', i, 1), //todo: lang
                                weekSwitchDay(widget.media, 'Wednesday', i, 2), //todo: lang
                                weekSwitchDay(widget.media, 'Thursday', i, 3), //todo: lang
                                weekSwitchDay(widget.media, 'Friday', i, 4), //todo: lang
                                weekSwitchDay(widget.media, 'Saturday', i, 5), //todo: lang
                                weekSwitchDay(widget.media, 'Sunday', i, 6), //todo: lang
                              ],
                            )
                                : Container(),
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
                        switchWeek.add(true);
                        daysInterval.add(EveryDay().toEmpty());
                        numberOfAvailableInterval = numberOfAvailableInterval + 1;
                        StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilitySwitchWeek(switchWeek));
                        StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityNumberOfInterval(numberOfAvailableInterval));
                        StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityDaysInterval(daysInterval));
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.add, color: BuytimeTheme.ManagerPrimary, size: widget.media.width * 0.08),
                          Text(
                            "ADD SLOT", //todo: lang
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: widget.media.height * 0.023,
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
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.00),
                  child: Container(
                    width: widget.media.width * 0.50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: BuytimeTheme.ManagerPrimary,
                      ),
                      onPressed: () {
                        print("Aggiorno il service con booking selezionato");
                        StoreProvider.of<AppState>(context).dispatch(UpdateService(snapshot.serviceState));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "NEXT", //todo: lang
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: widget.media.height * 0.023,
                            color: BuytimeTheme.TextWhite,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
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
