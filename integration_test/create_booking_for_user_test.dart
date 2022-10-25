import 'package:Buytime/utils/regression_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

///Integration test run cmd
///
///Android Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/create_booking_for_user_test.dart --debug
///
///iOS Command
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD -t integration_test/create_booking_for_user_test.dart --debug

void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    ///Create Booking For User
    testWidgets('Create Booking For User', (tester) async {
      await RegressionUtils().loadApp(tester);

      ///Home => Login
      await RegressionUtils().login(tester, 'test_salesman@buytime.network', 'test2020');
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

          await tester.enterText(find.byKey(ValueKey('create_guests_key')), '2');
          await tester.pumpAndSettle(const Duration(seconds: 1));

          await tester.flingFrom(Offset(0, 400), Offset(0, -500), 2000);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          await tester.tap(find.byKey(ValueKey('create_booking_invite_key')));
          await tester.pumpAndSettle(const Duration(seconds: 3));

          await tester.flingFrom(Offset(0, 400), Offset(0, -500), 2000);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          await tester.tap(find.byKey(ValueKey('copy_to_dashboard_key')));
          await tester.pumpAndSettle(const Duration(seconds: 3));
        }
      }else{
        debugPrint('listview not found');
      }
    });
  });
}



