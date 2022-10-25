

import 'package:Buytime/utils/regression_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

///Integration test run cmd
///
///Android Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/self_check_in_test.dart --debug
///
///iOS Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD -t integration_test/self_check_in_test.dart --debug



void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    ///Home => Login User => Self Check in => log out
    testWidgets('Self Check In', (tester) async {
      await RegressionUtils().loadApp(tester);

      ///Home => login
      await RegressionUtils().login(tester, 'test_self@buytime.network', 'Test2021');

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



  });
}



