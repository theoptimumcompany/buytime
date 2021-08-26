import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/UI/management/invite/UI_M_booking_details.dart';
import 'package:Buytime/UI/management/invite/UI_M_booking_list.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_service_list.dart';
import 'package:Buytime/UI/user/booking/UI_U_booking_page.dart';
import 'package:Buytime/UI/user/booking/UI_U_booking_self_creation.dart';
import 'package:Buytime/UI/user/booking/UI_U_confirm_booking.dart';
import 'package:Buytime/UI/user/booking/UI_U_my_bookings.dart';
import 'package:Buytime/UI/user/cart/UI_U_ConfirmOrder.dart';
import 'package:Buytime/UI/user/landing/UI_U_landing.dart';
import 'package:Buytime/UI/user/login/UI_U_login.dart';
import 'package:Buytime/UI/user/login/UI_U_registration.dart';
import 'package:Buytime/UI/user/booking/RUI_U_order_detail.dart';
import 'package:Buytime/UI/user/service/UI_U_service_details.dart';
import 'package:Buytime/UI/user/turist/UI_U_service_explorer.dart';
import 'package:Buytime/UI/user/login/UI_U_home.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/navigation/route_aware_widget.dart';
import 'package:flutter/material.dart';

import 'UI/management/business/RUI_M_business_list.dart';
import 'UI/management/service_internal/RUI_M_service_list.dart';
import 'UI/user/turist/RUI_U_service_explorer.dart';

MaterialPageRoute<dynamic> appRoutes(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.home:
      return MainRoute(Home(), settings: settings);
    case AppRoutes.registration:
      return SlideInEnterRoute(Registration(false), settings: settings);
    case AppRoutes.login:
      return SlideInEnterRoute(Login(false), settings: settings);
    /*case AppRoutes.landing:
      return FabRoute(Landing(), settings: settings);*/
    case AppRoutes.bookingDetails:
      return FabRoute(BookingDetails(), settings: settings);
    case AppRoutes.bookingSelfCreation:
      return FabRoute(BookingSelfCreation(), settings: settings);
    case AppRoutes.categories:
      return SlideInExitRoute(ManageCategory(), settings: settings);
    case AppRoutes.businessList:
      return FabRoute(RBusinessList(), settings: settings);
    case AppRoutes.business:
      return FabRoute(UI_M_Business(), settings: settings);
    case AppRoutes.confirmBooking:
      return FabRoute(ConfirmBooking(), settings: settings);
    case AppRoutes.bookingPage:
      return FabRoute(BookingPage(), settings: settings);
    case AppRoutes.managerServiceList:
      return SlideInExitRoute(RServiceList(), settings: settings);
    case AppRoutes.myBookings:
      return FabRoute(MyBookings(), settings: settings);
    case AppRoutes.confirmOrder:
      return FabRoute(ConfirmOrder(), settings: settings);
    case AppRoutes.orderDetailsRealtime:
      return FabRoute(RUI_U_OrderDetail('/bookingPage'), settings: settings);
    case AppRoutes.orderDetailsRealtimeToRoom:
      return FabRoute(RUI_U_OrderDetail('/bookingRoomPaymentList'), settings: settings);
    case AppRoutes.bookingList:
      return FabRoute(BookingList(), settings: settings);
    case AppRoutes.serviceDetails:
      return FabRoute(ServiceDetails(), settings: settings);
    case AppRoutes.serviceExplorer:
      return FabRoute(RServiceExplorer(), settings: settings);
    default:
      return MainRoute(Home(), settings: settings);
  }
}

class MainRoute<T> extends MaterialPageRoute<T> {
  MainRoute(Widget widget, {RouteSettings settings}) : super(builder: (_) => RouteAwareWidget(child: widget), settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return FadeTransition(opacity: animation, child: child);
  }
}

class FabRoute<T> extends MaterialPageRoute<T> {
  FabRoute(Widget widget, {RouteSettings settings}) : super(builder: (_) => RouteAwareWidget(child: widget), settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child);
  }
}

class SlideInExitRoute<T> extends MaterialPageRoute<T> {
  SlideInExitRoute(Widget widget, {RouteSettings settings}) : super(builder: (_) => RouteAwareWidget(child: widget), settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation),
      child: child,
    );
  }
}

class SlideInEnterRoute<T> extends MaterialPageRoute<T> {
  SlideInEnterRoute(Widget widget, {RouteSettings settings}) : super(builder: (_) => RouteAwareWidget(child: widget), settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation),
      child: child,
    );
  }
}
