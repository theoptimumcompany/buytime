import 'dart:async';

import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/user/landing/UI_U_Landing.dart';
import 'package:Buytime/UI/user/login/UI_U_Home.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/filter_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/booking_page_service_list_item.dart';
import 'package:Buytime/reusable/custom_bottom_button_widget.dart';
import 'package:Buytime/reusable/find_your_inspiration_card_widget.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/reusable/booking_card_widget.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {

  static String route = '/searchPage';
  bool fromConfirm;
  SearchPage({Key key, this.fromConfirm}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return  WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: BuytimeAppbar(
          background: BuytimeTheme.BackgroundCerulean,
          width: media.width,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    tooltip: AppLocalizations.of(context).comeBack,
                    onPressed: () {
                      //widget.fromConfirm != null ? Navigator.of(context).pop() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()),);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Buytime', //TODO Make it Global
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 5,
                        color: BuytimeTheme.TextWhite,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Container(
                  width: double.infinity,
                  color: BuytimeTheme.DividerGrey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}