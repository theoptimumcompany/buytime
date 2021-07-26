import 'package:Buytime/UI/management/service_internal/RUI_M_service_list.dart';
import 'package:Buytime/app_state.dart';
import 'package:Buytime/combined_epics.dart';
import 'package:Buytime/environment_abstract.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/navigation/navigation_middleware.dart';
import 'package:Buytime/reblox/reducer/app_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:Buytime/main.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

///Integration test run cmd
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/app_test.dart --debug

void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    ///Free Access
    testWidgets('Free Access', (tester) async {
      await loadApp(tester);

      debugPrint('KEY VALUE: ${find.byKey(ValueKey('free_access_key')).toString()}');
      await tester.tap(find.byKey(ValueKey('free_access_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

   /* ///Registration Error => Wrong Password
    testWidgets('Registration erorr', (tester) async {
      await loadApp(tester);

      await tester.tap(find.byKey(ValueKey('home_register_key')));
      ///Home => Login
      await register(tester, 'test_automatico@buytime.network', 'test2021');
      expect(find.text('Password has a minimum of 6 characters and at least 1 digit, 1 lowercase char and 1 uppercase char'), findsOneWidget);
    });

    ///Registration User => Landing => log out
    testWidgets('Registration User', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => registration
      await register(tester, 'test_automatico@buytime.network', 'Test2021');

      ///Log out
      await tester.tap(find.byKey(ValueKey('log_out_key')));
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    ///Registration Error => Email exists
    testWidgets('Registration erorr', (tester) async {
      await loadApp(tester);

      await tester.tap(find.byKey(ValueKey('home_register_key')));
      ///Home => Login
      await register(tester, 'test_automatico@buytime.network', 'Test2021');
      expect(find.text('The email address is already in use by another account.'), findsOneWidget);
    });*/

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
      ChangeNotifierProvider(create: (_) => Spinner([], [])),
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