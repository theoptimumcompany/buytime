import 'package:Buytime/UI/management/business/RUI_M_business_list.dart';
import 'package:Buytime/UI/management/business/UI_M_create_business.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/utils/utils.dart';

class PersonalInfoPark extends StatefulWidget {
  final String title = 'Personal Info';
  PersonalInfoPark({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => PersonalInfoParkState();
}

class PersonalInfoParkState extends State<PersonalInfoPark> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return false;
      },
      child: Scaffold(
         appBar: BuytimeAppbar(
            width: media.width,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Icon(Icons.chevron_left, color: BuytimeTheme.TextWhite),
                      onPressed: () {
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_BusinessList()));
                        Navigator.pushReplacement(context, EnterExitRoute(enterPage: RBusinessList(), exitPage: UI_M_CreateBusiness(), from: false));
                      }),
                ],
              ),

              ///Title
              Utils.barTitle(AppLocalizations.of(context).yourDetails),
              SizedBox(
                width: 56.0,
              )
            ],
          ),
        body: Center(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                  child: Form(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (true && value.isNotEmpty) {
                          return "test " + AppLocalizations.of(context).required;
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                      decoration: configureInputDecoration(context, AppLocalizations.of(context).name),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                  child: Form(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (true && value.isNotEmpty) {
                          return "test " + AppLocalizations.of(context).required;
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                      decoration: configureInputDecoration(context, AppLocalizations.of(context).surname),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                  child: Form(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (true && value.isNotEmpty) {
                          return "test " + AppLocalizations.of(context).required;
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                      decoration: configureInputDecoration(context, AppLocalizations.of(context).phoneNumber),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                  child: Form(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (true && value.isNotEmpty) {
                          return "test " + AppLocalizations.of(context).required;
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                      decoration: configureInputDecoration(context, AppLocalizations.of(context).salesmanName),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                  child: Form(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (true && value.isNotEmpty) {
                          return "test " + AppLocalizations.of(context).required;
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                      decoration: configureInputDecoration(context, AppLocalizations.of(context).salesmanName),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                  child: Form(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (true && value.isNotEmpty) {
                          return "test " + AppLocalizations.of(context).required;
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                      decoration: configureInputDecoration(context, AppLocalizations.of(context).salesmanName),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                  child: Form(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (true && value.isNotEmpty) {
                          return "test " + AppLocalizations.of(context).required;
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                      decoration: configureInputDecoration(context, AppLocalizations.of(context).salesmanName),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                  child: Form(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (true && value.isNotEmpty) {
                          return "test " + AppLocalizations.of(context).required;
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                      decoration: configureInputDecoration(context, AppLocalizations.of(context).salesmanName),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration configureInputDecoration(BuildContext context, String label) {
    return InputDecoration(
                      labelText: label,
                      errorStyle: TextStyle(color: BuytimeTheme.AccentRed),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.AccentRed), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    );
  }

}
