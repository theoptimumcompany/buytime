import 'package:Buytime/UI/management/business/UI_M_edit_business.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/UI/management/category/W_category_list_item.dart';
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
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
//import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'UI_M_manage_business.dart';

class UI_M_Business extends StatefulWidget {
  static String route = '/business';

  ManagerModel manager;
  ServiceModel service;

  UI_M_Business({Key key, this.service, this.manager}) : super(key: key);

  @override
  _UI_M_BusinessState createState() => _UI_M_BusinessState();
}

class _UI_M_BusinessState extends State<UI_M_Business> {
  List<BookingState> bookingList = [];

  @override
  void initState() {
    super.initState();
  }

  // Widget calendarButtonOrCalendar() {
  //   //Returns a calendar button that displays 'Select Calendar' or Returns a
  //   // Calendar Page if the button was pressed
  //     return  TextButton(
  //         child: Text("Create Event",
  //             style: Theme.of(context).textTheme.body1),
  //         onPressed: () {
  //
  //           final Event event = Event(
  //             title: 'Nuovo Evento Buytime',
  //             description: 'Cazzarola',
  //             location: 'Poggibonsi',
  //             startDate: DateTime(2021,03,17),
  //          //   alarmInterval: Duration(days: 1), // on iOS, you can set alarm notification after your event.
  //             endDate: DateTime(2021,03,18),
  //           );
  //           Add2Calendar.addEvent2Cal(event);
  //
  //         });
  // }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool hotel = false;

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
        List<CategoryState> categoryRootList = snapshot.categoryList.categoryListState;
        snapshot.business.business_type.forEach((element) {
          if (element.content == 'Hotel') hotel = true;
        });
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            drawerEnableOpenDragGesture: false,
            key: _drawerKey,

            ///Appbar
            appBar: BuytimeAppbar(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        tooltip: AppLocalizations.of(context).openMenu,
                        onPressed: () {
                          _drawerKey.currentState.openDrawer();
                        },
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          AppLocalizations.of(context).dashboard,
                          textAlign: TextAlign.start,
                          style: BuytimeTheme.appbarTitle,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UI_M_EditBusiness()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 1),
                        child: Text(
                          AppLocalizations.of(context).edit,
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
                                                'Hi ' + snapshot.user.name,
                                                style: TextStyle(fontWeight: FontWeight.w700, fontFamily: BuytimeTheme.FontFamily, fontSize: 24, color: BuytimeTheme.TextBlack),
                                              ),
                                            ),

                                            ///Employees count
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text(
                                                AppLocalizations.of(context).employees,
                                                style: TextStyle(fontWeight: FontWeight.w400, fontFamily: BuytimeTheme.FontFamily, fontSize: 14, color: BuytimeTheme.TextMedium),
                                              ),
                                            ),

                                            ///Menu items count
                                            Container(
                                              margin: EdgeInsets.only(top: 2.5),
                                              child: Text(
                                                AppLocalizations.of(context).menuItems,
                                                style: TextStyle(fontWeight: FontWeight.w400, fontFamily: BuytimeTheme.FontFamily, fontSize: 14, color: BuytimeTheme.TextMedium),
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

                    ///Categories & Manage
                    Container(
                        margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0, bottom: SizeConfig.safeBlockVertical * 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///Categories
                            Container(
                              child: Text(
                                AppLocalizations.of(context).serviceCategories,
                                style: TextStyle(fontWeight: FontWeight.w700, fontFamily: BuytimeTheme.FontFamily, fontSize: 18, color: BuytimeTheme.TextBlack),
                              ),
                            ),

                            ///Manage
                            InkWell(
                              onTap: () {
                                debugPrint('MANAGE Clicked!');
                                StoreProvider.of<AppState>(context).dispatch(CategoryTreeCreateIfNotExists(snapshot.business.id_firestore, context));

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => ManageCategory()),
                                );
                              },
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  AppLocalizations.of(context).manage,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontFamily: BuytimeTheme.FontFamily, fontSize: 18, color: BuytimeTheme.UserPrimary),
                                ),
                              ),
                            ),
                          ],
                        )),

                    ///Categories list top part
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: SizeConfig.safeBlockVertical * 1, bottom: 10),
                      decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1)),
                      child: Row(
                        children: [
                          ///Menu item text
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Text(
                                AppLocalizations.of(context).menuItemsCaps,
                                style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 10, color: BuytimeTheme.TextBlack, letterSpacing: 1.5),
                              ),
                            ),
                          ),

                          ///Most popular text
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Text(
                                AppLocalizations.of(context).mostPopularCaps,
                                style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 10, color: BuytimeTheme.TextBlack, letterSpacing: 1.5),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    ///Categories list & Invite user
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => UI_M_ServiceList()),
                          );
                        },
                        child: Stack(
                          children: [
                            categoryRootList.length > 0
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
                                                CategoryState categoryItem = categoryRootList.elementAt(index);
                                                return CategoryListItemWidget(categoryItem);
                                                // return InkWell(
                                                //   onTap: () {
                                                //     debugPrint('Category Item: ${categoryItem.name.toUpperCase()} Clicked!');
                                                //   },
                                                //   //child: MenuItemListItemWidget(menuItem),
                                                //   child: CategoryListItemWidget(categoryItem),
                                                // );
                                              },
                                              childCount: categoryRootList.length,
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: SizeConfig.screenHeight * 0.1,
                                    child: Center(
                                      child: Text(AppLocalizations.of(context).noActiveCategory),
                                    ),
                                  ),

                            ///Invite
                            hotel
                                ? Positioned.fill(
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
                                              Share.share(AppLocalizations.of(context).share, subject: 'Test', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);*/
                                              StoreProvider.of<AppState>(context).dispatch(BookingListRequest(snapshot.business.id_firestore));
                                              //Navigator.push(context, MaterialPageRoute(builder: (context) => BookingList(bookingList: bookingList)));
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
                                                                AppLocalizations.of(context).inviteUser,
                                                                style: TextStyle(
                                                                    color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontFamily: BuytimeTheme.FontFamily, fontSize: 16, letterSpacing: 0.15),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: FittedBox(
                                                                fit: BoxFit.scaleDown,
                                                                child: Text(
                                                                  AppLocalizations.of(context).userJoinQR,
                                                                  style: TextStyle(
                                                                      color: BuytimeTheme.TextMedium,
                                                                      fontWeight: FontWeight.w400,
                                                                      fontFamily: BuytimeTheme.FontFamily,
                                                                      fontSize: 14,
                                                                      letterSpacing: 0.25),
                                                                ),
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
                                : Container()
                          ],
                        ),
                      ),
                    ),

                    //Expanded(child: calendarButtonOrCalendar()),
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

