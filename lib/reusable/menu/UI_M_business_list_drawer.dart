import 'package:Buytime/UI/management/activity/RUI_M_activity_management.dart';
import 'package:Buytime/UI/management/activity/UI_M_activity_management.dart';
import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/management/notification/RUI_M_notification_center.dart';
import 'package:Buytime/UI/user/landing/UI_U_landing.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reblox/reducer/category_invite_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_detail_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Buytime/UI/user/login/UI_U_home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/globals.dart';

final GoogleSignIn googleSignIn = new GoogleSignIn();
enum DrawerSelection { BusinessList, NotificationCenter, ActivityManagement }

class UI_M_BusinessListDrawer extends StatefulWidget {
  UI_M_BusinessListDrawer({
    Key key,
    @required this.mediaz,
  }) : super(key: key);

  final Size mediaz;

  @override
  _UI_M_BusinessListDrawerState createState() => _UI_M_BusinessListDrawerState();
}

DrawerSelection drawerSelection = DrawerSelection.BusinessList;

class _UI_M_BusinessListDrawerState extends State<UI_M_BusinessListDrawer> {

  ///Storage
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    var mediaWidth = media.width;
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ///Header
              Container(
                height: 235,
                child: DrawerHeader(
                  margin: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      ///Logo
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Image.asset('assets/img/img_buytime.png', height: 40),
                        ),
                      ),

