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

class StepPrice extends StatefulWidget {
  StepPrice({this.media});

  Size media;

  @override
  State<StatefulWidget> createState() => StepPriceState();
}

class StepPriceState extends State<StepPrice> {
  ///Price vars
  final TextEditingController _priceController = TextEditingController();

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///Price TextFormField
                  Flexible(
                      child: GestureDetector(
                    onTap: () async {},
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: TextFormField(
                        enabled: true,
                        controller: _priceController,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: BuytimeTheme.DividerGrey,
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            labelText: 'Slot Price',
                            labelStyle: TextStyle(
                              fontFamily: BuytimeTheme.FontFamily,
                              color: Color(0xff666666),
                              fontWeight: FontWeight.w400,
                            ),
                            suffixText: '€'),
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
              ));
        });
  }
}
