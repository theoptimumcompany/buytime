import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class UserRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    print("UserService catched action");
    return actions.whereType<LoggedUser>().asyncMap((event) async {
      print("UserService user id:" + event.userState.uid);

      DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(event.userState.uid)
          .get()
          .catchError((onError) {
        print(onError);
        return new CreateUser(event.userState);
      });
      UserState stateFromFirebase = UserState.fromJson(userDocumentSnapshot.data());
      print("user_service_epic: " + stateFromFirebase.toString());
      return new CreateUser(stateFromFirebase);

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
      });
    });
  }
}

class UserEditDevice implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateUserDevice>().asyncMap((event) {
      print("UserService edit field : " + event.device.name);
      List<String> idField = [event.device.id];
      DocumentReference docUser =
          FirebaseFirestore.instance.collection('user').doc(event.device.user_uid);
      docUser.update(<String, dynamic>{
        event.device.name: FieldValue.arrayUnion(idField),
      });
    });
  }
}

class UserEditToken implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateUserToken>().asyncMap((event) {
      print("UserService edit token : " + event.token.name);
      List<String> idField = [event.token.id];
      DocumentReference docUser =
      FirebaseFirestore.instance.collection('user').doc(event.token.user_uid);
      docUser.update(<String, dynamic>{
        event.token.name: FieldValue.arrayUnion(idField),
      });
    });
  }
}
