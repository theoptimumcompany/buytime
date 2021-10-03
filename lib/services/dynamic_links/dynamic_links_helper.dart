import 'package:Buytime/UI/management/business/RUI_M_business_list.dart';
import 'package:Buytime/UI/user/booking/UI_U_booking_self_creation.dart';
import 'package:Buytime/UI/user/landing/invite_guest_form.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reblox/reducer/order_detail_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DynamicLinkHelper {

  final storage = new FlutterSecureStorage();

  String selfBookingCode = '';
  String bookingCode = '';
  String categoryCode = '';

  String orderId = '';
  String userId = '';

  static String discoverBusinessName = '';
  static String discoverBusinessId = '';

  bool onBookingCode = false;
  bool rippleLoading = false;
  bool secondRippleLoading = false;
  bool requestingBookings = false;



void initDynamicLinks(BuildContext context) async {
  print("RUI_U_service_explorer : initDynamicLinks start");
  /// lanciato quando l'app é aperta
  FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
    await dynamicLinksSwitch(dynamicLink, context);
  }, onError: (OnLinkErrorException e) async {
    print('onLinkError');
    print(e.message);
  });
  await Future.delayed(Duration(seconds: 2)); // TODO: vi spezzo le gambine. AHAHAHAH Riccaa attentoooo.
  /// Serve un delay che altrimenti getInitialLink torna NULL
  final PendingDynamicLinkData dynamicLink = await FirebaseDynamicLinks.instance.getInitialLink();
  await dynamicLinksSwitch(dynamicLink, context);
}

Future<Uri> dynamicLinksSwitch(PendingDynamicLinkData dynamicLink, BuildContext context) async {
  Uri deepLink;
  deepLink = dynamicLink?.link;
  debugPrint('RUI_U_service_explorer :  DEEPLINK onLink: $deepLink');
  if (deepLink != null) {
    String bookingCodeRead = await storage.containsKey(key: 'bookingCodeRead') ? await storage.read(key: 'bookingCodeRead') ?? '' : '';
    String categoryInviteRead = await storage.containsKey(key: 'categoryInviteRead') ? await storage.read(key: 'categoryInviteRead') ?? '' : '';
    String orderIdRead = await storage.containsKey(key: 'orderIdRead') ? await storage.read(key: 'orderIdRead') ?? '' : '';
    String onSiteUserIdRead = await storage.containsKey(key: 'onSiteUserIdRead') ? await storage.read(key: 'onSiteUserIdRead') ?? '' : '';
    String onSiteOrderIdRead = await storage.containsKey(key: 'onSiteOrderIdRead') ? await storage.read(key: 'onSiteOrderIdRead') ?? '' : '';
    String discoverBusinessNameRead = await storage.containsKey(key: 'discoverBusinessNameRead') ? await storage.read(key: 'discoverBusinessNameRead') ?? '' : '';
    String discoverBusinessIdRead = await storage.containsKey(key: 'discoverBusinessIdRead') ? await storage.read(key: 'discoverBusinessIdRead') ?? '' : '';

    if (deepLink.queryParameters.containsKey('booking') && bookingCodeRead != 'true') {
      await deepLinkBooking(deepLink, context);
    }
    else if (deepLink.queryParameters.containsKey('categoryInvite') && categoryInviteRead != 'true') {
      await deepLinkCategoryInvite(deepLink, context);
    }
    else if (deepLink.queryParameters.containsKey('userId') && deepLink.queryParameters.containsKey('orderId') && onSiteUserIdRead != 'true' && onSiteOrderIdRead != 'true') {
      await deepLinkOnSitePayment(deepLink, context);
    }
    else if (deepLink.queryParameters.containsKey('orderId') && orderIdRead != 'true') {
      await deepLinkOrder(deepLink, context);
    }
    else if (deepLink.queryParameters.containsKey('selfBookingCode') && deepLink.queryParameters['selfBookingCode'].length > 5) {
      await deepLinkSelfBooking(deepLink, context);
    }
    else if (deepLink.queryParameters.containsKey('discoverBusinessName') && deepLink.queryParameters.containsKey('discoverBusinessId') && discoverBusinessNameRead != 'true' && discoverBusinessIdRead != 'true') {
      await deepLinkSearchBusiness(deepLink);
    }
  }
  return deepLink;
}

