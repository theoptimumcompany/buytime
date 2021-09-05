import 'package:Buytime/UI/user/service/UI_U_service_list.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/promotion/promotion_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        snapshot.removeItem(snapshot.itemList[index],context);
        snapshot.itemList.removeAt(index);
      } else {
        snapshot.cartCounter = snapshot.cartCounter - snapshot.itemList[index].number;
        snapshot.removeItem(snapshot.itemList[index],context);
        snapshot.itemList.removeAt(index);
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
        Navigator.of(context).pop();
      }
      StoreProvider.of<AppState>(context).dispatch(UpdateOrder(snapshot));
    });
  }

  void deleteOneItem(OrderState snapshot, int index) {
    setState(() {
      if(snapshot.itemList.length > 1){
        if (snapshot.itemList[index].number > 1) {
          --snapshot.cartCounter;
          int itemCount =  snapshot.itemList[index].number;
          debugPrint('UI_U_Cart => BEFORE| ${snapshot.itemList[index].name} ITEM COUNT: ${snapshot.itemList[index].number}');
          debugPrint('UI_U_Cart => BEFORE| TOTAL: ${snapshot.total}');
          --itemCount;
          snapshot.itemList[index].number = itemCount;
          double serviceTotal =  snapshot.total;
          serviceTotal = serviceTotal - snapshot.itemList[index].price;
          snapshot.totalPromoDiscount -= Utils.calculatePromoDiscount(snapshot.itemList[index].price, context, snapshot.itemList[index].id_business);
          snapshot.total = serviceTotal;
          snapshot.total += Utils.calculatePromoDiscount(snapshot.itemList[index].price, context, snapshot.itemList[index].id_business);
          debugPrint('UI_U_Cart => AFTER| ${snapshot.itemList[index].name} ITEM COUNT: ${snapshot.itemList[index].number}');
          debugPrint('UI_U_Cart => AFTER| TOTAL: ${snapshot.total}');
          /*snapshot.removeItem(snapshot.itemList[index]);
        snapshot.itemList.removeAt(index);*/
        }else{
          snapshot.cartCounter = snapshot.cartCounter - snapshot.itemList[index].number;
          snapshot.removeItem(snapshot.itemList[index],context);
          snapshot.itemList.removeAt(index);
          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
          //Navigator.of(context).pop();
        }
      }else{
        if (snapshot.itemList[index].number > 1) {
          --snapshot.cartCounter;
          int itemCount =  snapshot.itemList[index].number;
          debugPrint('UI_U_Cart => BEFORE| ${snapshot.itemList[index].name} ITEM COUNT: ${snapshot.itemList[index].number}');
          debugPrint('UI_U_Cart => BEFORE| TOTAL: ${snapshot.total}');
          --itemCount;
          snapshot.itemList[index].number = itemCount;
          double serviceTotal =  snapshot.total;
          serviceTotal = serviceTotal - snapshot.itemList[index].price;
          snapshot.totalPromoDiscount -= Utils.calculatePromoDiscount(snapshot.itemList[index].price, context, snapshot.itemList[index].id_business);
          snapshot.total = serviceTotal;
          snapshot.total += Utils.calculatePromoDiscount(snapshot.itemList[index].price, context, snapshot.itemList[index].id_business);
          debugPrint('UI_U_Cart => AFTER| ${snapshot.itemList[index].name} ITEM COUNT: ${snapshot.itemList[index].number}');
          debugPrint('UI_U_Cart => AFTER| TOTAL: ${snapshot.total}');
          /*snapshot.removeItem(snapshot.itemList[index]);
        snapshot.itemList.removeAt(index);*/
        }else{
          snapshot.cartCounter = snapshot.cartCounter - snapshot.itemList[index].number;
          snapshot.removeItem(snapshot.itemList[index],context);
          snapshot.itemList.removeAt(index);
          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
          Navigator.of(context).pop();
        }
      }
      StoreProvider.of<AppState>(context).dispatch(UpdateOrder(snapshot));
    });
  }

  void addOneItem(OrderState snapshot, int index) {
    setState(() {
      ++snapshot.cartCounter;
      int itemCount =  snapshot.itemList[index].number;
      debugPrint('UI_U_Cart => BEFORE| ${snapshot.itemList[index].name} ITEM COUNT: ${snapshot.itemList[index].number}');
      debugPrint('UI_U_Cart => BEFORE| TOTAL: ${snapshot.total}');
      ++itemCount;
      snapshot.itemList[index].number = itemCount;
      double serviceTotal =  snapshot.total;
      serviceTotal = serviceTotal + snapshot.itemList[index].price;
      snapshot.totalPromoDiscount += Utils.calculatePromoDiscount(snapshot.itemList[index].price, context, snapshot.itemList[index].id_business);
      snapshot.total = serviceTotal;
      snapshot.total -= Utils.calculatePromoDiscount(snapshot.itemList[index].price, context, snapshot.itemList[index].id_business);
      debugPrint('UI_U_Cart => AFTER| ${snapshot.itemList[index].name} ITEM COUNT: ${snapshot.itemList[index].number}');
      debugPrint('UI_U_Cart => AFTER| TOTAL: ${snapshot.total}');
      StoreProvider.of<AppState>(context).dispatch(UpdateOrder(snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.safeBlockVertical * 9,
      width: SizeConfig.screenWidth,
      key: key,
      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
      child: GestureDetector(
        onTap: () {
          //onOrderItemCardTap(orderEntry);
        },
        child: orderEntry.time == null || orderEntry.time.isEmpty ?
            ///Non reservable
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3, right: SizeConfig.safeBlockHorizontal * 3),
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
                      mainAxisAlignment: show ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Quantity & Service Name
                              Padding(
                                padding: EdgeInsets.only(bottom: show ? 0 : 5),
                                child: Text(
                                  Utils.retriveField(Localizations.localeOf(context).languageCode, orderEntry.name),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: BuytimeTheme.FontFamily,
                                      fontWeight: FontWeight.w500,
                                      color: BuytimeTheme.TextBlack,
                                      fontSize: 16 /// mediaSize.height * 0.024
                                  ),
                                ),
                              ),
                              ///Remoce/Add item & Quantity
                              show ?
                                Row(
                                children: [
                                  ///Remove item
                                  InkWell(
                                    key: Key('remove_one_item_key'),
                                    child: Container(
                                      margin: EdgeInsets.all(SizeConfig.safeBlockVertical * 1),
                                      child: Icon(
                                        Icons.remove,
                                        color: BuytimeTheme.UserPrimary,
                                        //size: 22,
                                        //size: SizeConfig.safeBlockHorizontal * 15,
                                      ),
                                    ),
                                    onTap: () {
                                      deleteOneItem(orderState, index);
                                    },
                                  ),
                                  ///Quantity
                                  Text(
                                    orderEntry.number.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: BuytimeTheme.TextMedium,
                                        fontSize: 14 /// mediaSize.height * 0.024
                                    ),
                                  ),
                                  ///Add item
                                  InkWell(
                                    key: Key('add_one_item_key'),
                                    child: Container(
                                      margin: EdgeInsets.all(SizeConfig.safeBlockVertical * 1),
                                      child: Icon(
                                        Icons.add,
                                        color: BuytimeTheme.UserPrimary,
                                        //size: 22,
                                        //size: SizeConfig.safeBlockHorizontal * 15,
                                      ),
                                    ),
                                    onTap: () {
                                      addOneItem(orderState, index);
                                    },
                                  )
                                ],
                              ):
                              Container(
                                child: Text(
                                  '${orderEntry.number} x ${AppLocalizations.of(context).currency} ${orderEntry.price.toStringAsFixed(2)}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      fontWeight: FontWeight.w600,
                                      color: BuytimeTheme.TextMedium,
                                      fontSize: 14 /// mediaSize.height * 0.024
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ///Price
                        Column(
                          children: [
                            Container(
                              //margin: EdgeInsets.only(right: SizeConfig.safeBlockVertical * 3),
                              child: Text(
                                price(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    letterSpacing: 0.25,
                                    fontFamily: BuytimeTheme.FontFamily,
                                    fontWeight: FontWeight.w400,
                                    color: BuytimeTheme.TextBlack,
                                    fontSize: 16 /// mediaSize.height * 0.024
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ) :
            ///Reservable
       Container(
         margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3, right: SizeConfig.safeBlockHorizontal * 3),
         decoration: BoxDecoration(
           border: Border(
             bottom: BorderSide(width: 1.0, color: Color.fromRGBO(33, 33, 33, 0.1)),
           ),
         ),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             ///Summary & Price
             Expanded(
               flex: 1,
               child: Container(
                 alignment: Alignment.centerLeft,
                 decoration: BoxDecoration(
                   //color: Colors.blue,
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
                                   '${AppLocalizations.of(context).reservation}',
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
                                 '${orderEntry.number} x ${AppLocalizations.of(context).euroSpace} ${(orderEntry.price/orderEntry.number).toStringAsFixed(2)} = ${AppLocalizations.of(context).euroSpace} ${orderEntry.price.toStringAsFixed(2)}',
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
                 //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                   //color: Colors.blue,

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
                                 '${DateFormat('dd/MM/yyyy',Localizations.localeOf(context).languageCode).format(orderEntry.date)}',
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
             ///Minutes or Days
             Expanded(
               flex: 1,
               child: Container(
                 alignment: Alignment.centerRight,
                 decoration: BoxDecoration(
                   //color: Colors.blue,

                 ),
                 child: Text(
                   '${orderEntry.minutes}',
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
      return '${AppLocalizations.of(context).currency} ' + orderEntry.price.toStringAsFixed(2);
    }
    //return "€ " + orderEntry.price.toStringAsFixed(2) + " x " +  orderEntry.number.toString() + " = € " + (orderEntry.price * orderEntry.number).toStringAsFixed(2);
    return '${AppLocalizations.of(context).currency} ' + (orderEntry.price * orderEntry.number).toStringAsFixed(2);
  }
}
