import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

typedef OptimumOrderItemCardMediumCallback = void Function(OrderEntry);

class OptimumOrderItemCardMedium extends StatefulWidget {
  OptimumOrderItemCardMediumCallback onOrderItemCardTap;
  OrderEntry orderEntry;
  Size mediaSize;
  Widget rightWidget1;
  ObjectKey key;

  OptimumOrderItemCardMedium({this.orderEntry, this.onOrderItemCardTap, this.rightWidget1, @required this.mediaSize, @required this.key}) {
    this.orderEntry = orderEntry;
    this.onOrderItemCardTap = onOrderItemCardTap;
    this.rightWidget1 = rightWidget1;
    this.mediaSize = mediaSize;
    this.key = key;
  }

  @override
  _OptimumOrderItemCardMediumState createState() => _OptimumOrderItemCardMediumState(orderEntry: orderEntry, onOrderItemCardTap: onOrderItemCardTap, rightWidget1: rightWidget1, mediaSize: mediaSize, key: key);
}

class _OptimumOrderItemCardMediumState extends State<OptimumOrderItemCardMedium> {
  OptimumOrderItemCardMediumCallback onOrderItemCardTap;
  Widget rightWidget1;
  Size mediaSize;
  OrderEntry orderEntry;
  ObjectKey key;


  _OptimumOrderItemCardMediumState({this.orderEntry, this.onOrderItemCardTap, this.rightWidget1, this.mediaSize, this.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.safeBlockVertical * 10,
      key: key,
      child: GestureDetector(
        onTap: () {
          onOrderItemCardTap(orderEntry);
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
                    ///Quantity & Service Name & Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Quantity & Service Name
                              Padding(
                                padding: const EdgeInsets.only(bottom:5.0),
                                child: Text(
                                  orderEntry.number.toString() + " x " +  orderEntry.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: BuytimeTheme.FontFamily,
                                      fontWeight: FontWeight.w600,
                                      color: BuytimeTheme.TextDark.withOpacity(.8),
                                      fontSize: mediaSize.height * 0.024,
                                  ),
                                ),
                              ),
                              ///Price
                              Text(
                                price(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                    fontSize: mediaSize.height * 0.021,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.6)
                                ),
                              ),
                            ],
                          ),
                        ),
                        rightWidget1 != null ? rightWidget1 : SizedBox()
                      ],
                    ),
                    /*Container(
                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                      height: SizeConfig.safeBlockVertical * .25,
                      color: BuytimeTheme.DividerGrey,
                    )*/
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
    if (orderEntry.number == 1) {
      return "€ " + orderEntry.price.toStringAsFixed(2);
    }
    return "€ " + orderEntry.price.toString() + " x " +  orderEntry.number.toString() + " = € " + (orderEntry.price * orderEntry.number).toStringAsFixed(2);
  }
}