Future<void> deepLinkSearchBusiness(Uri deepLink) async {
  debugPrint('ON SEARCH ON LINK');
  debugPrint('RUI_U_service_explorer :  discoverBusinessName  onLink: $discoverBusinessName  - discoverBusinessId onLink: $discoverBusinessId');
  await storage.write(key: 'discoverBusinessName ', value: discoverBusinessName );
  await storage.write(key: 'discoverBusinessId', value: discoverBusinessId);
  await storage.write(key: 'discoverBusinessNameRead', value: 'true');
  await storage.write(key: 'discoverBusinessIdRead', value: 'true');
  if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
    debugPrint('RUI_U_service_explorer :  USER Is LOGGED in onLink');
    debugPrint('SHOULD SEARCH : ${discoverBusinessName}');
  } else
    debugPrint('RUI_U_service_explorer :  USER NOT LOGGED in onLink');
  await storage.write(key: 'discoverBusinessNameRead', value: 'false');
  await storage.write(key: 'discoverBusinessIdRead', value: 'false');
}

Future<void> deepLinkSelfBooking(Uri deepLink, BuildContext context) async {
  String tmSselfBookingCode = deepLink.queryParameters['selfBookingCode'];
  debugPrint('RUI_U_service_explorer :  selfBookingCode from dynamic link: $tmSselfBookingCode');
  selfBookingCode = tmSselfBookingCode;
  await storage.write(key: 'selfBookingCode', value: tmSselfBookingCode);

  if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
    debugPrint('RUI_U_service_explorer :  USER Is LOGGED in onLink');
    StoreProvider.of<AppState>(context).dispatch(BusinessRequest(tmSselfBookingCode));
    await storage.write(key: 'selfBookingCode', value: '');
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.push(context, MaterialPageRoute(builder: (context) => BookingSelfCreation()));
  } else {
    debugPrint('RUI_U_service_explorer :  USER NOT LOGGED in onLink');
  }
}

Future<void> deepLinkOrder(Uri deepLink, BuildContext context) async {
  String orderId = deepLink.queryParameters['orderId'];
  debugPrint('RUI_U_service_explorer :  orderId from dynamic link: $orderId');
  await storage.write(key: 'orderId', value: orderId);
  await storage.write(key: 'orderIdRead', value: 'true');
  if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
    debugPrint('RUI_U_service_explorer :  USER Is LOGGED in onLink');
    StoreProvider.of<AppState>(context).dispatch(SetOrderDetailAndNavigatePopOrderId(orderId));
    // Navigator.push(context, MaterialPageRoute(builder: (context) => RBusinessList()));
  } else
    debugPrint('RUI_U_service_explorer :  USER NOT LOGGED in onLink');
}

Future<void> deepLinkOnSitePayment(Uri deepLink, BuildContext context) async {
  debugPrint('ON SITE PAYMENT ON LINK');
  String orderId = deepLink.queryParameters['orderId'];
  String userId = deepLink.queryParameters['userId'];
  debugPrint('RUI_U_service_explorer :  userId onLink: $userId - orderId onLink: $orderId');
  await storage.write(key: 'onSiteUserId', value: userId);
  await storage.write(key: 'onSiteOrderId', value: orderId);
  await storage.write(key: 'onSiteUserIdRead', value: 'true');
  await storage.write(key: 'onSiteOrderIdRead', value: 'true');
  if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
    debugPrint('RUI_U_service_explorer :  USER Is LOGGED in onLink');
    if (StoreProvider.of<AppState>(context).state.user.getRole() != Role.user) {
      StoreProvider.of<AppState>(context).dispatch(OrderRequest(orderId));
      await Future.delayed(Duration(milliseconds: 3000));
      StoreProvider.of<AppState>(context).state.order.progress = 'paid';
      StoreProvider.of<AppState>(context).dispatch(UpdateOrderByManager(StoreProvider.of<AppState>(context).state.order, OrderStatus.paid));
    } else {
      debugPrint('USER NO PERMISSION in LINK');
    }
    await storage.write(key: 'onSiteUserIdRead', value: 'false');
    await storage.write(key: 'onSiteOrderIdRead', value: 'false');
  } else
    debugPrint('RUI_U_service_explorer :  USER NOT LOGGED in onLink');
}

Future<void> deepLinkCategoryInvite(Uri deepLink, BuildContext context) async {
  String categoryInvite = deepLink.queryParameters['categoryInvite'];
  debugPrint('v: $categoryInvite');
  await storage.write(key: 'categoryInvite', value: categoryInvite);
  await storage.write(key: 'categoryInviteRead', value: 'true');
  if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
    debugPrint('RUI_U_service_explorer :  USER Is LOGGED in onLink');
    StoreProvider.of<AppState>(context).dispatch(UserBookingListRequest(StoreProvider.of<AppState>(context).state.user.email, false));
    Navigator.push(context, MaterialPageRoute(builder: (context) => RBusinessList()));
  }
}

