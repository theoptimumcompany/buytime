import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OptimumCreditCardButtonCallback = void Function();
typedef OptimumCreditCardDisposeCallback = void Function(StripeCardResponse stripeCardResponse);

class OptimumCreditCardButton extends StatefulWidget {
  OptimumCreditCardButtonCallback onCreditCardButtonTap;
  OptimumCreditCardDisposeCallback onCreditCardDisposeTap;
  StripeCardResponse stripeCardResponse;
  Size mediaSize;

  OptimumCreditCardButton({this.stripeCardResponse, this.onCreditCardButtonTap, this.onCreditCardDisposeTap, @required this.mediaSize}){
    this.mediaSize = mediaSize;
  }

  @override
  _OptimumCreditCardButtonState createState() => _OptimumCreditCardButtonState(stripeCardResponse: stripeCardResponse, onCreditCardButtonTap: onCreditCardButtonTap, onCreditCardDisposeTap: onCreditCardDisposeTap, mediaSize: mediaSize);
}

class _OptimumCreditCardButtonState extends State<OptimumCreditCardButton> {
  OptimumCreditCardButtonCallback onCreditCardButtonTap;
  OptimumCreditCardDisposeCallback onCreditCardDisposeTap;
  StripeCardResponse stripeCardResponse;
  Size mediaSize;
  bool showDisposeIcon = false;
  double clickableOpacity = 1.0;

  _OptimumCreditCardButtonState({this.stripeCardResponse, this.onCreditCardButtonTap, this.onCreditCardDisposeTap, this.mediaSize});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    String capitalizedBrand = stripeCardResponse.brand[0].toUpperCase() + stripeCardResponse.brand.substring(1, stripeCardResponse.brand.length);
    return Column(
      children: [
        SizedBox(height: 10.0,),
        Container(
          width: media.width,
          child: GestureDetector(
            onTap: () {
              if (!showDisposeIcon) {
                onCreditCardButtonTap();
              }
            },
            onLongPress:() {
              setState(() {
                showDisposeIcon = !showDisposeIcon;
                clickableOpacity = showDisposeIcon ? 0.2 : 1.0;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedOpacity(
                  opacity: clickableOpacity,
                  duration: Duration(seconds: 1),
                  child: stripeCardResponse.brand == "visa" ?
                  Image.asset("assets/img/visa.jpg", width: media.width * 0.16,) :
                  Image.asset("assets/img/mastercard.png", width: media.width * 0.16,),
                ),
                SizedBox(width: media.width * 0.05,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Color.fromRGBO(33, 33, 33, 0.1)),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedOpacity(
                            opacity: clickableOpacity,
                            duration: Duration(seconds: 1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  capitalizedBrand + AppLocalizations.of(context).ending + stripeCardResponse.last4,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.black
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(stripeCardResponse.expMonth.toString() + "/" + stripeCardResponse.expYear.toString(),
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black
                                        )),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          showDisposeIcon ?
                              IconButton(icon: Icon(Icons.delete, color: Color.fromRGBO(249, 99, 99, 1.0), size: 40.0,), onPressed: () {
                                onCreditCardDisposeTap(stripeCardResponse);
                              })
                              :
                          Icon(Icons.chevron_right, size: 30.0, color: Colors.black,)

                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
