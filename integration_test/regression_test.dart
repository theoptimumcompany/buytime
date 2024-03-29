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
import 'package:Buytime/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:Buytime/main.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

///Integration test run cmd
///
///Android Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/app_test.dart --debug
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/regression_test.dart --debug
///
///iOS Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD -t integration_test/app_test.dart --debug

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageId}');
  debugPrint('main => ${message.data}');
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    ///Search in discover  by category name [Single file created]
    testWidgets('Discover Search', (tester) async {
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


    ///Registration Error => Wrong Password [Single file created]
    testWidgets('Registration password error', (tester) async {
      await loadApp(tester);

      /*debugPrint('KEY VALUE: ${find.byKey(ValueKey('action_button_discover')).toString()}');
      await tester.tap(find.byKey(ValueKey('action_button_discover')));
      await tester.pumpAndSettle(const Duration(seconds: 2));*/

      await tester.tap(find.byKey(ValueKey('home_register_key')));
      ///Home => Login
      await register(tester, 'test_automatico@buytime.network', 'test2021');
      expect(find.text('Password has a minimum of 6 characters and at least 1 digit, 1 lowercase char and 1 uppercase char'), findsOneWidget);
    });

    ///Registration User => Discover => log out [Single file created]
    testWidgets('Registration User', (tester) async {
      await loadApp(tester);

      /*debugPrint('KEY VALUE: ${find.byKey(ValueKey('action_button_discover')).toString()}');
      await tester.tap(find.byKey(ValueKey('action_button_discover')));
      await tester.pumpAndSettle(const Duration(seconds: 2));*/

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => registration
      await register(tester, 'test_automatico@buytime.network', 'Test2021');

      await tester.flingFrom(Offset(0, 400), Offset(0, -500), 10000);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      ///Log out
      await tester.tap(find.byKey(ValueKey('log_out_key')));
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    ///Registration Error => Email exists [Single file created]
    testWidgets('Registration email exists error', (tester) async {
      await loadApp(tester);

      /*debugPrint('KEY VALUE: ${find.byKey(ValueKey('action_button_discover')).toString()}');
      await tester.tap(find.byKey(ValueKey('action_button_discover')));
      await tester.pumpAndSettle(const Duration(seconds: 2));*/

      await tester.tap(find.byKey(ValueKey('home_register_key')));
      ///Home => Login
      await register(tester, 'test_automatico@buytime.network', 'Test2021');
      expect(find.text('The email address is already in use by another account.'), findsOneWidget);
    });

    ///Discover => Service add to cart => Tourist Login User => Payment process without ending [Single file created]
    testWidgets('Tourist service add to cart payment with no ending', (tester) async {
      await loadApp(tester);
      // await tester.pumpAndSettle(const Duration(seconds: 2));
      // debugPrint('KEY VALUE: ${find.byKey(ValueKey('action_button_discover')).toString()}');
      // await tester.tap(find.byKey(ValueKey('action_button_discover')));
      // await tester.pumpAndSettle(const Duration(seconds: 2));
      // //await tester.tap(find.byKey(ValueKey('login')));
      // ///Home => registration

      // await login(tester, 'test_automatico@buytime.network', 'Test2021');
      // await tester.pumpAndSettle(const Duration(seconds: 2));

      //  await tester.enterText(find.byKey(ValueKey('search_field_key')), 'Drink');
      // await tester.pumpAndSettle(const Duration(seconds: 2));

      debugPrint('KEY VALUE: ${find.byKey(ValueKey('free_access_key')).toString()}');
      await tester.tap(find.byKey(ValueKey('free_access_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.text('DRINK').first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // await tester.flingFrom(Offset(0, 400), Offset(0, -500), 1500);
      // await tester.pumpAndSettle(const Duration(seconds: 2));

      debugPrint('KEY VALUE: ${find.text('Mai Tai').toString()}');
      if(!find.text('Mai Tai').toString().contains('zero widgets with')){
        await tester.drag(find.text('Mai Tai').last, const Offset(-700, 0));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.enterText(find.byKey(ValueKey('table_number_field_key')), '1');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('close_table_number_field_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_buy_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('tourist_login')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await touristLogin(tester, 'test_automatico@buytime.network', 'Test2021');
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('back_cart_from_confirm_order_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('tourist_login_back')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('back_from_cart_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.text('Mai Tai').last);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('service_details_add_to_cart_key')).first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.enterText(find.byKey(ValueKey('table_number_field_key')), '1');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('close_table_number_field_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_buy_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('back_cart_from_confirm_order_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('back_from_cart_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('service_details_buy_key')).first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.enterText(find.byKey(ValueKey('table_number_field_key')), '1');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('close_table_number_field_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_buy_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('back_cart_from_confirm_order_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('add_one_item_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('remove_one_item_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // await tester.drag(find.text('Appetizer').first, const Offset(-700, 0));
        // await tester.pumpAndSettle(const Duration(seconds: 2));

        // await tester.tap(find.text('Appetizer'));
        // await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    });

    ///Home => Login User => Service add to cart => Payment process without ending [Single file created]
    testWidgets('Guest service add to cart payment with no ending', (tester) async {
      await loadApp(tester);
      // await tester.pumpAndSettle(const Duration(seconds: 2));
      // debugPrint('KEY VALUE: ${find.byKey(ValueKey('action_button_discover')).toString()}');
      // await tester.tap(find.byKey(ValueKey('action_button_discover')));
      // await tester.pumpAndSettle(const Duration(seconds: 2));
      // //await tester.tap(find.byKey(ValueKey('login')));
      // ///Home => registration
      // await login(tester, 'test_automatico@buytime.network', 'Test2021');
      // await tester.pumpAndSettle(const Duration(seconds: 2));



      //  await tester.enterText(find.byKey(ValueKey('search_field_key')), 'Drink');
      // await tester.pumpAndSettle(const Duration(seconds: 2));

      // debugPrint('KEY VALUE: ${find.byKey(ValueKey('action_button_discover')).toString()}');
      // await tester.tap(find.byKey(ValueKey('action_button_discover')));
      // await tester.pumpAndSettle(const Duration(seconds: 2));

      ///Home => Login
      await login(tester, 'test_automatico@buytime.network', 'Test2021');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // await tester.tap(find.byKey(ValueKey('discover_key')));
      // await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.text('DRINK').first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // await tester.flingFrom(Offset(0, 400), Offset(0, -500), 1500);
      // await tester.pumpAndSettle(const Duration(seconds: 2));

      if(!find.text('Mai Tai').toString().contains('zero widgets with')){
        await tester.drag(find.text('Mai Tai').first, const Offset(-700, 0));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.enterText(find.byKey(ValueKey('table_number_field_key')), '1');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('close_table_number_field_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_buy_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('back_cart_from_confirm_order_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('back_from_cart_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.text('Mai Tai').first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('service_details_add_to_cart_key')).first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.enterText(find.byKey(ValueKey('table_number_field_key')), '1');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('close_table_number_field_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_buy_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('back_cart_from_confirm_order_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('back_from_cart_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('service_details_buy_key')).first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.enterText(find.byKey(ValueKey('table_number_field_key')), '1');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('close_table_number_field_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('cart_buy_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('back_cart_from_confirm_order_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('add_one_item_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('remove_one_item_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // await tester.drag(find.text('Appetizer').first, const Offset(-700, 0));
        // await tester.pumpAndSettle(const Duration(seconds: 2));

        // await tester.tap(find.text('Appetizer'));
        // await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    });

    ///Home => Login User => Service reserve => Payment process without ending [Single file created]
    testWidgets('Guest service reserve payment with no ending', (tester) async {
      await loadApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      //await tester.tap(find.byKey(ValueKey('login')));

      // debugPrint('KEY VALUE: ${find.byKey(ValueKey('action_button_discover')).toString()}');
      // await tester.tap(find.byKey(ValueKey('action_button_discover')));
      // await tester.pumpAndSettle(const Duration(seconds: 2));

      ///Home => registration
      await login(tester, 'test_automatico@buytime.network', 'Test2021');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      //  await tester.enterText(find.byKey(ValueKey('search_field_key')), 'Drink');
      // await tester.pumpAndSettle(const Duration(seconds: 2));

      // await tester.tap(find.byKey(ValueKey('discover_key')));
      // await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('DIVING').first);
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

        // await tester.drag(find.text('Reservation').first, const Offset(-700, 0));
        // await tester.pumpAndSettle(const Duration(seconds: 2));

        //service_reserve_buy_key

        // await tester.tap(find.text('Appetizer'));
        // await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    });

    /*///Registration User => Landing => log out
    testWidgets('Registration User', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => registration
      //await register(tester, 'test_automatico@buytime.network', 'Test2021');

      ///Log out
      await tester.tap(find.byKey(ValueKey('log_out_key')));
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });*/

    ///Home => Login User => Discover => My Bookings => Booking page => Search [Single file created]
    testWidgets('Guest booking page search', (tester) async {
      await loadApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      //await tester.tap(find.byKey(ValueKey('login')));

      // debugPrint('KEY VALUE: ${find.byKey(ValueKey('action_button_discover')).toString()}');
      // await tester.tap(find.byKey(ValueKey('action_button_discover')));
      // await tester.pumpAndSettle(const Duration(seconds: 2));

      ///Home => Login
      await login(tester, 'test_self@buytime.network', 'Test2021');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('my_bookings_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('booking_0')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(find.byKey(ValueKey('guest_search_field_key')), 'Test');
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

    ///Home => Login User =>  Discover => My Bookings => Service Reserve [Single file created]
    testWidgets('Guest booking page reserve service', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      // debugPrint('KEY VALUE: ${find.byKey(ValueKey('action_button_discover')).toString()}');
      // await tester.tap(find.byKey(ValueKey('action_button_discover')));
      // await tester.pumpAndSettle(const Duration(seconds: 2));

      ///Home => registration
      await login(tester, 'test_self@buytime.network', 'Test2021');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('my_bookings_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('booking_0')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      ///Scroll down
      await tester.flingFrom(Offset(0, 400), Offset(0, -500), 2000);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.drag(find.byKey(ValueKey('top_service_2')).first, const Offset(-700, 0));
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

      await tester.tap(find.byKey(ValueKey('top_service_2')).first);
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


    ///Home => Login User => Self Check in => log out [Single file created]
    testWidgets('Self Check In', (tester) async {
      await loadApp(tester);
      // debugPrint('KEY VALUE: ${find.byKey(ValueKey('action_button_discover')).toString()}');
      // await tester.tap(find.byKey(ValueKey('action_button_discover')));
      // await tester.pumpAndSettle(const Duration(seconds: 2));

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
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.flingFrom(Offset(0, 400), Offset(0, -500), 2000);
      await tester.pumpAndSettle(const Duration(seconds: 2));

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

      await tester.flingFrom(Offset(0, 400), Offset(0, -500), 2000);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('create_self_invite_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('back_from_booking_page_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.flingFrom(Offset(0, 400), Offset(0, -500), 2000);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.byKey(ValueKey('log_out_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

    });

    ///Create Booking For User [Single file created]
    testWidgets('Create Booking For User', (tester) async {
      await loadApp(tester);
      // debugPrint('KEY VALUE: ${find.byKey(ValueKey('action_button_discover')).toString()}');
      // await tester.tap(find.byKey(ValueKey('action_button_discover')));
      // await tester.pumpAndSettle(const Duration(seconds: 2));
      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      await login(tester, 'test_salesman@buytime.network', 'test2020');
      await tester.pumpAndSettle(const Duration(seconds: 2));
      ///Scroll up and down
      final listFinder = find.byType(ListView);
      debugPrint('KEY VALUE: ${find.byType(ListView).toString()}');
      if(!find.byType(ListView).toString().contains('zero widgets with')){

        await tester.flingFrom(Offset(0, 400), Offset(0, -500), 2000);
        await tester.pumpAndSettle(const Duration(seconds: 2));

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

          await tester.flingFrom(Offset(0, 400), Offset(0, -500), 2000);
          await tester.pumpAndSettle(const Duration(seconds: 2));

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

  final NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await Firebase.initializeApp();
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  debugPrint('main => User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );
  var initialzationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (
          int id,
          String title,
          String body,
          String payload,
          ) async {
        didReceiveLocalNotificationSubject.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      });
  var initializationSettings = InitializationSettings(android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        selectNotificationSubject.add(payload);
      });

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

  await tester.flingFrom(Offset(0, 400), Offset(0, -500), 1500);
  await tester.pumpAndSettle(const Duration(seconds: 2));

  await tester.tap(find.byKey(ValueKey('login_key')));
  await tester.pumpAndSettle(const Duration(seconds: 2));
}

Future<void> touristLogin(WidgetTester tester, String email, String password) async {
  await tester.enterText(find.byKey(ValueKey('email_key')), email);
  await tester.pumpAndSettle(const Duration(seconds: 1));
  await tester.enterText(find.byKey(ValueKey('password_key')), password);
  await tester.pumpAndSettle(const Duration(seconds: 2));

  await tester.flingFrom(Offset(0, 400), Offset(0, -500), 1500);
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

  await tester.flingFrom(Offset(0, 400), Offset(0, -500), 1500);
  await tester.pumpAndSettle(const Duration(seconds: 2));

  await tester.tap(find.byKey(ValueKey('registration_key')));
  await tester.pumpAndSettle(const Duration(seconds: 2));
}