import 'package:Buytime/UI/management/service_external/UI_M_external_service_list.dart';
import 'package:Buytime/UI/management/service_external/UI_M_p_a_service_list.dart';
import 'package:Buytime/UI/management/service_external/UI_M_external_business_details.dart';
import 'package:Buytime/UI/management/service_external/UI_M_external_service_details.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share/share.dart';
import 'package:Buytime/UI/user/service/UI_U_service_details.dart';

class ExternalServiceItem extends StatefulWidget {

  ServiceState serviceState;
  List<ServiceState> serviceList;
  String title;
  bool fromBusiness;
  ExternalBusinessState externalBusinessState;
  ExternalServiceItem(this.serviceState, this.fromBusiness, this.serviceList, this.title, this.externalBusinessState);

  @override
  _ExternalServiceItemState createState() => _ExternalServiceItemState();
}

class _ExternalServiceItemState extends State<ExternalServiceItem> {


  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    String duration = '';
    if(widget.serviceState.serviceSlot.isNotEmpty){
      widget.serviceState.serviceSlot.forEach((element) {
        if(element.day != 0){
          debugPrint('W_external_service_item => SLOT WITH DAYS');
          duration = '${element.day} d';
        }else{
          debugPrint('W_external_service_item => SLOT WITHOUT DAYS');
          int tmpMin = element.hour * 60 + element.minute;
          if(tmpMin > 90)
            duration = '${element.hour} h ${element.minute} ${AppLocalizations.of(context).spaceMinSpace}';
          else
            duration = '$tmpMin ${AppLocalizations.of(context).spaceMinSpace}';
        }
      });
    }else{
      duration = 'depends';
    }

