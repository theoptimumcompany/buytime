import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reusable/appbar/manager_buytime_appbar.dart';
import 'package:Buytime/reusable/menu/UI_menu_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/Manager_tab_navigation_item.dart';

class UI_M_Tabs extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => UI_M_TabsState();
}

class UI_M_TabsState extends State<UI_M_Tabs> {

  GlobalKey<ScaffoldState> _drawerKeyTabs = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
    });
  }


  int _currentIndex = 0;
  bool visibleDrawer = false;

  @override 
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          visibleDrawer = (snapshot.user.salesman || snapshot.user.owner) ? true : false;
          return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                key: _drawerKeyTabs,
                appBar: BuytimeAppbarManager(
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
                            tooltip: AppLocalizations.of(context).showMenu,
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
                drawer: MenuDrawer(media: media,managerDrawer: true,),
                body: IndexedStack(
                  index: _currentIndex,
                  children: [
                    for (final tabItem in ManagerTabNavigationItem.items) tabItem.page,
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  backgroundColor:  Color.fromRGBO(50, 50, 100, 1.0),
                  currentIndex: _currentIndex,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.black,
                  onTap: (int index) => setState(() => _currentIndex = index),
                  items: [
                    for (final tabItem in ManagerTabNavigationItem.items)
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
