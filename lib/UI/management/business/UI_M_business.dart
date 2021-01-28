import 'package:Buytime/reusable/appbar/manager_buytime_appbar.dart';
import 'package:Buytime/UI/management/category/UI_manage_category.dart';
import 'package:Buytime/UI/management/category/W_category_list_item.dart';
import 'package:Buytime/UI/management/invite/UI_M_BookingList.dart';
import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/UI/model/manager_model.dart';
import 'package:Buytime/UI/model/service_model.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share/share.dart';

import 'UI_C_manage_business.dart';

class UI_M_Business extends StatefulWidget {
  static String route = '/customer';

  ManagerModel manager;
  ServiceModel service;

  UI_M_Business({Key key, this.service, this.manager}) : super(key: key);

  @override
  _UI_M_BusinessState createState() => _UI_M_BusinessState();
}

class _UI_M_BusinessState extends State<UI_M_Business> {

  List<BookingState> bookingList = new List();

  @override
  void initState() {
    super.initState();

  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    ///Init sizeConfig
    SizeConfig().init(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) => {
        print("On Init Business : Request List of Root Categories"),
        store.dispatch(RequestRootListCategory(store.state.business.id_firestore)),
      },
      builder: (context, snapshot) {
        List<CategoryState> categoryStateList = snapshot.categoryList.categoryListState;
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            drawerEnableOpenDragGesture: false,
            key: _drawerKey,
            ///Appbar
            appBar: BuytimeAppbarManager(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    tooltip: 'Open Menu',
                    onPressed: () {
                      _drawerKey.currentState.openDrawer();
                    },
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      "Dashboard",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: media.height * 0.025,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UI_ManageBusiness(0)),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: media.height * 0.025,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
            drawer: UI_M_BusinessListDrawer(),
            body: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///Appabar bottom arc & Worker card & Business logo
                    Container(
                      child: Column(
                        children: [
                          ///Worker card & Business logo
                          Container(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                decoration: BoxDecoration(color: Colors.transparent),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ///Worker card
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(top: 25.0, left: 20.0),
                                        color: Colors.transparent,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ///Welcome message 'Hi ...'
                                            Container(
                                              child: Text(
                                                'Hi ',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black.withOpacity(0.7)),
                                              ),
                                            ),

                                            ///Employees count
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text(
                                                '1000 employees',
                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.blueGrey),
                                              ),
                                            ),

                                            ///Menu items count
                                            Container(
                                              margin: EdgeInsets.only(top: 2.5),
                                              child: Text(
                                                '1 menu items',
                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.blueGrey),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                    ///Business logo
                                    Expanded(
                                      flex: 2,
                                      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                        Container(
                                          //color: Colors.deepOrange,
                                          width: 140,

                                          ///Fixed width
                                          child: Image.network(StoreProvider.of<AppState>(context).state.business.logo, fit: BoxFit.cover, scale: 1.1),
                                        )
                                      ]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ///Testing Service List
                    Container(
                        margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///Services
                            Container(
                              child: Text(
                                'Services',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),

                            ///Manage
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => UI_M_ServiceList()),
                                );
                              },
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Test ServiceList',
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.lightBlue),
                                ),
                              ),
                            ),
                          ],
                        )),

                    ///Categories & Manage

                    Container(
                        margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///Categories
                            Container(
                              child: Text(
                                'Categories',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),

                            ///Manage
                            InkWell(
                              onTap: () {
                                debugPrint('MANAGE Clicked!');
                                if (StoreProvider.of<AppState>(context).state.categoryTree.categoryNodeList == null) {
                                  StoreProvider.of<AppState>(context).dispatch(new CategoryTreeCreateIfNotExists(snapshot.business.id_firestore, context));
                                }
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => UI_ManageCategory()),
                                );
                              },
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Manage',
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.lightBlue),
                                ),
                              ),
                            ),
                          ],
                        )),

                    ///Categories list top part
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10),
                      decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1)),
                      child: Row(
                        children: [
                          ///Menu item text
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Text(
                                'MENU ITEMS',
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.5),
                              ),
                            ),
                          ),

                          ///Most popular text
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Text(
                                'MOST POPULAR',
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.5),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),


                        ///Categories list & Invite user
                        Expanded(
                            child: Stack(
                              children: [
                                categoryStateList.length > 0
                                    ?
                                ///Categories list
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      color: Colors.blueGrey.withOpacity(0.1),
                                      margin: EdgeInsets.only(bottom: 60.0),
                                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                      child: CustomScrollView(shrinkWrap: true, slivers: [
                                        SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                              //MenuItemModel menuItem = menuItems.elementAt(index);
                                              CategoryState categoryItem = categoryStateList.elementAt(index);
                                              return InkWell(
                                                onTap: () {
                                                  debugPrint('Category Item: ${categoryItem.name.toUpperCase()} Clicked!');
                                                },
                                                //child: MenuItemListItemWidget(menuItem),
                                                child: CategoryListItemWidget(categoryItem),
                                              );
                                            },
                                            childCount: categoryStateList.length,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ) : Container(
                                  height: SizeConfig.screenHeight * 0.1,
                                  child: Center(
                                    child: Text("Non ci sono categorie attive!"),
                                  ),
                                ),

                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 5,
                                            blurRadius: 5,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            debugPrint('INVITE USER Clicked!');

                                            /*final RenderBox box = context.findRenderObject();
                                            Share.share('Share', subject: 'Test', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);*/

                                            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingList(bookingList: bookingList)));
                                          },
                                          child: Container(
                                            height: 70,
                                            child: Row(
                                              children: [
                                                ///QR code Icon
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 15.0),
                                                    child: Icon(
                                                      Icons.qr_code_scanner,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),

                                                ///Message
                                                Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              'Invite user',
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Text(
                                                              'Users join by scanning your QR code',
                                                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey.withOpacity(0.8)),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )),

                                                ///Arrow Icon
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                    ///Invite user

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
