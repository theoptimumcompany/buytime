

import 'package:Buytime/utils/regression_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

///Integration test run cmd
///
///Android Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/guest_booking_page_service_reserve_test.dart --debug
///
///iOS Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD -t integration_test/guest_booking_page_service_reserve_test.dart --debug



void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    ///Home => Login User =>  Discover => My Bookings => Service Reserve
    testWidgets('Guest booking page reserve service', (tester) async {
      await RegressionUtils().loadApp(tester);

      ///Home => registration
      await RegressionUtils().login(tester, 'test_self@buytime.network', 'Test2021');
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

    });

  });
}



