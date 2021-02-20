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

class CalendarAvailability extends StatefulWidget {
  CalendarAvailability({this.media});

  Size media;

  @override
  State<StatefulWidget> createState() => CalendarAvailabilityState();
}

class CalendarAvailabilityState extends State<CalendarAvailability> {

  ///Calendar vars
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();
  DateTime checkIn = DateTime.now();
  DateTime checkOut = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  Future<void> selectDate(BuildContext context, DateTime cIn, DateTime cOut) async {
    final DateTimeRange picked = await showDateRangePicker(
        context: context, initialDateRange: DateTimeRange(start: cIn, end: cOut), firstDate: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), lastDate: new DateTime(2025));
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
                controller: _checkInController,
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
                    suffixIcon: Icon(Icons.calendar_today,)),
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
                controller: _checkOutController,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: BuytimeTheme.DividerGrey,
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    labelText: AppLocalizations.of(context).checkOut,
                    //hintText: "email *",
                    //hintStyle: TextStyle(color: Color(0xff666666)),
                    labelStyle: TextStyle(
                      fontFamily: BuytimeTheme.FontFamily,
                      fontSize: 12,
                      color: Color(0xff666666),
                      fontWeight: FontWeight.w400,
                    ),
                    suffixIcon: Icon(Icons.calendar_today)
                ),
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
