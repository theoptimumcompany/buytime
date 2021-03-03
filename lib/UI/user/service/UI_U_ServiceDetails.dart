import 'dart:async';
import 'package:Buytime/UI/user/cart/UI_U_Cart.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/cart_icon.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/b_cube_grid_spinner.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


class ServiceDetails extends StatefulWidget {
  final ServiceState serviceState;

  ServiceDetails({@required this.serviceState});

  @override
  createState() => _ServiceDetailsState();

}

class _ServiceDetailsState extends State<ServiceDetails> with SingleTickerProviderStateMixin {

  ServiceState serviceState;
  OrderState order = OrderState(itemList: List<OrderEntry>(), date: DateTime.now(), position: "", total: 0.0, business: BusinessSnippet().toEmpty(), user: UserSnippet().toEmpty(), businessId: "");

  @override
  void initState() {
    super.initState();
    serviceState = widget.serviceState;
    debugPrint('image: ${serviceState.image1}');
  }


  @override
  void dispose() {
    super.dispose();
  }

  String version200(String imageUrl) {
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0 && imageUrl.contains("http")) {
      extension = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_1000x1000" + extension;
    }else {
      result = "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;

    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store){
        //order = store.state.order.itemList != null ? (store.state.order.itemList.length > 0 ? store.state.order : order) : order;
      },
      builder: (context, snapshot) {
        order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : order) : order;
        return  GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: BuytimeAppbar(
                background: BuytimeTheme.UserPrimary,
                width: media.width,
                children: [
                  ///Back Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        widget.serviceState.name, //TODO Make it Global
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 5,
                          color: BuytimeTheme.TextWhite,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  ///Cart
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: Icon(
                                  CartIcon.add_shopping_cart_24px,
                                  color: BuytimeTheme.TextWhite,
                                  size: 24.0,
                                ),
                                onPressed: (){
                                  if (cartCounter > 0) {
                                    // dispatch the order
                                    StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                    // go to the cart page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Cart()),
                                    );
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (_) => new AlertDialog(
                                          title: new Text(AppLocalizations.of(context).warning),
                                          content: new Text(AppLocalizations.of(context).emptyCart),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(AppLocalizations.of(context).ok),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        ));
                                  }
                                },
                              ),
                            ),
                          ),
                          cartCounter > 0 ? Positioned.fill(
                            top: 5,
                            left: 2.5,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                '$cartCounter', //TODO Make it Global
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  color: BuytimeTheme.TextWhite,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ) : Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ///Background Image
                        Flexible(
                            flex: 3,
                            child: Container(
                              height: SizeConfig.safeBlockVertical * 55,
                              child: Stack(
                                children: [
                                  ///Background image
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(version200(serviceState.image1)),
                                                fit: BoxFit.fill
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                  /*///Back button
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10.0),
                                        child: IconButton(
                                          iconSize: 30,
                                          icon: Icon(
                                            Icons.keyboard_arrow_left,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async{
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),*/
                                ],
                              ),
                            )
                        ),
                        ///Service Name
                        Flexible(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ///Service Name Text
                              Container(
                                margin: EdgeInsets.only(top:  SizeConfig.safeBlockVertical * 2.5),
                                child: Text(
                                  serviceState.name ?? AppLocalizations.of(context).serviceName,
                                  style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                              ///Service Name Text
                              Container(
                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                child: Text(
                                  serviceState.name ?? AppLocalizations.of(context).serviceName,
                                  style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextDark,
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                              ///Amount
                              Container(
                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                child: Text(
                                  serviceState.price != null ? '€ ${serviceState.price}/1 Unit' : '€ 99/ ' + AppLocalizations.of(context).hour,
                                  style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextDark,
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                              ///Buy
                              Container(
                                  width: SizeConfig.safeBlockHorizontal * 40,
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 2),
                                  child: RaisedButton(
                                    onPressed: () {

                                    },
                                    textColor: BuytimeTheme.TextWhite,
                                    color: BuytimeTheme.UserPrimary,
                                    padding: EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      'BUY',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                              ),
                              ///Add to card
                              Container(
                                  width: SizeConfig.safeBlockHorizontal * 40,
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 2),
                                  child: FlatButton(
                                    onPressed: () {
                                      order.business.name = snapshot.business.name;
                                      order.business.id = snapshot.business.id_firestore;
                                      order.user.name = snapshot.user.name;
                                      order.user.id = snapshot.user.uid;
                                      order.addItem(widget.serviceState, snapshot.business.ownerId);
                                      setState(() {
                                        cartCounter++;
                                      });
                                    },
                                    textColor: BuytimeTheme.UserPrimary,
                                    color: BuytimeTheme.BackgroundWhite,
                                    padding: EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context).addToCart,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                              ),
                              ///Description
                              Flexible(
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, bottom: SizeConfig.safeBlockVertical * 1),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                                        child: Text(
                                          'Service Description',
                                          style: TextStyle(
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: SizeConfig.safeBlockHorizontal * 5
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 2),
                                        child: Text(
                                          serviceState.description.isNotEmpty ? serviceState.description : 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In luctus laoreet tortor at rhoncus. Integer ac pretium ipsum, non faucibus elit. Curabitur nisi diam, lacinia sit amet accumsan nec, dictum tempus neque. Fusce et quam ante.',
                                          style: TextStyle(
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: SizeConfig.safeBlockHorizontal * 4
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              /* )*/
            ),
          ),
        );
      },
    );
  }
}
