import 'package:Buytime/UI/user/service/UI_U_service_list.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

typedef OptimumOrderItemCardMediumCallback = void Function(OrderEntry);

class OptimumOrderItemCardMedium extends StatefulWidget {
  OptimumOrderItemCardMediumCallback onOrderItemCardTap;
  OrderEntry orderEntry;
  Size mediaSize;
  Widget rightWidget1;
  ObjectKey key;
  OrderState orderState;
  int index;
  bool show;

  OptimumOrderItemCardMedium({this.orderEntry, this.onOrderItemCardTap, this.rightWidget1, @required this.mediaSize, @required this.key, this.orderState, this.index, this.show}) {
    this.orderEntry = orderEntry;
    this.onOrderItemCardTap = onOrderItemCardTap;
    this.rightWidget1 = rightWidget1;
    this.mediaSize = mediaSize;
    this.key = key;
    this.orderState = orderState;
    this.index = index;
    this.show = show;
  }

  @override
  _OptimumOrderItemCardMediumState createState() => _OptimumOrderItemCardMediumState(orderEntry: orderEntry, onOrderItemCardTap: onOrderItemCardTap, rightWidget1: rightWidget1, mediaSize: mediaSize, key: key, orderState: orderState, index: index, show: show);
}

class _OptimumOrderItemCardMediumState extends State<OptimumOrderItemCardMedium> {
  OptimumOrderItemCardMediumCallback onOrderItemCardTap;
  Widget rightWidget1;
  Size mediaSize;
  OrderEntry orderEntry;
  ObjectKey key;
  OrderState orderState;
  int index;
  bool show;


  _OptimumOrderItemCardMediumState({this.orderEntry, this.onOrderItemCardTap, this.rightWidget1, this.mediaSize, this.key, this.orderState, this.index, this.show});

  void deleteItem(OrderState snapshot, int index) {
    setState(() {
      if (snapshot.itemList.length > 1) {
        snapshot.cartCounter = snapshot.cartCounter - snapshot.itemList[index].number;
        snapshot.removeItem(snapshot.itemList[index]);
        snapshot.itemList.removeAt(index);
      } else {
        snapshot.cartCounter = snapshot.cartCounter - snapshot.itemList[index].number;
        snapshot.removeItem(snapshot.itemList[index]);
        snapshot.itemList.removeAt(index);
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
        Navigator.of(context).pop();
      }
      StoreProvider.of<AppState>(context).dispatch(UpdateOrder(snapshot));
    });
  }

