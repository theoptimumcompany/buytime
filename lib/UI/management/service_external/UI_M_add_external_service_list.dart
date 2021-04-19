import 'dart:math';

import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/service_external/UI_M_external_service_list.dart';
import 'package:Buytime/UI/management/service_external/widget/W_add_external_business_list_item.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/external_business_list_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/reusable/material_design_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AddExternalServiceList extends StatefulWidget {
  bool fromMy;
  AddExternalServiceList(this.fromMy);
  @override
  State<StatefulWidget> createState() => AddExternalServiceListState();
}

class AddExternalServiceListState extends State<AddExternalServiceList> {

  List<ExternalBusinessState> externalServiceList = [];
  TextEditingController _searchController = TextEditingController();
  String sortBy = '';
  ExternalBusinessState tmpBusiness = ExternalBusinessState();

  bool startRequest = false;
  bool noActivity = false;

  @override
  void initState() {
    super.initState();
    //externalServiceList.add(tmpBusiness);
  }

  Future<bool> _onWillPop() {}

  void undoDeletion(index, ExternalBusinessState item) {
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState(() {
      //orderState.addReserveItem(item., snapshot.business.ownerId, widget.serviceState.serviceSlot.first.startTime[i], widget.serviceState.serviceSlot.first.minDuration.toString(), dates[index]);
      externalServiceList.insert(index, item);
      //orderState.total += item.price * item.number;
    });
  }

