import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:Buytime/UI/management/service/UI_M_edit_service.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OnFilePickedCallback = void Function();

class TabAvailability extends StatefulWidget {
  TabAvailability({this.media});

  Size media;

  @override
  State<StatefulWidget> createState() => TabAvailabilityState();
}

class TabAvailabilityState extends State<TabAvailability> {
  int numberOfAvailableInterval = 1;
  List<bool> switchWeek = [];
  List<bool> baseWeek = [false, false, false, false, false, false, false];
  List<List<bool>> daysInterval = [];
  double availableIntervalDynamicHeight = 155.00;

  @override
  void initState() {
    super.initState();
    daysInterval.add(baseWeek);
  }

  Widget weekSwitchDay(Size media, bool enabledDay, String dayName, int dayNumber) {
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
                  value: enabledDay,
                  onChanged: (value) {
                    setState(() {
                      daysInterval[numberOfAvailableInterval][dayNumber] = value;
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          switchWeek = snapshot.serviceState.tabAvailability.switchWeek;
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
                          Container(
                              child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: BuytimeTheme.BackgroundLightGrey,
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Start", //todo: lang
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: widget.media.height * 0.024,
                                              color: BuytimeTheme.TextGrey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Icon(Icons.av_timer, color: BuytimeTheme.SymbolGrey, size: widget.media.width * 0.07),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: BuytimeTheme.BackgroundLightGrey,
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Stop", //todo: lang
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: widget.media.height * 0.024,
                                              color: BuytimeTheme.TextGrey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Icon(Icons.av_timer, color: BuytimeTheme.SymbolGrey, size: widget.media.width * 0.07),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),

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
                                          if (!value) {
                                            availableIntervalDynamicHeight = availableIntervalDynamicHeight + 410.00;
                                            StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityHeight(availableIntervalDynamicHeight + 160.00));
                                          } else {
                                            availableIntervalDynamicHeight = availableIntervalDynamicHeight - 410.00;
                                            StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityHeight(availableIntervalDynamicHeight + 160.00));
                                          }
                                          StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilitySwitchWeek(value, i));
                                         // switchWeek[i] = value;
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
                          !switchWeek[i] //todo: <----Vedere perchè non sente il change sul valore
                              ? Column(
                                  children: [
                                    weekSwitchDay(widget.media, daysInterval[i][0], 'Monday', 0), //todo: lang
                                    weekSwitchDay(widget.media, daysInterval[i][1], 'Tuesday', 1), //todo: lang
                                    weekSwitchDay(widget.media, daysInterval[i][2], 'Wednesday', 2), //todo: lang
                                    weekSwitchDay(widget.media, daysInterval[i][3], 'Thursday', 3), //todo: lang
                                    weekSwitchDay(widget.media, daysInterval[i][4], 'Friday', 4), //todo: lang
                                    weekSwitchDay(widget.media, daysInterval[i][5], 'Saturday', 5), //todo: lang
                                    weekSwitchDay(widget.media, daysInterval[i][6], 'Sunday', 6), //todo: lang
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
                       // switchWeek.add(true);
                        StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityNewSwitchWeekValue(true));
                        daysInterval.add(baseWeek);
                        numberOfAvailableInterval = numberOfAvailableInterval + 1;
                        availableIntervalDynamicHeight = availableIntervalDynamicHeight + 156.00;
                        StoreProvider.of<AppState>(context).dispatch(SetServiceTabAvailabilityHeight(availableIntervalDynamicHeight + 160.00));
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
                        print("Save tab 1");
                        setState(() {});
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
