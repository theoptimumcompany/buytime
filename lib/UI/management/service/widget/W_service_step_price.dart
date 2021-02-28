import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:flutter/cupertino.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

class StepPrice extends StatefulWidget {
  Size media;
  StepPrice({this.media});

  @override
  State<StatefulWidget> createState() => StepPriceState();
}

class StepPriceState extends State<StepPrice> {

  ///Price vars
  double price = 0.0;
  GlobalKey<FormState> _formSlotPriceKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  bool validateAndSave() {
    final FormState form = _formSlotPriceKey.currentState;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool validatePrice(String value) {
    RegExp regex = RegExp(r'(^\d*\.?\d*)');
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {
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
                           // controller: priceController,
                            initialValue: snapshot.serviceSlot.price.toString(),
                            onChanged: (value) {
                              if (value == "") {
                                setState(() {
                                  price = 0.0;
                                  value = "0.0";
                                });
                              } else {
                                setState(() {
                                  price = double.parse(value);
                                });
                              }
                              validateAndSave();
                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotPrice(price));
                            },
                            onSaved: (value) {
                              if (value == "") {
                                setState(() {
                                  price = 0.0;
                                  value = "0.0";
                                });
                              } else {
                                setState(() {
                                  price = double.parse(value);
                                });
                              }
                              validateAndSave();
                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotPrice(price));
                            },
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: BuytimeTheme.DividerGrey,
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                            // validator: (value) => value.isEmpty
                            //     ? 'Service price is blank'
                            //     : validatePrice(value)
                            //     ? null
                            //     : 'Not a valid price',
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
