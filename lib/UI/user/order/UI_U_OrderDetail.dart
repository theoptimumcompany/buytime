import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/user_buytime_appbar.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:Buytime/reusable/order/optimum_order_item_card_medium.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class UI_U_OrderDetail extends StatefulWidget {
  final String title = 'Order Detail';

  @override
  State<StatefulWidget> createState() => UI_U_OrderDetailState();
}

class UI_U_OrderDetailState extends State<UI_U_OrderDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var confirmedOrder = OrderState(itemList: null);
    return WillPopScope(
      onWillPop: () async {
        cartCounter = 0;
        StoreProvider.of<AppState>(context).dispatch(SetOrderToEmpty(""));
        return true;
      },
      child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          onInit: (store) {
            cartCounter = 0;
            confirmedOrder = store.state.order;
            StoreProvider.of<AppState>(context).dispatch(SetOrderToEmpty(""));
          },
          onDispose: (store) {
            cartCounter = 0;
            StoreProvider.of<AppState>(context).dispatch(SetOrderToEmpty(""));
          },
          builder: (context, snapshot) {
            Timestamp stamp = Timestamp.now(); //TODO snapshot.order.date; Salvare bene timestamp sul navigation
            DateTime date = stamp.toDate();
            String formattedDate = DateFormat('dd/MM/yyyy kk:mm').format(date);
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: BuytimeAppbarUser(
                width: media.width,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: Colors.white, size: media.width * 0.1),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ColorFiltered(
                    colorFilter: ColorFilter.linearToSrgbGamma(),
                    child: Image.network(
                      confirmedOrder.business?.thumbnail,
                      height: media.height * 0.05,
                    ),
                  ),
                  SizedBox(
                    width: 40.0,
                  )
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 10.0,bottom: 5.0),
                    child: Text(
                      AppLocalizations.of(context).orderConfirmed,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: media.height * 0.035,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      formattedDate.split(" ")[0].toString() + AppLocalizations.of(context).at + formattedDate.split(" ")[1].toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: media.height * 0.024,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GridView.builder(
                              itemCount: confirmedOrder.itemList.length + 1,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 5,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                final item = (index != confirmedOrder.itemList.length ? confirmedOrder.itemList[index] : null);
                                return index != confirmedOrder.itemList.length
                                    ? OptimumOrderItemCardMedium(
                                        key: ObjectKey(item),
                                        orderEntry: confirmedOrder.itemList[index],
                                        mediaSize: media,
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(246, 246, 246, 1.0),
                                          border: Border(
                                            bottom: BorderSide(width: 1.0, color: Color.fromRGBO(33, 33, 33, 0.1)),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context).total + confirmedOrder.total.toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: media.height * 0.026,
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context).tax + (confirmedOrder.total != null ? (confirmedOrder.total * 0.25).toStringAsFixed(2) : "0"),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: media.height * 0.020,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                              },
                            ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                      child: Text(
                        AppLocalizations.of(context).thanksOrder + confirmedOrder.business?.name + "!",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: media.height * 0.035,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
