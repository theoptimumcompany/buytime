import 'dart:convert';
import 'dart:math';

import 'package:Buytime/reblox/enum/order_time_intervals.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/app_state.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart'as http;

typedef OnTranslatingCallback = void Function(bool translated);
class Utils {

  ///Image sizes
  static String imageSizing200 =  "_200x200";
  static String imageSizing600 =  "_600x600";
  static String imageSizing1000 =  "_1000x1000";

  ///Set image
  static String sizeImage(String image, String sizing) {
    int lastPoint = image.lastIndexOf('.');
    String extension = image.substring(lastPoint);
    image = image.replaceAll(extension, '');
    return image + sizing + extension;
  }

  ///Custom app bar bottom part
  static Widget bottomArc = CustomPaint(
    painter: ShapesPainter(),
    child: Container(height: 20),
  );

  ///Random booking code
  static String getRandomBookingCode(int strlen) {
    var chars       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  ///Get date
  static getDate(Timestamp date){
    if(date == null)
      date = Timestamp.fromDate(DateTime.now());
    return DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000).toUtc();
  }

  ///Set date
  static setDate(DateTime date){
    return date;
  }

  ///Convert enum to string
  static String enumToString(dynamic enumToTranslate){
    return enumToTranslate.toString().split('.').last;
  }

