import 'dart:core';
import 'package:Buytime/UI/user/booking/RUI_U_order_detail.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/helper/payment/paypal/paypal_service.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  bool tourist;
  bool reserve;
  OrderState orderState;
  PaypalPayment({this.onFinish, this.tourist, this.reserve, this.orderState});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic,dynamic> defaultCurrency = {"symbol": "EUR ", "decimalDigits": 2, "symbolBeforeTheNumber": true, "currency": "EUR"};

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL= 'cancel.example.com';


  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();
        final transactions = getOrderParams();
        debugPrint('CALL PAYPAL CREATE PAYMENT');
        final res = await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: '+e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  // item name, price and quantity
  String itemName = 'iPhone X';
  String itemPrice = '1.99';
  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    List items = [] ;
    widget.orderState.itemList.length > 1 ?
    items = [
      {
        "name": '${AppLocalizations.of(context).multipleOrders}',
        "quantity": '${widget.orderState.cartCounter}',
        "price": '${widget.orderState.total}',
        "currency": defaultCurrency["currency"]
      }
    ] : items = [
      {
        "name": '${widget.orderState.itemList.first.name}',
        "quantity": '${widget.orderState.cartCounter}',
        "price": '${widget.orderState.total}',
        "currency": defaultCurrency["currency"]
      }
    ];


    // checkout invoice details
    debugPrint('CHECK OUT INVOICE: ${widget.orderState.total} - ${widget.orderState.cartCounter}');
    String totalAmount = '${widget.orderState.total}';
    String subTotalAmount = '${widget.orderState.total}';
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    String userFirstName = 'Gulshan';
    String userLastName = 'Yadav';
    String addressCity = 'Delhi';
    String addressStreet = 'Mathura Road';
    String addressZipCode = '110014';
    String addressCountry = 'India';
    String addressState = 'Delhi';
    String addressPhoneNumber = '+919990119091';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount":
              ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping &&
                isEnableAddress)
              "shipping_address": {
                "recipient_name": userFirstName +
                    " " +
                    userLastName,
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {
        "return_url": returnURL,
        "cancel_url": cancelURL
      }
    };
    return temp;
  }

  bool executionComplete = false;

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return WillPopScope(
          onWillPop: () async {
            ///Block iOS Back Swipe
            if (Navigator.of(context).userGestureInProgress)
              return false;
            else
              return false;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
              leading: executionComplete ? Container() : GestureDetector(
                child: Icon(Icons.keyboard_arrow_left,
                  color: Colors.white,
                  size: 25.0,),
                onTap: () => Navigator.pop(context),
              ),
              actions: [
                executionComplete ? Container(
                    child: IconButton(
                        icon: Icon(Icons.check, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RUI_U_OrderDetail("")),);
                        }
                    )
                ) : Container()
              ],
            ),
            body: WebView(
              initialUrl: checkoutUrl,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) async {
                debugPrint('RETURN URL: $returnURL - REQUEST: $request');
                if (request.url.contains(returnURL)) {
                  // final uri = Uri.parse(request.url);
                  final uri = Uri.parse(request.url);
                  final payerID = uri.queryParameters['PayerID'];
                  //String payerID = await services.identifyUser(accessToken);
                  if (payerID != null) {
                    ///FIRST LOGIN ERROR
                   /* V/InputMethodManager( 2041): b/117267690: Failed to get fallback IMM with expected displayId=110 actual IMM#displayId=0 view=io.flutter.plugins.webviewflutter.InputAwareWebView{f2c779b VFEDHVC.. .F...... 0,0-1080,1840}
                      I/chromium( 2041): [INFO:CONSOLE(0)] "Refused to apply style from 'https://www.paypalobjects.com/webapps/return.example.com/error.css' because its MIME type ('text/html') is not a supported stylesheet MIME type, and strict MIME checking is enabled.",
                      source: https://www.paypalobjects.com/webapps/return.example.com/?paymentId=PAYID-MFXKSGY4GV7306654020144T&token=EC-4GP91630PR3129051&PayerID=HF6VT5MWLNC4J (0)*/
                    ///TODO Add the order progress update here
                    ///Payment success
                    services.executePayment(Uri.parse(executeUrl), payerID, accessToken).then((id) {
                      debugPrint('PAYMENT EXECUTION SUCCESS - ID: $id');
                      widget.onFinish(id);
                      setState(() {
                        executionComplete = true;
                      });
                      StoreProvider.of<AppState>(context).dispatch(CreatingOrder());
                      if(widget.reserve){
                        if (widget.orderState.isOrderAutoConfirmable()){
                          StoreProvider.of<AppState>(context).dispatch(CreateOrderReservablePaypalAndPay(OrderReservableState.fromReservableState(widget.orderState), PaymentType.paypal));
                        }else{
                          StoreProvider.of<AppState>(context).dispatch(CreateOrderReservablePaypalPending(OrderReservableState.fromReservableState(widget.orderState), PaymentType.paypal));
                        }
                      }else{
                        if (widget.orderState.isOrderAutoConfirmable()){
                          StoreProvider.of<AppState>(context).dispatch(CreateOrderPaypalAndPay(widget.orderState, PaymentType.paypal));
                        }else{
                          StoreProvider.of<AppState>(context).dispatch(CreateOrderPaypalPending(widget.orderState, PaymentType.paypal));
                        }
                      }
                    });
                  } else {
                    ///No payer id
                    Navigator.of(context).pop();
                  }
                  //Navigator.of(context).pop();
                }
                if (request.url.contains(cancelURL)) {
                  Navigator.of(context).pop();
                }


                return NavigationDecision.navigate;
              },
            ),
          )
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left,
                color: Colors.white,
                size: 25.0,),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
          elevation: 0.0,
        ),
        body: Center(
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                      height: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/img/brand/bg_paypal.png')
                        )
                      ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: BuytimeTheme.BackgroundCerulean.withOpacity(.8),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: SizeConfig.safeBlockVertical * 20,
                              height: SizeConfig.safeBlockVertical * 20,
                              child: Center(
                                child: SpinKitRipple(
                                  color: Colors.white,
                                  size: SizeConfig.safeBlockVertical * 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}