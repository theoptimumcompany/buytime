import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarAvailability extends StatefulWidget {
  Size media;

  CalendarAvailability({this.media});

  @override
  State<StatefulWidget> createState() => CalendarAvailabilityState();
}

class CalendarAvailabilityState extends State<CalendarAvailability> {
  ///Calendar vars
  TextEditingController checkInController = TextEditingController();
  TextEditingController checkOutController = TextEditingController();
  DateTime checkIn;
  DateTime checkOut;
  int indexStepper;

  @override
  void initState() {
    super.initState();
  }

  Future<void> selectDate(BuildContext context, DateTime cIn, DateTime cOut) async {
    final DateTimeRange picked = await showDateRangePicker(
        context: context, initialDateRange: DateTimeRange(start: cIn, end: cOut), firstDate: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), lastDate: new DateTime(2025));
    if (picked != null && picked.start != null && picked.end != null) {
      setState(() {
        checkInController.text = DateFormat('dd/MM/yyyy').format(picked.start);
        print(checkInController.text);
        checkOutController.text = DateFormat('dd/MM/yyyy').format(picked.end);
        print(checkOutController.text);
        checkIn = picked.start;
        checkOut = picked.end;
        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotCheckIn(checkInController.text));
        StoreProvider.of<AppState>(context).dispatch(SetServiceSlotCheckOut(checkOutController.text));
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    checkInController.text = StoreProvider.of<AppState>(context).state.serviceSlot.checkIn;
    checkOutController.text = StoreProvider.of<AppState>(context).state.serviceSlot.checkOut;
    List<String> checkInString = checkInController.text.split('/');
    List<String> checkOutString = checkOutController.text.split('/');
    checkIn = checkInController.text == ''
        ? DateTime.now()
        : DateTime(
            int.parse(checkInString[2]),
            int.parse(checkInString[1]),
            int.parse(checkInString[0]),
          );
    checkOut = checkOutController.text == ''
        ? DateTime.now()
        : DateTime(
            int.parse(checkOutString[2]),
            int.parse(checkOutString[1]),
            int.parse(checkOutString[0]),
          );
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          return Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///Check In
              Flexible(
                  child: GestureDetector(
                onTap: () async {
                  await selectDate(context, checkIn, checkOut);
                },
                child: TextFormField(
                  enabled: false,
                  controller: checkInController,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: BuytimeTheme.DividerGrey,
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      labelText: AppLocalizations.of(context).checkIn,
                      labelStyle: TextStyle(
                        fontFamily: BuytimeTheme.FontFamily,
                        fontSize: 12,
                        color: Color(0xff666666),
                        fontWeight: FontWeight.w400,
                      ),
                      suffixIcon: Icon(
                        Icons.calendar_today,
                      )),
                  style: TextStyle(
                    fontFamily: BuytimeTheme.FontFamily,
                    color: Color(0xff666666),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return AppLocalizations.of(context).pleaseEnterAValidDateInterval;
                    }
                    return null;
                  },
                ),
              )),
              Container(
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1),
              ),

              ///Check Out
              Flexible(
                  child: GestureDetector(
                onTap: () async {
                  await selectDate(context, checkIn, checkOut);
                },
                child: TextFormField(
                  enabled: false,
                  controller: checkOutController,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: BuytimeTheme.DividerGrey,
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      labelText: AppLocalizations.of(context).checkOut,
                      labelStyle: TextStyle(
                        fontFamily: BuytimeTheme.FontFamily,
                        fontSize: 12,
                        color: Color(0xff666666),
                        fontWeight: FontWeight.w400,
                      ),
                      suffixIcon: Icon(Icons.calendar_today)),
                  style: TextStyle(
                    //fontSize: 12,
                    fontFamily: BuytimeTheme.FontFamily,
                    color: Color(0xff666666),
                    fontSize: 13,
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
              ))
            ],
          ));
        });
  }
}