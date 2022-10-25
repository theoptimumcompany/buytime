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

import 'package:Buytime/main.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

final navigationReducer = combineReducers<List<String>>([
  TypedReducer<List<String>, NavigateReplaceAction>(_navigateReplace),
  TypedReducer<List<String>, NavigatePushAction>(_navigatePush),
  TypedReducer<List<String>, NavigatePopAction>(_navigatePop),
  TypedReducer<List<String>, NavigatePopUntilAction>(_navigatePopUntil),
]);

List<String> _navigateReplace(
    List<String> route, NavigateReplaceAction action) =>
    [action.routeName];

List<String> _navigatePush(List<String> route, NavigatePushAction action) {
  var result = List<String>.from(route);
  result.add(action.routeName);
  return result;
}

// TODO adjust logic
List<String> _navigatePopUntil(List<String> route, NavigatePopUntilAction action) {
  var result = List<String>.from(route);
  if (result != null && result.isNotEmpty) {
    result.removeLast();
  }
  return result;
}

List<String> _navigatePop(List<String> route, NavigatePopAction action) {
  var result = List<String>.from(route);
  if (result != null && result.isNotEmpty) {
    result.removeLast();
  }
  return result;
}

List<String> _navigate(List<String> route, NavigatePopAction action) {
  var result = List<String>.from(route);
  if (result != null && result.isNotEmpty) {
    navigatorKey.currentState.pop();
  }
  return result;
}

class NavigateReplaceAction {
  final String routeName;

  NavigateReplaceAction(this.routeName);

  @override
  String toString() {
    return 'MainMenuNavigateAction{routeName: $routeName}';
  }
}

class NavigatePushAction {
  final String routeName;

  NavigatePushAction(this.routeName);

  @override
  String toString() {
    return 'NavigatePushAction{routeName: $routeName}';
  }
}

class NavigatePopUntilAction {
  final String routeName;

  NavigatePopUntilAction(this.routeName);

  @override
  String toString() {
    return 'NavigatePopUntilAction{routeName: $routeName}';
  }
}

class NavigatePopAction {


  @override
  String toString() {
    debugPrint('pop');
    return 'NavigatePopAction';
  }
}
