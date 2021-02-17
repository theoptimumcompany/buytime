import 'dart:async';

import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/user/landing/UI_U_Landing.dart';
import 'package:Buytime/UI/user/login/UI_U_Home.dart';
import 'package:Buytime/UI/user/search/UI_U_SearchPage.dart';
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

class BookingPage extends StatefulWidget {

  static String route = '/bookingPage';
  bool fromConfirm;
  BookingPage({Key key, this.fromConfirm}) : super(key: key);
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {

  TextEditingController _searchController = TextEditingController();

  BookingState bookingState;
  BusinessState businessState;
  ServiceListState serviceListState;
  List<ServiceState> serviceList = [];
  CategoryListState categoryListState;
  List<CategoryState> categoryList = [];

  bool sameMonth = false;

  @override
  void initState() {
    super.initState();
  }

  String version1000(String imageUrl) {
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0 && imageUrl.contains("http")) {
      extension = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_1000x1000" + extension;
    }else {
      result = "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }
    return result;
  }

  List<String> titles = ['Log out']; //TODO Make it Global
  String _selected = '';
  bool isManagerOrAbove = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, snapshot) {

        bookingState = snapshot.booking;
        businessState = snapshot.business;
        serviceListState = snapshot.serviceList;
        serviceList = serviceListState.serviceListState;
        categoryListState = snapshot.categoryList;
        categoryList = categoryListState.categoryListState;

        //debugPrint('UI_U_BookingPage: business logo => ${businessState.logo}');
        //debugPrint('UI_U_BookingPage: service list lenght => ${serviceList.length}');
        String startMonth = DateFormat('MM').format(bookingState.start_date);
        String endMonth = DateFormat('MM').format(bookingState.end_date);

        if(startMonth == endMonth)
          sameMonth = true;
        else
          sameMonth = false;


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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  child: PopupMenuButton(
                    icon: Icon(
                      Icons.settings,
                      color: BuytimeTheme.TextWhite,
                      size: 30.0,
                    ),
                    elevation: 3.2,
                    initialValue: _selected,
                    onCanceled: () {
                      print('You have not chossed anything');
                    },
                    onSelected:(String title) async{
                      setState(() {
                        _selected = title;
                      });
                      if(title == 'Log out') { //TODO Make it Global
                        SharedPreferences prefs = await SharedPreferences.getInstance();

                        await prefs.setBool('easy_check_in', false);
                        await prefs.setBool('star_explanation', false);
                        FirebaseAuth.instance.signOut().then((_) {
                          googleSignIn.signOut();

                          facebookSignIn.logOut();
                          //Resetto il carrello
                          cartCounter = 0;

                          //Svuotare lo Store sul Logout
                          StoreProvider.of<AppState>(context).dispatch(SetCategoryToEmpty());
                          StoreProvider.of<AppState>(context).dispatch(SetCategoryListToEmpty());
                          StoreProvider.of<AppState>(context).dispatch(SetCategoryTreeToEmpty());
                          StoreProvider.of<AppState>(context).dispatch(SetFilterToEmpty());
                          StoreProvider.of<AppState>(context).dispatch(SetOrderToEmpty(""));
                          StoreProvider.of<AppState>(context).dispatch(SetOrderListToEmpty());
                          StoreProvider.of<AppState>(context).dispatch(SetBusinessToEmpty());
                          StoreProvider.of<AppState>(context).dispatch(SetBusinessListToEmpty());
                          StoreProvider.of<AppState>(context).dispatch(SetServiceToEmpty());
                          StoreProvider.of<AppState>(context).dispatch(SetServiceListToEmpty());
                          StoreProvider.of<AppState>(context).dispatch(SetPipelineToEmpty());
                          StoreProvider.of<AppState>(context).dispatch(SetPipelineListToEmpty());
                          StoreProvider.of<AppState>(context).dispatch(SetStripeToEmpty());
                          StoreProvider.of<AppState>(context).dispatch(SetUserStateToEmpty());
                          //Torno al Login
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return titles.map((String title) {
                        return PopupMenuItem(
                          value: title,
                          child: Text(title),
                        );
                      }).toList();
                    },
                  ),
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
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///Business Logo
                          Container(
                            //margin: EdgeInsets.only(left: SizeConfig.safeBlockVertical * 1, right: SizeConfig.safeBlockHorizontal * 1),
                            width: SizeConfig.safeBlockVertical * 20, ///25%
                            height: SizeConfig.safeBlockVertical * 20, ///25%
                            decoration: BoxDecoration(
                              color: Color(0xffE6E7E8),
                              /*borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                          border: Border.all(
                              color: Color(0xffA694C6),
                              width: 4
                          ),*/
                            ),
                            child: CachedNetworkImage(
                              imageUrl: businessState.logo,
                              imageBuilder: (context, imageProvider) => Container(
                                //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                                decoration: BoxDecoration(
                                  //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                          ///Greetings & Portfolio
                          Container(
                            height: SizeConfig.safeBlockVertical * 18,
                            width: double.infinity,
                            color: BuytimeTheme.BackgroundWhite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///Greetings
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                                  child: Text(
                                    'Hi ${bookingState.user.first.name}', //TODO Make it Global
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextBlack,
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizeConfig.safeBlockHorizontal * 7
                                    ),
                                  ),
                                ),
                                ///Portfolio
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                  child: Text(
                                    'Your holiday in Portoferraio', //TODO Make it Global
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                ),
                                ///Date
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 0.5),
                                  child: Text(
                                    sameMonth ? '${DateFormat('dd').format(bookingState.start_date)}-${DateFormat('dd MMMM').format(bookingState.end_date)}' : '${DateFormat('dd MMMM').format(bookingState.start_date)}',
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ///Top Service
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                              padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                              color: BuytimeTheme.BackgroundWhite,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///Top Services
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                    child: Text(
                                      'Top Services', //TODO Make it Global
                                      style: TextStyle(
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextDark,
                                          fontWeight: FontWeight.bold,
                                          fontSize: SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                  serviceList.isNotEmpty ? CustomScrollView(shrinkWrap: true, slivers: [
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate((context, index) {
                                        //MenuItemModel menuItem = menuItems.elementAt(index);
                                        ServiceState service = serviceList.elementAt(index);

                                        return BookingListServiceListItem(service);
                                      },
                                        childCount: serviceList.length > 5 ? serviceList.getRange(0, 5).length : serviceList.length,
                                      ),
                                    ),
                                  ]) : Container(
                                    height: SizeConfig.safeBlockVertical * 8,
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                    decoration: BoxDecoration(
                                        color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Center(
                                        child: Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                          alignment: Alignment.centerLeft,
                                          child:  Text(
                                            'No active service found', //TODO Make it Global
                                            style: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextGrey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16
                                            ),
                                          ),
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          ///Search & Contact
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                              //height: SizeConfig.safeBlockVertical * 28,
                              width: double.infinity,
                              color: BuytimeTheme.BackgroundWhite,
                              child: Column(
                                children: [
                                  ///Search
                                  Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
                                    height: SizeConfig.safeBlockHorizontal * 20,
                                    child: TextFormField(
                                      controller: _searchController,
                                      textAlign: TextAlign.start,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color(0xff666666)),
                                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                                        ),
                                        errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.redAccent),
                                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                                        ),
                                        labelText: 'What are you looking for?', //TODO Make it Global
                                        helperText: 'Search for services and ideas around you', //TODO Make it Global
                                        //hintText: "email *",
                                        //hintStyle: TextStyle(color: Color(0xff666666)),
                                        labelStyle: TextStyle(
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: Color(0xff666666),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        helperStyle:  TextStyle(
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: Color(0xff666666),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        suffixIcon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          Icons.search,
                                          color: Color(0xff666666),
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: Color(0xff666666),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onEditingComplete: (){
                                        debugPrint('done');
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
                                      },
                                    ),
                                  ),
                                  ///Contact
                                  Container(
                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(50))
                                      ),
                                      child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            onTap: () async {
                                              String url = businessState.phone_number;
                                              debugPrint('Restaurant phonenumber: ' + url); //TODO Make it Global
                                              if (await canLaunch('tel:$url')) {
                                                await launch('tel:$url');
                                              } else {
                                                throw 'Could not launch $url';
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 2),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  ///Text
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          'Speak with ${businessState.responsible_person_name}', //TODO Make it Global
                                                          style: TextStyle(
                                                              fontFamily: BuytimeTheme.FontFamily,
                                                              color: BuytimeTheme.TextBlack,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: SizeConfig.safeBlockHorizontal * 4
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                                        child: Text(
                                                          'your dedicated advisor', //TODO Make it Global
                                                          style: TextStyle(
                                                              fontFamily: BuytimeTheme.FontFamily,
                                                              color: BuytimeTheme.TextGrey,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: SizeConfig.safeBlockHorizontal * 4
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  ///Icon
                                                  Icon(
                                                    Icons.call,
                                                    color: BuytimeTheme.ActionButton,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      )
                                  )
                                ],
                              ),
                            ),
                          ),
                          ///Inspiration
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                              padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1),
                              color: BuytimeTheme.BackgroundWhite,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///Inspiration
                                  /*Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                    child: Text(
                                      'Find your inspiration here', //TODO Make it Global
                                      style: TextStyle(
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextDark,
                                          fontWeight: FontWeight.bold,
                                          fontSize: SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2, right: SizeConfig.safeBlockHorizontal * 2),
                                    height: SizeConfig.safeBlockVertical * 50,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
                                                  //width: double.infinity,
                                                  //height: double.infinity,
                                                  width: SizeConfig.safeBlockVertical * 18,
                                                  height: SizeConfig.safeBlockVertical * 18,
                                                  color: BuytimeTheme.AccentRed,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
                                                  //width: double.infinity,
                                                  //height: double.infinity,
                                                  width: SizeConfig.safeBlockVertical * 18,
                                                  height: SizeConfig.safeBlockVertical * 18,
                                                  color: BuytimeTheme.Secondary,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
                                                  //width: double.infinity,
                                                  //height: double.infinity,
                                                  width: SizeConfig.safeBlockVertical * 18,
                                                  height: SizeConfig.safeBlockVertical * 18,
                                                  color: BuytimeTheme.ManagerPrimary,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
                                                  //width: double.infinity,
                                                  //height: double.infinity,
                                                  width: SizeConfig.safeBlockVertical * 28,
                                                  height: SizeConfig.safeBlockVertical * 28,
                                                  color: BuytimeTheme.BackgroundLightBlue,
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
                                                  //width: double.infinity,
                                                  //height: double.infinity,
                                                  width: SizeConfig.safeBlockVertical * 28,
                                                  height: SizeConfig.safeBlockVertical * 28,
                                                  color: BuytimeTheme.TextPurple,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )*/
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                    child: Text(
                                      'Find your inspiration here', //TODO Make it Global
                                      style: TextStyle(
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextDark,
                                          fontWeight: FontWeight.bold,
                                          fontSize: SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                  categoryList.isNotEmpty ? Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2, right: SizeConfig.safeBlockHorizontal * 2),
                                    //height: SizeConfig.safeBlockVertical * 50,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            ///First showcase
                                            Flexible(
                                              flex: 1,
                                              child: FindYourInspirationCardWidget(
                                                  18,18, categoryList[0].categoryImage, categoryList[0].name
                                              ),
                                            ),
                                            ///Second showcase
                                            categoryList.length >= 2 ? Flexible(
                                              flex: 1,
                                              child: FindYourInspirationCardWidget(
                                                  18,18, categoryList[1].categoryImage, categoryList[1].name
                                              ),
                                            ) : Container(),
                                            ///third showcase
                                            categoryList.length >= 3 ? Flexible(
                                              flex: 1,
                                              child: FindYourInspirationCardWidget(
                                                  18,18, categoryList[2].categoryImage, categoryList[2].name
                                              ),
                                            ) : Container()
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ///Fourth showcase
                                            categoryList.length >= 4 ? Flexible(
                                              flex: 1,
                                              child: FindYourInspirationCardWidget(
                                                  28,28, categoryList[3].categoryImage, categoryList[3].name
                                              ),
                                            ) : Container(),
                                            ///Fifth showcase
                                            categoryList.length == 5 ? Flexible(
                                              flex: 1,
                                              child: FindYourInspirationCardWidget(
                                                  28,28, categoryList[4].categoryImage, categoryList[4].name
                                              ),
                                            ) : Container(),
                                          ],
                                        )
                                      ],
                                    ),
                                  ) :
                                  Container(
                                    height: SizeConfig.safeBlockVertical * 8,
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                    decoration: BoxDecoration(
                                        color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Center(
                                        child: Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                          alignment: Alignment.centerLeft,
                                          child:  Text(
                                            'No active service found',
                                            style: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextGrey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16
                                            ),
                                          ),
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          StoreConnector<AppState, AppState>(
                              converter: (store) => store.state,
                              builder: (context, snapshot) {
                                isManagerOrAbove = snapshot.user != null && (snapshot.user.getRole() != Role.user) ? true : false;
                                return isManagerOrAbove ? Flexible(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.white,
                                    height: 60,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () async {
                                          StoreProvider.of<AppState>(context).dispatch(SetBusinessListToEmpty());
                                          StoreProvider.of<AppState>(context).dispatch(SetOrderListToEmpty());
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UI_M_BusinessList()),
                                          );
                                        },
                                        child: CustomBottomButtonWidget(
                                            Text(
                                              AppLocalizations.of(context).goToBusiness,
                                              style: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: Colors.black.withOpacity(.7),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16
                                              ),
                                            ),
                                            '',
                                            Icon(
                                              Icons.business_center,
                                              color: BuytimeTheme.SymbolGrey,
                                            )),
                                      ),
                                    ),
                                  ),
                                ): Container();
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}