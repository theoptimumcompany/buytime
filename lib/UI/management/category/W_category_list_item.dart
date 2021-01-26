import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      height: 40, ///Item size
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
                      height: 40,
                      width: 35,
                      decoration: BoxDecoration(
                          color: Colors.lime[800].withOpacity(0.7)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "100",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20
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
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17
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
                        "Servizio più Popolare",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17
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