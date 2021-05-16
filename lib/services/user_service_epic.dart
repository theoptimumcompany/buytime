import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
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
    //print("USER_SERVICE_EPIC - UserRequstService => CATCHED ACTION");
    return actions.whereType<LoggedUser>().asyncMap((event) async {
      debugPrint("USER_SERVICE_EPIC - UserRequstService => USER ID: ${event.userState.uid}");

      DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance /// 1 READ - 1 DOC
          .collection('user')
          .doc(event.userState.uid)
          .get()
          .catchError((onError) {
        debugPrint('USER_SERVICE_EPIC - UserRequstService => ERROR: $onError');
        stateFromFirebase = event.userState;
        ///Return
      });


      if(userDocumentSnapshot.data() != null && userDocumentSnapshot.data().isNotEmpty)
        stateFromFirebase = UserState.fromJson(userDocumentSnapshot.data());

      debugPrint("USER_SERVICE_EPIC - UserRequstService => USER STATE: " + stateFromFirebase.toString());

      statisticsState = store.state.statistics;
      int reads = statisticsState.userRequestServiceRead;
      int writes = statisticsState.userRequestServiceWrite;
      int documents = statisticsState.userRequestServiceDocuments;
      debugPrint('USER_SERVICE_EPIC - UserRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++documents;
      debugPrint('USER_SERVICE_EPIC - UserRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.userRequestServiceRead = reads;
      statisticsState.userRequestServiceWrite = writes;
      statisticsState.userRequestServiceDocuments = documents;

      ///Return
      /*
      return FirebaseFirestore.instance
          .collection('user')
          .doc(event.userState.uid)
          .get()
          .then((snapshot) {
        event.userState.salesman = snapshot.get('salesman');
        event.userState.owner = snapshot.get('owner');
        event.userState.manager = snapshot.get("manager");
        event.userState.admin = snapshot.get("admin");
        event.userState.worker = snapshot.get("worker");
        return new CreateUser(event.userState);
      }).catchError((onError) {
        print(onError);
        return new CreateUser(event.userState);
      });*/
    }).expand((element) {
      var actionArray = [];
      actionArray.add(UpdateStatistics(statisticsState));
      if(stateFromFirebase != null)
       actionArray.add(UserToState(stateFromFirebase));
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
      docUser.update(<String, dynamic>{event.device.name: FieldValue.arrayUnion(idField),}); ///1 WRITE

      statisticsState = store.state.statistics;
      int reads = statisticsState.userEditDeviceRead;
      int writes = statisticsState.userEditDeviceWrite;
      int documents = statisticsState.userEditDeviceDocuments;
      debugPrint('USER_SERVICE_EPIC - UserEditDevice => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++writes;
      ++documents;
      debugPrint('USER_SERVICE_EPIC - UserEditDevice =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.userEditDeviceRead = reads;
      statisticsState.userEditDeviceWrite = writes;
      statisticsState.userEditDeviceDocuments = documents;

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
      docUser.update(<String, dynamic>{event.token.name: FieldValue.arrayUnion(idField),}); /// 1 WRITE

      statisticsState = store.state.statistics;
      int reads = statisticsState.userEditTokenRead;
      int writes = statisticsState.userEditTokenWrite;
      int documents = statisticsState.userEditTokenDocuments;
      debugPrint('USER_SERVICE_EPIC - UserEditToken => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++writes;
      ++documents;
      debugPrint('USER_SERVICE_EPIC - UserEditToken =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.userEditTokenRead = reads;
      statisticsState.userEditTokenWrite = writes;
      statisticsState.userEditTokenDocuments = documents;

    }).expand((element) => [
      UpdateStatistics(statisticsState)
    ]);
  }
}
