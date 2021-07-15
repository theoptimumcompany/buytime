import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/category/widget/W_category_list_item.dart';
import 'package:Buytime/UI/management/service_internal/RUI_M_service_list.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_service_list.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InternalServiceShowcase extends StatefulWidget {
  List<CategoryState> categoryRootList;

  InternalServiceShowcase({this.categoryRootList});

  @override
  State<StatefulWidget> createState() => InternalServiceShowcaseState();
}

class InternalServiceShowcaseState extends State<InternalServiceShowcase> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ///Internal Services
          Container(
              margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0, bottom: SizeConfig.safeBlockVertical * 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      AppLocalizations.of(context).internalServices,
                      style: TextStyle(fontWeight: FontWeight.w700, fontFamily: BuytimeTheme.FontFamily, fontSize: 18, color: BuytimeTheme.TextBlack),
                    ),
                  ),

                  ///Manage Internal Services
                  InkWell(
                    onTap: () {
                      Navigator.push(context, EnterExitRoute(enterPage: RServiceList(), exitPage: UI_M_Business(), from: true));
                    },
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        AppLocalizations.of(context).manageUpper,
                        style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 14, color: BuytimeTheme.ManagerPrimary),
                      ),
                    ),
                  ),
                ],
              )),
          ///Categories list top part
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
            decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1)),
            child: Row(
              children: [
                ///Menu item text
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Text(
                      AppLocalizations.of(context).categoriesUpper,
                      style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 10, color: BuytimeTheme.TextBlack, letterSpacing: 1.5),
                    ),
                  ),
                ),

                ///Most popular text
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Text(
                      AppLocalizations.of(context).mostPopularCaps,
                      style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 10, color: BuytimeTheme.TextBlack, letterSpacing: 1.5),
                    ),
                  ),
                )
              ],
            ),
          ),
          ///Categories list
          Expanded(
            child: Stack(
              children: [
                widget.categoryRootList.length > 0
                    ?
                    ///Categories list
                    Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            color: Colors.blueGrey.withOpacity(0.1),
                            //margin: EdgeInsets.only(bottom: 60.0),
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: CustomScrollView(shrinkWrap: true, slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                    CategoryState categoryItem = widget.categoryRootList.elementAt(index);
                                    //return CategoryListItemWidget(categoryItem, BuytimeTheme.SymbolLime);
                                    return Container();
                                    // return InkWell(
                                    //   onTap: () {
                                    //     debugPrint('Category Item: ${categoryItem.name.toUpperCase()} Clicked!');
                                    //   },
                                    //   //child: MenuItemListItemWidget(menuItem),
                                    //   child: CategoryListItemWidget(categoryItem),
                                    // );
                                  },
                                  childCount: widget.categoryRootList.length,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      )
                    : Container(
                        height: SizeConfig.screenHeight * 0.1,
                        child:  Center(
                          child: Text(
                            AppLocalizations.of(context).thereAreNoServicesInThisBusiness,
                            style: TextStyle(fontWeight: FontWeight.w500, fontFamily: BuytimeTheme.FontFamily, fontSize: 13, color: BuytimeTheme.TextBlack,),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
