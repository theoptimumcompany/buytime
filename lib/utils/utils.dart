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

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Buytime/environment_abstract.dart';
import 'package:Buytime/reblox/enum/order_time_intervals.dart';
import 'package:Buytime/reblox/model/area/area_list_state.dart';
import 'package:Buytime/reblox/model/area/area_state.dart';
import 'package:Buytime/reblox/model/notification/id_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/promotion/promotion_list_state.dart';
import 'package:Buytime/reblox/model/promotion/promotion_state.dart';
import 'package:Buytime/reblox/reducer/promotion/promotion_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_place/google_place.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

typedef OnTranslatingCallback = void Function(bool translated);
typedef OnPlaceDetailsCallback = void Function(List<dynamic> placeDetails);

class Utils {
  ///Image sizes
  static String imageSizing200 = "_200x200";
  static String imageSizing600 = "_600x600";
  static String imageSizing1000 = "_1000x1000";

  ///Calculate Promo Discount
  static double calculatePromoDiscount(double fullPrice, context) {
    double promoPrice = 0.0;

    debugPrint('START CALCULATE PROMO');

    if (StoreProvider.of<AppState>(context).state.promotionState != null) {
      PromotionState promotionState = StoreProvider.of<AppState>(context).state.promotionState;
      debugPrint('PROMO ' + promotionState.promotionId);
      switch (promotionState.discountType) {
        case 'fixedAmount':
          promoPrice = (promotionState.discount).toDouble();
          break;
        case 'percentageAmount':
          promoPrice = ((fullPrice * promotionState.discount)/100);
          break;
        default:
          promoPrice = 0.0;
      }
    }
    debugPrint('PROMO ' + promoPrice.toString());
    return promoPrice;
  }

  ///Check Promo Discount
  static PromotionState checkPromoDiscount(String promoName, context) {
    debugPrint('START CHECK PROMO');

    if (StoreProvider.of<AppState>(context).state.promotionListState.promotionListState.isNotEmpty && StoreProvider.of<AppState>(context).state.promotionListState != null) {
      List<PromotionState> promotionListState = StoreProvider.of<AppState>(context).state.promotionListState.promotionListState;
      for (var a = 0; a < promotionListState.length; a++) {
        if (promotionListState[a].promotionId == promoName) {
          debugPrint('PROMO NAME ' + promotionListState[a].promotionId);
          return promotionListState[a];
        }
      }
    }
    return PromotionState(promotionId: 'empty');
  }

  ///Calculate Eco
  static double calculateEcoTax(OrderState orderState) {
    double totalECO = 0;
    double partialECO = 0;
    debugPrint('TOTAL IN UTILS: ${orderState.total} - ${orderState.carbonCompensation}');
    totalECO = orderState.total;
    partialECO = (totalECO * 2.5) / 100;
    if (orderState.carbonCompensation) {
      totalECO = totalECO + partialECO;
    } else {
      totalECO = totalECO - partialECO;
    }

    return partialECO;
  }

  ///Set image
  static String sizeImage(String image, String sizing) {
    //debugPrint('UTILS => SIZE IMAGE: $image');
    if (image.isNotEmpty) {
      int lastPoint = image.lastIndexOf('.');
      String extension = image.substring(lastPoint);
      image = image.replaceAll(extension, '');
      return image + sizing + extension;
    }
    return image;
  }

  ///Custom app bar bottom part
  static Widget bottomArc = CustomPaint(
    painter: ShapesPainter(),
    child: Container(height: 20),
  );

  ///Random booking code
  static String getRandomBookingCode(int strlen) {
    var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  static String capitalize(String stringa) {
    return "${stringa[0].toUpperCase()}${stringa.substring(1)}";
  }

  ///Get business type
  static getBusinessType(dynamic businessType) {
    if (businessType != null) {
      if (businessType is List<dynamic>) {
        if (businessType.isNotEmpty) {
          return businessType.first;
        }
        return 'hub';
      } else {
        return businessType;
      }
    }
    return 'hub';
  }

  ///set business type
  static setBusinessType(dynamic businessType) {
    if (businessType != null) {
      if (businessType is List<String>) {
        if (businessType.isNotEmpty) {
          return businessType.first;
        }
        return 'hub';
      } else {
        return businessType;
      }
    }
    return 'hub';
  }

  ///Get date
  static getDate(Timestamp date) {
    if (date == null) date = Timestamp.fromDate(DateTime.now());
    return DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000).toUtc();
  }

