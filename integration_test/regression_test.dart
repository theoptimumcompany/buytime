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
///
///Android Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/app_test.dart --debug
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/regression_test.dart --debug
///
///iOS Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD -t integration_test/app_test.dart --debug


void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    ///Free Access
    testWidgets('Free Access', (tester) async {
      await loadApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      debugPrint('KEY VALUE: ${find.byKey(ValueKey('free_access_key')).toString()}');
      await tester.tap(find.byKey(ValueKey('free_access_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    ///Search in turist by category name
    testWidgets('Free Access', (tester) async {
      await loadApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      debugPrint('KEY VALUE: ${find.byKey(ValueKey('free_access_key')).toString()}');
      await tester.tap(find.byKey(ValueKey('free_access_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(find.byKey(ValueKey('search_field_key')), 'Diving');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.byKey(ValueKey('search_button_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('search_clear_button_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(find.byKey(ValueKey('search_field_key')), 'tour');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.byKey(ValueKey('search_button_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('search_clear_button_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    ///Registration Error => Wrong Password
    testWidgets('Registration error', (tester) async {
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
    });

    ///Login User => Discover => Service add to cart => Payment process without ending
    testWidgets('Login User', (tester) async {
      await loadApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => registration
      await login(tester, 'test_automatico@buytime.network', 'Test2021');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      /* await tester.enterText(find.byKey(ValueKey('search_field_key')), 'Drink');
      await tester.pumpAndSettle(const Duration(seconds: 2));*/

      await tester.tap(find.text('Drink'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      if(!find.text('Appetizer').toString().contains('zero widgets with')){
        await tester.drag(find.text('Appetizer').first, const Offset(-700, 0));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_buy_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('back_cart_from_confirm_order_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('back_from_cart_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.text('Appetizer').first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('service_details_add_to_cart_key')).first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_buy_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('back_cart_from_confirm_order_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('back_from_cart_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('service_details_buy_key')).first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_buy_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('back_cart_from_confirm_order_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('add_one_item_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('remove_one_item_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        /*await tester.drag(find.text('Appetizer').first, const Offset(-700, 0));
        await tester.pumpAndSettle(const Duration(seconds: 2));*/

        // await tester.tap(find.text('Appetizer'));
        // await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    });

    ///Login User => Discover => Service reserve => Payment process without ending
    testWidgets('Login User', (tester) async {
      await loadApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => registration
      await login(tester, 'test_automatico@buytime.network', 'Test2021');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      /* await tester.enterText(find.byKey(ValueKey('search_field_key')), 'Drink');
      await tester.pumpAndSettle(const Duration(seconds: 2));*/

      await tester.tap(find.text('Diving'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      if(!find.text('Discovery Scuba Diving').toString().contains('zero widgets with')){
        await tester.drag(find.text('Discovery Scuba Diving').first, const Offset(-700, 0));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('service_slot_0_0_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('service_reserve_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_reserve_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('back_cart_from_confirm_order_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('back_from_cart_reserve_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('back_from_service_reserve_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.text('Discovery Scuba Diving').first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('service_reserve_buy_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('service_slot_0_0_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('service_reserve_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_reserve_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('back_cart_from_confirm_order_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        /*await tester.drag(find.text('Reservation').first, const Offset(-700, 0));
        await tester.pumpAndSettle(const Duration(seconds: 2));*/

        //service_reserve_buy_key

        // await tester.tap(find.text('Appetizer'));
        // await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    });

    ///Registration User => Landing => log out
    testWidgets('Registration User', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => registration
      //await register(tester, 'test_automatico@buytime.network', 'Test2021');

      ///Log out
      await tester.tap(find.byKey(ValueKey('log_out_key')));
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    ///Login User => Landing => Search
    testWidgets('Login User', (tester) async {
      await loadApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => registration
      await login(tester, 'test_user@buytime.network', 'test2020');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(find.byKey(ValueKey('guest_search_field_key')), 'Mass');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.byKey(ValueKey('guest_search_button_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('back_home_from_search_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      //final gesture = await tester.startGesture(Offset(0, 400)); //Position of the scrollview
      //await gesture.moveBy(Offset(0, -500)); //How much to scroll by
      ///Scroll down
      await tester.flingFrom(Offset(0, 400), Offset(0, -500), 2000);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      debugPrint('KEY VALUE: ${find.byKey(ValueKey('category_0_0_key')).toString()}');
      if(!find.byKey(ValueKey('category_0_0_key')).toString().contains('zero widgets with')){
        await tester.tap(find.byKey(ValueKey('category_0_0_key')).first, warnIfMissed: false);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }else{
        debugPrint('KEY \'category_0_0_key\' not found');
      }

    });

    ///Login User => Landing => Service Reserve
    testWidgets('Login User', (tester) async {
      await loadApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => registration
      //await login(tester, 'test_user@buytime.network', 'test2020');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.drag(find.text('Shiatsu Massage').first, const Offset(-700, 0));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('service_slot_0_0_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('service_reserve_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('cart_reserve_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('back_cart_from_confirm_order_key')));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.byKey(ValueKey('back_from_cart_reserve_key')));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.byKey(ValueKey('back_from_service_reserve_key')));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.text('Shiatsu Massage').first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('service_reserve_buy_key')));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.byKey(ValueKey('service_slot_0_0_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('service_reserve_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('cart_reserve_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('back_cart_from_confirm_order_key')));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      /*await tester.drag(find.text('Reservation').first, const Offset(-700, 0));
      await tester.pumpAndSettle(const Duration(seconds: 2));*/
    });

    ///Login User => Self Check in => log out
    testWidgets('Registration User', (tester) async {
      await loadApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => login
      await login(tester, 'test_self@buytime.network', 'Test2021');
      //await tester.tap(find.byKey(ValueKey('log_out_key')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.enterText(find.byKey(ValueKey('self_email_key')), 'test_self@buytime.network');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.enterText(find.byKey(ValueKey('self_name_key')), 'Test');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.enterText(find.byKey(ValueKey('self_surname_key')), 'Self');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.byKey(ValueKey('self_check_in_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      DateTime currentDate = DateTime.now();
      String start = currentDate.add(Duration(days: 0)).day.toString();
      String end = currentDate.add(Duration(days: 1)).day.toString();

      await tester.tap(find.text(start).first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text(end).first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('Save'.toUpperCase()).first);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      //await tester.tap(find.byKey(ValueKey('self_check_out_key')));
      //await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.flingFrom(Offset(0, 400), Offset(0, -500), 2000);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(find.byKey(ValueKey('self_guests_key')), '2');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.byKey(ValueKey('create_self_invite_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('back_from_booking_page_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('log_out_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

    });

    testWidgets('Add External Service', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      await login(tester, 'test_salesman@buytime.network', 'test2020');

      ///Scroll up and down
      final listFinder = find.byType(ListView);
      debugPrint('KEY VALUE: ${find.byType(ListView).toString()}');
      if(!find.byType(ListView).toString().contains('zero widgets with')){
        await binding.watchPerformance(() async {
          await tester.fling(listFinder, const Offset(0, -500), 4000);
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }, reportKey: 'scrolling_summary');

        debugPrint('KEY VALUE: ${find.text('Scoglio Bianco').toString()}');
        ///Business List => First Business of the list
        await tester.ensureVisible(find.text('Hotel Danila', skipOffstage: false));
        if(!find.text('Scoglio Bianco').toString().contains('zero widgets with')) {
          //debugPrint('KEY VALUE: ${find.byKey(ValueKey('business_0_key')).toString()}');
          await tester.tap(find.text('Scoglio Bianco'));
          await tester.pumpAndSettle(const Duration(seconds: 2));

          await tester.tap(find.byKey(ValueKey('business_invite_key')));
          await tester.pumpAndSettle(const Duration(seconds: 2));

          await tester.tap(find.byKey(ValueKey('create_booking_key')));
          await tester.pumpAndSettle(const Duration(seconds: 2));

          await tester.enterText(find.byKey(ValueKey('create_email_key')), 'test_self@buytime.network');
          await tester.pumpAndSettle(const Duration(seconds: 1));

          await tester.enterText(find.byKey(ValueKey('create_name_key')), 'Test');
          await tester.pumpAndSettle(const Duration(seconds: 1));

          await tester.enterText(find.byKey(ValueKey('create_surname_key')), 'Self');
          await tester.pumpAndSettle(const Duration(seconds: 1));

          await tester.tap(find.byKey(ValueKey('create_check_in_key')));
          await tester.pumpAndSettle(const Duration(seconds: 2));

          DateTime currentDate = DateTime.now();
          String start = currentDate.add(Duration(days: 0)).day.toString();
          String end = currentDate.add(Duration(days: 1)).day.toString();

          await tester.tap(find.text(start).first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          await tester.tap(find.text(end).first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          await tester.tap(find.text('Save'.toUpperCase()).first);
          await tester.pumpAndSettle(const Duration(seconds: 1));

          // await tester.tap(find.byKey(ValueKey('create_check_out_key')));
          // await tester.pumpAndSettle(const Duration(seconds: 2));

          // await tester.flingFrom(Offset(0, 400), Offset(0, -500), 2000);
          // await tester.pumpAndSettle(const Duration(seconds: 2));

          await tester.enterText(find.byKey(ValueKey('create_guests_key')), '2');
          await tester.pumpAndSettle(const Duration(seconds: 1));

          await tester.tap(find.byKey(ValueKey('create_booking_invite_key')));
          await tester.pumpAndSettle(const Duration(seconds: 3));

          await tester.flingFrom(Offset(0, 400), Offset(0, -500), 2000);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // await tester.tap(find.byKey(ValueKey('send_booking_email_key')));
          // await tester.pumpAndSettle(const Duration(seconds: 3));

          await tester.tap(find.byKey(ValueKey('copy_to_dashboard_key')));
          await tester.pumpAndSettle(const Duration(seconds: 3));
        }
      }else{
        debugPrint('listview not found');
      }

    });


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