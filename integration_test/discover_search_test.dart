import 'package:Buytime/utils/regression_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

///Integration test run cmd
///
///Android Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/discover_search_test.dart --debug
///
///iOS Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD -t integration_test/discover_search_test.dart --debug



void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    ///Search in discover  by category name
    testWidgets('Discover Search', (tester) async {
      await RegressionUtils().loadApp(tester);
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

  });
}



