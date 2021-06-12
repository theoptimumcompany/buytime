import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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
