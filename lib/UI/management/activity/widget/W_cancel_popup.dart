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

import 'dart:ui';

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

// ignore: must_be_immutable
class CancelPop extends StatefulWidget {

  OrderState order;
  CancelPop({Key key, this.order}) : super(key: key);

  @override
  _CancelPopState createState() => _CancelPopState();
}

class _CancelPopState extends State<CancelPop> {

  String _cancellationReason = 'Overbooking';
  int _radioValue = 0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      _cancellationReason = AppLocalizations.of(context).overbooking;
      debugPrint('UI_M_activity_management => RADIO VALUE: $_radioValue');

      switch (_radioValue) {
        case 0:
          _cancellationReason = AppLocalizations.of(context).overbooking;
          break;
        case 1:
          _cancellationReason = AppLocalizations.of(context).techProblem;
          break;
        case 2:
          _cancellationReason = AppLocalizations.of(context).legalRestrict;
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 318,
        height: 230,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 2.5,
                  sigmaY: 2.5
              ),
              child: Container(
                width: 318,
                height: 230,
                decoration: BoxDecoration(
                    color: BuytimeTheme.BackgroundWhite,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ///Title
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).whyDoYou,
                                style: TextStyle(
                                    letterSpacing: 1.25,
                                    fontFamily: BuytimeTheme.FontFamily,
                                    color: BuytimeTheme.TextBlack,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16
                                  ///SizeConfig.safeBlockHorizontal * 4
                                ),
                              )
                            ],
                          ),
                        ),
                        ///Overbooking
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  AppLocalizations.of(context).overbooking, ///'Overbooking',
                                  style: TextStyle(
                                      letterSpacing: 0.25,
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextMedium,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14
                                    ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                              Container(
                                child: Radio(
                                  toggleable: true,
                                  value: 0,
                                  groupValue: _radioValue,
                                  activeColor: BuytimeTheme.ManagerPrimary,
                                  onChanged: _handleRadioValueChange,
                                ),
                              )
                            ],
                          ),
                        ),
                        ///Technical problem
                        Container(
                          margin: EdgeInsets.only(left: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  AppLocalizations.of(context).techProblem, ///'Technical problem',
                                  style: TextStyle(
                                      letterSpacing: 0.25,
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextMedium,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14
                                    ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                              Container(
                                child: Radio(
                                  toggleable: true,
                                  value: 1,
                                  groupValue: _radioValue,
                                  activeColor: BuytimeTheme.ManagerPrimary,
                                  onChanged: _handleRadioValueChange,
                                ),
                              )
                            ],
                          ),
                        ),
                        ///Legal restrictions (COVID)
                       Container(
                         margin: EdgeInsets.only(top: 0, left: 25),
                         child:  Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Container(
                               child: Text(
                                 AppLocalizations.of(context).legalRestrict, ///'Legal restrictions (COVID)',
                                 style: TextStyle(
                                     letterSpacing: 0.25,
                                     fontFamily: BuytimeTheme.FontFamily,
                                     color: BuytimeTheme.TextMedium,
                                     fontWeight: FontWeight.w400,
                                     fontSize: 14
                                   ///SizeConfig.safeBlockHorizontal * 4
                                 ),
                               ),
                             ),
                             Container(
                               child: Radio(
                                   toggleable: true,
                                   value: 2,
                                   groupValue: _radioValue,
                                   activeColor: BuytimeTheme.ManagerPrimary,
                                   onChanged: _handleRadioValueChange
                               ),
                             ),
                           ],
                         ),
                       ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ///Cancel
                            Container(
                                margin: EdgeInsets.only(right: 5, left:5, bottom: 2.5),
                                alignment: Alignment.center,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          AppLocalizations.of(context).cancel.toUpperCase(),
                                          style: TextStyle(
                                              letterSpacing: 1.25,
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: BuytimeTheme.TextMalibu,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14
                                            ///SizeConfig.safeBlockHorizontal * 4
                                          ),
                                        ),
                                      )),
                                )),
                            ///Confirm
                            Container(
                                margin: EdgeInsets.only(right: 5, left:5, bottom: 2.5),
                                alignment: Alignment.center,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        widget.order.progress = Utils.enumToString(OrderStatus.canceled);
                                        StoreProvider.of<AppState>(context).dispatch(UpdateOrderByManager(widget.order, OrderStatus.canceled, cancellationReason: _cancellationReason));
                                        Navigator.of(context).pop();
                                      },
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),
                                        child: Text(
                                          AppLocalizations.of(context).confirm.toUpperCase(),
                                          style:  TextStyle(
                                              letterSpacing: 1.25,
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: BuytimeTheme.TextMalibu,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14
                                            ///SizeConfig.safeBlockHorizontal * 4
                                          ),
                                        ),
                                      )),
                                ))
                          ],
                        )
                      ],
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

