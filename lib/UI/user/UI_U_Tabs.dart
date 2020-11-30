import 'dart:async';
import 'package:BuyTime/UI/user/model/User_tab_navigation_item.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/role/role.dart';
import 'package:BuyTime/reusable/appbar/user_buytime_appbar.dart';
import 'package:BuyTime/reusable/easy_check_in.dart';
import 'package:BuyTime/reusable/menu/UI_menu_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UI_U_Tabs extends StatefulWidget {
  final String title = 'Tabs';

  @override
  State<StatefulWidget> createState() => UI_U_TabsState();
}

class UI_U_TabsState extends State<UI_U_Tabs> {
  final TextEditingController _whereController = TextEditingController();

  GlobalKey<ScaffoldState> _drawerKeyTabs = GlobalKey();

  /* Inizializzo GPS e sull'initstate controllo se lo supporta */
  Location location = new Location();
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  bool gps = false;

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  Marker resultMarker;

  double lat = null;
  double long = null;

  /*CameraPosition _initPos = CameraPosition(
    target: LatLng(3,3),
    zoom: 14.4746,
  );*/

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      print("Easy Check :" + prefs.getBool('easy_check_in').toString());

      // if (prefs.getBool('easy_check_in') == null) {
      //   await prefs.setBool('easy_check_in', false);
      //   await showDialog(
      //     context: context,
      //     builder: (_) => EasyCheckIn(),
      //   );
      // } else if (prefs.getBool('easy_check_in') == false) {
      //   await showDialog(
      //     context: context,
      //     builder: (_) => EasyCheckIn(),
      //   );
      // }
    });
    // remote request for the list of businesses
  }

  Timer timer;
  bool up = false;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  int _currentIndex = 0;
  bool visibleDrawer = false;

  @override 
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
         visibleDrawer = snapshot.user != null && (snapshot.user.getRole() != Role.user) ? true : false;

          return WillPopScope(
              onWillPop: () async {
                if (up) {
                  up = false;
                }
                FocusScope.of(context).unfocus();
                return false;
              },
              child: Scaffold(
                key: _drawerKeyTabs,
                appBar: BuyTimeAppbarUser(
                  width: media.width,
                  height : media.height * 0.13,
                  children: [
                    (visibleDrawer
                        ? IconButton(
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            tooltip: 'Show menu',
                            onPressed: () {
                              _drawerKeyTabs.currentState.openDrawer();
                            },
                          )
                        : Container(height: media.height * 0.07, width: media.height * 0.07)),
                    kIsWeb ?
                        Image.asset('assets/img/brand/logo_appbar.png', height: media.height * 0.065) :
                        SvgPicture.asset('assets/img/brand/logo_appbar.svg', height: media.height * 0.065),
                    Container(height: media.height * 0.07, width: media.height * 0.07)
                  ],
                ),
                drawer: MenuDrawer(media: media, managerDrawer: false,),
                body: IndexedStack(
                  index: _currentIndex,
                  children: [
                    for (final tabItem in UserTabNavigationItem.items) tabItem.page,
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Color.fromRGBO(1, 159, 224, 1.0),
                  currentIndex: _currentIndex,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.black,
                  onTap: (int index) => setState(() => _currentIndex = index),
                  items: [
                    for (final tabItem in UserTabNavigationItem.items)
                      BottomNavigationBarItem(
                        icon: tabItem.icon,
                        title: tabItem.title,
                      )
                  ],
                ),
              ));
        });
  }
}
