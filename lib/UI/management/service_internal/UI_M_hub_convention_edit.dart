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

class HubConventionEdit extends StatefulWidget {
  bool createSlot = false;
  bool editSlot = false;
  int indexSlot = -1;
  ConventionSlot conventionSlot;

  HubConventionEdit({this.createSlot, this.editSlot, this.indexSlot, this.conventionSlot});

  @override
  State<StatefulWidget> createState() => HubConventionEditState();
}

class HubConventionEditState extends State<HubConventionEdit> {
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
  Stream<QuerySnapshot> businessStream;
  @override
  initState() {
    businessStream = FirebaseFirestore.instance
        .collection("business")
        .where("hub", isEqualTo: true).snapshots(includeMetadataChanges: true);
    super.initState();
    discountController.text = widget.conventionSlot.discount.toString();
    _hubController.text = widget.conventionSlot.hubName;
    if(_hubController.text != "allHubs"){
      allHubs = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          ///Block iOS Back Swipe
          if (Navigator.of(context).userGestureInProgress)
            return false;
          else
            return true;
        },
        child: StreamBuilder<QuerySnapshot>(
            stream: businessStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> hubSnapshot) {
              hubsList.clear();
              if (hubSnapshot.hasError || hubSnapshot.connectionState == ConnectionState.waiting && hubsList.isEmpty) {
                return CircularProgressIndicator();
              }
              hubSnapshot.data.docs.forEach((element) {
                BusinessState businessState = BusinessState.fromJson(element.data());
                hubsList.add(businessState);
              });

              return Stack(
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
                                          buildListConventionElement(context),
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
              );
            }
        )
    );
  }

  Column buildListConventionElement(BuildContext context) {
    return Column(
      children: [
        ///Dropdown
        Container(
            width: 335.0,
            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
            decoration: BoxDecoration(border: Border.all(color: BuytimeTheme.SymbolLightGrey), borderRadius: BorderRadius.all(Radius.circular(5))),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
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
                  items: allHubs ?
                  null :
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
            )

        ),
        Container(
          padding: EdgeInsets.all(20.0),
          child: TextFormField(
              controller: discountController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(labelText: '%'),
          ),
        ),
      ],
    );
  }
}
