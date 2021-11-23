

import 'package:Buytime/utils/regression_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

///Integration test run cmd
///
///Android Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/guest_booking_page_search_test.dart --debug
///
///iOS Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD -t integration_test/guest_booking_page_search_test.dart --debug

void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    ///Home => Login User => Discover => My Bookings => Booking page => Search
    testWidgets('Guest booking page search', (tester) async {
      await RegressionUtils().loadApp(tester);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      ///Home => Login
      await RegressionUtils().login(tester, 'test_self@buytime.network', 'Test2021');
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
  });
}



