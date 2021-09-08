import 'package:Buytime/UI/management/service_internal/RUI_M_service_list.dart';
import 'package:Buytime/UI/user/service/UI_U_service_reserve.dart';
import 'package:Buytime/UI/user/turist/RUI_U_service_explorer.dart';
import 'package:Buytime/app_state.dart';
import 'package:Buytime/combined_epics.dart';
import 'package:Buytime/environment_abstract.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/navigation/navigation_middleware.dart';
import 'package:Buytime/reblox/reducer/app_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:integration_test/integration_test.dart';
import 'package:Buytime/main.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

///Integration test run cmd
///
///Android Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/app_test.dart --debug
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/regression_test.dart --debug
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/single_test.dart --debug
///
///iOS Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD -t integration_test/app_test.dart --debug


void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;




  });
}

///Load Application
Future<void> loadApp(WidgetTester tester) async {
  final epics = combinedEpics;
  final _initialState = appState;
  final store = new Store<AppState>(
    appReducer,
    initialState: _initialState,
    middleware: createNavigationMiddleware(epics),
  );

  WidgetsFlutterBinding.ensureInitialized();
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.PROD,
  );
  Environment().initConfig(environment);
  ///App Load
  await tester.pumpWidget(MultiProvider(
    providers: [
      //ChangeNotifierProvider(create: (_) => NavigationState()),
      ChangeNotifierProvider(create: (_) => Spinner(true,[],[], [])),
      ChangeNotifierProvider(create: (_) => ReserveList([], OrderReservableState().toEmpty(),[], [], [], [])),
      ChangeNotifierProvider(create: (_) => Explorer(false, [])),
    ],
    child: Buytime(store: store),
  ));
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

///User Login
Future<void> login(WidgetTester tester, String email, String password) async {
  await tester.tap(find.byKey(ValueKey('home_login_key')));
  //await tester.tap(find.text('Log In'.toUpperCase()));
  await tester.pumpAndSettle(const Duration(seconds: 1));

  await tester.enterText(find.byKey(ValueKey('email_key')), email);
  await tester.pumpAndSettle(const Duration(seconds: 1));
  await tester.enterText(find.byKey(ValueKey('password_key')), password);
  await tester.pumpAndSettle(const Duration(seconds: 2));

  await tester.tap(find.byKey(ValueKey('login_key')));
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

Future<void> touristLogin(WidgetTester tester, String email, String password) async {
  await tester.enterText(find.byKey(ValueKey('email_key')), email);
  await tester.pumpAndSettle(const Duration(seconds: 1));
  await tester.enterText(find.byKey(ValueKey('password_key')), password);
  await tester.pumpAndSettle(const Duration(seconds: 2));

  await tester.tap(find.byKey(ValueKey('login_key')));
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

///User Registration
Future<void> register(WidgetTester tester, String email, String password) async {
  await tester.tap(find.byKey(ValueKey('home_register_key')));
  //await tester.tap(find.text('Register'.toUpperCase()));
  await tester.pumpAndSettle(const Duration(seconds: 1));

  await tester.enterText(find.byKey(ValueKey('email_key')), email);
  await tester.pumpAndSettle(const Duration(seconds: 1));
  await tester.enterText(find.byKey(ValueKey('password_key')), password);
  await tester.pumpAndSettle(const Duration(seconds: 2));
  await tester.tap(find.byKey(ValueKey('eye_key')));
  await tester.pumpAndSettle(const Duration(seconds: 1));

  await tester.tap(find.byKey(ValueKey('registration_key')));
  await tester.pumpAndSettle(const Duration(seconds: 2));
}