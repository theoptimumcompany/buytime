import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/category/W_category_list_item.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_service_list.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BusinessHeader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BusinessHeaderState();
}

class BusinessHeaderState extends State<BusinessHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return

        ///Appabar bottom arc & Worker card & Business logo
        Column(
      children: [
        ///Worker card & Business logo
        Container(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///Worker card
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 25.0, left: 20.0),
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Welcome message 'Hi ...'
                          Container(
                            child: Text(
                              '${AppLocalizations.of(context).hi}' + StoreProvider.of<AppState>(context).state.user.name,
                              style: TextStyle(fontWeight: FontWeight.w700, fontFamily: BuytimeTheme.FontFamily, fontSize: 24, color: BuytimeTheme.TextBlack),
                            ),
                          ),

                          ///Employees count
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              AppLocalizations.of(context).employees,
                              style: TextStyle(fontWeight: FontWeight.w400, fontFamily: BuytimeTheme.FontFamily, fontSize: 14, color: BuytimeTheme.TextMedium),
                            ),
                          ),

                          ///Menu items count
                          Container(
                            margin: EdgeInsets.only(top: 2.5),
                            child: Text(
                              AppLocalizations.of(context).menuItems,
                              style: TextStyle(fontWeight: FontWeight.w400, fontFamily: BuytimeTheme.FontFamily, fontSize: 14, color: BuytimeTheme.TextMedium),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  ///Business logo
                  Expanded(
                    flex: 2,
                    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                          //color: Colors.deepOrange,
                          width: 140,

                          ///Fixed width
                          child: CachedNetworkImage(
                            imageUrl: StoreProvider.of<AppState>(context).state.business.logo,
                            imageBuilder: (context, imageProvider) => Container(
                              //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                  //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                                  image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              )),
                            ),
                            placeholder: (context, url) => Container(
                              height: 140,
                              width: 140,
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
                          )

                          //Image.network(StoreProvider.of<AppState>(context).state.business.logo, fit: BoxFit.cover, scale: 1.1),
                          )
                    ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
