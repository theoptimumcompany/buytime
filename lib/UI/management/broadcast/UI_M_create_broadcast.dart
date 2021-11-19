import 'package:Buytime/UI/management/business/RUI_M_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/management/business/UI_M_create_business.dart';
import 'package:Buytime/UI/management/business/UI_M_manage_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/reblox/model/broadcast/broadcast_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reusable/animation/enterExitRoute.dart';
import 'package:Buytime/helper/dynamic_links/dynamic_links_helper.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/UI/management/business/widget/w_optimum_business_card_medium_manager.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/menu/w_manager_drawer.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CreateBroadcast extends StatefulWidget {
  static String route = '/createBroadcast';
  bool view;
  BroadcastState broadcastState;
  CreateBroadcast(this.view, this.broadcastState);
  @override
  State<StatefulWidget> createState() => CreateBroadcastState();
}

class CreateBroadcastState extends State<CreateBroadcast> {

  GlobalKey<ScaffoldState> _drawerKeyTabs = GlobalKey();

  bool startRequest = false;
  bool noActivity = false;
  bool generated = false;

  ///Storage
  final storage = new FlutterSecureStorage();
  emptyCategoryInvite() async{
    await storage.write(key: 'categoryInvite', value: '');
  }
  String orderId = '';
  String userId = '';


  @override
  void initState() {
    super.initState();
    emptyCategoryInvite();
    if(widget.broadcastState.senderId.isNotEmpty)
      messageController.text = widget.broadcastState.body;
    //initDynamicLinks();

  }

  TextEditingController messageController = TextEditingController();
  bool sending = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    SizeConfig().init(context);


    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _drawerKeyTabs,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.dark,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              //key: Key('business_drawer_key'),
              icon: const Icon(
                Icons.close,
                color: BuytimeTheme.TextBlack,
                //size: 30.0,
              ),
              //tooltip: AppLocalizations.of(context).showMenu,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          drawer: ManagerDrawer(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///TextFiled
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  readOnly: widget.view,
                  controller: messageController,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    //errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    //labelText: AppLocalizations.of(context).writeSomething,
                    //helperText: AppLocalizations.of(context).searchForServicesAndIdeasAroundYou,
                    hintText:AppLocalizations.of(context).writeSomething,
                    hintStyle: TextStyle(
                        color: Color(0xff666666),
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      fontFamily: BuytimeTheme.FontFamily
                    ),
                    labelStyle: TextStyle(
                      fontFamily: BuytimeTheme.FontFamily,
                      color: Color(0xff666666),
                      fontWeight: FontWeight.w400,
                    ),
                    helperStyle: TextStyle(
                      fontFamily: BuytimeTheme.FontFamily,
                      color: Color(0xff666666),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w400, fontSize: 16),
                  onEditingComplete: () {
                    debugPrint('UI_M_add_external_service_list => done');
                    FocusScope.of(context).unfocus();

                  },
                ),
              ),
              ///Button
              !widget.view ?
              Container(
                //height: double.infinity,
                //color: Colors.black87,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///Confirm button
                    Container(
                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical * 2),
                        width: 198,
                        ///media.width * .4
                        height: 44,
                        child: MaterialButton(
                          key: Key('service_reserve_key'),
                          elevation: 0,
                          hoverElevation: 0,
                          focusElevation: 0,
                          highlightElevation: 0,
                          onPressed: () async{
                            FocusScope.of(context).unfocus();
                            setState(() {
                              sending = true;
                            });
                            BroadcastState broadcastState = BroadcastState().toEmpty();
                            broadcastState.body = messageController.text;
                            broadcastState.timestamp = DateTime.now();
                            broadcastState.sendTime = DateTime.now();
                            broadcastState.sendNow = true;
                            broadcastState.topic = 'broadcast_user';
                            broadcastState.title = 'Broadcast Message';
                            broadcastState.senderId = StoreProvider.of<AppState>(context).state.user.uid;
                            await FirebaseFirestore.instance.collection("broadcast").doc().set(broadcastState.toJson()).then((value) => setState(() {
                              //debugPrint('SEND VALUE: $value');
                              sending = false;
                            }));
                            Flushbar(
                              padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
                              margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2, left: SizeConfig.blockSizeHorizontal * 20, right: SizeConfig.blockSizeHorizontal * 20),

                              ///2% - 20% - 20%
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              backgroundColor: BuytimeTheme.SymbolGrey,
                              boxShadows: [
                                BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(3, 3),
                                  blurRadius: 3,
                                ),
                              ],
                              // All of the previous Flushbars could be dismissed by swiping down
                              // now we want to swipe to the sides
                              //dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                              // The default curve is Curves.easeOut
                              duration: Duration(seconds: 2),
                              forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                              messageText: Text(
                                AppLocalizations.of(context).messageSent,
                                style: TextStyle(color: BuytimeTheme.TextWhite, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            )..show(context);
                          },
                          textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                          color: BuytimeTheme.ActionBlackPurple,
                          disabledColor: BuytimeTheme.SymbolLightGrey,
                          padding: EdgeInsets.all(media.width * 0.03),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20),
                          ),
                          child: sending ? Container(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ) : Text(
                            AppLocalizations.of(context).send,
                            style: TextStyle(
                              letterSpacing: 1.25,
                              fontSize: 14,
                              fontFamily: BuytimeTheme.FontFamily,
                              fontWeight: FontWeight.w500,
                              color: BuytimeTheme.TextWhite,
                            ),
                          ),
                        )),
                  ],
                ),
              ) : Container()
            ],
          )
      ),
    );
  }
}
