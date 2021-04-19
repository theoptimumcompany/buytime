import 'package:Buytime/UI/user/about_us/UI_U_about_us.dart';
import 'package:Buytime/UI/user/business/UI_U_business_list.dart';
import 'package:Buytime/UI/user/order/UI_U_order_history.dart';
import 'package:Buytime/UI/user/service/UI_U_service_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserTabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;
  static var context;

  UserTabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });
  /*static List<UserTabNavigationItem> get items => [
    UserTabNavigationItem(
      page: UI_U_BusinessList(),
      icon: Icon(Icons.business),
      title: Text('${AppLocalizations.of(context).businesses}'),
    ),
    UserTabNavigationItem(
      page: UI_U_OrderHistory(),
      icon: Icon(Icons.list),
      title: Text('${AppLocalizations.of(context).orders}'),
    ),
    UserTabNavigationItem(
      page: UI_U_AboutUs(),
      icon: Icon(Icons.info_outline),
      title: Text('${AppLocalizations.of(context).aboutUs}'),
    ),
  ];*/
}