    //debugPrint('image: ${widget.serviceState.image1}');
    return Container(
        //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              onTap: () async {
                Navigator.push(context, EnterExitRoute(enterPage: ExternalServiceDetails(widget.serviceState, widget.externalBusinessState), exitPage: ExternalBusinessDetails(widget.externalBusinessState, false, true), from: true));
                //Navigator.push(context, MaterialPageRoute(builder: (context) => ExternalServiceDetails(serviceState: widget.serviceState)),);;
              },
              child: Container(
                height: 91,  ///SizeConfig.safeBlockVertical * 15
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: 1, bottom: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ///Service Image
                        CachedNetworkImage(
                          imageUrl: Utils.version200(widget.serviceState.image1),
                          imageBuilder: (context, imageProvider) => Container(
                            //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                            height: 91,
                            width: 91,
                            decoration: BoxDecoration(
                              //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                                image: DecorationImage(image: imageProvider, fit: BoxFit.cover,)),
                          ),
                          placeholder: (context, url) => Utils.imageShimmer(91, 91),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        ///Service Name & Description
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Name & Duration & Price
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ///Service Name
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Container(
                                          width: SizeConfig.safeBlockHorizontal * 50,
                                          child: Text(
                                            widget.serviceState.name != null ? Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name) : '..............',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                letterSpacing: 0.15,
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextBlack,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16 /// SizeConfig.safeBlockHorizontal * 4
                                            ),
                                          ),
                                        ),
                                      ),
                                      widget.serviceState.serviceSlot.isNotEmpty ?
                                      ///Duration
                                      FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Container(
                                          width: 180, ///SizeConfig.safeBlockHorizontal * 50
                                          height: 20, ///SizeConfig.safeBlockVertical * 10
                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .25),
                                          child: Text(
                                            duration,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                letterSpacing: 0.25,
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextGrey,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                            ),
                                          ),
                                        ),
                                      ) : Container(),
                                      ///Price
                                      FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Container(
                                          width: 180, ///SizeConfig.safeBlockHorizontal * 50
                                          height: 20, ///SizeConfig.safeBlockVertical * 10
                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .25),
                                          child: Text(
                                            '${widget.serviceState.price.toStringAsFixed(0)} ${AppLocalizations.of(context).euroSpace}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                letterSpacing: 0.25,
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextGrey,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              widget.serviceState.visibility == 'Invisible' || widget.serviceState.visibility == 'Deactivated' ?
                              ///Message
                              FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Container(
                                  width: 180, ///SizeConfig.safeBlockHorizontal * 50
                                  height: 15, ///SizeConfig.safeBlockVertical * 10
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .25, bottom: SizeConfig.safeBlockVertical * .25),
                                  child: Text(
                                    widget.serviceState.visibility == 'Deactivated' ? '${AppLocalizations.of(context).serviceNotAvailable}' : '${AppLocalizations.of(context).serviceNotVisible}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        letterSpacing: 0.25,
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.AccentRed,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12 ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                ),
                              ) : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    (){
                      bool equalService = false;
                      bool equalBusiness = false;
                      StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported.forEach((element) {
                        if(element.externalServiceId == widget.serviceState.serviceId && element.imported == true){
                          debugPrint('${ widget.serviceState.name} | service true');
                          equalService = true;
                        }
                      });
                      StoreProvider.of<AppState>(context).state.externalBusinessImportedListState.externalBusinessImported.forEach((element) {
                        if(element.externalBusinessId == widget.serviceState.businessId && element.imported == true){
                          debugPrint('${ widget.serviceState.name} | business true');
                          equalBusiness = true;
                        }
                      });
                      if(equalBusiness){
                        debugPrint('${ widget.serviceState.name} | if | business true');
                        StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported.forEach((element) {
                          if(element.externalServiceId == widget.serviceState.serviceId && element.imported == true){
                            debugPrint('${ widget.serviceState.name} | if | business true | service true');
                            equalService = true;
                          }
                          if(element.externalServiceId == widget.serviceState.serviceId && element.imported == false){
                            debugPrint('${ widget.serviceState.name} | if | business true | service false');
                            equalService = false;
                            equalBusiness = false;
                          }
                        });
                        bool found = false;
                        StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported.forEach((element) {
                          if(element.externalServiceId == widget.serviceState.serviceId && element.imported == true){
                            found = true;
                          }
                        });

                        if(!found && StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported.length != 0){
                          equalService = false;
                          equalBusiness = false;
                        }
                      }
                      debugPrint('${ widget.serviceState.name} | Business : $equalBusiness | Service: $equalService');
                      if(equalService || equalBusiness){
                        return Icon(
                          Icons.settings_ethernet,
                          color: BuytimeTheme.ActionButton,
                        );
                      }
                      return Container();
                    }()
                  ],
                ),
              ),
            )
        )
    );
  }


}