Future<void> deepLinkBooking(Uri deepLink, BuildContext context) async {
  String id = deepLink.queryParameters['booking'];
  debugPrint('RUI_U_service_explorer :  booking onLink: $id');
  await storage.write(key: 'bookingCode', value: id);
  await storage.write(key: 'bookingCodeRead', value: 'true');
  if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
    debugPrint('RUI_U_service_explorer :  USER Is LOGGED in onLink');
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InviteGuestForm(
          id: id,
          fromLanding: true,
        )));
  } else
    debugPrint('RUI_U_service_explorer :  USER NOT LOGGED in onLink');
}

bookingCodeFound(BuildContext context) async {
  bookingCode = await storage.read(key: 'bookingCode') ?? '';
  debugPrint('RUI_U_service_explorer :  DEEP LINK EMPTY | BOOKING CODE: $bookingCode');
  await storage.delete(key: 'bookingCode');

  if (bookingCode.isNotEmpty)
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InviteGuestForm(
          id: bookingCode,
          fromLanding: true,
        )));
}
selfCheckInFound(BuildContext context) async {
  selfBookingCode = await storage.read(key: 'selfBookingCode') ?? '';
  debugPrint('RUI_U_service_explorer :  DEEP LINK EMPTY | selfBookingCode : $selfBookingCode');
  await storage.delete(key: 'selfBookingCode');

  if (selfBookingCode.isNotEmpty) {
    StoreProvider.of<AppState>(context).dispatch(BusinessRequest(selfBookingCode));
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookingSelfCreation()));
  }
}
categoryInviteFound(BuildContext context) async {
  categoryCode = await storage.read(key: 'categoryInvite') ?? '';
  debugPrint('RUI_U_service_explorer :  DEEP LINK EMPTY | CATEGORY INVITE: $categoryCode');
  // await storage.delete(key: 'categoryInvite');
  if (categoryCode.isNotEmpty) {
    StoreProvider.of<AppState>(context).dispatch(UserBookingListRequest(StoreProvider.of<AppState>(context).state.user.email, false));
    Navigator.push(context, MaterialPageRoute(builder: (context) => RBusinessList()));
  }
}
onSitePaymentFound(BuildContext context) async {
  userId = await storage.read(key: 'onSiteUserId') ?? '';
  orderId = await storage.read(key: 'onSiteOrderId') ?? '';
  debugPrint('RUI_U_service_explorer :  DEEP LINK EMPTY | userId: $userId | orderId: $orderId');
  await storage.delete(key: 'onSiteUserId');
  await storage.delete(key: 'onSiteOrderId');

  if (userId.isNotEmpty && orderId.isNotEmpty) {
    if (StoreProvider.of<AppState>(context).state.user.getRole() != Role.user) {
      StoreProvider.of<AppState>(context).dispatch(OrderRequest(orderId));
      await Future.delayed(Duration(milliseconds: 3000));
      StoreProvider.of<AppState>(context).state.order.progress = 'paid';
      StoreProvider.of<AppState>(context).dispatch(UpdateOrderByManager(StoreProvider.of<AppState>(context).state.order, OrderStatus.paid));
    } else {
      debugPrint('USER NO PERMISSION');
    }

    await storage.write(key: 'onSiteUserIdRead', value: 'false');
    await storage.write(key: 'onSiteOrderIdRead', value: 'false');
  }
}

clearBooking() async {
  await storage.write(key: 'bookingCode', value: '');
}

searchBusiness() async {
  discoverBusinessName = await storage.read(key: 'discoverBusinessName') ?? '';
  discoverBusinessId = await storage.read(key: 'discoverBusinessId') ?? '';
  debugPrint('RUI_U_service_explorer :  DEEP LINK EMPTY | discoverBusinessName : $discoverBusinessName | discoverBusinessId: $discoverBusinessId');
  await storage.delete(key: 'discoverBusinessName');
  await storage.delete(key: 'discoverBusinessId');
  if (discoverBusinessName.isNotEmpty && discoverBusinessId.isNotEmpty) {
    await storage.write(key: 'discoverBusinessNameRead', value: 'false');
    await storage.write(key: 'discoverBusinessIdRead', value: 'false');
  }
}

}
