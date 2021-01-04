import 'dart:core';
import 'package:BuyTime/UI/management/business/UI_C_business_list.dart';
import 'package:BuyTime/UI/user/UI_U_Tabs.dart';
import 'package:BuyTime/UI/user/business/UI_U_business_list.dart';
import 'package:BuyTime/UI/user/landing/invite_guest_form.dart';
import 'package:BuyTime/UI/user/landing/test.dart';
import 'package:BuyTime/UI/user/login/UI_U_Home.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/reducer/business_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/business_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_snippet_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_snippet_reducer.dart';
import 'package:BuyTime/reblox/reducer/filter_reducer.dart';
import 'package:BuyTime/reblox/reducer/order_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/order_reducer.dart';
import 'package:BuyTime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/pipeline_reducer.dart';
import 'package:BuyTime/reblox/reducer/service_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/service_reducer.dart';
import 'package:BuyTime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:BuyTime/reblox/reducer/user_reducer.dart';
import 'package:BuyTime/reusable/custom_bottom_button_widget.dart';
import 'package:BuyTime/reusable/landing_card_widget.dart';
import 'package:BuyTime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:BuyTime/utils/globals.dart';
import 'package:BuyTime/utils/size_config.dart';
import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class Landing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LandingState();
}

class LandingState extends State<Landing> {

  List<LandingCardWidget> cards = new List();
  @override
  void initState() {
    super.initState();
    cards.add(LandingCardWidget('Inserisci il Booking Code', 'Inizia il tuo viaggio', 'assets/img/booking_code.png', null));
    cards.add(LandingCardWidget('About Buytime', 'Scopri la nostra rete', 'assets/img/beach_girl.png', null));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);


    return WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).unfocus();
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: Container(
                height: SizeConfig.safeBlockVertical * 100,
                child: Column(
                  children: [
                    ///Celurian Part
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: double.infinity,
                        color: BuytimeTheme.BackgroundCerulean,
                        child: Column(
                          children: [
                            ///Welcome text & Share icon
                            Expanded(
                              flex: 2,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ///Welcome text
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 8),
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Text(
                                          'Benvenuto su Buytime',
                                          style: TextStyle(
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: SizeConfig.safeBlockHorizontal * 7.5
                                          ),
                                        )
                                    ),
                                  ),
                                  ///Share icon
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, right: SizeConfig.safeBlockHorizontal * 4),
                                      child: IconButton(
                                        onPressed: (){
                                          final RenderBox box = context.findRenderObject();
                                          Share.share('Share',
                                              subject: 'Test',
                                              sharePositionOrigin:
                                              box.localToGlobal(Offset.zero) &
                                              box.size);
                                        },
                                        icon: Icon(
                                          Icons.share,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ///Description
                            Expanded(
                              flex: 3,
                              child: Container(
                                  margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 8, right: SizeConfig.safeBlockHorizontal * 8),
                                  child: Text(
                                    'Quando prenoti con un Buytime Enabled® Hotel, '
                                        'ti verrà concesso l\'accesso alle strutture del tuo hotel tramite l\'app Buytime.\n\n'
                                        'Prenota massaggi e richiedi un drink con due soli tocchi.',
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18//SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    ///Card list & Booking history & Contact us & Log out
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          ///Card list & Booking history
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                ///Card list
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                    alignment: Alignment.centerLeft,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: cards.length,
                                      itemBuilder: (context, index){
                                        LandingCardWidget landingCard = cards.elementAt(index);
                                        return Container(
                                          margin: EdgeInsets.all(2.5),
                                          child: _OpenContainerWrapper(
                                            index: index,
                                            closedBuilder: (BuildContext _, VoidCallback openContainer) {
                                              landingCard.callback = openContainer;
                                              return landingCard;
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                ///Booking history
                                Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 8, bottom: SizeConfig.safeBlockVertical * 1),
                                    alignment: Alignment.centerLeft,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                          onTap: (){

                                          },
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          child: Container(
                                            padding: EdgeInsets.all(5.0),
                                            child: Text(
                                              'CRONOLOGIA BOOKINGS',
                                              style: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: Color(0xff207cc3),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 4
                                              ),
                                            ),
                                          )
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          ///Contact us & Log out
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ///Contact us
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.white,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () async{
                                          String url = '000 000 0000'.trim();
                                          debugPrint('Restaurant phonenumber: ' + url);
                                          if (await canLaunch('tel:$url')) {
                                            await launch('tel:$url');
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        child: CustomBottomButtonWidget(
                                            'Contattaci',
                                            'Hai domande?',
                                            Icon(
                                              Icons.call,
                                              color: Colors.grey,
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ///Log out
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.white,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                          onTap: () async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();

                                            await prefs.setBool('easy_check_in', false);
                                            await prefs.setBool('star_explanation', false);

                                            FirebaseAuth.instance.signOut().then((_) {
                                              googleSignIn.signOut();

                                              facebookSignIn.logOut();
                                              //Resetto il carrello
                                              cartCounter = 0;

                                              //Svuotare lo Store sul Logout
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetCategoryToEmpty());
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetCategoryListToEmpty());
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetCategorySnippetToEmpty());
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetCategorySnippetListToEmpty());
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetFilterToEmpty());
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetOrderToEmpty(""));
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetOrderListToEmpty());
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetBusinessToEmpty());
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetBusinessListToEmpty());
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetServiceToEmpty());
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetServiceListToEmpty());
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetPipelineToEmpty());
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetPipelineListToEmpty());
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetStripeToEmpty());
                                              StoreProvider.of<AppState>(context)
                                                  .dispatch(SetUserStateToEmpty());
                                              //Torno al Login
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => Home()),
                                              );
                                            });
                                          },
                                          child: CustomBottomButtonWidget(
                                              'Log out',
                                              '',
                                              Icon(
                                                Icons.logout,
                                                color: Colors.grey,
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}


class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    this.closedBuilder,
    this.transitionType,
    this.onClosed,
    this.index
  });

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool> onClosed;
  final int index;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (BuildContext context, VoidCallback _) {
        return index == 0 ? InviteGuestForm() : UI_U_Tabs();
      },
      onClosed: onClosed,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      tappable: false,
      closedBuilder: closedBuilder,
      transitionDuration: Duration(milliseconds: 800),
    );
  }
}