                      ///Buytime text
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            AppLocalizations.of(context).buytime,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, fontFamily: BuytimeTheme.FontFamily, letterSpacing: 0.15, color: BuytimeTheme.TextBlack),
                          ),
                        ),
                      ),

                      ///Sub text
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            AppLocalizations.of(context).enterpriseManagement,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, fontFamily: BuytimeTheme.FontFamily, letterSpacing: 0.25, color: BuytimeTheme.TextMedium),
                          ),
                        ),
                      ),

                      ///User E-Mail
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            snapshot.user.email,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12, fontFamily: BuytimeTheme.FontFamily, letterSpacing: 0.25, color: BuytimeTheme.TextMedium),
                          ),
                        ),
                      ),

                      ///User Role
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                              snapshot.user.admin ?
                                  AppLocalizations.of(context).admin :
                              snapshot.user.salesman ?
                              AppLocalizations.of(context).salesman :
                            snapshot.user.owner
                                ?  AppLocalizations.of(context).owner
                                : snapshot.user.manager
                                    ?  AppLocalizations.of(context).manager
                                    : AppLocalizations.of(context).worker
                            ,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12, fontFamily: BuytimeTheme.FontFamily, letterSpacing: 0.25, color: BuytimeTheme.TextMedium),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              ///Business List
              Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BuytimeTheme.DividerGrey))),
                child: ListTile(
                  selected: drawerSelection == DrawerSelection.BusinessList,
                  //selectedTileColor: Color.fromRGBO(32, 124, 195, 0.3),
                  autofocus: false,
                  title: Text(
                    AppLocalizations.of(context).businessList,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      fontFamily: BuytimeTheme.FontFamily,
                      letterSpacing: 0.1,
                      color: drawerSelection == DrawerSelection.BusinessList ? BuytimeTheme.ManagerPrimary : BuytimeTheme.TextBlack,
                    ),
                  ),
                  //leading: Icon(Icons.list),
                  onTap: () {
                    //Navigator.pop(context);
                    setState(() {
                      drawerSelection = DrawerSelection.BusinessList;
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_BusinessList()));
                    });
                  },
                ),
              ),
              ///Notification Center
              Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BuytimeTheme.DividerGrey))),
                child: ListTile(
                  selected: drawerSelection == DrawerSelection.NotificationCenter,
                  //selectedTileColor: Color.fromRGBO(32, 124, 195, 0.3),
                  autofocus: false,
                  title: Text(
                    AppLocalizations.of(context).notificationCenter,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      fontFamily: BuytimeTheme.FontFamily,
                      letterSpacing: 0.1,
                      color: drawerSelection == DrawerSelection.NotificationCenter ? BuytimeTheme.ManagerPrimary : BuytimeTheme.TextBlack,
                    ),
                  ),
                  //leading: Icon(Icons.list),
                  onTap: () {
                    //Navigator.pop(context);
                    setState(() {
                      drawerSelection = DrawerSelection.NotificationCenter;
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RNotificationCenter()));
                    });
                  },
                ),
              ),
              ///Activity Management
              Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BuytimeTheme.DividerGrey))),
                child: ListTile(
                  selected: drawerSelection == DrawerSelection.ActivityManagement,
                  //selectedTileColor: Color.fromRGBO(32, 124, 195, 0.3),
                  autofocus: false,
                  title: Text(
                    AppLocalizations.of(context).activityManagement,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      fontFamily: BuytimeTheme.FontFamily,
                      letterSpacing: 0.1,
                      color: drawerSelection == DrawerSelection.ActivityManagement ? BuytimeTheme.ManagerPrimary : BuytimeTheme.TextBlack,
                    ),
                  ),
                  //leading: Icon(Icons.list),
                  onTap: () {
                    //Navigator.pop(context);
                    setState(() {
                      drawerSelection = DrawerSelection.ActivityManagement;
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RActivityManagement()));
                    });
                  },
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ///Customer service
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(color: BuytimeTheme.DividerGrey),
                                //bottom: BorderSide(color: BuytimeTheme.DividerGrey)
                            )
                        ),
                        child: ListTile(
                          leading: Icon(Icons.call, color: BuytimeTheme.TextMedium, size: 24),
                          onTap: () async{
                            /*String url = StoreProvider.of<AppState>(context).state.business.phoneConcierge.isNotEmpty ?
                            StoreProvider.of<AppState>(context).state.business.phoneConcierge : BuytimeConfig.FlaviosNumber.trim();*/
                            String url = BuytimeConfig.FlaviosNumber.trim();
                            debugPrint('Restaurant phonenumber: ' + url);
                            if (await canLaunch('tel:$url')) {
                            await launch('tel:$url');
                            } else {
                            throw 'Could not launch $url';
                            }
                          },
                          title: Text(
                              AppLocalizations.of(context).speakWithCustomerService,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: BuytimeTheme.FontFamily,
                                letterSpacing: 0.1,
                                color: BuytimeTheme.TextMedium,
                              )),
                        ),
                      ),
                      ///Speak with
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: BuytimeTheme.DividerGrey),
                              //bottom: BorderSide(color: BuytimeTheme.DividerGrey)
                            )
                        ),
                        child: ListTile(
                          leading: Icon(Icons.call, color: BuytimeTheme.TextMedium, size: 24),
                          onTap: () async{
                            String url = StoreProvider.of<AppState>(context).state.business.phoneSalesman.isNotEmpty ?
                            StoreProvider.of<AppState>(context).state.business.phoneSalesman : BuytimeConfig.FlaviosNumber.trim();
                            //String url = BuytimeConfig.FlaviosNumber.trim();
                            debugPrint('Restaurant phonenumber: ' + url);
                            if (await canLaunch('tel:$url')) {
                              await launch('tel:$url');
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          title: Text(
                              '${AppLocalizations.of(context).speakWith} ${StoreProvider.of<AppState>(context).state.business.salesmanName}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: BuytimeTheme.FontFamily,
                                letterSpacing: 0.1,
                                color: BuytimeTheme.TextMedium,
                              )),
                        ),
                      ),
                      ///Client mode
                      Container(
                        decoration: BoxDecoration(border: Border(top: BorderSide(color: BuytimeTheme.DividerGrey), bottom: BorderSide(color: BuytimeTheme.DividerGrey))),
                        child: ListTile(
                          leading: Icon(Icons.emoji_emotions_outlined, color: BuytimeTheme.TextMedium, size: 24),
                          onTap: () {
                            /*StoreProvider.of<AppState>(context)
                              .dispatch(SetBusinessListToEmpty());
                          StoreProvider.of<AppState>(context)
                              .dispatch(SetOrderListToEmpty());*/
                            switchToClient = true;
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()));
                          },
                          title: Text(AppLocalizations.of(context).clientMode,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: BuytimeTheme.FontFamily,
                                letterSpacing: 0.1,
                                color: BuytimeTheme.TextMedium,
                              )),
                        ),
                      ),

                      ///Settings
                      ListTile(
                        leading: Icon(Icons.settings, color: BuytimeTheme.TextMedium, size: 24),
                        onTap: () {},
                        title: Text(AppLocalizations.of(context).userSettings,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontFamily: BuytimeTheme.FontFamily,
                              letterSpacing: 0.1,
                              color: BuytimeTheme.TextMedium,
                            )),
                      ),

                      ///Log out
                      ListTile(
                        leading: Icon(Icons.logout, color: BuytimeTheme.TextMedium, size: 24),
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await storage.write(key: 'bookingCode', value: '');
                          FirebaseAuth.instance.signOut().then((_) {
                            googleSignIn.signOut();
                            //Resetto il carrello
                            //cartCounter = 0;
                            //Svuotare lo Store sul Logout
                            StoreProvider.of<AppState>(context).dispatch(SetServiceToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetBookingToEmpty(''));
                            StoreProvider.of<AppState>(context).dispatch(SetBookingListToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetBusinessListToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetCategoryListToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetCategoryToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetBusinessToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetCategoryTreeToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetOrderListToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetOrderToEmpty(''));
                            StoreProvider.of<AppState>(context).dispatch(SetPipelineListToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetPipelineToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetServiceListToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetServiceSlotToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetStripeToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetUserStateToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetOrderReservableToEmpty(''));
                            StoreProvider.of<AppState>(context).dispatch(SetCategoryInviteToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetExternalBusinessListToEmpty());
                            StoreProvider.of<AppState>(context).dispatch(SetOrderDetailToEmpty(''));
                            StoreProvider.of<AppState>(context).dispatch(SetOrderReservableListToEmpty());
                            //Torno al Login
                            drawerSelection = DrawerSelection.BusinessList;
                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);
                            Navigator.of(context).pushReplacementNamed(Home.route);
                          });
                        },
                        title: Text(AppLocalizations.of(context).logout,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontFamily: BuytimeTheme.FontFamily,
                              letterSpacing: 0.1,
                              color: BuytimeTheme.TextMedium,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
