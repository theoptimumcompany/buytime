import 'package:Buytime/UI/management/business/RUI_M_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/management/business/UI_M_create_business.dart';
import 'package:Buytime/UI/management/business/UI_M_manage_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/reblox/model/broadcast/broadcast_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reusable/animation/enterExitRoute.dart';
import 'package:Buytime/helper/dynamic_links/dynamic_links_helper.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/UI/management/business/widget/w_optimum_business_card_medium_manager.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/menu/w_manager_drawer.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateBroadcast extends StatefulWidget {
  static String route = '/createBroadcast';
  bool view;
  BroadcastState broadcastState;
  Widget create(BuildContext context) {
    //final pageIndex = context.watch<Spinner>();
    return ChangeNotifierProvider<Broadcast>(
      create: (_) => Broadcast([], Map()),
      child: CreateBroadcast(this.view, this.broadcastState),
    );
  }
  CreateBroadcast(this.view, this.broadcastState);
  @override
  State<StatefulWidget> createState() => CreateBroadcastState();
}

class CreateBroadcastState extends State<CreateBroadcast> {

  GlobalKey<ScaffoldState> _drawerKeyTabs = GlobalKey();

  bool startRequest = false;
  bool noActivity = false;
  bool generated = false;

  ///Storage
  final storage = new FlutterSecureStorage();
  emptyCategoryInvite() async{
    await storage.write(key: 'categoryInvite', value: '');
  }
  String orderId = '';
  String userId = '';
  List<ServiceState> serviceList = [];
  Map<String, bool> serviceSelected = Map();
  Map<String, bool> topicSelected = Map();

  @override
  void initState() {
    super.initState();
    emptyCategoryInvite();
    if(widget.broadcastState.senderId.isNotEmpty)
      messageController.text = widget.broadcastState.body;
    //initDynamicLinks();

  }

  TextEditingController messageController = TextEditingController();
  bool sending = false;
  
  List<String> topics = [];

