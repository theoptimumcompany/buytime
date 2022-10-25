

import 'package:Buytime/utils/regression_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

///Integration test run cmd
///
///Android Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/tourist_service_add_to_cart_payment_with_no_ending_test.dart --debug
///
///iOS Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD -t integration_test/tourist_service_add_to_cart_payment_with_no_ending_test.dart --debug



void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    ///Discover => Service add to cart => Tourist Login User => Payment process without ending
    testWidgets('Tourist service add to cart payment with no ending', (tester) async {
      await RegressionUtils().loadApp(tester);

      debugPrint('KEY VALUE: ${find.byKey(ValueKey('free_access_key')).toString()}');
      await tester.tap(find.byKey(ValueKey('free_access_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.text('DRINK').first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      debugPrint('KEY VALUE: ${find.text('Mai Tai').toString()}');
      if(!find.text('Vodka Red Bull').toString().contains('zero widgets with')){
        await tester.drag(find.text('Vodka Red Bull').last, const Offset(-700, 0));
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

        await RegressionUtils().touristLogin(tester, 'test_automatico@buytime.network', 'Test2021');
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('back_cart_from_confirm_order_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('tourist_login_back')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('back_from_cart_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.text('Vodka Red Bull').last);
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