  void search(List<ExternalBusinessState> list) {
    setState(() {
      externalServiceList.clear();
      List<ExternalBusinessState> serviceState = list;
      if (_searchController.text.isNotEmpty) {
        serviceState.forEach((element) {
          if (element.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
            externalServiceList.add(element);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaWidth = media.width;
    var mediaHeight = media.height;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store){
          if(widget.fromMy){
            store.dispatch(ExternalBusinessListRequest('any', store.state.user.getRole()));
            startRequest = true;
          }
        },
        builder: (context, snapshot) {
          if (_searchController.text.isEmpty) {
            externalServiceList.clear();
            externalServiceList.addAll(snapshot.externalBusinessList.externalBusinessListState);
          }
          debugPrint('UI_M_add_external_service_list => EXTERNAL BUSINESS LIST: ${externalServiceList.length}');
          if(snapshot.externalBusinessList.externalBusinessListState.isEmpty && startRequest){
            noActivity = true;
          }else{
            if(snapshot.externalBusinessList.externalBusinessListState.isNotEmpty && snapshot.externalBusinessList.externalBusinessListState.first.id_firestore == null)
              snapshot.externalBusinessList.externalBusinessListState.removeLast();
            noActivity = false;
            startRequest = false;
          }
          return WillPopScope(
              onWillPop: () async {
                ///Block iOS Back Swipe
                if (Navigator.of(context).userGestureInProgress)
                  return false;
                else
                  _onWillPop();
                return true;
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: BuytimeAppbar(
                  width: media.width,
                  children: [
                    ///Back Button
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
                      onPressed: () {
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_Business()))
                        Navigator.pushReplacement(context, EnterExitRoute(enterPage: ExternalServiceList(), exitPage: AddExternalServiceList(false), from: false));
                      },
                    ),
                    Utils.barTitle(AppLocalizations.of(context).addExternalService),
                    IconButton(
                      icon: Icon(Icons.add, color: BuytimeTheme.ManagerPrimary),
                      onPressed: () {
                        return null;
                      },
                    ),
                  ],
                ),
                body: Container(
                  child: Column(
                    children: [
                      ///Search
                      Container(
                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
                        height: SizeConfig.safeBlockHorizontal * 15,
                        child: TextFormField(
                          controller: _searchController,
                          textAlign: TextAlign.start,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            labelText: AppLocalizations.of(context).searchBusinessOrServiceName,
                            //helperText: AppLocalizations.of(context).searchForServicesAndIdeasAroundYou,
                            //hintText: "email *",
                            //hintStyle: TextStyle(color: Color(0xff666666)),
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
                            suffixIcon: InkWell(
                              onTap: () {
                                debugPrint('done');
                                FocusScope.of(context).unfocus();
                                search(snapshot.externalBusinessList.externalBusinessListState);
                              },
                              child: Icon(
                                // Based on passwordVisible state choose the icon
                                Icons.search,
                                color: Color(0xff666666),
                              ),
                            ),
                          ),
                          style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w400, fontSize: 16),
                          onEditingComplete: () {
                            debugPrint('done');
                            FocusScope.of(context).unfocus();
                            search(snapshot.externalBusinessList.externalBusinessListState);
                          },
                        ),
                      ),
                      ///Sort By
                      Container(
                        //width: SizeConfig.safeBlockHorizontal * 20,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5),
                              child: IconButton(
                                  onPressed: (){},
                                  icon: Icon(
                                    Icons.map_outlined,
                                    color: BuytimeTheme.SymbolGrey,
                                  )
                              ),
                            ),
                            Container(
                              //width: SizeConfig.safeBlockHorizontal * 20,
                              margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                              child: DropdownButton(
                                underline: Container(),
                                hint: Row(
                                  children: [
                                    Icon(
                                      Icons.sort,
                                      color: BuytimeTheme.TextMedium,
                                      size: 24,
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          AppLocalizations.of(context).sortBy,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 14,
                                            ///SizeConfig.safeBlockHorizontal * 4
                                            color: BuytimeTheme.TextMedium,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          sortBy,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 14,
                                            ///SizeConfig.safeBlockHorizontal * 4
                                            color: BuytimeTheme.TextBlack,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                isExpanded: false,
                                iconSize: 0,
                                style: TextStyle(color: Colors.blue),
                                items: [AppLocalizations.of(context).distance].map(
                                      (val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                val,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: BuytimeTheme.TextMedium,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                          sortBy == val
                                              ? Icon(
                                            MaterialDesignIcons.done,
                                            color: BuytimeTheme.TextMedium,
                                            size: SizeConfig.safeBlockHorizontal * 5,
                                          )
                                              : Container(),
                                        ],
                                      ),
                                    );
                                  },
                                ).toList(),
                                onChanged: (val) {
                                  setState(
                                        () {
                                      //_dropDownValue = val;
                                      sortBy = val;
                                      if (sortBy == AppLocalizations.of(context).distance) {
                                        //externalServiceList.sort((a, b) => a.name.compareTo(b.name));
                                      } else {
                                        //externalServiceList.sort((a, b) => b.name.compareTo(a.name));
                                      }
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      ///External Searched list
                      externalServiceList.isNotEmpty ?
                      Expanded(
                        child: CustomScrollView(
                          shrinkWrap: true,
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate((context, index){
                                ExternalBusinessState item = externalServiceList.elementAt(index);
                                return Dismissible(
                                  // Each Dismissible must contain a Key. Keys allow Flutter to
                                  // uniquely identify widgets.
                                  key: UniqueKey(),
                                  // Provide a function that tells the app
                                  // what to do after an item has been swiped away.
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    // Remove the item from the data source.
                                    setState(() {
                                      externalServiceList.removeAt(index);
                                    });
                                    if (direction == DismissDirection.endToStart) {

                                      debugPrint('UI_U_external_service_list => DX to DELETE');
                                      // Show a snackbar. This snackbar could also contain "Undo" actions.
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text(AppLocalizations.of(context).spaceRemoved),
                                          action: SnackBarAction(
                                              label: AppLocalizations.of(context).undo,
                                              onPressed: () {
                                                //To undo deletion
                                                undoDeletion(index, item);
                                              })));
                                    } else {
                                      externalServiceList.insert(index, item);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      AddExternalBusinessListItem(item, snapshot.business, false),
                                      Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                                        height: SizeConfig.safeBlockVertical * .2,
                                        color: BuytimeTheme.DividerGrey,
                                      )
                                    ],
                                  ),
                                  background: Container(
                                    color: BuytimeTheme.BackgroundWhite,
                                    //margin: EdgeInsets.symmetric(horizontal: 15),
                                    alignment: Alignment.centerRight,
                                  ),
                                  secondaryBackground: Container(
                                    color: BuytimeTheme.AccentRed,
                                    //margin: EdgeInsets.symmetric(horizontal: 15),
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                      child: Icon(
                                        BuytimeIcons.remove,
                                        size: 24,

                                        ///SizeConfig.safeBlockHorizontal * 7
                                        color: BuytimeTheme.SymbolWhite,
                                      ),
                                    ),
                                  ),
                                );
                              },
                                childCount: externalServiceList.length,
                              ),
                            ),
                          ],
                        ),
                      )  :
                      _searchController.text.isNotEmpty
                          ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              //height: SizeConfig.safeBlockVertical * 8,
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ///Sad icon
                                  Container(
                                    child: Icon(
                                      BuytimeIcons.sad,
                                      color: BuytimeTheme.BackgroundCerulean,
                                    ),
                                  ),
                                  ///No result for ...
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 5),
                                        //alignment: Alignment.centerLeft,
                                        child: Text(
                                          AppLocalizations.of(context).noResultsFor,
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 16),
                                        ),
                                      ),
                                      Flexible(child: Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, right: SizeConfig.safeBlockHorizontal * 5),
                                        //alignment: Alignment.centerLeft,
                                        child: Text(
                                          ' \"${_searchController.text}\"',
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 16),
                                        ),
                                      ))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          AppLocalizations.of(context).tryAnotherSearch,
                                          style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 16),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                //height: double.infinity,
                                //color: Colors.black87,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ///Confirm button
                                    Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical *4),
                                        width: 158, ///media.width * .4
                                        height: 44,
                                        child: MaterialButton(
                                          elevation: 0,
                                          hoverElevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          onPressed: () {

                                          },
                                          textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                          color:  BuytimeTheme.ManagerPrimary,
                                          padding: EdgeInsets.all(media.width * 0.03),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context).contactUs.toUpperCase(),
                                            style: TextStyle(
                                              letterSpacing: 1.25,
                                              fontSize: 14,
                                              fontFamily: BuytimeTheme.FontFamily,
                                              fontWeight: FontWeight.w500,
                                              color: BuytimeTheme.TextWhite,

                                            ),
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ) : externalServiceList.isEmpty
                          ? noActivity ?
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator()
                          ],
                        ),
                      ) : Container(
                        height: SizeConfig.safeBlockVertical * 8,
                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                        decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context).noExternalServiceFound,
                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            )),
                      )
                          : Container()
                      ,
                    ],
                  ),
                ),
              ));
        });
  }
}
