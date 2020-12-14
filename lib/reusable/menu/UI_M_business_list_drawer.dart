import 'package:BuyTime/UI/management/business/UI_M_business_list.dart';
import 'package:BuyTime/UI/user/UI_U_Tabs.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/user/user_state.dart';
import 'package:BuyTime/reblox/reducer/business_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/business_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_snippet_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_snippet_reducer.dart';
import 'package:BuyTime/reblox/reducer/filter_reducer.dart';
import 'package:BuyTime/reblox/reducer/order_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/order_reducer.dart';
import 'package:BuyTime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/pipeline_reducer.dart';
import 'package:BuyTime/reblox/reducer/service_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/service_reducer.dart';
import 'package:BuyTime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:BuyTime/reblox/reducer/user_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BuyTime/UI/user/login/UI_U_Home.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/globals.dart';

final GoogleSignIn googleSignIn = new GoogleSignIn();
final FacebookLogin facebookSignIn = new FacebookLogin();
enum DrawerSelection {
  BusinessList,
}

class UI_M_BusinessListDrawer extends StatefulWidget {
  UI_M_BusinessListDrawer({
    Key key,
    @required this.mediaz,
  }) : super(key: key);

  final Size mediaz;

  @override
  _UI_M_BusinessListDrawerState createState() =>
      _UI_M_BusinessListDrawerState();
}

class _UI_M_BusinessListDrawerState extends State<UI_M_BusinessListDrawer> {
  DrawerSelection _drawerSelection = DrawerSelection.BusinessList;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    var mediaWidth = media.width;
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: mediaHeight * 0.3,
            child: DrawerHeader(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.transparent, style: BorderStyle.none),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset('assets/img/img_buytime.png',
                          height: mediaHeight * 0.08),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Buytime",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: mediaHeight * 0.03,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        "Enterprise Management",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: mediaHeight * 0.025,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            selected: _drawerSelection == DrawerSelection.BusinessList,
            selectedTileColor: Color.fromRGBO(32, 124, 195, 0.3),
            autofocus: false,
            title: Text(
              "Business List",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: mediaHeight * 0.025,
              ),
            ),
            leading: Icon(Icons.list),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _drawerSelection = DrawerSelection.BusinessList;
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UI_M_BusinessList()));
              });
            },
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ListTile(
                    leading: Icon(Icons.emoji_emotions_outlined,
                        color: Colors.black.withOpacity(0.6), size: 30),
                    onTap: () {
                      StoreProvider.of<AppState>(context)
                          .dispatch(SetBusinessListToEmpty());
                      StoreProvider.of<AppState>(context)
                          .dispatch(SetOrderListToEmpty());
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => UI_U_Tabs()));
                    },
                    title: Text('Switch to client mode',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: mediaHeight * 0.025,
                        )),
                  ),
                  Divider(
                    color: Colors.grey,
                    endIndent: 10,
                    indent: 10,
                  ),
                  ListTile(
                    leading: Icon(Icons.settings,
                        color: Colors.black.withOpacity(0.6), size: 30),
                    onTap: () {},
                    title: Text('User Settings',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: mediaHeight * 0.025,
                        )),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout,
                        color: Colors.black.withOpacity(0.6), size: 30),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      await prefs.setBool('easy_check_in', false);
                      await prefs.setBool('star_explanation', false);
                      FirebaseAuth.instance.signOut().then((_) {
                        googleSignIn.signOut();

                        facebookSignIn.logOut();
                        //Resetto il carrello
                        cartCounter = 0;

                        //Svuotare lo Store sul Logout
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetCategoryToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetCategoryListToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetCategorySnippetToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetCategorySnippetListToEmpty());
                        StoreProvider.of<AppState>(context)
                            .dispatch(SetFilterToEmpty());
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
                    title: Text('Logout',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: mediaHeight * 0.025,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
