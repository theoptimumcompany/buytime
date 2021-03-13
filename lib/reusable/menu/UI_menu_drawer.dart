import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/UI/user/UI_U_Tabs.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Buytime/UI/user/login/UI_U_Home.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/globals.dart';

final GoogleSignIn googleSignIn = new GoogleSignIn();
final FacebookLogin facebookSignIn = new FacebookLogin();

class MenuDrawer extends StatelessWidget {
  const  MenuDrawer({
    Key key,
    @required this.media,
    this.managerDrawer,
  }) : super(key: key);

  final Size media;
  final bool managerDrawer;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Column(
        // Important: Remove any padding from the ListView.

        children: <Widget>[
          StoreConnector<AppState, UserState>(
              converter: (store) => store.state.user,
              builder: (context, snapshot) {
                return UserAccountsDrawerHeader(
                    accountName:
                        snapshot.name == null ? Text("") : Text(snapshot.name),
                    accountEmail: Text(snapshot.email),
                    decoration: new BoxDecoration(
                        color: managerDrawer
                            ? Color.fromRGBO(0, 103, 145, 1.0)
                            : Color.fromRGBO(1, 159, 224, 1.0),
                        borderRadius: new BorderRadius.vertical(
                          bottom: const Radius.elliptical(50, 40),
                        )),
                    currentAccountPicture: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: snapshot != null &&
                              snapshot.photo != null &&
                              !snapshot.photo.isEmpty &&
                              snapshot.photo.contains("http")
                          ? NetworkImage("${snapshot.photo}")
                          : null,
                      backgroundColor: Colors.transparent,
                    ));
              }),
          Expanded(
            flex: 4,
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (context, snapshot) {
                  return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        snapshot.user.getRole() != Role.user
                            ? ListTile(
                                title: Text(
                                  managerDrawer
                                      ? AppLocalizations.of(context).userModeShort
                                      : AppLocalizations.of(context).managerModeShort,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 20),
                                ),
                                onTap: () {
                                  StoreProvider.of<AppState>(context)
                                      .dispatch(SetBusinessListToEmpty());
                                  StoreProvider.of<AppState>(context)
                                      .dispatch(SetOrderListToEmpty());
                                  managerDrawer
                                      ? Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UI_U_Tabs()))
                                      : Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UI_M_BusinessList()),
                                        );
                                },
                              )
                            : Container(),
                        managerDrawer && snapshot.businessList.businessListState.length > 0
                            ? Divider(
                          color: Colors.grey,
                          endIndent: 10,
                          indent: 10,
                        )
                            : Container(),
                      ]));
                }),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: 200,
                  child: RaisedButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      await prefs.setBool('easy_check_in', false);
                      await prefs.setBool('star_explanation', false);
                      FirebaseAuth.instance.signOut().then((_) {
                        googleSignIn.signOut();

                        facebookSignIn.logOut();
                        //Resetto il carrello
                        //cartCounter = 0;

                        //Svuotare lo Store sul Logout
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetCategoryToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetCategoryListToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetCategoryTreeToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetOrderToEmpty(""));
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetOrderListToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetBusinessToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetBusinessListToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetServiceToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetServiceListToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetServiceSlotToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetPipelineToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetPipelineListToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetStripeToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetUserStateToEmpty());
                        //Torno al Login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      });
                    },
                    padding: EdgeInsets.all(media.width * 0.025),
                    textColor: Colors.white,
                    color: managerDrawer
                        ? Color.fromRGBO(50, 50, 100, 1.0)
                        : Color.fromRGBO(1, 159, 224, 1.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(500.0)),
                    child: Text(
                      AppLocalizations.of(context).logout,
                      style: TextStyle(
                        fontSize: 23,
                        fontFamily: BuytimeTheme.FontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
