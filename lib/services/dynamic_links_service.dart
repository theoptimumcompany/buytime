// import 'package:Buytime/UI/management/UI_manage_service_old.dart';
// import 'package:Buytime/UI/user/business/UI_U_businss_list.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
//
// class DynamicLinkService {
//
//
//   Future<void> retrieveDynamicLink(BuildContext context) async {
//     try {
//       final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
//       final Uri deepLink = data?.link;
//
//       if (deepLink != null) {
//         Navigator.of(context).push(MaterialPageRoute(builder: (context) => UI_U_BusinessList()));
//       }
//
//       FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
//         Navigator.of(context).push(MaterialPageRoute(builder: (context) => UI_U_BusinessList()));
//       });
//
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//
//
//   Future<Uri> createDynamicLink() async {
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://buytime.page.link',
//       link: Uri.parse('https://beta.itunes.apple.com/v1/app/1508552491'),
//       androidParameters: AndroidParameters(
//         packageName: 'com.theoptimumcompany.buytime',
//         minimumVersion: 1,
//       ),
//       iosParameters: IosParameters(
//         bundleId: 'com.theoptimumcompany.buytime',
//         minimumVersion: '1',
//         appStoreId: '1508552491',
//       ),
//     );
//     var dynamicUrl = await parameters.buildUrl();
//     print("Link dinamico creato " + dynamicUrl.toString());
//     return dynamicUrl;
//   }
//
// }