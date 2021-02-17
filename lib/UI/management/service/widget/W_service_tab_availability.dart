import 'package:Buytime/reblox/model/app_state.dart';
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
  double availableIntervalDynamicHeight = 155.00;
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();
  DateTime checkIn = DateTime.now();
  DateTime checkOut = DateTime.now();

  @override
  void initState() {
    super.initState();
  }



  Widget weekSwitchDay(Size media, String dayName, int listNumber, int dayNumber) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
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

  Future<void> _selectTimeRange(BuildContext context, DateTime cIn, DateTime cOut) async {
    final DateTimeRange picked = await showDateRangePicker(
        context: context,
        initialDateRange: DateTimeRange(start: cIn, end: cOut),
        firstDate: new DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day),
        lastDate: new DateTime(2025)
    );
    if (picked != null && picked.start != null && picked.end != null) {
      print(picked);
      _checkInController.text = DateFormat('dd/MM/yyyy').format(picked.start);
      _checkOutController.text = DateFormat('dd/MM/yyyy').format(picked.end);
      setState(() {
        checkIn = picked.start;
        checkOut = picked.end;
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
          if (snapshot.serviceState.tabAvailability.intervalsHeight < 155.00) {
            StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityTabHeight(availableIntervalDynamicHeight + (160.00 * numberOfAvailableInterval)));
            StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityIntervalsHeight(availableIntervalDynamicHeight));
          }
          availableIntervalDynamicHeight = snapshot.serviceState.tabAvailability.intervalsHeight;
          //TODO : GESTIRE VALORA DAL DB PER ALTEZZE GIUSTE
          return Column(
            children: [
              Container(
                height: availableIntervalDynamicHeight,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: numberOfAvailableInterval,
                    itemBuilder: (context, i) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                            child: Container(
                                child: Row(
                              children: [
                                Text(
                                  (i + 1).toString() + ". Availabile time",
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///Check In
                                  GestureDetector(
                                    onTap: ()async{
                                      await _selectTimeRange(context, checkIn, checkOut);
                                    },
                                    child: Container(
                                      width: media.width * 0.4,
                                      child: TextFormField(
                                        enabled: false,
                                        controller: _checkInController,
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
                                            labelText: AppLocalizations.of(context).checkIn,
                                            //hintText: "email *",
                                            //hintStyle: TextStyle(color: Color(0xff666666)),
                                            labelStyle: TextStyle(
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: Color(0xff666666),
                                              fontWeight: FontWeight.w400,
                                            ),
                                            suffixIcon: Icon(
                                                Icons.calendar_today
                                            )
                                        ),
                                        style: TextStyle(
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: Color(0xff666666),
                                          fontWeight: FontWeight.w800,
                                        ),
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return AppLocalizations.of(context).pleaseEnterAValidDateInterval;
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  ///Check Out
                                  GestureDetector(
                                    onTap: () async{
                                      await _selectTimeRange(context, checkIn, checkOut);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15.0),
                                      child: Container(
                                        width: media.width * 0.4,
                                        child: TextFormField(
                                          enabled: false,
                                          controller: _checkOutController,
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
                                              labelText: AppLocalizations.of(context).checkOut,
                                              //hintText: "email *",
                                              //hintStyle: TextStyle(color: Color(0xff666666)),
                                              labelStyle: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: Color(0xff666666),
                                                fontWeight: FontWeight.w400,
                                              ),
                                              suffixIcon: Icon(
                                                  Icons.calendar_today
                                              )
                                          ),
                                          style: TextStyle(
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: Color(0xff666666),
                                            fontWeight: FontWeight.w800,
                                          ),
                                          validator: (String value) {
                                            debugPrint('${checkIn.compareTo(checkOut)}');
                                            if (value.isEmpty || checkIn.compareTo(checkOut) > 0) {
                                              return AppLocalizations.of(context).pleaseEnterAValidDateInterval;
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
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
                                          print("Dimensione availableIntervalDynamicHeight iniziale " + availableIntervalDynamicHeight.toString());
                                          if (!value) {
                                            StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityTabHeight(snapshot.serviceState.tabAvailability.tabHeight + 400.00));
                                            StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityIntervalsHeight(snapshot.serviceState.tabAvailability.intervalsHeight + 400.00));
                                          } else {
                                            StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityTabHeight(snapshot.serviceState.tabAvailability.tabHeight - 400.00));
                                            StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityIntervalsHeight(snapshot.serviceState.tabAvailability.intervalsHeight - 400.00));
                                          }
                                          print("Dimensione dopo dispatch " + availableIntervalDynamicHeight.toString());
                                          availableIntervalDynamicHeight = snapshot.serviceState.tabAvailability.intervalsHeight;
                                          print("Dimensione dopo dispatch dopo assegnazione " + availableIntervalDynamicHeight.toString());

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
                        StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilitySwitchWeek(switchWeek));
                        daysInterval.add(EveryDay().toEmpty());
                        numberOfAvailableInterval = numberOfAvailableInterval + 1;
                        StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityNumberOfInterval(numberOfAvailableInterval));
                        StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityDaysInterval(daysInterval));
                        StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityTabHeight(snapshot.serviceState.tabAvailability.tabHeight + 155.00));
                        StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityIntervalsHeight(snapshot.serviceState.tabAvailability.intervalsHeight + 155.00));
                        availableIntervalDynamicHeight = snapshot.serviceState.tabAvailability.tabHeight;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.add, color: BuytimeTheme.ManagerPrimary, size: widget.media.width * 0.08),
                          Text(
                            "ADD INTEVAL", //todo: lang
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
                          "SAVE", //todo: lang
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
