import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OptimumOrderHistoryItemCardMediumCallback = void Function(OrderState);

class OptimumOrderHistoryItemCardMedium extends StatefulWidget {
  OptimumOrderHistoryItemCardMediumCallback onOrderHistoryItemCardTap;
  OrderState order;
  Size mediaSize;
  Widget rightWidget1;
  ObjectKey key;

  OptimumOrderHistoryItemCardMedium({this.order, this.onOrderHistoryItemCardTap, this.rightWidget1, @required this.mediaSize, @required this.key}) {
    this.order = order;
    this.onOrderHistoryItemCardTap = onOrderHistoryItemCardTap;
    this.rightWidget1 = rightWidget1;
    this.mediaSize = mediaSize;
    this.key = key;
  }

  @override
  _OptimumOrderHistoryItemCardMediumState createState() => _OptimumOrderHistoryItemCardMediumState(order: order, onOrderHistoryItemCardTap: onOrderHistoryItemCardTap, rightWidget1: rightWidget1, mediaSize: mediaSize, key: key);
}

class _OptimumOrderHistoryItemCardMediumState extends State<OptimumOrderHistoryItemCardMedium> {
  OptimumOrderHistoryItemCardMediumCallback onOrderHistoryItemCardTap;
  Widget rightWidget1;
  Size mediaSize;
  OrderState order;
  ObjectKey key;


  _OptimumOrderHistoryItemCardMediumState({this.order, this.onOrderHistoryItemCardTap, this.rightWidget1, this.mediaSize, this.key});

  @override
  Widget build(BuildContext context) {

    // Timestamp stamp = order.date;
    // DateTime date = stamp.toDate();
    String formattedDate = DateFormat('dd/MM/yyyy kk:mm').format(order.date);

    return Container(
      key: key,
      child: GestureDetector(
        onTap: () {
          onOrderHistoryItemCardTap(order);
        },
        child: Row(
          children: [
            SizedBox(
              width: mediaSize.width * 0.045,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Color.fromRGBO(33, 33, 33, 0.1)),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom:5.0),
                                child: Text(
                                  order.business.name + " - " + formattedDate.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: mediaSize.height * 0.024,
                                  ),
                                ),
                              ),
                              Text(
                                price(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: mediaSize.height * 0.021,
                                    color: Colors.black.withOpacity(0.6)
                                ),
                              ),
                            ],
                          ),
                        ),
                        rightWidget1 != null ? rightWidget1 : SizedBox()
                      ],
                    ),
                    // rowWidget1 != null || rowWidget2 != null || rowWidget3 != null ? Row(children: [
                    //   rowWidget1,
                    //   rowWidget2,
                    //   rowWidget3
                    // ],) : null
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String price() {
    return AppLocalizations.of(context).currency + order.total.toStringAsFixed(2);
  }
}
