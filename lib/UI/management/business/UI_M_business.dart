import 'package:Buytime/UI/management/business/UI_M_edit_business.dart';
import 'package:Buytime/UI/management/business/widget/W_business_header.dart';
import 'package:Buytime/UI/management/business/widget/W_external_services_showcase.dart';
import 'package:Buytime/UI/management/business/widget/W_internal_services_showcase.dart';
import 'package:Buytime/UI/management/business/widget/W_invite_user.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/UI/management/category/W_category_list_item.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_service_list.dart';
import 'package:Buytime/UI/model/manager_model.dart';
import 'package:Buytime/UI/model/service_model.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  ///Prova Evento su Calendario
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
      onInit: (store) {
        print("On Init Business : Request List of Root Categories");
        store.dispatch(RequestRootListCategory(store.state.business.id_firestore));
        store.state.business.business_type.forEach((element) {
          print("UI_M_Business => Business Type: ${element.name}");
          if (element.name == 'Hotel') hotel = true;
        });
      },
      builder: (context, snapshot) {
        List<CategoryState> categoryRootList = snapshot.categoryList.categoryListState;
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
                  ],
                ),
                ///Title
                Utils.barTitle(AppLocalizations.of(context).dashboard),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      onTap: () {
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_EditBusiness()),);
                        Navigator.push(context, EnterExitRoute(enterPage: UI_M_EditBusiness(), exitPage: UI_M_Business(), from: true));
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 1),
                        child: Text(
                          AppLocalizations.of(context).edit,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
            drawer: UI_M_BusinessListDrawer(),
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: media.height * 0.88),
                child: Center(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BusinessHeader(),
                        InternalServiceShowcase(categoryRootList: categoryRootList),
                        ExternalServiceShowcase(categoryRootList: categoryRootList),
                        InviteUser(
                          hotel: hotel,
                        ),
                        //Expanded(child: calendarButtonOrCalendar()),
                      ],
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
