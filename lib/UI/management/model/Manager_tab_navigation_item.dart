import 'package:Buytime/UI/management/old_design/UI_M_business_list.dart';
import 'package:Buytime/UI/management/order/UI_M_OrderHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


// TODO insert context and translate
class ManagerTabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

  ManagerTabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<ManagerTabNavigationItem> get items => [
    ManagerTabNavigationItem(
      page: UI_M_BusinessList(),
      icon: Icon(Icons.business),
      title: Text("Businesses"),
    ),
    ManagerTabNavigationItem(
      page: UI_M_OrderHistory(),
      icon: Icon(Icons.list),
      title: Text("Orders"),
    ),
  ];
}
