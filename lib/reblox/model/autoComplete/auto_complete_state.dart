import 'dart:convert';

import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AutoCompleteState {

  ///Storage
  final storage = new FlutterSecureStorage();

  String email;
  String password;

  List<dynamic> convertToJson(List<UserSnippet> objectStateList) {
    List<dynamic> list = [];
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  AutoCompleteState({
    this.email,
    this.password
  });

  AutoCompleteState toEmpty() {
    return AutoCompleteState(
      email: "",
      password: "",
    );
  }

  String enumToString(AutoCompleteState bookingStatus){
    return bookingStatus.toString().split('.').last;
  }

  AutoCompleteState.fromState(AutoCompleteState state) {
    this.email = state.email;
    this.password = state.password;
  }

  companyStateFieldUpdate(
    String email,
    String password,
  ) {
    AutoCompleteState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  AutoCompleteState copyWith({
    String email,
    String password,
  }) {
    return AutoCompleteState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  AutoCompleteState.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };

  writeToStorage(List<AutoCompleteState> state) async{

    //List<CardState> list = await readFromStorage();
    String append = '';
    state.forEach((element) {
      String read = jsonEncode(element.toJson());
      debugPrint('auto_complete_state => JSON: $read');
      append = append.isNotEmpty ? append + '|' + read : read;
    });

    debugPrint('auto_complete_state => List: $append');
    await storage.write(key: 'autoComplete', value: append);
  }

  Future<List<AutoCompleteState>> readFromStorage() async {
    List<AutoCompleteState> list = [];
    String tmpString = await storage.read(key: 'autoComplete') ?? '';
    debugPrint('auto_complete_state => List: $tmpString');

    if (tmpString.isNotEmpty) {
      List<String> cards = tmpString.split('|');
      cards.forEach((element) {
        Map<String, dynamic> map = jsonDecode(element);
        debugPrint('auto_complete_state => EMAIL: ${map['email']}');
        if (element.isNotEmpty) {
          AutoCompleteState state = AutoCompleteState.fromJson(map);
          list.add(state);
        }
      });
    }

    return list;
  }

}
