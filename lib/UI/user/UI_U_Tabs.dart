import 'package:Buytime/UI/user/model/User_tab_navigation_item.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/menu/UI_menu_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UI_U_Tabs extends StatefulWidget {
  final String title = '/tabs';

  @override
  State<StatefulWidget> createState() => UI_U_TabsState();
}

class UI_U_TabsState extends State<UI_U_Tabs> {
  GlobalKey<ScaffoldState> _drawerKeyTabs = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  int _currentIndex = 0;
  bool visibleDrawer = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          visibleDrawer =
              snapshot.user != null && (snapshot.user.getRole() != Role.user) ? true : false;

          return Scaffold(
            drawerEnableOpenDragGesture: false,
            key: _drawerKeyTabs,
            appBar: BuytimeAppbar(
              children: [
                (IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                  tooltip: AppLocalizations.of(context).showMenu,
                  onPressed: () {
                    //_drawerKeyTabs.currentState.openDrawer();
                    Navigator.of(context).pop();
                  },
                )),
                kIsWeb
                    ? Image.asset('assets/img/brand/logo_appbar.png',
                    height: media.height * 0.065)
                    : SvgPicture.asset('assets/img/brand/logo_appbar.svg',
                    height: media.height * 0.065),
                Container(height: media.height * 0.07, width: media.height * 0.07)
              ],
            ),
            drawer: MenuDrawer(
              media: media,
              managerDrawer: false,
            ),
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
          );

          /*WillPopScope(
              onWillPop: () async {
                FocusScope.of(context).unfocus();
                return false;
              },
              child: )*/
        });
  }
}