  void deleteOneItem(OrderState snapshot, int index) {
    setState(() {
      if(snapshot.itemList.length >= 1){
        if (snapshot.itemList[index].number > 1) {
          --snapshot.cartCounter;
          int itemCount =  snapshot.itemList[index].number;
          debugPrint('UI_U_Cart => BEFORE| ${snapshot.itemList[index].name} ITEM COUNT: ${snapshot.itemList[index].number}');
          debugPrint('UI_U_Cart => BEFORE| TOTAL: ${snapshot.total}');
          --itemCount;
          snapshot.itemList[index].number = itemCount;
          double serviceTotal =  snapshot.total;
          serviceTotal = serviceTotal - snapshot.itemList[index].price;
          snapshot.total = serviceTotal;
          debugPrint('UI_U_Cart => AFTER| ${snapshot.itemList[index].name} ITEM COUNT: ${snapshot.itemList[index].number}');
          debugPrint('UI_U_Cart => AFTER| TOTAL: ${snapshot.total}');


          /*snapshot.removeItem(snapshot.itemList[index]);
        snapshot.itemList.removeAt(index);*/
        }
      }else{
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
        Navigator.of(context).pop();
      }
      StoreProvider.of<AppState>(context).dispatch(UpdateOrder(snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.safeBlockVertical * 10,
      width: SizeConfig.screenWidth,
      key: key,
      child: GestureDetector(
        onTap: () {
          //onOrderItemCardTap(orderEntry);
        },
        child: orderEntry.time == null || orderEntry.time.isEmpty ?
            ///Non reservable
        Row(
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
                                      fontWeight: FontWeight.w500,
                                      color: BuytimeTheme.TextBlack,
                                      fontSize: 18 /// mediaSize.height * 0.024
                                  ),
                                ),
                              ),
                              ///Price
                              Text(
                                price(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                    fontWeight: FontWeight.w600,
                                    color: BuytimeTheme.TextMedium,
                                    fontSize: 14 /// mediaSize.height * 0.024
                                ),
                              ),
                            ],
                          ),
                        ),
                        show ?
                        Column(
                          children: [
                            Row(
                              children: [
                                orderEntry.number >= 2 ? IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color: BuytimeTheme.AccentRed,
                                    //size: SizeConfig.safeBlockHorizontal * 15,
                                  ),
                                  onPressed: () {
                                    deleteOneItem(orderState, index);
                                  },
                                ) : Container(),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_shopping_cart,
                                    color: BuytimeTheme.SymbolGrey,
                                    //size: SizeConfig.safeBlockHorizontal * 15,
                                  ),
                                  onPressed: () {
                                    deleteItem(orderState, index);
                                  },
                                ),
                              ],
                            )
                          ],
                        ) :
                            Container()
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
        ) :
            ///Reservable
       Container(
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             ///Summary & Price
             Expanded(
               flex: 1,
               child: Container(
                 margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                   //color: Colors.blue,
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
                               ///Selection summary
                               Padding(
                                 padding: const EdgeInsets.only(bottom:5.0),
                                 child: Text(
                                   'Reservation',
                                   overflow: TextOverflow.ellipsis,
                                   style: TextStyle(
                                       letterSpacing: 0.25,
                                       fontFamily: BuytimeTheme.FontFamily,
                                       fontWeight: FontWeight.w400,
                                       color: BuytimeTheme.TextBlack,
                                       fontSize: 14 /// mediaSize.height * 0.024
                                   ),
                                 ),
                               ),
                               ///Price
                               Text(
                                 '€ ${orderEntry.price.toStringAsFixed(2)}',
                                 overflow: TextOverflow.ellipsis,
                                 style: TextStyle(
                                     fontFamily: BuytimeTheme.FontFamily,
                                     fontWeight: FontWeight.w600,
                                     color: BuytimeTheme.TextMedium,
                                     fontSize: 14 /// mediaSize.height * 0.024
                                 ),
                               ),
                             ],
                           ),
                         ),

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
             ///Time & Date
             Expanded(
               flex: 1,
               child: Container(
                 margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                   //color: Colors.blue,
                   border: Border(
                     bottom: BorderSide(width: 1.0, color: Color.fromRGBO(33, 33, 33, 0.1)),
                   ),
                 ),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     ///Time & Date
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               ///Time
                               Padding(
                                 padding: const EdgeInsets.only(bottom:5.0),
                                 child: Text(
                                   '${orderEntry.time}',
                                   overflow: TextOverflow.ellipsis,
                                   style: TextStyle(
                                       fontFamily: BuytimeTheme.FontFamily,
                                       fontWeight: FontWeight.w400,
                                       color: BuytimeTheme.TextBlack,
                                       fontSize: 24 /// mediaSize.height * 0.024
                                   ),
                                 ),
                               ),
                               ///Date
                               Text(
                                 '${DateFormat('dd/MM/yyyy').format(orderEntry.date)}',
                                 overflow: TextOverflow.ellipsis,
                                 style: TextStyle(
                                     fontFamily: BuytimeTheme.FontFamily,
                                     fontWeight: FontWeight.w600,
                                     color: BuytimeTheme.TextMedium,
                                     fontSize: 14 /// mediaSize.height * 0.024
                                 ),
                               ),
                             ],
                           ),
                         ),

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
             ///Minutes
             Expanded(
               flex: 1,
               child: Container(
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                   //color: Colors.blue,
                   border: Border(
                     bottom: BorderSide(width: 1.0, color: Color.fromRGBO(33, 33, 33, 0.1)),
                   ),
                 ),
                 child: Text(
                   '${orderEntry.minutes} minutes',
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                       fontFamily: BuytimeTheme.FontFamily,
                       fontWeight: FontWeight.w400,
                       color: BuytimeTheme.TextMedium,
                       fontSize: 14 /// mediaSize.height * 0.024
                   ),
                 ),
               ),
             )
           ],
         ),
       ),
      ),
    );
  }

  String price() {
    if (orderEntry.number == 1) {
      return "€ " + orderEntry.price.toStringAsFixed(2);
    }
    return "€ " + orderEntry.price.toStringAsFixed(2) + " x " +  orderEntry.number.toString() + " = € " + (orderEntry.price * orderEntry.number).toStringAsFixed(2);
  }
}
