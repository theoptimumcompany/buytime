
import 'package:BuyTime/reblox/model/business/business_state.dart';
import 'package:BuyTime/reusable/snippet/generic.dart';
import 'package:BuyTime/reblox/model/user/user_state.dart';
import 'package:BuyTime/reusable/snippet/device.dart';
import 'package:BuyTime/reusable/snippet/token.dart';

class UserRequest {
  String _userStateId;
  UserRequest(this._userStateId);
  String get userStateId => _userStateId;
}

class UnlistenUser {
}

class UpdateUser {
  UserState _userState;
  UpdateUser(this._userState);
  UserState get userState => _userState;
}


class UpdatedUser {
  UserState _userState;
  UpdatedUser(this._userState);
  UserState get userState => _userState;
}

class CreateUser {
  UserState _userState;
  CreateUser(this._userState);
  UserState get userState => _userState;
}

class LoggedUser {
  UserState _userState;
  LoggedUser(this._userState);
  UserState get userState => _userState;
}

class UpdateUserDevice {
  Device _device;
  UpdateUserDevice(this._device);
  Device get device => _device;
}

class UpdateUserToken {
  Token _token;
  UpdateUserToken(this._token);
  Token get token => _token;
}

class CreatedUser {
  UserState _userState;
  CreatedUser(this._userState);
  UserState get userState => _userState;
}
class CreatedUserFromStore {
  UserState userState;
  CreatedUserFromStore();
}

class UserChanged {
  UserState _userState;
  UserChanged(this._userState);
  UserState get userState => _userState;
}

class SetUserName
{
  String _name;
  SetUserName(this._name);
  String get name => _name;
}
class SetUserSurname
{
  String _surname;
  SetUserSurname(this._surname);
  String get surname => _surname;
}
class SetUserEmail
{
  String _email;
  SetUserEmail(this._email);
  String get email => _email;
}
class SetUserUid
{
  String _uid;
  SetUserUid(this._uid);
  String get uid => _uid;
}
class SetUserBirth
{
  String _birth;
  SetUserBirth(this._birth);
  String get birth => _birth;
}
class SetUserGender
{
  String _gender;
  SetUserGender(this._gender);
  String get gender => _gender;
}
class SetUserCity
{
  String _city;
  SetUserCity(this._city);
  String get city => _city;
}
class SetUserZip
{
  int _zip;
  SetUserZip(this._zip);
  int get zip => _zip;
}
class SetUserStreet
{
  String _street;
  SetUserStreet(this._street);
  String get street => _street;
}
class SetUserNation
{
  String _nation;
  SetUserNation(this._nation);
  String get nation => _nation;
}
class SetUserCellularPhone
{
  int _cellularPhone;
  SetUserCellularPhone(this._cellularPhone);
  int get cellularPhone => _cellularPhone;
}
class SetUserOwner
{
  bool _owner;
  SetUserOwner(this._owner);
  bool get owner => _owner;
}
class SetUserSalesman
{
  bool _salesman;
  SetUserSalesman(this._salesman);
  bool get salesman => _salesman;
}
class SetUserManager
{
  bool _manager;
  SetUserManager(this._manager);
  bool get manager => _manager;
}
class SetUserPhoto
{
  String _photo;
  SetUserPhoto(this._photo);
  String get photo => _photo;
}
class SetUserDevice
{
  List<String> _device;
  SetUserDevice(this._device);
  List<String> get device => _device;
}

class SetUserStateToEmpty {
  String _something;
  SetUserStateToEmpty();
  String get something => _something;
}


UserState userReducer(UserState state, action) {
  UserState userState = new UserState.fromState(state);
  if (action is SetUserStateToEmpty) {
    userState = UserState().toEmpty();
    return userState;
  }
  if (action is SetUserName) {
    userState.name = action.name;
    return userState;
  }
  if (action is SetUserSurname) {
    userState.surname = action.surname;
    return userState;
  }
  if (action is SetUserEmail) {
    userState.email = action.email;
    return userState;
  }
  if (action is SetUserUid) {
    userState.uid = action.uid;
    return userState;
  }
  if (action is SetUserBirth) {
    userState.birth = action.birth;
    return userState;
  }
  if (action is SetUserGender) {
    userState.gender = action.gender;
    return userState;
  }
  if (action is SetUserCity) {
    userState.city = action.city;
    return userState;
  }
  if (action is SetUserZip) {
    userState.zip = action.zip;
    return userState;
  }
  if (action is SetUserStreet) {
    userState.street = action.street;
    return userState;
  }
  if (action is SetUserNation) {
    userState.nation = action.nation;
    return userState;
  }
  if (action is SetUserCellularPhone) {
    userState.cellularPhone = action.cellularPhone;
    return userState;
  }
  if (action is SetUserOwner) {
    userState.owner = action.owner;
    return userState;
  }
  if (action is SetUserSalesman) {
    userState.salesman = action.salesman;
    return userState;
  }
  if (action is SetUserManager) {
    userState.manager = action.manager;
    return userState;
  }
  if (action is SetUserPhoto) {
    userState.photo = action.photo;
    return userState;
  }
  if (action is SetUserDevice) {
    userState.device = action.device;
    return userState;
  }
  if (action is UserChanged) {
    userState = action.userState.copyWith();
    return userState;
  }
  if (action is CreateUser) {
    userState = action.userState.copyWith();
    return userState;
  }


  return state;
}