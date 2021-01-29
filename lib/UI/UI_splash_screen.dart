// library ui_splash_screen_widget;
//
// import 'package:Buytime/utils/theme/buytime_theme.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, }) : super(key: key);
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
//
//
// class _MyHomePageState extends State<MyHomePage> {
//
//
//
//
//   @override
//   Future<void> initState() async {
//     await  Firebase.initializeApp();
//     this.initDynamicLinks();
//     super.initState();
//   }
//
//
//   void initDynamicLinks() async {
//     FirebaseDynamicLinks.instance.onLink(
//         onSuccess: (PendingDynamicLinkData dynamicLink) async {
//           final Uri deepLink = dynamicLink?.link;
//
//           if (deepLink != null) {
//             Navigator.pushNamed(context, deepLink.path);
//           }
//         },
//         onError: (OnLinkErrorException e) async {
//           print('onLinkError');
//           print(e.message);
//         }
//     );

  //   final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri deepLink = data?.link;
  //
  //   if (deepLink != null) {
  //     Navigator.pushNamed(context, deepLink.path);
  //   }
  // }
//
//    @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: BuytimeTheme.UserPrimary,
//       body : Container(
//         margin: EdgeInsets.only(bottom: height/3,),
//         child: Center(child: new Image.asset('assets/img/brand/logo.png', width: 100.0, height: 100.0,)),
//       ),
//     );
//   }
// }
//
