import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class UserRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  UserState stateFromFirebase;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<LoggedUser>().asyncMap((event) async {
      debugPrint("USER_SERVICE_EPIC - UserRequestService => USER ID: ${event.userState.uid}");
      DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance /// 1 READ - 1 DOC
          .collection('user')
          .doc(event.userState.uid).get()
          .catchError((onError) {
        debugPrint('USER_SERVICE_EPIC - UserRequstService => ERROR: $onError');
        stateFromFirebase = event.userState;
        ///Return
      });
      if(userDocumentSnapshot.data() != null)
        stateFromFirebase = UserState.fromJson(userDocumentSnapshot.data());
      debugPrint("USER_SERVICE_EPIC - UserRequstService => USER STATE uid: " + stateFromFirebase.uid + " email: " + stateFromFirebase.email);
      statisticsState = store.state.statistics;
    }).expand((element) {
      var actionArray = [];
      actionArray.add(UpdateStatistics(statisticsState));
      if(stateFromFirebase != null)
       actionArray.add(UserToState(stateFromFirebase));

      //actionArray.add(NavigatePushAction(AppRoutes.serviceExplorer));
      return actionArray;
    });
  }
}

class UserEditDevice implements EpicClass<AppState> {
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateUserDevice>().asyncMap((event) {
      debugPrint("USER_SERVICE_EPIC - UserEditDevice => DEVICE NAME: ${event.device.name}, DEVICE ID: ${event.device.id}, DEVICE USER ID: ${event.device.user_uid}");
      List<String> idField = [event.device.id];
      DocumentReference docUser = FirebaseFirestore.instance.collection('user').doc(event.device.user_uid); /// 1 READ - 1 DOC
      docUser.update(<String, dynamic>{event.device.name: idField,}); ///1 WRITE
      statisticsState = store.state.statistics;
    }).expand((element) => [
      UpdateStatistics(statisticsState)
    ]);
  }
}

class UserEditToken implements EpicClass<AppState> {
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateUserToken>().asyncMap((event) {
      debugPrint("USER_SERVICE_EPIC - UserEditToken => TOKEN NAME: ${event.token.name}, TOKEN ID: ${event.token.id}, TOKEN USER ID: ${event.token.user_uid}");
      List<String> idField = [event.token.id];
      DocumentReference docUser = FirebaseFirestore.instance.collection('user').doc(event.token.user_uid); /// 1 READ - 1 DOC
      docUser.update(<String, dynamic>{event.token.name: idField,}); /// 1 WRITE
      statisticsState = store.state.statistics;
    }).expand((element) => [
      UpdateStatistics(statisticsState)
    ]);
  }
}

Future<UserState> requestForUserDocument(String uid) async {
  UserState userStateFromFirebase;
  DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
      .collection('user')
      .doc(uid)
      .get()
      .catchError((onError) {
          debugPrint('USER_SERVICE_EPIC - requestForUserDocument => ERROR: $onError');
        });
  if(userDocumentSnapshot.data() != null)
    userStateFromFirebase = UserState.fromJson(userDocumentSnapshot.data());
  return userStateFromFirebase;
}
