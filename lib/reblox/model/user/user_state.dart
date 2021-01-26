import 'package:Buytime/reblox/model/role/role.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserState {
  String name;
  String surname;
  String email;
  String uid;
  String birth;
  String gender;
  String city;
  int zip;
  String street;
  String nation;
  int cellularPhone;
  bool owner = false;
  bool salesman = false;
  bool manager = false;
  bool admin = false;
  bool worker = false;
  String photo;
  List<String> device;
  String token;

  UserState({
    this.name,
    this.surname,
    this.email,
    this.uid,
    this.birth,
    this.gender,
    this.city,
    this.street,
    this.nation,
    this.cellularPhone,
    this.zip,
    this.owner = false,
    this.salesman = false,
    this.manager = false,
    this.admin = false,
    this.worker = false,
    this.photo,
    this.device,
    this.token,
  });

  UserState.fromState(UserState user) {
    this.name = user.name;
    this.surname = user.surname;
    this.email = user.email;
    this.uid = user.uid;
    this.birth = user.birth;
    this.gender = user.gender;
    this.city = user.city;
    this.street = user.street;
    this.nation = user.nation;
    this.cellularPhone = user.cellularPhone;
    this.zip = user.zip;
    this.owner = user.owner;
    this.salesman = user.salesman;
    this.manager = user.manager;
    this.admin = user.admin;
    this.worker = user.worker;
    this.photo = user.photo;
    this.device = user.device;
    this.token = user.token;
  }

  UserState toEmpty() {
    return UserState(
      name: "",
      surname: "",
      email: "",
      uid: "",
      birth: "01-09-1990",
      gender: "",
      city: "",
      zip: 00000,
      street: "",
      nation: "",
      cellularPhone: 0,
      owner: false,
      salesman: false,
      manager: false,
      admin: false,
      worker: false,
      photo: "",
      device: [""],
    );
  }

  UserState copyWith(
      {String name,
      String surname,
      String email,
      String uid,
      String birth,
      String gender,
      String city,
      int zip,
      String street,
      String nation,
      int cellularPhone,
      bool owner,
      bool salesman,
      bool manager,
      bool admin,
      bool worker,
      String photo,
      List<String> device,
      String token}) {
    return UserState(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      city: city ?? this.city,
      zip: zip ?? this.zip,
      street: street ?? this.street,
      nation: nation ?? this.nation,
      cellularPhone: cellularPhone ?? this.cellularPhone,
      owner: owner ?? this.owner,
      salesman: salesman ?? this.salesman,
      manager: manager ?? this.manager,
      admin: admin ?? this.admin,
      worker: worker ?? this.worker,
      photo: photo ?? this.photo,
      device: device ?? this.device,
      token: token ?? this.token,
    );
  }

  UserState.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        surname = json['surname'],
        email = json['email'],
        uid = json['uid'],
        birth = json['birth'],
        gender = json['gender'],
        city = json['city'],
        zip = json['zip'],
        street = json['street'],
        nation = json['nation'],
        cellularPhone = json['cellularPhone'],
        owner = json['owner'],
        salesman = json['salesman'],
        manager = json['manager'],
        worker = json['worker'],
        admin = json['admin'],
        // device = json['device'],
        // token = json['token'],
        photo = json['photo'];


  UserState.fromFirebaseUser(User user, String deviceId, String serverToken)
      : name = user.displayName,
        surname = "",
        email = user.email,
        uid = user.uid,
        birth = "",
        gender = "",
        city = "",
        zip = 0,
        street = "",
        nation = "",
        cellularPhone = 0,
        owner = false,
        salesman = false,
        manager = false,
        worker = false,
        admin = false,
        device = [deviceId],
        token = serverToken,
        photo = user.photoURL;

  Map<String, dynamic> toJson() => {
        'name': name,
        'surname': surname,
        'email': email,
        'uid': uid,
        'birth': birth,
        'gender': gender,
        'city': city,
        'zip': zip,
        'street': street,
        'nation': nation,
        'cellularPhone': cellularPhone,
        'owner': owner,
        'salesman': salesman,
        'manager': manager,
        'worker': worker,
        'admin': admin,
        'photo': photo,
        'device': device,
        'token': token,
      };



  getRole() {
    if (this == null) return Role.user;
    if (this.admin) return Role.admin;
    if (this.manager) return Role.manager;
    if (this.salesman) return Role.salesman;
    if (this.owner) return Role.owner;
    if (this.worker) return Role.worker;
    return Role.user;
  }
}
