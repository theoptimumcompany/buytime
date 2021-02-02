import 'package:Buytime/UI/user/about_us/UI_U_About_Us.dart';
import 'package:Buytime/UI/user/business/UI_U_business_list.dart';
import 'package:Buytime/UI/user/order/UI_U_OrderHistory.dart';
import 'package:Buytime/UI/user/service/UI_U_service_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserTabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

  UserTabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });
// TODO add context to translate
  static List<UserTabNavigationItem> get items => [
    UserTabNavigationItem(
      page: UI_U_BusinessList(),
      icon: Icon(Icons.business),
      title: Text("Businesses"),
    ),
    UserTabNavigationItem(
      page: UI_U_OrderHistory(),
      icon: Icon(Icons.list),
      title: Text("Orders"),
    ),
    UserTabNavigationItem(
      page: UI_U_AboutUs(),
      icon: Icon(Icons.info_outline),
      title: Text("About us"),
    ),
  ];
}
