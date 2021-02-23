import 'package:Buytime/reblox/model/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/service/service_time_slot_state.dart';
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
  TextEditingController _priceController = TextEditingController();
  var _formSlotPriceKey;
  int indexStepper;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    indexStepper = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.actualSlotIndex;
    _priceController = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.priceController[indexStepper];
    _formSlotPriceKey = StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.formSlotPriceKey[indexStepper];
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          return Form(
            key:  _formSlotPriceKey,
            child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Price TextFormField
                    Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: TextFormField(
                            enabled: true,
                            controller: _priceController,
                            onChanged: (value) {
                              setState(() {
                                _priceController.text = value;
                                StoreProvider.of<AppState>(context).dispatch(SetServiceSlotPriceController(_priceController.text, indexStepper));
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                _priceController.text = value;
                                StoreProvider.of<AppState>(context).dispatch(SetServiceSlotPriceController(_priceController.text, indexStepper));
                              });
                            },
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
                                errorMaxLines: 2,
                                errorStyle: TextStyle(
                                  color: BuytimeTheme.ErrorRed,
                                  fontSize: 12.0,
                                ),
                                suffixText: '€'),
                            style: TextStyle(
                              fontFamily: BuytimeTheme.FontFamily,
                              color: Color(0xff666666),
                              fontWeight: FontWeight.w800,
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please insert a price';
                              }
                              return null;
                            },
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
                )),
          );
        });
  }
}
