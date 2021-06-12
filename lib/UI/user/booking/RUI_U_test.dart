import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/order/optimum_order_item_card_medium.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:flutter/foundation.dart';
import 'package:Buytime/UI/user/map/UI_U_map.dart';

class RUI_U_test extends StatefulWidget {
  @override
  createState() => _RUI_U_testState();

}

class _RUI_U_testState extends State<RUI_U_test> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final Stream<DocumentSnapshot> _orderStream =  FirebaseFirestore.instance.collection('order').doc('d89adf90-b8b2-11eb-bd23-550155f03559').snapshots(includeMetadataChanges: true);
      return StreamBuilder<DocumentSnapshot>(
        stream: _orderStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> orderSnapshot) {
          if (!orderSnapshot.hasError && orderSnapshot.connectionState != ConnectionState.waiting) {
            OrderState orderState = OrderState.fromJson(orderSnapshot.data.data());
            return Scaffold(
              body: Column(
                children: [
                  Text(orderState.orderId),
                  Text(orderState.progress),
                  Text(orderSnapshot.data.get('progress')),
                ],
              ),
            );
          }
          return  Scaffold(
            body: Column(
              children: [
                Text('waiting'),
              ],
            ),
          );
        }
        );

  }
}
