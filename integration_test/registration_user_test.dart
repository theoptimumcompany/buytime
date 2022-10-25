

import 'package:Buytime/utils/regression_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

///Integration test run cmd
///
///Android Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/registration_user_test.dart --debug
///
///iOS Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD -t integration_test/registration_user_test.dart --debug

void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    ///Registration User => Discover => log out
    testWidgets('Registration User', (tester) async {
      await RegressionUtils().loadApp(tester);

      ///Home => registration
      await RegressionUtils().register(tester, 'test_automatico@buytime.network', 'Test2021');

      await tester.flingFrom(Offset(0, 400), Offset(0, -500), 10000);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      ///Log out
      await tester.tap(find.byKey(ValueKey('log_out_key')));
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });



  });
}



