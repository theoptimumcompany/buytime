import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class CategoryListItemWidget extends StatefulWidget {

  CategoryState categoryItem;
  CategoryListItemWidget(this.categoryItem);

  @override
  _CategoryListItemWidgetState createState() => _CategoryListItemWidgetState();
}
class _CategoryListItemWidgetState extends State<CategoryListItemWidget> {
  ///Models
  CategoryState categoryItem;

  @override
  void initState() {
    super.initState();
    categoryItem = widget.categoryItem;
  }

  @override
  Widget build(BuildContext context) {
    ///Init sizeConfig
    SizeConfig().init(context);

    return Container(
      height: 30, ///Item size
      width: SizeConfig.screenWidth, ///Screen width
      //color: Colors.blue,
      child: Row(
        children: [
          ///Item count & Type
          Expanded(
              flex: 1,
              child: Row(
                children: [
                  ///Item count
                  Container(
                      margin: EdgeInsets.only(left: 20.0, right: 5.0, top: 2.5, bottom: 2.5),
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                          color: BuytimeTheme.SymbolLime
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 27,
                            width: 27,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "100",
                                style: TextStyle(
                                    color: BuytimeTheme.TextWhite,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: BuytimeTheme.FontFamily,
                                    fontSize: 16
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  ///Category Name
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: Text(
                        widget.categoryItem.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: BuytimeTheme.TextBlack,
                            fontWeight: FontWeight.w400,
                            fontFamily: BuytimeTheme.FontFamily,
                            fontSize: 16
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
          ///Most popular
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///Message
                  Flexible(
                    child: Container(
                      child: Text(
                        AppLocalizations.of(context).mostPopularService,
                        style: TextStyle(
                            color: BuytimeTheme.TextBlack,
                            fontWeight: FontWeight.w400,
                            fontFamily: BuytimeTheme.FontFamily,
                            fontSize: 16
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}