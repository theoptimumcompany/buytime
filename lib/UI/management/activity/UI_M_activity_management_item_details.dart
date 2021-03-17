import 'package:Buytime/UI/management/activity/widget/W_dashboard_card.dart';
import 'package:Buytime/UI/management/activity/widget/W_dashboard_list_item.dart';
import 'package:Buytime/UI/management/business/UI_M_edit_business.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
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
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
//import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ActivityManagementItemDetails extends StatefulWidget {
  static String route = '/activityManagementItemDetails';

  OrderState orderState;

  ActivityManagementItemDetails({Key key, this.orderState}) : super(key: key);

  @override
  _ActivityManagementItemDetailsState createState() => _ActivityManagementItemDetailsState();
}

class _ActivityManagementItemDetailsState extends State<ActivityManagementItemDetails> {
  List<BookingState> bookingList = [];
  bool seeAll = false;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List<OrderState> pendingList = [];
  List<OrderState> acceptedList = [];
  List<List> orderList = [];

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    ///Init sizeConfig
    SizeConfig().init(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
      },
      builder: (context, snapshot) {

        //List<CategoryState> categoryRootList = snapshot.categoryList.categoryListState;
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
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        tooltip: AppLocalizations.of(context).comeBack,
                        onPressed: () {
                          //widget.fromConfirm != null ? Navigator.of(context).pop() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()),);
                          Future.delayed(Duration.zero, () {
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                ///Title
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      AppLocalizations.of(context).activityManagement,
                      textAlign: TextAlign.start,
                      style: BuytimeTheme.appbarTitle,
                    ),
                  ),
                ),
                SizedBox(
                  width: 56.0,
                )
              ],
            ),
            //drawer: UI_M_BusinessListDrawer(),
            body: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

