import 'package:Buytime/environment_abstract.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier {

  FireStorageService() {
    initializeApp(
        apiKey: Environment().config.googleApiKey,
        authDomain: Environment().config.fireStorageServiceAuthDomain,
        databaseURL: Environment().config.fireStorageServiceDatabaseURL,
        projectId: Environment().config.fireStorageServiceProjectId,
        storageBucket: Environment().config.fireStorageServiceStorageBucket,
        messagingSenderId: Environment().config.fireStorageServiceMessagingSenderId,
        appId: Environment().config.fireStorageServiceAppId,
        measurementId: Environment().config.fireStorageServiceMeasurementId);
  }

  static Future<dynamic> loadFromStorage(BuildContext context, String image) async {
    var url = await storage().ref(image).getDownloadURL();
    return url;
  }
}