  List<Widget> listOfTopicChips(List<String> topicList) {
    List<Widget> listOfWidget = [];
    topicList.forEach((topic) {
      listOfWidget.add(InputChip(
        onPressed: () {},
        selected: false,
        label: Text(
          topic,
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ));
    });
    //if (listOfWidget.isEmpty)
      /*listOfWidget.add(Container(
        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 1),
        child: Text(
          AppLocalizations.of(context).noManagerAssigned,
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ));*/

    return listOfWidget;
  }

  ServiceState allServices = ServiceState().toEmpty();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    SizeConfig().init(context);
    allServices.name = AppLocalizations.of(context).allServices;

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        store.state.serviceList.serviceListState.clear();
        List<String> businessIds = [];
        debugPrint('UI_M_slot_management => BUSINESS LIST LENGTH: ${store.state.businessList.businessListState.length}');
        store.state.businessList.businessListState.forEach((element) {
          businessIds.add(element.id_firestore);
          if(element.hub){
            topics.add('${AppLocalizations.of(context).guestsOf} ${element.name.toUpperCase()}');
            topicSelected.putIfAbsent(topics.last, () => false);
          }
        });
        if(topics.isNotEmpty){
          topics.add(AppLocalizations.of(context).turist);
          topicSelected.putIfAbsent(AppLocalizations.of(context).turist, () => false);
        }

        debugPrint('UI_M_crate_broadcast => BUSINESS IDS LIST LENGTH: ${businessIds.length}');
        if(!widget.view)
          store.dispatch(ServiceListRequestByBusinessIdsBroadcast(businessIds));
        noActivity = true;
        startRequest = true;

      },
      builder: (context, snapshot) {
        Locale myLocale = Localizations.localeOf(context);
        //print("UI_M_Business => Categories : ${snapshot.serviceListSnippetState.businessSnippet}");
        /*if(snapshot.serviceListSnippetState.businessSnippet != null && snapshot.serviceListSnippetState.businessSnippet.isNotEmpty){
          categories = snapshot.serviceListSnippetState.businessSnippet;
        }*/
        //debugPrint('UI_M_slot_management => IMPORTED SERVICE LENGTH: ${snapshot.externalServiceImportedListState.externalServiceImported.length}');

        if(snapshot.serviceList.serviceListState.isEmpty && startRequest){
          noActivity = true;
        }else{
          if(snapshot.serviceList.serviceListState.isNotEmpty){
            //serviceList.clear();
            print("UI_M_crate_broadcast => Service List Length: ${snapshot.serviceList.serviceListState.length}");
            serviceList = snapshot.serviceList.serviceListState;
            if(!serviceList.contains(allServices)){
              serviceList.add(allServices);
            }
            serviceList.sort((a, b) => (Utils.retriveField(myLocale.languageCode, a.name)).compareTo(Utils.retriveField(myLocale.languageCode, b.name)));
            serviceList.forEach((service) {
              serviceSelected.putIfAbsent(service.name, () => false);
            });

            //serviceList.sort((a,b) => a.name.compareTo(b.name));
            noActivity = false;
            startRequest = false;
          }
        }
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
              key: _drawerKeyTabs,
              appBar: AppBar(
                backgroundColor: Colors.white,
                brightness: Brightness.dark,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  //key: Key('business_drawer_key'),
                  icon: const Icon(
                    Icons.close,
                    color: BuytimeTheme.TextBlack,
                    //size: 30.0,
                  ),
                  //tooltip: AppLocalizations.of(context).showMenu,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              drawer: ManagerDrawer(),
              body: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: new BoxConstraints(
                    maxHeight: SizeConfig.safeBlockVertical * 92.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///Interested services
                          !widget.view ?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ///Header
                              Container(
                                  margin: EdgeInsets.only(left: 16),
                                  child: Text(
                                    AppLocalizations.of(context).selectInterestedServices,
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextMedium,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14 ///SizeConfig.safeBlockHorizontal * 7
                                    ),
                                  )),
                              ///Chips
                              noActivity ?
                              Container(
                                margin: EdgeInsets.only(top: 12),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator()
                                      ],
                                    )
                                  ],
                                ),
                              ) :
                              serviceList.isNotEmpty ?
                              ConstrainedBox(
                                  constraints: new BoxConstraints(
                                    maxHeight: SizeConfig.safeBlockVertical * 20,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Container(
                                            margin: EdgeInsets.only(left: 16, top: 7, bottom: 12),
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                Wrap(
                                                  spacing: 5,
                                                  children: serviceList.map((e) => InputChip(
                                                    selected: false,
                                                    backgroundColor: serviceSelected[e.name] ?
                                                    BuytimeTheme.ManagerPrimary : BuytimeTheme.SymbolLightGrey,
                                                    label: Text(
                                                      Utils.retriveField(Localizations.localeOf(context).languageCode, e.name),
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight: FontWeight.w500,
                                                          color: BuytimeTheme.TextWhite
                                                      ),
                                                    ),
                                                    //avatar: FlutterLogo(),
                                                    onPressed: serviceSelected[AppLocalizations.of(context).allServices] && e.name != AppLocalizations.of(context).allServices ? null :  () {
                                                      setState(() {
                                                        serviceSelected[e.name] = !serviceSelected[e.name];
                                                      });
                                                    },
                                                  ))
                                                      .toList(),
                                                ),
                                              ],
                                            )
                                        ),
                                      )
                                    ],
                                  )
                              ) : Container()
                            ],
                          ) : Container(),
                          ///Select Recipient
                          topics.isNotEmpty && !widget.view ?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Header
                              Container(
                                  margin: EdgeInsets.only(left: 16),
                                  child: Text(
                                    AppLocalizations.of(context).selectRecipient,
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextMedium,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14 ///SizeConfig.safeBlockHorizontal * 7
                                    ),
                                  )),
                              ///Chips
                              ConstrainedBox(
                                  constraints: new BoxConstraints(
                                    maxHeight: SizeConfig.safeBlockVertical * 20,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Container(
                                            margin: EdgeInsets.only(left: 16, top: 7, bottom: 7),
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                Wrap(
                                                  spacing: 5,
                                                  children: topics.map((e) => InputChip(
                                                    selected: false,
                                                    backgroundColor: topicSelected[e] ?
                                                    BuytimeTheme.ManagerPrimary : BuytimeTheme.SymbolLightGrey,
                                                    label: Text(
                                                      e,
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight: FontWeight.w500,
                                                          color: BuytimeTheme.TextWhite
                                                      ),
                                                    ),
                                                    //avatar: FlutterLogo(),
                                                    onPressed: topicSelected[AppLocalizations.of(context).turist] && e != AppLocalizations.of(context).turist ? null : () {
                                                      setState(() {
                                                        topicSelected[e] = !topicSelected[e];
                                                      });
                                                    },
                                                  ))
                                                      .toList(),
                                                ),
                                              ],
                                            )
                                        ),
                                      )
                                    ],
                                  )
                              )
                            ],
                          ) : Container(),
                          Container(
                            child: Divider(
                              indent: 0.0,
                              color: BuytimeTheme.DividerGrey,
                              thickness: 1.0,
                            ),
                          ),
                          ///TextFiled
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(left: 16, right: 16),
                              child: TextFormField(
                                readOnly: widget.view,
                                controller: messageController,
                                textAlign: TextAlign.start,
                                maxLines: 10,
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  //errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  //labelText: AppLocalizations.of(context).writeSomething,
                                  //helperText: AppLocalizations.of(context).searchForServicesAndIdeasAroundYou,
                                  hintText:AppLocalizations.of(context).writeSomething,
                                  hintStyle: TextStyle(
                                      color: Color(0xff666666),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      fontFamily: BuytimeTheme.FontFamily
                                  ),
                                  labelStyle: TextStyle(
                                    fontFamily: BuytimeTheme.FontFamily,
                                    color: Color(0xff666666),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  helperStyle: TextStyle(
                                    fontFamily: BuytimeTheme.FontFamily,
                                    color: Color(0xff666666),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w400, fontSize: 16),
                                onEditingComplete: () {
                                  debugPrint('UI_M_add_external_service_list => done');
                                  FocusScope.of(context).unfocus();

                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      ///Button
                      !widget.view ?
                      Container(
                        //height: double.infinity,
                        //color: Colors.black87,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ///Confirm button
                            Container(
                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical * 2),
                                width: 198,
                                ///media.width * .4
                                height: 44,
                                child: MaterialButton(
                                  key: Key('service_reserve_key'),
                                  elevation: 0,
                                  hoverElevation: 0,
                                  focusElevation: 0,
                                  highlightElevation: 0,
                                  onPressed: () async{
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      sending = true;
                                    });
                                    BroadcastState broadcastState = BroadcastState().toEmpty();
                                    broadcastState.body = messageController.text;
                                    broadcastState.timestamp = DateTime.now();
                                    broadcastState.sendTime = DateTime.now();
                                    broadcastState.sendNow = true;
                                    broadcastState.topic = 'broadcast_user';
                                    broadcastState.title = 'Broadcast Message';
                                    broadcastState.senderId = StoreProvider.of<AppState>(context).state.user.uid;
                                    await FirebaseFirestore.instance.collection("broadcast").doc().set(broadcastState.toJson()).then((value) => setState(() {
                                      //debugPrint('SEND VALUE: $value');
                                      sending = false;
                                    }));
                                    Flushbar(
                                      padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
                                      margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2, left: SizeConfig.blockSizeHorizontal * 20, right: SizeConfig.blockSizeHorizontal * 20),

                                      ///2% - 20% - 20%
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      backgroundColor: BuytimeTheme.SymbolGrey,
                                      boxShadows: [
                                        BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(3, 3),
                                          blurRadius: 3,
                                        ),
                                      ],
                                      // All of the previous Flushbars could be dismissed by swiping down
                                      // now we want to swipe to the sides
                                      //dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                                      // The default curve is Curves.easeOut
                                      duration: Duration(seconds: 2),
                                      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                                      messageText: Text(
                                        AppLocalizations.of(context).messageSent,
                                        style: TextStyle(color: BuytimeTheme.TextWhite, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    )..show(context);
                                  },
                                  textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                  color: BuytimeTheme.ActionBlackPurple,
                                  disabledColor: BuytimeTheme.SymbolLightGrey,
                                  padding: EdgeInsets.all(media.width * 0.03),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(20),
                                  ),
                                  child: sending ? Container(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ) : Text(
                                    AppLocalizations.of(context).send,
                                    style: TextStyle(
                                      letterSpacing: 1.25,
                                      fontSize: 14,
                                      fontFamily: BuytimeTheme.FontFamily,
                                      fontWeight: FontWeight.w500,
                                      color: BuytimeTheme.TextWhite,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ) : Container()
                    ],
                  ),
                ),
              )
          ),
        );
      },
    );
  }
}

class Broadcast with ChangeNotifier{
  List<ServiceState> serviceList;
  Map<String, bool> serviceSelected;
  Broadcast(this.serviceList, this.serviceSelected);


  initServiceList(List<ServiceState> serviceList){
    this.serviceList = serviceList;
    debugPrint('RUI_U_service_explorer => SERVICE LIST INIT');
    notifyListeners();
  }

  clear(){
    this.serviceList.clear();
    this.serviceSelected.clear();
    notifyListeners();
  }

}
