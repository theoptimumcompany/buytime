import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier {

  FireStorageService() {
    initializeApp(
        apiKey: "AIzaSyAqLCyfL4leWMXJoLKM1_He-p400XIuAmo",
        authDomain: "buytime-458a1.firebaseapp.com",
        databaseURL: "https://buytime-458a1.firebaseio.com",
        projectId: "buytime-458a1",
        storageBucket: "buytime-458a1.appspot.com",
        messagingSenderId: "1009672636913",
        appId: "1:1009672636913:web:8c0345f639441bc0cfdc50",
        measurementId: "G-3L79M45JSN");
  }

  static Future<dynamic> loadFromStorage(BuildContext context, String image) async {
    var url = await storage().ref(image).getDownloadURL();
    return url;
  }
}