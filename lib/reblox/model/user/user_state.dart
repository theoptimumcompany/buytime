import 'package:Buytime/reblox/model/role/role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_state.g.dart';


@JsonSerializable(explicitToJson: true)
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
  List<String> token;
  @JsonKey(ignore: true)
  List<String> managerAccessTo;
  @JsonKey(ignore: true)
  List<String> workerAccessTo;


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
    this.managerAccessTo,
    this.workerAccessTo,
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
    this.managerAccessTo = user.managerAccessTo;
    this.workerAccessTo = user.workerAccessTo;
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
      managerAccessTo: [""],
      workerAccessTo: [""],
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
        List<String> token,
        List<String> managerAccessTo,
        List<String> workerAccessTo,
      }) {
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
      managerAccessTo: managerAccessTo ?? this.managerAccessTo,
      workerAccessTo: workerAccessTo ?? this.workerAccessTo,
    );
  }

  UserState.fromFirebaseUser(User user, String deviceId, List<String> serverToken)
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
        managerAccessTo = [],
        workerAccessTo = [],
        photo = user.photoURL;

  getRole() {
    if (this == null) return Role.user;
    if (this.admin) return Role.admin;
    if (this.salesman) return Role.salesman;
    if (this.owner) return Role.owner;
    if (this.manager) return Role.manager;
    if (this.worker) return Role.worker;
    return Role.user;
  }

  factory UserState.fromJson(Map<String, dynamic> json) => _$UserStateFromJson(json);
  Map<String, dynamic> toJson() => _$UserStateToJson(this);
}
