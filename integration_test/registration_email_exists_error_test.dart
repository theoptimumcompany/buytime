

import 'package:Buytime/utils/regression_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

///Integration test run cmd
///
///Android Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/registration_email_exists_error_test.dart --debug
///
///iOS Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD -t integration_test/registration_email_exists_error_test.dart --debug



void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    ///Registration Error => Email exists
    testWidgets('Registration email exists error', (tester) async {
      await RegressionUtils().loadApp(tester);

      /*debugPrint('KEY VALUE: ${find.byKey(ValueKey('action_button_discover')).toString()}');
      await tester.tap(find.byKey(ValueKey('action_button_discover')));
      await tester.pumpAndSettle(const Duration(seconds: 2));*/

      await tester.tap(find.byKey(ValueKey('home_register_key')));
      ///Home => Login
      await RegressionUtils().register(tester, 'test_automatico@buytime.network', 'Test2021');
      expect(find.text('The email address is already in use by another account.'), findsOneWidget);
    });



  });
}



