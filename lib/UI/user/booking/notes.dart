/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/widgets.dart';
//
// class ProductList extends StatefulWidget {
//   @override
//   _ProductListState createState() => _ProductListState();
// }
//
// class _ProductListState extends State<ProductList> {
//   StreamController<List<DocumentSnapshot>> _streamController =
//   StreamController<List<DocumentSnapshot>>();
//   List<DocumentSnapshot> _products = [];
//
//   bool _isRequesting = false;
//   bool _isFinish = false;
//
//   void onChangeData(List<DocumentChange> documentChanges) {
//     var isChange = false;
//     documentChanges.forEach((productChange) {
//       if (productChange.type == DocumentChangeType.removed) {
//         _products.removeWhere((product) {
//           return productChange.document.documentID == product.documentID;
//         });
//         isChange = true;
//       } else {
//
//         if (productChange.type == DocumentChangeType.modified) {
//           int indexWhere = _products.indexWhere((product) {
//             return productChange.document.documentID == product.documentID;
//           });
//
//           if (indexWhere >= 0) {
//             _products[indexWhere] = productChange.document;
//           }
//           isChange = true;
//         }
//       }
//     });
//
//     if(isChange) {
//       _streamController.add(_products);
//     }
//   }
//
//   @override
//   void initState() {
//     Firestore.instance
//         .collection('products')
//         .snapshots()
//         .listen((data) => onChangeData(data.documentChanges));
//
//     requestNextPage();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _streamController.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return NotificationListener<ScrollNotification>(
//         onNotification: (ScrollNotification scrollInfo) {
//           if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
//             requestNextPage();
//           }
//           return true;
//         },
//         child: StreamBuilder<List<DocumentSnapshot>>(
//           stream: _streamController.stream,
//           builder: (BuildContext context,
//               AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
//             if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
//             switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//                 return new Text('Loading...');
//               default:
//                 log("Items: " + snapshot.data.length.toString());
//                 return ListView.separated(
//                   separatorBuilder: (context, index) => Divider(
//                     color: Colors.black,
//                   ),
//                   itemCount: snapshot.data.length,
//                   itemBuilder: (context, index) => Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 32),
//                     child: new ListTile(
//                       title: new Text(snapshot.data[index]['name']),
//                       subtitle: new Text(snapshot.data[index]['description']),
//                     ),
//                   ),
//                 );
//             }
//           },
//         ));
//   }
//
//   void requestNextPage() async {
//     if (!_isRequesting && !_isFinish) {
//       QuerySnapshot querySnapshot;
//       _isRequesting = true;
//       if (_products.isEmpty) {
//         querySnapshot = await Firestore.instance
//             .collection('products')
//             .orderBy('index')
//             .limit(5)
//             .getDocuments();
//       } else {
//         querySnapshot = await Firestore.instance
//             .collection('products')
//             .orderBy('index')
//             .startAfterDocument(_products[_products.length - 1])
//             .limit(5)
//             .getDocuments();
//       }
//
//       if (querySnapshot != null) {
//         int oldSize = _products.length;
//         _products.addAll(querySnapshot.documents);
//         int newSize = _products.length;
//         if (oldSize != newSize) {
//           _streamController.add(_products);
//         } else {
//           _isFinish = true;
//         }
//       }
//       _isRequesting = false;
//     }
//   }
// }
//
//
//
//
// StreamBuilder<QuerySnapshot>(
// stream: _orderNotificationStream,
// builder: (context, AsyncSnapshot<DocumentSnapshot> notificationSnapshot) {
// if (notificationSnapshot.hasError) {
// return Text('Something went wrong');
// }
//
// if (notificationSnapshot.connectionState == ConnectionState.waiting) {
// return Text("Loading");
// }
// orderDetails = NotificationState.fromJson(notificationSnapshot.data.data());