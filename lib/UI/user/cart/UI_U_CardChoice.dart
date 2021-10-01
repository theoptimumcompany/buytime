import 'dart:convert';
import 'package:Buytime/UI/user/cart/widget/W_credit_card_simple.dart';
import 'package:Buytime/UI/user/cart/widget/W_loading_button.dart';
import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
// import 'package:stripe_payment/stripe_payment.dart' as StripeRecommended;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as StripeOfficial;

import 'package:http/http.dart' as http;

import '../../../environment_abstract.dart';

class CardChoice extends StatefulWidget {
  final String title = 'cardChoice';
  bool tourist;

  CardChoice({Key key, bool tourist}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CardChoiceState();
}

class CardChoiceState extends State<CardChoice> with SingleTickerProviderStateMixin {
  CardFieldInputDetails _card;
  String _email = '';
  SetupIntent _setupIntentResult;
  String _userId = '';
  bool _saveCard = false;
  List<Widget> cardWidgetList = [];
  bool tourist;


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  bool waitingForUser = true;
  bool isExternal = false;
  bool cardOrder = false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return false;
      },
      child: StoreConnector<AppState, AppState>(
          onInit: (store) {
            store?.dispatch(CheckStripeCustomer(true));
            store?.dispatch(AddingStripePaymentMethodResetOR());
            initializeCardList(store.state.cardListState);
            debugPrint('UI_U_ConfirmOrder => ON INIT');
          },
          distinct: true,
          converter: (store) => store.state,
          builder: (context, snapshot) {
            /// check if the stripe customer have been created for this user:
            _email = snapshot.user.email;
            _userId = snapshot.user.uid;
            return
              Scaffold(
                  appBar: buildBuytimeAppbar(media, context),
                  body: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CardField(
                            onCardChanged: (card) {
                              setState(() {
                                _card = card;
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          child: Text(AppLocalizations.of(context).virtualAndPrepaidNotSupported,
                            softWrap: true,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              // letterSpacing: 1.25,
                                fontStyle: FontStyle.italic,
                                fontFamily: BuytimeTheme.FontFamily,
                                color:  BuytimeTheme.TextGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 14
                            ),
                          ),
                        ),
                        (snapshot.cardListState.cardList != null && snapshot.cardListState.cardList.length > 0) ? Container() : LoadingButton(onPressed: _requestSaveCard, text: AppLocalizations.of(context).saveYourCard),
                      ],
                    ),
                  ));

          }),
    );
  }

  Future<void> _requestSaveCard() async {
    if (_card == null) {
      return;
    }
    try {
      // 1. Create setup intent on backend
      final clientSecret = await _createSetupIntentOnBackend(_email, _userId);

      // 2. Gather customer billing information (ex. email)
      final billingDetails = BillingDetails(
        email: _email,
        phone: '+48888000888',
        name : 'John Doe',
        address: Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '77063',
        ),
      ); // mo/ mocked data for tests

      debugPrint('Setup Intent created $clientSecret, $billingDetails');

      // 3. Confirm setup intent
      final setupIntentResult = await Stripe.instance.confirmSetupIntent(
        clientSecret,
        PaymentMethodParams.card(
          billingDetails: billingDetails,
        ), {}
      ).catchError((error) {
        debugPrint('Setup Intent confirmed $error');
      });
      debugPrint('Setup Intent confirmed $setupIntentResult');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).saveYourCardSuccess)));
      setState(() {
        _setupIntentResult = setupIntentResult;
      });
      StripeOfficial.Card card = StripeOfficial.Card(
          brand: _card.brand,
        country: "IT",
        expYear: _card.expiryYear,
        expMonth: _card.expiryMonth,
        funding: "",
        last4: _card.last4
      );
      StoreProvider.of<AppState>(context).dispatch(AddStripePaymentMethod(card, _userId, setupIntentResult.paymentMethodId));
    } catch (error, s) {
      debugPrint('Error while saving payment' + error.toString() + s.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).saveYourCardError)));
    }
  }

  Future<String> _createSetupIntentOnBackend(String email, String userId) async {
    final url = Uri.https("${Environment().config.cloudFunctionLink}", "/createSetupIntent", {'userId': '$userId'});
    final response = await http.get(url);
    final Map<String, dynamic> bodyResponse = json.decode(response.body);
    final clientSecret = bodyResponse['clientSecret'] as String;
    debugPrint('Client token  $clientSecret');
    return clientSecret;
  }

  void initializeCardList(CardListState newStore) {
    if (newStore != null && newStore.cardList != null) {
      for(int i = 0; i < newStore.cardList.length; i++) {
        cardWidgetList.add(CreditCardSimpleListElement(newStore.cardList[i]));
        print("UI_U_ConfirmOrder initializeCardList => N:${newStore.cardList?.length} - ADD CARD FirebaseId: ${newStore.cardList[i].stripeState.stripeCard.firestore_id}");
        print("UI_U_ConfirmOrder initializeCardList => Attributes[0]:${newStore.cardList[0].stripeState.stripeCard.paymentMethodId} - ${newStore.cardList[0].stripeState.stripeCard.last4} - ${newStore.cardList[0].stripeState.stripeCard.brand} - ${newStore.cardList[0].stripeState.stripeCard.expMonth}- ${newStore.cardList[0].stripeState.stripeCard.expYear}- ${newStore.cardList[0].stripeState.stripeCard.expYear}");
      }
    }
  }


  Future<Map<String, dynamic>> fetchPaymentIntentClientSecret() async {
    final url = Uri.parse('${Environment().config.cloudFunctionLink}/create-payment-intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': _email,
        'currency': 'EUR',
        'items': [
          {'id': 'id'}
        ],
        'request_three_d_secure': 'any',
      }),
    );
    return json.decode(response.body);
  }
  ///App bar
  BuytimeAppbar buildBuytimeAppbar(Size media, BuildContext context) {
    return BuytimeAppbar(
      background: widget.tourist != null && widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
      width: media.width,
      children: [
        ///Back Button
        IconButton(
          icon: Icon(Icons.chevron_left, color: BuytimeTheme.TextWhite),
          onPressed: () => Future.delayed(Duration.zero, () {
            /// if the order is paid we empty the order status before leaving
            String orderProgress = StoreProvider.of<AppState>(context).state.order.progress;
            if (orderProgress == Utils.enumToString(OrderStatus.paid) || orderProgress == Utils.enumToString(OrderStatus.toBePaidAtCheckout)) {
              StoreProvider.of<AppState>(context).dispatch(SetOrder(OrderState().toEmpty()));
              Navigator.of(context).popUntil(ModalRoute.withName('/bookingPage'));
            } else {
              Navigator.of(context).pop();
            }
          }),
        ),
        ///Order Title
        Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Text(
              AppLocalizations.of(context).confirmOrder,
              textAlign: TextAlign.start,
              style: BuytimeTheme.appbarTitle,
            ),
          ),
        ),
        SizedBox(
          width: 40.0,
        ),
      ],
    );
  }

}
