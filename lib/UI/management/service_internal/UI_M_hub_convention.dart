import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/service/convention_slot_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class UI_M_HubConvention extends StatefulWidget {

  bool createSlot = false;
  bool editSlot = false;
  int indexSlot = -1;
  ConventionSlot conventionSlot;
  UI_M_HubConvention({this.createSlot, this.editSlot, this.indexSlot, this.conventionSlot});
  Widget create(BuildContext context) {
    //final pageIndex = context.watch<Spinner>();
    return ChangeNotifierProvider<Convention>(
      create: (_) => Convention(true,[]),
      child: UI_M_HubConvention(createSlot: createSlot, editSlot: editSlot, indexSlot: indexSlot, conventionSlot: conventionSlot,)
    );
  }

  @override
  State<StatefulWidget> createState() => UI_M_HubConventionState();
}

class UI_M_HubConventionState extends State<UI_M_HubConvention> {
  int currentStep = 0;
  bool rippleLoading = false;
  int numberOfInterval = 0;
  int discountPercentage;
  final TextEditingController _hubController = TextEditingController();
  List<BusinessState> hubsList = [];

  bool allHubs = true;

  ConventionSlot conventionSlotAllHubs = ConventionSlot(hubName: "allHubs", hubId: "allHubs", discount: 0);
  List<ConventionSlot> conventionSlotList = [];
  TextEditingController discountController = TextEditingController();
  String discount = '';