  ///App bar title
  static Widget barTitle(String title){
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
          )
      ),
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

  static String retriveField(String myLocale, String field){
    List<String> tmpField = field.split('|');
    String tmp = '';
    if(field.contains('|')){
      tmpField.forEach((element) {
        if(element.endsWith('~\$~$myLocale')){
          //debugPrint('retriveField => Found element: $element');
          tmp = element.split('~\$~').first;
        }
      });
      if(tmp.isEmpty)
        tmp = field.split('~\$~').first;
    }else{
       if(field.contains('~\$~')){
         tmp = field.split('~\$~').first;
       }else{
         tmp = field;
       }
    }
    //debugPrint('retriveField => Found value: $tmp');
    return tmp;
  }
  static String saveField(String myLocale, String newField, String oldField){
    debugPrint('saveField => old field: $oldField');
    debugPrint('saveField => new field: $newField');
    List<String> tmpField = oldField.split('|');
    String tmp = '';
    if(oldField.contains('|')){
      debugPrint('saveField => old field not empty');
      if(tmpField.isNotEmpty){
        debugPrint('saveField => more languages');
        tmpField.forEach((element) {
          if(element.endsWith('~\$~$myLocale')){
            tmp += '$newField~\$~$myLocale|';
          }else
            tmp += '${element.split('~\$~').first}~\$~${element.split('~\$~').last}|';
        });
      }else{
        debugPrint('saveField => one language');
        tmp += '$newField~\$~$myLocale|';
      }
    }else{
      debugPrint('saveField => old field empty');
      tmp += '$newField~\$~$myLocale|';
    }
    tmp = tmp.substring(0, tmp.length - 1);
    debugPrint('saveField => updated Field value: $tmp');
    return tmp;
  }

  static Future<List<TextEditingController>> googleTranslate(List<String> language, Locale myLocale, List<TextEditingController> controllers, List<String> flags, int myIndex) async {
    for (int i = 0; i < language.length; i++) {
      if (controllers[i].text.isEmpty) {
        if (language[i] != myLocale.languageCode) {
          debugPrint('LanguageCode: ${language[i]} | Flag: ${flags[i]}');
          var url = Uri.https('translation.googleapis.com', '/language/translate/v2', {
            'source': '${myLocale.languageCode}',
            'target': '${language[i]}',
            'key': '${BuytimeConfig.AndroidApiKey}',
            'q': '${controllers[myIndex].text}'
          });
          final http.Response response = await http.get(url);
          //debugPrint('Response code: ${response.statusCode} | Response Body: ${response.body}');
          if (response.statusCode == 200) {
            var langResponseMap = jsonDecode(response.body);
            debugPrint('${language[i]} DONE | Decode: $langResponseMap');
            debugPrint('${language[i]} ${langResponseMap['data']['translations'][0]['translatedText']}');
            controllers[i].text = langResponseMap['data']['translations'][0]['translatedText'];
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
      } else if (timeSlotToCheck.difference(closestTimeSlot).isNegative){
        closestTimeSlot = timeSlotToCheck;
      }
    }
    /// check in which time interval the order has to be processed
    Duration nowToServiceDuration = closestTimeSlot.difference(DateTime.now());
    if (nowToServiceDuration.isNegative) {
      /// TODO: error the service performance should be already happened
    } else if (nowToServiceDuration.inHours <= 48) { // TODO: make hardcoded variables readable from the configuration (we have to create a collection "configurationPublic"
      return OrderTimeInterval.directPayment;
    } else if (nowToServiceDuration.inHours >= 48 && nowToServiceDuration.inDays <= 7) {
      return OrderTimeInterval.holdAndReminder;
    } else if (nowToServiceDuration.inDays > 7) {
      return OrderTimeInterval.reminder;
    }
  }

  static void multiLingualTranslate(BuildContext context, List<String> flags, List<String> language, String field, String stateField, FocusScopeNode node, OnTranslatingCallback translatingCallback) async{

    Locale myLocale = Localizations.localeOf(context);
    debugPrint('UI_M_create_service => My locale: ${myLocale.languageCode}');

    //FocusScopeNode node = FocusScope.of(context);
    String myLocaleCharCode = '';
    if(myLocale.languageCode == 'en')
      myLocaleCharCode = 'gb'.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'), (match) => String.fromCharCode(match.group(0).codeUnitAt(0) + 127397));
    else
      myLocaleCharCode = myLocale.languageCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'), (match) => String.fromCharCode(match.group(0).codeUnitAt(0) + 127397));

    List<TextEditingController> controllers = List.generate(flags.length, (index) => TextEditingController());
    int myIndex = 0;
    List<String> stateFiledList = stateField.split('|');
    debugPrint('UI_M_create_service => State field list: $stateFiledList');
    //nameController.text = Utils.retriveFiled(myLocale.languageCode, snapshot.serviceState.name);
    for(int i = 0; i < flags.length; i++){
      if(myLocaleCharCode == flags[i])
        myIndex = i;
      stateFiledList.forEach((element) {
        if(element.endsWith('~\$~${language[i]}')){
          String retrive = retriveField(language[i], stateField);
          debugPrint('Retrived value => $retrive');
          controllers[i].text = retrive;
        }
      });
    }
    bool isName = false;
    bool fieldIsEqual = true;
    bool translating = true;

    if(field == 'Name')
      isName = true;

    if(isName){
      debugPrint('Field of the Name');
      if(retriveField(myLocale.languageCode, stateField) != retriveField(myLocale.languageCode, StoreProvider.of<AppState>(context).state.serviceState.name))
        fieldIsEqual = false;
    }else{
      debugPrint('Field of the Description');
      if(retriveField(myLocale.languageCode, stateField) != retriveField(myLocale.languageCode, StoreProvider.of<AppState>(context).state.serviceState.description))
        fieldIsEqual = false;
    }

    if(!fieldIsEqual){
      debugPrint('Fields are not equal');
      for(int i = 0; i < controllers.length; i++){
        if(i != myIndex)
          controllers[i].clear();
      }
    }else{
      debugPrint('Fields are equal');
    }

    controllers = await googleTranslate(language, myLocale, controllers, flags, myIndex);

    bool allTranslated = true;
    controllers.forEach((element) {
      debugPrint('FIELDS: ${element.text}');
      if(element.text.isEmpty)
        allTranslated = false;
    });

    if(allTranslated)
      translating = false;
    debugPrint('controllers length: ${controllers.length}');

    translatingCallback(translating);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10)
          )
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)
                )
            ),
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
                      onEditingComplete: ()async{
                        for(int i = 0; i < controllers.length; i++){
                          if(i != myIndex)
                            controllers[i].clear();
                        }
                        controllers = await googleTranslate(language, myLocale, controllers, flags, myIndex);
                      },
                      style: TextStyle(
                        color: BuytimeTheme.TextGrey,
                        fontFamily: BuytimeTheme.FontFamily
                      ),
                      decoration: InputDecoration(
                          //labelText: field,
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                          suffixIcon: Container(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              '${Emoji.byChar(myLocaleCharCode)}',
                              style: TextStyle(
                                  fontSize: 24
                              ),
                            ),
                          )
                      )),
                ),
                ///Translated in:
                Container(
                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 6, top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 1),
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppLocalizations.of(context).translatedIn,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: BuytimeTheme.FontFamily,
                        color: BuytimeTheme.TextBlack
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: CustomScrollView(shrinkWrap: true, slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          String flag = flags.elementAt(index);
                          if(myLocaleCharCode != flag)
                            return Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 6, right: SizeConfig.safeBlockHorizontal * 6, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                              child: TextFormField(
                                //initialValue: _serviceName,
                                  controller: controllers.elementAt(index),
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
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          '${Emoji.byChar(flag)}',
                                          style: TextStyle(
                                              fontSize: 24
                                          ),
                                        ),
                                      )
                                  )),
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                          color: BuytimeTheme.SymbolLightGrey
                      )
                  ),
                  child: MaterialButton(
                    elevation: 0,
                    hoverElevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    onPressed:(){
                      node.unfocus();
                      String serviceField = '';
                      for(int i = 0; i < controllers.length; i++) {
                        if (controllers[i].text.isNotEmpty) {
                          serviceField += controllers[i].text + '~\$~' + language[i].toString() + '|';
                        }
                      }
                      if(serviceField.isNotEmpty){
                        serviceField = serviceField.substring(0, serviceField.length - 1);
                      }
                      debugPrint('MultiLingualTranslate => $serviceField');
                      if(field == 'Name')
                        StoreProvider.of<AppState>(context).dispatch(SetServiceName(serviceField));
                      else
                        StoreProvider.of<AppState>(context).dispatch(SetServiceDescription(serviceField));
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
                            color: BuytimeTheme.TextWhite
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );

      },
    );
  }

  static void googleSearch(BuildContext context){
    GooglePlace googlePlace = GooglePlace(BuytimeConfig.AndroidApiKey);
    List<AutocompletePrediction> predictions = [];

    void autoCompleteSearch(String value) async {
      var result = await googlePlace.autocomplete.get(value);
      if (result != null && result.predictions != null) {
        predictions = result.predictions;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10)
          )
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            margin: EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
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
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      autoCompleteSearch(value);
                    } else {
                      if (predictions.length > 0) {
                        predictions = [];
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(predictions[index].description),
                        onTap: () {
                          debugPrint(predictions[index].placeId);
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
                ),
                /*Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Image.asset("assets/powered_by_google.png"),
                ),*/
              ],
            ),
          ),
        );

      },
    );
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
