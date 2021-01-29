
import 'package:Buytime/UI/user/UI_U_Tabs.dart';
import 'package:Buytime/UI/user/landing/UI_U_Landing.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:Buytime/UI/user/landing/invite_guest_form.dart';

class DynamicLinkService {


  // Future<void> retrieveDynamicLink(BuildContext context) async {
  //   try {
  //     print("Prima dell'initial Link");
  //     PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
  //     print("Dopo initial Link");
  //     print('dynamic_links_service: data: $data');
  //     final Uri deepLink = data?.link;
  //     print('dynamic_links_service: deeplink: $deepLink');
  //     if (deepLink != null) {
  //
  //       if (deepLink.queryParameters.containsKey('booking')) {
  //         String id = deepLink.queryParameters['booking'];
  //         print('dynamin_links_service: id: $id');
  //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => InviteGuestForm()));
  //         //Navigator.of(context).push(MaterialPageRoute(builder: (context) => TestScreen(id: id);
  //         }
  //
  //       //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Landing()));
  //     }
  //     else{
  //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => UI_U_Tabs()));
  //     }
  //
  //     /*FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
  //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => InviteGuestForm()));
  //     });*/
  //     // FirebaseDynamicLinks.instance.onLink(
  //     //     onSuccess: (PendingDynamicLinkData dynamicLink) async {
  //     //       final Uri deepLink = dynamicLink?.link;
  //     //       print('dynamin_links_service: deeplink in onlink: $deepLink');
  //     //       if (deepLink != null) {
  //     //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => InviteGuestForm()));
  //     //       }
  //     //
  //     //     }, onError: (OnLinkErrorException e) async {
  //     //   print('onLinkError');
  //     //   print(e.message);
  //     // });
  //
  //   } catch (e) {
  //     print('dynamin_links_service: ${e.toString()}');
  //   }
  // }


  Future<Uri> createDynamicLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://buytime.page.link',
      link: Uri.parse('https://buytime.page.link/booking/?booking=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.theoptimumcompany.buytime',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.theoptimumcompany.buytime',
        minimumVersion: '1',
        appStoreId: '1508552491',
      ),
    );
    var dynamicUrl = await parameters.buildUrl();
    print("Link dinamico creato " + dynamicUrl.toString());
    return dynamicUrl;
  }

}