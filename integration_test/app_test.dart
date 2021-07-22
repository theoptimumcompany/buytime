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

    ///Login Error
    testWidgets('Login erorr', (tester) async {
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

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      await tester.tap(find.text('Log In'.toUpperCase()));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.enterText(find.byKey(ValueKey('email_key')), 'test_admin@buytime.network');
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(ValueKey('password_key')), 'Test2020');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      //debugPrint('DESC: ${find.byKey(ValueKey('error_key'))}');

      ///Login => Landing => Business List
      await tester.tap(find.byKey(ValueKey('login_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('The password is invalid or the user does not have a password.'), findsOneWidget);
    });

    ///Login Admin => Landing => Redirect Business List
    testWidgets('Login test', (tester) async {
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

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      await tester.tap(find.text('Log In'.toUpperCase()));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.enterText(find.byKey(ValueKey('email_key')), 'test_admin@buytime.network');
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(ValueKey('password_key')), 'test2020');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      //debugPrint('DESC: ${find.byKey(ValueKey('error_key'))}');

      ///Login => Landing => Business List
      await tester.tap(find.byKey(ValueKey('login_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      ///Scroll up and down
      final listFinder = find.byType(ListView);
      await binding.watchPerformance(() async {
        await tester.fling(listFinder, const Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, const Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');

      ///Business List => First Business of the list
      if(!find.byKey(ValueKey('business_0_key')).toString().contains('zero widgets with key')){
        debugPrint('KEY VALUE: ${find.byKey(ValueKey('business_0_key')).toString()}');
        await tester.tap(find.byKey(ValueKey('business_0_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        ///Business => Internal Service List
        await tester.tap(find.byKey(ValueKey('internal_service_manage_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        ///Internal Service List => Business
        await tester.tap(find.byKey(ValueKey('back_from_interval_service_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        ///Business => External Business List
        debugPrint('KEY VALUE: ${find.byKey(ValueKey('external_business_manage_key')).toString()}');

        if(!find.byKey(ValueKey('external_business_manage_key')).toString().contains('zero widgets with key')){
          await tester.tap(find.byKey(ValueKey('external_business_manage_key')));
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }else{
          debugPrint('KEY \'external_business_manage_key\' not found');
        }
        /*await tester.ensureVisible(find.byKey(ValueKey('external_business_manage_key')));
      await tester.tap(find.byKey(ValueKey('external_business_manage_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));*/
      }else{
        debugPrint('KEY \'business_0_key\' not found');
      }

    });

  });
}