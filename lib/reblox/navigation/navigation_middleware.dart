import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

import '../../main.dart';

List<Middleware<AppState>> createNavigationMiddleware(var epics) {
  return [
    EpicMiddleware<AppState>(epics),
    TypedMiddleware<AppState, NavigateReplaceAction>(_navigateReplace),
    TypedMiddleware<AppState, NavigatePushAction>(_navigate),
  ];
}

_navigateReplace(Store<AppState> store, action, NextDispatcher next) {
  final routeName = (action as NavigateReplaceAction).routeName;
  if (store.state.route.last != routeName) {
    navigatorKey.currentState.pushReplacementNamed(routeName);
  }
  next(action); //This need to be after name checks
}

_navigate(Store<AppState> store, action, NextDispatcher next) {
  final routeName = (action as NavigatePushAction).routeName;

  ///Need when the global key will be updated inr eal time
  /*if (store.state.route.last != routeName) {

  }*/
  navigatorKey.currentState.pushNamed(routeName);
  next(action); //This need to be after name checks
}