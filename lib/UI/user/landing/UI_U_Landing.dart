import 'dart:core';

import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/user/UI_U_Tabs.dart';
import 'package:Buytime/UI/user/booking/UI_U_PastBooking.dart';
import 'package:Buytime/UI/user/landing/invite_guest_form.dart';
import 'package:Buytime/UI/user/login/UI_U_Home.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/filter_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/reusable/custom_bottom_button_widget.dart';
import 'package:Buytime/reusable/landing_card_widget.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Landing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LandingState();
}

class LandingState extends State<Landing> {
  List<LandingCardWidget> cards = new List();

  @override
  void initState() {
    super.initState();
    cards.add(LandingCardWidget('Enter booking code', 'Start your journey', 'assets/img/booking_code.png', null));
    cards.add(LandingCardWidget('About Buytime', 'Discover our network', 'assets/img/beach_girl.png', null));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initDynamicLinks();
    });
  }

  void initDynamicLinks() async {
    print("Dentro initial dynamic");
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('booking')) {
          String id = deepLink.queryParameters['booking'];
          debugPrint('splash_screen: booking: $id');
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => InviteGuestForm(id)));
        }
        else if (deepLink.queryParameters.containsKey('categoryInvite')) {
          String id = deepLink.queryParameters['categoryInvite'];
          debugPrint('splash_screen: categoryInvite: $id');
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => InviteGuestForm(id)));
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    await Future.delayed(Duration(seconds: 2));

    ///Serve un delay che altrimenti getInitialLink torna NULL
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      if (deepLink.queryParameters.containsKey('booking')) {
        String id = deepLink.queryParameters['booking'];
        debugPrint('splash_screen: booking: $id');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => InviteGuestForm(id)));
      }
      else if (deepLink.queryParameters.containsKey('categoryInvite')) {
        String id = deepLink.queryParameters['categoryInvite'];
        debugPrint('splash_screen: categoryInvite: $id');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>InviteGuestForm(id)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    var isManagerOrAbove = false;


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
                                          AppLocalizations.of(context).welcomeToBuytime,
                                          style: TextStyle(
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: SizeConfig.safeBlockHorizontal * 7.5),
                                        )),
                                  ),
                                  ///Share icon
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, right: SizeConfig.safeBlockHorizontal * 4),
                                      child: IconButton(
                                        onPressed: () async{
                                          /*final RenderBox box = context.findRenderObject();
                                          Uri link = await createDynamicLink('prova');
                                          Share.share(AppLocalizations.of(context).checkYourBuytimeApp + link.toString(), subject: AppLocalizations.of(context).takeYourTime, sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                                          Share.share('Share', subject:
                                          Platform.isAndroid ?
                                              'https://play.google.com/store/apps/details?id=com.theoptimumcompany.buytime' :
                                          'Test'
                                              , sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);*/
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
                                  margin: EdgeInsets.only(
                                      bottom: SizeConfig.safeBlockVertical * 1,
                                      left: SizeConfig.safeBlockHorizontal * 8,
                                      right: SizeConfig.safeBlockHorizontal * 8),
                                  child: Text(
                                    AppLocalizations.of(context).whenYouBookWith,
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18 //SizeConfig.safeBlockHorizontal * 4
                                        ),
                                  )),
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
                                      child: CustomScrollView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        slivers: [
                                          SliverList(
                                            delegate: SliverChildBuilderDelegate(
                                              (context, index) {
                                                LandingCardWidget landingCard = cards.elementAt(index);
                                                return Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: _OpenContainerWrapper(
                                                    index: index,
                                                    closedBuilder: (BuildContext _, VoidCallback openContainer) {
                                                      landingCard.callback = openContainer;
                                                      return landingCard;
                                                    },
                                                  ),
                                                );
                                              },
                                              childCount: cards.length,
                                            ),
                                          ),
                                        ],
                                      )),
                                ),

                                ///Booking history
                                Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 8, bottom: SizeConfig.safeBlockVertical * 1),
                                    alignment: Alignment.centerLeft,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => PastBooking()),
                                            );
                                          },
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          child: Container(
                                            padding: EdgeInsets.all(5.0),
                                            child: Text(
                                              AppLocalizations.of(context).viewPastBookings,
                                              style: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: BuytimeTheme.UserPrimary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 4),
                                            ),
                                          )),
                                    )),
                              ],
                            ),
                          ),

                          ///Contact us & Log out
                          StoreConnector<AppState, AppState>(
                              converter: (store) => store.state,
                              builder: (context, snapshot) {
                                isManagerOrAbove = snapshot.user != null && (snapshot.user.getRole() != Role.user) ? true : false;
                                return Expanded(
                                  flex: isManagerOrAbove ? 3 : 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ///Go to business management IF manager role or above.
                                      isManagerOrAbove ? Flexible(
                                        flex: 1,
                                        child: Container(
                                          color: Colors.white,
                                          height: 60,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () async {
                                                StoreProvider.of<AppState>(context).dispatch(SetBusinessListToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetOrderListToEmpty());
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UI_M_BusinessList()),
                                                );
                                              },
                                              child: CustomBottomButtonWidget(
                                                  Text(
                                                    AppLocalizations.of(context).goToBusiness,
                                                    style: TextStyle(
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: Colors.black.withOpacity(.7),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16
                                                    ),
                                                  ),
                                                  '',
                                                  Icon(
                                                    Icons.business_center,
                                                    color: BuytimeTheme.SymbolGrey,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ): Container(),
                                      ///Contact us
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          color: Colors.white,
                                          height: 60,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () async {
                                                String url = BuytimeConfig.FlaviosNumber.trim();
                                                debugPrint('Restaurant phonenumber: ' + url);
                                                if (await canLaunch('tel:$url')) {
                                                  await launch('tel:$url');
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              },
                                              child: CustomBottomButtonWidget(
                                                  Text(
                                                    AppLocalizations.of(context).contactUs,
                                                    style: TextStyle(
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: Colors.black.withOpacity(.7),
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16
                                                    ),
                                                  ),
                                                  AppLocalizations.of(context).haveAnyQuestion,
                                                  Icon(
                                                    Icons.call,
                                                    color: BuytimeTheme.SymbolGrey,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),

                                      ///Log out
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          color: Colors.white,
                                          height: 60,
                                          padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1),
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
                                                    StoreProvider.of<AppState>(context).dispatch(SetCategoryToEmpty());
                                                    StoreProvider.of<AppState>(context).dispatch(SetCategoryListToEmpty());
                                                    StoreProvider.of<AppState>(context).dispatch(SetCategoryTreeToEmpty());
                                                    StoreProvider.of<AppState>(context).dispatch(SetFilterToEmpty());
                                                    StoreProvider.of<AppState>(context).dispatch(SetOrderToEmpty(""));
                                                    StoreProvider.of<AppState>(context).dispatch(SetOrderListToEmpty());
                                                    StoreProvider.of<AppState>(context).dispatch(SetBusinessToEmpty());
                                                    StoreProvider.of<AppState>(context).dispatch(SetBusinessListToEmpty());
                                                    StoreProvider.of<AppState>(context).dispatch(SetServiceToEmpty());
                                                    StoreProvider.of<AppState>(context).dispatch(SetServiceListToEmpty());
                                                    StoreProvider.of<AppState>(context).dispatch(SetPipelineToEmpty());
                                                    StoreProvider.of<AppState>(context).dispatch(SetPipelineListToEmpty());
                                                    StoreProvider.of<AppState>(context).dispatch(SetStripeToEmpty());
                                                    StoreProvider.of<AppState>(context).dispatch(SetUserStateToEmpty());
                                                    //Torno al Login
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => Home()),
                                                    );
                                                  });
                                                },
                                                child: CustomBottomButtonWidget(
                                                    Text(
                                                      AppLocalizations.of(context).logOut,
                                                      style: TextStyle(
                                                          fontFamily: BuytimeTheme.FontFamily,
                                                          color: Colors.black.withOpacity(.7),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 16
                                                      ),
                                                    ),
                                                    '',
                                                    Icon(
                                                      Icons.logout,
                                                      color: BuytimeTheme.SymbolGrey,
                                                    ))),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({this.closedBuilder, this.transitionType, this.onClosed, this.index});

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool> onClosed;
  final int index;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (BuildContext context, VoidCallback _) {
        return index == 0 ? InviteGuestForm('') : UI_U_Tabs();
      },
      onClosed: onClosed,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      tappable: false,
      closedBuilder: closedBuilder,
      transitionDuration: Duration(milliseconds: 800),
    );
  }
}
