/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:flutter/cupertino.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StepPrice extends StatefulWidget {
  Size media;

  StepPrice({this.media});

  @override
  State<StatefulWidget> createState() => StepPriceState();
}

class StepPriceState extends State<StepPrice> {
  ///Price vars
  TextEditingController priceController = TextEditingController();
  double price = 0.0;
  GlobalKey<FormState> _formSlotPriceKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      price = StoreProvider.of<AppState>(context).state.serviceSlot.price;
      List<String> format = [];
      format = price.toString().split(".");
      priceController.text = format[0].toString() + (format[1] == '0' ? '' : "." + (int.parse(format[1]) < 10 ? format[1].toString() + '0': format[1].toString()));

    });
  }

  // showPickerPrice(BuildContext context) {
  //   String initPrice = StoreProvider.of<AppState>(context).state.serviceSlot.price.toString();
  //   List<String> format = [];
  //   int unit = 0;
  //   int decimal = 0;
  //
  //   format = initPrice.split(".");
  //   unit = int.parse(format[0]);
  //   decimal = int.parse(format[1]);
  //
  //   Picker(
  //       adapter: NumberPickerAdapter(data: [
  //         NumberPickerColumn(initValue: unit, begin: 0, end: 999, jump: 1),
  //         NumberPickerColumn(initValue: decimal, begin: 0, end: 99, jump: 1),
  //       ]),
  //       delimiter: [
  //         PickerDelimiter(
  //             child: Container(
  //           alignment: Alignment.center,
  //           child: Text("."),
  //         ))
  //       ],
  //       hideHeader: true,
  //       title: Text(
  //         "Please select price",
  //         style: TextStyle(
  //           fontSize: widget.media.height * 0.022,
  //           color: BuytimeTheme.TextBlack,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //       selectedTextStyle: TextStyle(color: Colors.blue),
  //       onCancel: (){return 0;},
  //       onConfirm: (Picker picker, List value) {
  //         setState(() {
  //           priceController.text = value[0].toString() + "." + (value[1] < 10 ? value[1].toString() + "0" : value[1].toString());
  //           price = double.parse(value[0].toString() + "." + (value[1] < 10 ? value[1].toString() + "0" : value[1].toString()));
  //           StoreProvider.of<AppState>(context).dispatch(SetServiceSlotPrice(price));
  //         });
  //       }).showDialog(context);
  // }

  // bool validateAndSave() {
  //   final FormState form = _formSlotPriceKey.currentState;
  //   if (form.validate()) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  //
  // bool validatePrice(String value) {
  //   RegExp regex = RegExp(r'(^\d*\.?\d*)');
  //   return (!regex.hasMatch(value)) ? false : true;
  // }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          return Form(
            key: _formSlotPriceKey,
            child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Price TextFormField
                    Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Container(
                            height: 56,
                            child: TextFormField(
                              enabled: true,
                              controller: priceController,
                              //  initialValue: snapshot.serviceSlot.price.toString(),
                              onTap: (){
                                setState(() {
                                  priceController.clear();
                                });
                              },
                              onChanged: (value) {
                                if (value == "") {
                                  setState(() {
                                    price = 0.0;
                                    value = "0.0";
                                  });
                                } else {
                                  if (value.contains(".")) {
                                    List<String> priceString = value.split(".");
                                    if (priceString[1].length == 1) {
                                      value += "0";
                                    }
                                    else if(priceString[1].length == 0){
                                      value += "00";
                                    }
                                  } else {
                                    value += ".00";
                                  }
                                  setState(() {
                                    price = double.parse(value);
                                  });
                                }
                                StoreProvider.of<AppState>(context).dispatch(SetServiceSlotPrice(price));
                              },
                              onFieldSubmitted: (value) {
                                if (value == "") {
                                  setState(() {
                                    price = 0.0;
                                    value = "0.0";
                                    priceController.text = value;
                                  });
                                } else {
                                  if (value.contains(".")) {
                                    List<String> priceString = value.split(".");
                                    if (priceString[1].length == 1) {
                                      value += "0";
                                    }
                                    else if(priceString[1].length == 0){
                                      value += "00";
                                    }
                                  } else {
                                    value += ".00";
                                  }
                                  setState(() {
                                    price = double.parse(value);
                                    priceController.text = value;
                                  });
                                }
                                StoreProvider.of<AppState>(context).dispatch(SetServiceSlotPrice(price));
                              },
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                              textInputAction: TextInputAction.done,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: BuytimeTheme.DividerGrey,
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  errorMaxLines: 2,
                                  errorStyle: TextStyle(
                                    color: BuytimeTheme.ErrorRed,
                                    fontSize: 12.0,
                                  ),
                                  suffixText: AppLocalizations.of(context).currency),
                              style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w800,
                              ),
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
                )),
          );
        });
  }
}