  @override
  initState() {
    super.initState();
    discountController.text = widget.conventionSlot.discount.toString();
  }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    Stream<QuerySnapshot> businessStream = FirebaseFirestore.instance
        .collection("business")
        .where("hub", isEqualTo: true).snapshots(includeMetadataChanges: true);
    return WillPopScope(
      onWillPop: () async {
        ///Block iOS Back Swipe
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Scaffold(
                  appBar: BuytimeAppbar(
                    width: media.width,
                    children: [
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.keyboard_arrow_left, color: BuytimeTheme.SymbolWhite,),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Utils.barTitle(AppLocalizations.of(context).slotManagement),
                      SizedBox(
                        width: 30.0,
                      ),
                    ],
                  ),
                  body: Theme(
                    data: ThemeData(
                        primaryColor: BuytimeTheme.ManagerPrimary
                    ),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(),
                          child: Padding(
                              padding: const EdgeInsets.only(
                                top: 20.0,
                              ),
                              child: Column(
                                children: [
                                  ///All hub switch
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 20.0, right: 20.0),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Switch(
                                              activeColor: BuytimeTheme.ManagerPrimary,
                                              value: Provider.of<Convention>(context, listen: false).allHubs,
                                              onChanged:  (value) {
                                                setState(() {
                                                  allHubs = value;
                                                  Provider.of<Convention>(context, listen: false).initAllHubs(allHubs);
                                                });
                                              }
                                          ),
                                          Expanded(
                                            child: Text(
                                              AppLocalizations.of(context).sameDiscountOnAllHubs,
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontSize: media.height * 0.018,
                                                color: BuytimeTheme.TextGrey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ///Hub List
                                  buildListConventionElement(context, businessStream),

                                  ///Add new
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
                                    child: Container(
                                      width: 208,
                                      height: 44,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {

                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.add, color: BuytimeTheme.ManagerPrimary, size:24),
                                              Container(
                                                width: 150,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    AppLocalizations.of(context).addNewConventionUpper,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: BuytimeTheme.ManagerPrimary,
                                                      fontWeight: FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ///Save
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20.0,),
                                        child: Container(
                                          width: 208,
                                          height: 44,
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor: BuytimeTheme.ManagerPrimary,
                                            ),
                                            onPressed: () {
                                              StoreProvider.of<AppState>(context).state.serviceState.conventionSlotList.forEach((element) {
                                                debugPrint('THIS SERVICE CONVENTIONS BEFORE: ${element.hubId} | ${element.hubName} | ${element.discount}');
                                                if(element.hubId == widget.conventionSlot.hubId){
                                                  element.discount = int.parse(discountController.text);
                                                  element.hubName = _hubController.text;
                                                  hubsList.forEach((hub) {
                                                    if(hub.name == element.hubName)
                                                      element.hubId = hub.id_firestore;
                                                  });
                                                }
                                                debugPrint('THIS SERVICE CONVENTIONS AFTER: ${element.hubId} | ${element.hubName} | ${element.discount}');
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(0.0),
                                              child: Text(
                                                AppLocalizations.of(context).saveUpper,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: BuytimeTheme.TextWhite,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )

                          ),
                        ),
                      ),
                    ),
                  )
              ),
            ),
          ),

          ///Ripple Effect
          rippleLoading
              ? Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
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
              : Container()
        ],
      )
    );
  }

  Column buildListConventionElement(BuildContext context, Stream<QuerySnapshot> businessStream) {
    return Column(
              children: [
                ///Dropdown
                StreamBuilder<QuerySnapshot>(
                    stream: businessStream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> hubSnapshot) {
                      hubsList.clear();
                      if (hubSnapshot.hasError || hubSnapshot.connectionState == ConnectionState.waiting && hubsList.isEmpty) {
                        return  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator()
                              ],
                            )
                          ],
                        );
                      }
                      hubSnapshot.data.docs.forEach((element) {
                        BusinessState businessState = BusinessState.fromJson(element.data());
                        hubsList.add(businessState);
                      });

                      hubsList.forEach((hub) {
                        //debugPrint('HUB ID: ${hub.id_firestore} - CONVENTION HUB ID: ${widget.conventionSlot.hubId}');
                        if(hub.id_firestore == widget.conventionSlot.hubId){
                          debugPrint('HUB FOUND!');
                          _hubController.text = widget.conventionSlot.hubName;
                          discount = widget.conventionSlot.discount.toString();
                          allHubs = false;
                        }
                      });

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Provider.of<Convention>(context, listen: false).initAllHubs(allHubs);
                        Provider.of<Convention>(context, listen: false).initHubList(hubsList);
                      });



                      if(hubSnapshot.connectionState == ConnectionState.active)
                        return  Container(
                            width: 335.0,
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                            decoration: BoxDecoration(border: Border.all(color: BuytimeTheme.SymbolLightGrey), borderRadius: BorderRadius.all(Radius.circular(5))),
                            child: GestureDetector(
                              onTap: (){
                                FocusScope.of(context).unfocus();
                              },
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton(
                                    onTap: (){
                                      FocusScope.of(context).unfocus();
                                    },
                                    disabledHint: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          AppLocalizations.of(context).allHubs,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: BuytimeTheme.TextMedium,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    hint: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          _hubController.text != null ? _hubController.text : AppLocalizations.of(context).select,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: BuytimeTheme.TextMedium,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    items: allHubs ? null :
                                    hubsList.map(
                                          (val) {
                                        return DropdownMenuItem<String>(
                                          value: val.name,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Text(
                                                    val.name,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: BuytimeTheme.TextMedium,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )?.toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _hubController.text = value;
                                        // orderState.location = value;
                                        // StoreProvider.of<AppState>(context).dispatch(UpdateOrder(orderState));
                                      });
                                    },
                                    style: Theme.of(context).textTheme.headline1,
                                  ),
                                ),
                              ),
                            )

                        );

                      return Container();
                    }
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: discountController,
                    //initialValue: discount,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    decoration: const InputDecoration(labelText: '%'),
                    onChanged: (value) {
                        debugPrint('DISOCOUNT CHANGED FROM $discount TO $value');

                      },
                    onSaved: (v){

                    },
                    onEditingComplete: (){
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            );
  }
}

class Convention with ChangeNotifier{
  bool allHubs;
  List<BusinessState> hubList;
  Convention(this.allHubs, this.hubList);

  initAllHubs(bool allHubs){
    this.allHubs = allHubs;
    debugPrint('LOAD ALL HUBS');
    notifyListeners();
  }
  initHubList(List<BusinessState> hubList){
    this.hubList = hubList;
    debugPrint('LOAD HUB LIST');
    notifyListeners();
  }

  clear(){
    this.allHubs = false;
    this.hubList = [];
  }

}