  ///Set date
  static setDate(DateTime date) {
    return date;
  }

  static IdState stringToMap(String string) {
    IdState tmp = IdState().toEmpty();
    try {
      // debugPrint('STRING: $string');
      if (string != null) tmp = IdState.fromJson(jsonDecode(string));
    } catch (e) {
      debugPrint('ERROR: $e');
    }
    return tmp;
  }

  static String mapToString(IdState state) {
    String tmp = '';
    try {
      tmp = jsonEncode(state.toJson());
    } catch (e) {
      debugPrint('ERROR: $e');
    }
    return tmp;
  }

  ///Shimmer
  static Widget imageShimmer(double width, double heigth) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        //margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.0),
        //width: double.infinity,
        //height: double.infinity,
        width: width,

        ///SizeConfig.safeBlockVertical * widget.width
        height: heigth,

        ///SizeConfig.safeBlockVertical * widget.width,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          //color: Colors.black.withOpacity(.2)
        ),
      ),
    );
  }

  static Widget textShimmer(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          margin: EdgeInsets.all(SizeConfig.safeBlockVertical * .0),
          //width: double.infinity,
          //height: double.infinity,
          width: width,
          height: height,
          //color: Colors.black,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(1)),
            //color: Colors.black.withOpacity(.2)
          ),
          child: Text('sample'),
        ),
      ),
    );
  }

  static Widget iconShimmer(Widget icon) {
    return SizedBox(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          margin: EdgeInsets.all(SizeConfig.safeBlockVertical * .0),
          //width: double.infinity,
          //height: double.infinity,
          //color: Colors.black,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(1)),
            //color: Colors.black.withOpacity(.2)
          ),
          child: icon,
        ),
      ),
    );
  }

  ///Convert enum to string
  static String enumToString(dynamic enumToTranslate) {
    return enumToTranslate.toString().split('.').last;
  }

  ///App bar title
  static Widget barTitle(String title) {
    return Container(
      width: SizeConfig.safeBlockHorizontal * 60,
      child: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: BuytimeTheme.appbarTitle,
            ),
          )),
    );
  }

  ///Open google map
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<void> openMapWithDirections(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static String retriveField(String myLocale, String field) {
    List<String> tmpField = field.trim().split('|');
    String tmp = '';
    if (field.contains('|')) {
      tmpField.forEach((element) {
        if (element.endsWith('~\$~$myLocale')) {
          //debugPrint('retriveField => Found element: $element');
          tmp = element.split('~\$~').first;
        }
      });
      if (tmp.isEmpty) tmp = field.split('~\$~').first;
    } else {
      if (field.contains('~\$~')) {
        tmp = field.split('~\$~').first;
      } else {
        tmp = field;
      }
    }
    //debugPrint('retriveField => Found value: $tmp');
    return tmp;
  }

  static String saveField(String myLocale, String newField, String oldField) {
    debugPrint('saveField => old field: $oldField');
    debugPrint('saveField => new field: $newField');
    List<String> tmpField = oldField.trim().split('|');
    String tmp = '';
    if (oldField.contains('|')) {
      debugPrint('saveField => old field not empty');
      if (tmpField.isNotEmpty) {
        debugPrint('saveField => more languages');
        tmpField.forEach((element) {
          if (element.endsWith('~\$~$myLocale')) {
            tmp += '$newField~\$~$myLocale|';
          } else
            tmp += '${element.split('~\$~').first}~\$~${element.split('~\$~').last}|';
        });
      } else {
        debugPrint('saveField => one language');
        tmp += '$newField~\$~$myLocale|';
      }
    } else {
      debugPrint('saveField => old field empty');
      tmp += '$newField~\$~$myLocale|';
    }
    debugPrint('saveField => updated Field value: $tmp');
    tmp = tmp.substring(0, tmp.length - 1);
    debugPrint('saveField => updated Field value: $tmp');
    return tmp;
  }

  static Future<List<TextEditingController>> googleTranslate(List<String> language, String myLanguage, List<TextEditingController> controllers, List<String> flags, int myIndex) async {
    for (int i = 0; i < language.length; i++) {
      if (controllers[i].text.isEmpty) {
        if (language[i] != myLanguage) {
          debugPrint('LanguageCode: ${language[i]} | Flag: ${flags[i]}');
          var url = Uri.https('translation.googleapis.com', '/language/translate/v2', {'source': '${myLanguage}', 'target': '${language[i]}', 'key': '${Environment().config.googleApiKey}', 'q': '${controllers[myIndex].text}'});
          final http.Response response = await http.get(url, headers: {
            //HttpHeaders.contentTypeHeader : "utf-8",
            'charset': "utf-8"
          });
          debugPrint('Response code: ${response.statusCode} | Response Body: ${response.body}');
          if (response.statusCode == 200) {
            //var langResponseMap = jsonDecode(utf8.decode(response.bodyBytes));
            var langResponseMap = jsonDecode(response.body);
            //var langResponseMap = jsonDecode(Html.decode(response.bodyBytes));
            debugPrint('${language[i]} DONE | Decode: $langResponseMap');
            debugPrint('${language[i]} ${langResponseMap['data']['translations'][0]['translatedText']}');
            var unescape = HtmlUnescape();
            var text = unescape.convert(langResponseMap['data']['translations'][0]['translatedText']);
            debugPrint('Convert: $text');
            controllers[i].text = text;
          }
        }
      }
    }

    return controllers;
  }

  static OrderTimeInterval getTimeInterval(OrderReservableState orderReservableState) {
    OrderTimeInterval orderTimeIntervalResult;
    DateTime closestTimeSlot;

    /// find the service time slot closest to today
    for (int i = 0; i < orderReservableState.itemList.length; i++) {
      DateTime timeSlotToCheck = orderReservableState.itemList[i].date; // || timeSlotToCheck.difference(closestTimeSlot)
      if (closestTimeSlot == null) {
        closestTimeSlot = timeSlotToCheck;
      } else if (timeSlotToCheck.difference(closestTimeSlot).isNegative) {
        closestTimeSlot = timeSlotToCheck;
      }
    }

    /// check in which time interval the order has to be processed
    Duration nowToServiceDuration = closestTimeSlot.difference(DateTime.now());
    if (nowToServiceDuration.isNegative) {
      /// TODO: error the service performance should be already happened
      return OrderTimeInterval.directPayment;
    } else if (nowToServiceDuration.inHours <= 48) {
      // TODO: make hardcoded variables readable from the configuration (we have to create a collection "configurationPublic"
      return OrderTimeInterval.directPayment;
    } else if (nowToServiceDuration.inHours >= 48 && nowToServiceDuration.inDays <= 7) {
      return OrderTimeInterval.holdAndReminder;
    } else if (nowToServiceDuration.inDays > 7) {
      return OrderTimeInterval.reminder;
    }

    return OrderTimeInterval.directPayment;
  }

  static void multiLingualTranslate(BuildContext context, List<String> flags, List<String> language, String field, String stateField, FocusScopeNode node, OnTranslatingCallback translatingCallback) async {
    Locale myLocale = Localizations.localeOf(context);
    String myLanguage = myLocale.languageCode.substring(0, 2);
    debugPrint('Utils => My locale: ${myLanguage}');

    language.forEach((element) {
      debugPrint('Utils => locale: $element');
    });

    //FocusScopeNode node = FocusScope.of(context);
    String myLocaleCharCode = '';
    if (myLanguage == 'en')
      myLocaleCharCode = 'gb'.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'), (match) => String.fromCharCode(match.group(0).codeUnitAt(0) + 127397));
    else
      myLocaleCharCode = myLanguage.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'), (match) => String.fromCharCode(match.group(0).codeUnitAt(0) + 127397));

    List<TextEditingController> controllers = List.generate(flags.length, (index) => TextEditingController());
    int myIndex = 0;
    List<String> stateFiledList = stateField.trim().split('|');
    debugPrint('UI_M_create_service => State field list: $stateFiledList');
    //nameController.text = Utils.retriveFiled(myLanguage, snapshot.serviceState.name);
    for (int i = 0; i < flags.length; i++) {
      if (myLocaleCharCode == flags[i]) myIndex = i;
      stateFiledList.forEach((element) {
        if (element.endsWith('~\$~${language[i]}')) {
          String retrive = retriveField(language[i], stateField);
          debugPrint('Retrived value => $retrive');
          controllers[i].text = retrive;
        }
      });
    }
    bool isName = false;
    bool isDescription = false;
    bool fieldIsEqual = true;
    bool translating = true;

    if (field == AppLocalizations.of(context).name)
      isName = true;
    else if (field == AppLocalizations.of(context).description) isDescription = true;

    if (isName) {
      debugPrint('Field of the Name');
      if (retriveField(myLanguage, stateField) != retriveField(myLanguage, StoreProvider.of<AppState>(context).state.serviceState.name)) fieldIsEqual = false;
    } else if (isDescription) {
      debugPrint('Field of the Description');
      if (retriveField(myLanguage, stateField) != retriveField(myLanguage, StoreProvider.of<AppState>(context).state.serviceState.description)) fieldIsEqual = false;
    } else {
      debugPrint('Field of the condition');
      if (retriveField(myLanguage, stateField) != retriveField(myLanguage, StoreProvider.of<AppState>(context).state.serviceState.condition)) fieldIsEqual = false;
    }

    if (!fieldIsEqual) {
      debugPrint('Fields are not equal');
      for (int i = 0; i < controllers.length; i++) {
        if (i != myIndex) controllers[i].clear();
      }
    } else {
      debugPrint('Fields are equal');
    }

    controllers = await googleTranslate(language, myLanguage, controllers, flags, myIndex);

    bool allTranslated = true;
    controllers.forEach((element) {
      debugPrint('FIELDS: ${element.text}');
      if (element.text.isEmpty) allTranslated = false;
    });

    if (allTranslated) translating = false;
    debugPrint('controllers length: ${controllers.length}');

    translatingCallback(translating);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
                //top: SizeConfig.safeBlockVertical * 5,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ///Current language
                    /*Container(
                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 6, top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * .5),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Current language:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: BuytimeTheme.FontFamily,
                        color: BuytimeTheme.ManagerPrimary
                    ),
                  ),
                ),*/

                    ///Current
                    Container(
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 6, right: SizeConfig.safeBlockHorizontal * 6, top: SizeConfig.safeBlockVertical * 5, bottom: SizeConfig.safeBlockVertical * 1),
                      child: TextFormField(
                          enabled: false,
                          //initialValue: _serviceName,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: controllers.elementAt(myIndex),
                          validator: (value) => value.isEmpty ? AppLocalizations.of(context).serviceNameBlank : null,
                          onChanged: (value) {
                            //StoreProvider.of<AppState>(context).dispatch(SetServiceName(value));
                          },
                          onSaved: (value) {
                            /*if (validateAndSave()) {
                                      //_serviceName = value;
                                      StoreProvider.of<AppState>(context).dispatch(SetServiceName(value));
                                    }*/
                          },
                          onEditingComplete: () async {
                            for (int i = 0; i < controllers.length; i++) {
                              if (i != myIndex) controllers[i].clear();
                            }
                            controllers = await googleTranslate(language, myLanguage, controllers, flags, myIndex);
                          },
                          style: TextStyle(color: BuytimeTheme.TextGrey, fontFamily: BuytimeTheme.FontFamily),
                          decoration: InputDecoration(
                              //labelText: field,
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                              border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                              suffixIcon: Container(
                                height: 20,
                                width: 20,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(top: 8, right: 8),
                                child: Image(
                                  image: AssetImage('assets/img/flags/$myLocale.png'),
                                ),
                              ))),
                    ),

                    ///Translated in:
                    Container(
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 6, top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 1),
                      alignment: Alignment.topLeft,
                      child: Text(
                        AppLocalizations.of(context).translatedIn,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        height: SizeConfig.safeBlockVertical * 50,
                        margin: EdgeInsets.only(bottom: 10),
                        child: CustomScrollView(
                            //physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    String flag = flags.elementAt(index);
                                    if (myLocaleCharCode != flag)
                                      return Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 6, right: SizeConfig.safeBlockHorizontal * 6, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                        child: TextFormField(
                                            //initialValue: _serviceName,
                                            controller: controllers.elementAt(index),
                                            keyboardType: TextInputType.multiline,
                                            textInputAction: TextInputAction.done,
                                            maxLines: null,
                                            validator: (value) => value.isEmpty ? AppLocalizations.of(context).serviceNameBlank : null,
                                            onChanged: (value) {
                                              //StoreProvider.of<AppState>(context).dispatch(SetServiceName(value));
                                            },
                                            onSaved: (value) {
                                              /*if (validateAndSave()) {
                                      //_serviceName = value;
                                      StoreProvider.of<AppState>(context).dispatch(SetServiceName(value));
                                    }*/
                                            },
                                            decoration: InputDecoration(
                                                labelText: field,
                                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                suffixIcon: Container(
                                                  height: 20,
                                                  width: 20,
                                                  alignment: Alignment.centerRight,
                                                  padding: EdgeInsets.only(top: 8, right: 8),
                                                  child: Image(
                                                    image: AssetImage('assets/img/flags/${language.elementAt(index)}.png'),
                                                  ),
                                                ))),
                                      );
                                    else
                                      return Container();
                                  },
                                  childCount: flags.length,
                                ),
                              ),
                            ]),
                      ),
                    ),

                    ///Save button
                    Container(
                      margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                      width: 198,
                      height: 44,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), border: Border.all(color: BuytimeTheme.SymbolLightGrey)),
                      child: MaterialButton(
                        elevation: 0,
                        hoverElevation: 0,
                        focusElevation: 0,
                        highlightElevation: 0,
                        onPressed: () {
                          node.unfocus();
                          String serviceField = '';
                          for (int i = 0; i < controllers.length; i++) {
                            if (controllers[i].text.isNotEmpty) {
                              serviceField += controllers[i].text + '~\$~' + language[i].toString() + '|';
                            }
                          }
                          if (serviceField.isNotEmpty) {
                            serviceField = serviceField.substring(0, serviceField.length - 1);
                          }
                          debugPrint('MultiLingualTranslate => $serviceField');
                          if (isName)
                            StoreProvider.of<AppState>(context).dispatch(SetServiceName(serviceField));
                          else if (isDescription)
                            StoreProvider.of<AppState>(context).dispatch(SetServiceDescription(serviceField));
                          else
                            StoreProvider.of<AppState>(context).dispatch(SetServiceCondition(serviceField));
                          //nextPage();
                          Navigator.of(context).pop();
                        },
                        textColor: BuytimeTheme.TextWhite,
                        color: BuytimeTheme.ManagerPrimary,
                        //disabledColor: AppTheme.BackgroundGrey,
                        //padding: EdgeInsets.all(media.width * 0.03),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${AppLocalizations.of(context).accept.toUpperCase()}',
                            style: TextStyle(
                                letterSpacing: 1.25,
                                fontSize: 16,

                                ///16 | SizeConfig.safeBlockHorizontal * 4.5
                                fontFamily: BuytimeTheme.FontFamily,
                                fontWeight: FontWeight.w600,
                                color: BuytimeTheme.TextWhite),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void googleSearch(BuildContext context, OnPlaceDetailsCallback detailsCallback) {
    GooglePlace googlePlace = GooglePlace(Environment().config.googleApiKey);
    List<List<String>> predictions = [];
    List<dynamic> detailsResult = [];

    Future<List<List<String>>> autoCompleteSearch(String value) async {
      List<List<String>> tmpPredictions = [];

      ///https://maps.googleapis.com/maps/api/place/autocomplete/xml?input=Amoeba&types=establishment&location=37.76999,-122.44696&radius=500&key=YOUR_API_KEY
      // var url = Uri.https('maps.googleapis.com', '/maps/api/place/autocomplete/json', {'input': '$value','types': 'establishment', 'radius': '500', 'key': '${Environment().config.googleApiKey}'});
      var url = Uri.https('maps.googleapis.com', '/maps/api/place/autocomplete/json', {'input': '$value', 'key': '${Environment().config.googleApiKey}'});
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        //debugPrint('Place Autocomplete done => response body: ${response.body}');
        var predictResponseMap = jsonDecode(response.body)['predictions'];
        predictResponseMap.forEach((element) {
          debugPrint('PREDICT DESCRIPTION: ${element['description']}');
          debugPrint('PREDICT PLACE ID: ${element['place_id']}');
          tmpPredictions.add([element['description'], element['place_id']]);
        });
      }
      return tmpPredictions;
    }

    void getDetails(String placeId, BuildContext bootmContext) async {
      ///https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJN1t_tDeuEmsRUsoyG83frY4&fields=name,rating,formatted_phone_number&key=YOUR_API_KEY
      var url = Uri.https('maps.googleapis.com', '/maps/api/place/details/json', {'place_id': '$placeId', 'fields': 'address_components,geometry,formatted_address', 'key': '${Environment().config.googleApiKey}'});
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        //debugPrint('Place Details done => response body: ${response.body}');
        var detailsResponseMap = jsonDecode(response.body)['result'];
        debugPrint('PLACE FORMATTED ADDRESS: ${detailsResponseMap['formatted_address']}');
        debugPrint('PLACE COORDINATES: LAT: ${detailsResponseMap['geometry']['location']['lat']} | LNG: ${detailsResponseMap['geometry']['location']['lng']}');
        //debugPrint('PREDICT PLACE ID: ${element['place_id']}');
        detailsResult.add(detailsResponseMap['formatted_address']);

        ///Complete address
        detailsResult.add(detailsResponseMap['geometry']['location']['lat'].toString());

        ///Latitude
        detailsResult.add(detailsResponseMap['geometry']['location']['lng'].toString());

        ///Longitude
        detailsResult.add([]);
        detailsResponseMap['address_components'].forEach((element) {
          debugPrint('TYPES: ${element['types']}');
          debugPrint('VALUE SHORT NAME: ${element['short_name']}');
          debugPrint('VALUE LONG NAME: ${element['long_name']}');
          detailsResult.last.add([element['types'].toString(), element['short_name'], element['long_name']]);

          ///Type
        });
      }

      detailsCallback(detailsResult);
      Navigator.of(bootmContext).pop();
    }

    TextEditingController addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      builder: (BuildContext context) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                            controller: addressController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).address,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: BuytimeTheme.ManagerPrimary,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: BuytimeTheme.SymbolLightGrey,
                                  width: 1.0,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: BuytimeTheme.SymbolLightGrey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            onEditingComplete: () async {
                              currentFocus.unfocus();
                              debugPrint('Google Place API Call');
                              if (addressController.text.isNotEmpty) {
                                debugPrint('Search not empty');
                                List<List<String>> tmpPredictions = await autoCompleteSearch(addressController.text);
                                setState(() {
                                  predictions.clear();
                                  predictions = tmpPredictions;
                                });
                              } else {
                                debugPrint('Search empty');
                                if (predictions.length > 0) {
                                  predictions = [];
                                }
                              }
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        addressController.text.isNotEmpty && predictions.isNotEmpty
                            ? Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: predictions.length,
                                  itemBuilder: (context, index) {
                                    debugPrint('data found');
                                    return ListTile(
                                      leading: Icon(
                                        Icons.place,
                                        color: BuytimeTheme.ManagerPrimary,
                                      ),
                                      title: Text(predictions[index][0]),
                                      onTap: () async {
                                        debugPrint(predictions[index][1]);
                                        getDetails(predictions[index][1], context);
                                        /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                  placeId: predictions[index].placeId,
                                  googlePlace: googlePlace,
                                ),
                              ),
                            );*/
                                      },
                                    );
                                  },
                                ),
                              )
                            : Container(),
                        /*Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Image.asset("assets/powered_by_google.png"),
                ),*/
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static String translateOrderStatus(BuildContext context, String progress) {
    return progress == Utils.enumToString(OrderStatus.progress)
        ? '${AppLocalizations.of(context).progress}'
        : progress == Utils.enumToString(OrderStatus.unpaid)
            ? '${AppLocalizations.of(context).unpaid}'
            : progress == Utils.enumToString(OrderStatus.accepted)
                ? '${AppLocalizations.of(context).accepted}'
                : progress == Utils.enumToString(OrderStatus.paid)
                    ? '${AppLocalizations.of(context).paid}'
                    : progress == Utils.enumToString(OrderStatus.pending)
                        ? '${AppLocalizations.of(context).pending}'
                        : progress == Utils.enumToString(OrderStatus.created)
                            ? '${AppLocalizations.of(context).created}'
                            : progress == Utils.enumToString(OrderStatus.toBePaidAtCheckout)
                                ? '${AppLocalizations.of(context).toBePaidAtCheckout}'
                                : progress == Utils.enumToString(OrderStatus.canceled)
                                    ? '${AppLocalizations.of(context).canceled}'
                                    : progress == Utils.enumToString(OrderStatus.frozen)
                                        ? '${AppLocalizations.of(context).frozen}'
                                        : progress == Utils.enumToString(OrderStatus.declined)
                                            ? '${AppLocalizations.of(context).declined}'
                                            : progress == Utils.enumToString(OrderStatus.holding)
                                                ? '${AppLocalizations.of(context).holding}'
                                                : progress == Utils.enumToString(OrderStatus.creating)
                                                    ? '${AppLocalizations.of(context).creating}'
                                                    : '???';
  }

  static String translateOrderStatusUser(BuildContext context, String progress) {
    return progress == Utils.enumToString(OrderStatus.progress)
        ? '${AppLocalizations.of(context).pending}'
        : progress == Utils.enumToString(OrderStatus.unpaid)
            ? '${AppLocalizations.of(context).pending}'
            : progress == Utils.enumToString(OrderStatus.accepted)
                ? '${AppLocalizations.of(context).accepted}'
                : progress == Utils.enumToString(OrderStatus.paid)
                    ? '${AppLocalizations.of(context).paid}'
                    : progress == Utils.enumToString(OrderStatus.pending)
                        ? '${AppLocalizations.of(context).pending}'
                        : progress == Utils.enumToString(OrderStatus.created)
                            ? '${AppLocalizations.of(context).created}'
                            : progress == Utils.enumToString(OrderStatus.toBePaidAtCheckout)
                                ? '${AppLocalizations.of(context).accepted}'
                                : progress == Utils.enumToString(OrderStatus.canceled)
                                    ? '${AppLocalizations.of(context).canceled}'
                                    : progress == Utils.enumToString(OrderStatus.frozen)
                                        ? '${AppLocalizations.of(context).canceled}'
                                        : progress == Utils.enumToString(OrderStatus.declined)
                                            ? '${AppLocalizations.of(context).canceled}'
                                            : progress == Utils.enumToString(OrderStatus.holding)
                                                ? '${AppLocalizations.of(context).accepted}'
                                                : progress == Utils.enumToString(OrderStatus.creating)
                                                    ? '${AppLocalizations.of(context).pending}'
                                                    : '???';
  }

  static Color colorOrderStatus(BuildContext context, String progress) {
    return progress == Utils.enumToString(OrderStatus.progress)
        ? BuytimeTheme.Secondary
        : progress == Utils.enumToString(OrderStatus.unpaid)
            ? BuytimeTheme.BackgroundCerulean
            : progress == Utils.enumToString(OrderStatus.accepted)
                ? BuytimeTheme.ActionButton
                : progress == Utils.enumToString(OrderStatus.created)
                    ? BuytimeTheme.ActionButton
                    : progress == Utils.enumToString(OrderStatus.paid)
                        ? BuytimeTheme.ActionButton
                        : progress == Utils.enumToString(OrderStatus.pending)
                            ? BuytimeTheme.Secondary
                            : progress == Utils.enumToString(OrderStatus.toBePaidAtCheckout)
                                ? BuytimeTheme.Secondary
                                : progress == Utils.enumToString(OrderStatus.canceled)
                                    ? BuytimeTheme.AccentRed
                                    : progress == Utils.enumToString(OrderStatus.frozen)
                                        ? BuytimeTheme.BackgroundLightBlue
                                        : progress == Utils.enumToString(OrderStatus.declined)
                                            ? BuytimeTheme.AccentRed
                                            : progress == Utils.enumToString(OrderStatus.holding)
                                                ? BuytimeTheme.Secondary
                                                : progress == Utils.enumToString(OrderStatus.creating)
                                                    ? BuytimeTheme.Secondary
                                                    : BuytimeTheme.TextBlack;
  }

  static Color colorOrderStatusUser(BuildContext context, String progress) {
    return progress == Utils.enumToString(OrderStatus.progress)
        ? BuytimeTheme.Secondary
        : progress == Utils.enumToString(OrderStatus.unpaid)
            ? BuytimeTheme.Secondary
            : progress == Utils.enumToString(OrderStatus.accepted)
                ? BuytimeTheme.ActionButton
                : progress == Utils.enumToString(OrderStatus.created)
                    ? BuytimeTheme.Secondary
                    : progress == Utils.enumToString(OrderStatus.paid)
                        ? BuytimeTheme.ActionButton
                        : progress == Utils.enumToString(OrderStatus.pending)
                            ? BuytimeTheme.Secondary
                            : progress == Utils.enumToString(OrderStatus.toBePaidAtCheckout)
                                ? BuytimeTheme.ActionButton
                                : progress == Utils.enumToString(OrderStatus.canceled)
                                    ? BuytimeTheme.AccentRed
                                    : progress == Utils.enumToString(OrderStatus.frozen)
                                        ? BuytimeTheme.AccentRed
                                        : progress == Utils.enumToString(OrderStatus.declined)
                                            ? BuytimeTheme.AccentRed
                                            : progress == Utils.enumToString(OrderStatus.holding)
                                                ? BuytimeTheme.ActionButton
                                                : progress == Utils.enumToString(OrderStatus.creating)
                                                    ? BuytimeTheme.Secondary
                                                    : BuytimeTheme.TextBlack;
  }

  /// DISTANCE IS CALCULATED IN KM
  static double calculateDistanceBetweenPoints(String coordinatesA, String coordinatesB) {
    double lat1 = 0.0;
    double lon1 = 0.0;
    double lat2 = 0.0;
    double lon2 = 0.0;
    if (coordinatesA.isNotEmpty) {
      List<String> latLng1 = coordinatesA.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      //debugPrint('W_add_external_business_list_item => $businessState.name} | Cordinates 1: $latLng1');
      if (latLng1.length == 2) {
        lat1 = double.parse(latLng1[0]);
        lon1 = double.parse(latLng1[1]);
      }
    }
    if (coordinatesB.isNotEmpty) {
      List<String> latLng2 = coordinatesB.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      // debugPrint('W_add_external_business_list_item => ${widget.serviceState.name} | Cordinates 2: $latLng2');
      if (latLng2.length == 2) {
        lat2 = double.parse(latLng2[0]);
        lon2 = double.parse(latLng2[1]);
      }
    }
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double tmp = (12742 * asin(sqrt(a)));
    debugPrint('calculateDistanceBetweenPoints => Distance: $tmp');

    return tmp;
  }

  static String version200(String imageUrl) {
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0 && imageUrl.contains("http")) {
      extension = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_200x200" + extension;
    } else {
      result = "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }
    return result;
  }

  static String version1000(String imageUrl) {
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0 && imageUrl.contains("http")) {
      extension = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_1000x1000" + extension;
    } else {
      result = "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }
    return result;
  }

  static AreaState getCurrentArea(String userCoordinate, AreaListState areaListState) {
    AreaState areaFound = AreaState().toEmpty();
    if (userCoordinate != null && userCoordinate.isNotEmpty) {
      if (areaListState != null && areaListState.areaList != null) {
        for (int ij = 0; ij < areaListState.areaList.length; ij++) {
          var distance = Utils.calculateDistanceBetweenPoints(areaListState.areaList[ij].coordinates, userCoordinate);
          debugPrint('UI_M_edit_business: area distance ' + distance.toString());
          if (distance != null && distance < 100) {
            areaFound = areaListState.areaList[ij];
          }
        }
      }
    }
    return areaFound;
  }
}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    p.lineTo(0, 10);
    p.relativeQuadraticBezierTo(size.width / 2, 10.0, size.width, 0);
    p.lineTo(size.width, 0);
    p.close();

    canvas.drawPath(p, Paint()..color = Color(0xff006791));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