/*
import 'package:Buytime/UI/management/service_external/UI_M_external_service_list.dart';
import 'package:Buytime/UI/management/service_external/UI_M_p_a_service_list.dart';
import 'package:Buytime/UI/management/service_external/UI_M_external_business_details.dart';
import 'package:Buytime/UI/management/service_external/UI_M_external_service_details.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share/share.dart';
import 'package:Buytime/UI/user/service/UI_U_service_details.dart';

class ExternalServiceItem extends StatefulWidget {

  ServiceState serviceState;
  List<ServiceState> serviceList;
  String title;
  bool fromBusiness;
  ExternalBusinessState externalBusinessState;
  ExternalServiceItem(this.serviceState, this.fromBusiness, this.serviceList, this.title, this.externalBusinessState);

  @override
  _ExternalServiceItemState createState() => _ExternalServiceItemState();
}

class _ExternalServiceItemState extends State<ExternalServiceItem> {


  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    String duration = '';
    if(widget.serviceState.serviceSlot.isNotEmpty){
      widget.serviceState.serviceSlot.forEach((element) {
        if(element.day != 0){
          debugPrint('W_external_service_item => SLOT WITH DAYS');
          duration = '${element.day} d';
        }else{
          debugPrint('W_external_service_item => SLOT WITHOUT DAYS');
          int tmpMin = element.hour * 60 + element.minute;
          if(tmpMin > 90)
            duration = '${element.hour} h ${element.minute}${AppLocalizations.of(context).spaceMinSpace}';
          else
            duration = '$tmpMin${AppLocalizations.of(context).spaceMinSpace}';
        }
      });
    }else{
      duration = 'depends';
    }
    //debugPrint('image: ${widget.serviceState.image1}');
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store){
      },
      builder: (context, snapshot) {
        bool equal = false;
        if(snapshot.serviceListSnippetState.businessId != null){
          snapshot.serviceListSnippetState.businessSnippet.forEach((bS) {
            if(bS.categoryAbsolutePath.split('/').first == widget.externalBusinessState.id_firestore){
              bS.serviceList.forEach((sL) {
                if(sL.serviceAbsolutePath.split('/').last == widget.serviceState.serviceId){
                  equal = true;
                }
              });
            }
          });
        }
        return   Container(
          //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  onTap: () async {
                    Navigator.push(context, EnterExitRoute(enterPage: ExternalServiceDetails(widget.serviceState, widget.externalBusinessState), exitPage: ExternalBusinessDetails(widget.externalBusinessState, false, true), from: true));
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => ExternalServiceDetails(serviceState: widget.serviceState)),);;
                  },
                  child: Container(
                    height: 91,  ///SizeConfig.safeBlockVertical * 15
                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: 1, bottom: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ///Service Image
                            CachedNetworkImage(
                              imageUrl: Utils.version200(widget.serviceState.image1), /// widget.serviceState.image1 != null && widget.serviceState.image1 .isNotEmpty ? widget.serviceState.image1  : 'https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200_1000x1000.png?alt=media&token=082a1896-32d8-4750-b7cc-141f00bc060c',
                              imageBuilder: (context, imageProvider) => Container(
                                //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                                height: 91,
                                width: 91,
                                decoration: BoxDecoration(
                                  //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover,)),
                              ),
                              placeholder: (context, url) => Container(
                                height: 91,
                                width: 91,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      //padding: EdgeInsets.only(top: 80, bottom: 80, left: 50, right: 50),
                                      child: CircularProgressIndicator(
                                        //valueColor: new AlwaysStoppedAnimation<Color>(BuytimeTheme.ManagerPrimary),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            ///Service Name & Description
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///Service Name
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Container(
                                      width: SizeConfig.safeBlockHorizontal * 50,
                                      child: Text(
                                        widget.serviceState.name ?? '..............',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            letterSpacing: 0.15,
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: BuytimeTheme.TextBlack,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16 /// SizeConfig.safeBlockHorizontal * 4
                                        ),
                                      ),
                                    ),
                                  ),
                                  widget.serviceState.serviceSlot.isNotEmpty ?
                                  ///Duration
                                  FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Container(
                                      width: 180, ///SizeConfig.safeBlockHorizontal * 50
                                      height: 20, ///SizeConfig.safeBlockVertical * 10
                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .25),
                                      child: Text(
                                        duration,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            letterSpacing: 0.25,
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: BuytimeTheme.TextGrey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                        ),
                                      ),
                                    ),
                                  ) : Container(),
                                  ///Price
                                  FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Container(
                                      width: 180, ///SizeConfig.safeBlockHorizontal * 50
                                      height: 20, ///SizeConfig.safeBlockVertical * 10
                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .25),
                                      child: Text(
                                        '${widget.serviceState.price.toStringAsFixed(0)} ${AppLocalizations.of(context).euroSpace}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            letterSpacing: 0.25,
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: BuytimeTheme.TextGrey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        equal ? Icon(
                          Icons.settings_ethernet,
                          color: BuytimeTheme.ActionButton,
                        ) : Container()
                      ],
                    ),
                  ),
                )
            )
        );
      },
    );
  }


}


 */
