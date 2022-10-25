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

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

import '../../main.dart';

List<Middleware<AppState>> createNavigationMiddleware(var epics) {
  return [
    EpicMiddleware<AppState>(epics),
    TypedMiddleware<AppState, NavigateReplaceAction>(_navigateReplace),
    TypedMiddleware<AppState, NavigatePushAction>(_navigate),
    //TypedMiddleware<AppState, NavigatePopAction>(_navigatePop),
  ];
}

_navigateReplace(Store<AppState> store, action, NextDispatcher next) {
  final routeName = (action as NavigateReplaceAction).routeName;
  if (store.state.route.last != routeName) {
    navigatorKey.currentState.pushReplacementNamed(routeName);
  }
  next(action); //This need to be after name checks
}

/*_navigatePop(Store<AppState> store, action, NextDispatcher next) {
  final routeName = (action as NavigatePopAction).lastRouteName;
  if (store.state.route.last == routeName) {
    //navigatorKey.currentState.pop();
  }
  next(action); //This need to be after name checks
}*/

_navigate(Store<AppState> store, action, NextDispatcher next) {
  final routeName = (action as NavigatePushAction).routeName;
  debugPrint("navigation_middleware => ROUTE NAVIGATE : " + routeName);
  navigatorKey.currentState.pushNamed(routeName);
  next(action); //This need to be after name checks
}

