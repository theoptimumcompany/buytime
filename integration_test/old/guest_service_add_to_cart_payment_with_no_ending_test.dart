

import 'package:Buytime/utils/regression_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

///Integration test run cmd
///
///Android Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/guest_service_add_to_cart_payment_with_no_ending_test.dart --debug
///
///iOS Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD -t integration_test/guest_service_add_to_cart_payment_with_no_ending_test.dart --debug



void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    ///Home => Login User => Service add to cart => Payment process without ending
    testWidgets('Guest service add to cart payment with no ending', (tester) async {
      await RegressionUtils().loadApp(tester);

      ///Home => Login
      await RegressionUtils().login(tester, 'test_automatico@buytime.network', 'Test2021');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // await tester.tap(find.byKey(ValueKey('discover_key')));
      // await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.text('DRINK').first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

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

      }
    });
  });
}



