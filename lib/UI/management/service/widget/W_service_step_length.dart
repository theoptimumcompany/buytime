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

class StepLength extends StatefulWidget {
  StepLength({this.media});

  Size media;

  @override
  State<StatefulWidget> createState() => StepLengthState();
}

class StepLengthState extends State<StepLength> {
  ///Length vars
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _limitBookingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          return Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Hour
                    Flexible(
                        child: GestureDetector(
                      onTap: () async {},
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: TextFormField(
                          enabled: true,
                          controller: _hourController,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: BuytimeTheme.DividerGrey,
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              labelText: 'Hour',
                              labelStyle: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w400,
                              ),
                              suffixText: 'h'),
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
                    )),
                    Container(
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1),
                    ),

                    ///Minute
                    Flexible(
                        child: GestureDetector(
                      onTap: () async {},
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: TextFormField(
                          enabled: true,
                          controller: _minuteController,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: BuytimeTheme.DividerGrey,
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              labelText: 'Minute',
                              labelStyle: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w400,
                              ),
                              suffixText: 'm'),
                          style: TextStyle(
                            //fontSize: 12,
                            fontFamily: BuytimeTheme.FontFamily,
                            color: Color(0xff666666),
                            fontWeight: FontWeight.w800,
                          ),
                          validator: (String value) {
                            return;
                          },
                        ),
                      ),
                    ))
                  ],
                ),
              ),

              /// Resume text time duration
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Container(
                      child: Flexible(
                        child: Text(
                          'This service offered to guests that lasts XXX minutes', //TODO: <-- ADD TO LANGUAGE TRANSLATE
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
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Booking Limit
                    Flexible(
                        child: GestureDetector(
                      onTap: () async {},
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: TextFormField(
                          enabled: true,
                          controller: _limitBookingController,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: BuytimeTheme.DividerGrey,
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              labelText: 'Booking limit',
                              labelStyle: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w400,
                              ),
                              suffixText: 'limit'),
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
                    )),
                    Container(
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1),
                    ),

                    ///Empty
                    Flexible(
                        child: GestureDetector(
                      onTap: () async {},
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(),
                      ),
                    ))
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
                          'This service has a limit of bookings of XXX', //TODO: <-- ADD TO LANGUAGE TRANSLATE
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
          ));
        });
  }
}
