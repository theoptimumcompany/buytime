import 'package:Buytime/UI/management/service_internal/RUI_M_service_list.dart';
import 'package:Buytime/app_state.dart';
import 'package:Buytime/combined_epics.dart';
import 'package:Buytime/environment_abstract.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/navigation/navigation_middleware.dart';
import 'package:Buytime/reblox/reducer/app_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:Buytime/main.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

///Integration test run cmd
///flutter drive --driver integration_test/driver.dart --target --dart-define=ENVIRONMENT=PROD --flavor prod -t integration_test/app_test.dart --debug

void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    ///Login User => Landing => Redirect Booking id exists
    testWidgets('Login User', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      await login(tester, 'test_user@buytime.network', 'test2020');
    });

    ///Login User => Landing => Redirect Booking id exists => if not - invite
    testWidgets('Login User', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      //await login(tester, 'test_user@buytime.network', 'test2020');

      if(!find.byKey(ValueKey('invite_key')).toString().contains('zero widgets with')){
        await tester.tap(find.byKey(ValueKey('invite_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }else{
        debugPrint('KEY \'invite_key\' not found');
      }
    });

    ///Login User => Landing => Redirect Booking id exists => if not but have old bookings - My Bookings
    testWidgets('Login User', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      //await login(tester, 'test_user@buytime.network', 'test2020');

      if(!find.byKey(ValueKey('my_bookings_key')).toString().contains('zero widgets with')){
        await tester.tap(find.byKey(ValueKey('my_bookings_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }else{
        debugPrint('KEY \'my_bookings_key\' not found');
      }
    });


    ///Login User => Landing => Redirect Booking id exists => if not - Discover
    testWidgets('Login User', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      //await login(tester, 'test_user@buytime.network', 'test2020');

      if(!find.byKey(ValueKey('discover_key')).toString().contains('zero widgets with')){
        await tester.tap(find.byKey(ValueKey('discover_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        if(!find.byKey(ValueKey('category_0_key')).toString().contains('zero widgets with')){
          await tester.tap(find.byKey(ValueKey('category_0_key')));
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }else{
          debugPrint('KEY \'category_0_key\' not found');
        }
      }else{
        debugPrint('KEY \'discover_key\' not found');
      }
    });


    ///Login Error
    testWidgets('Login erorr', (tester) async {
      await loadApp(tester);

      await tester.tap(find.byKey(ValueKey('login_key')));
      ///Home => Login
      await login(tester, 'test_admin@buytime.network', 'Test2020');
      expect(find.text('The password is invalid or the user does not have a password.'), findsOneWidget);
    });

    ///Login Admin => Landing => Redirect Business List
    testWidgets('Business List', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      await login(tester, 'test_admin@buytime.network', 'test2020');

      ///Scroll up and down
      final listFinder = find.byType(ListView);
      await binding.watchPerformance(() async {
        await tester.fling(listFinder, const Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, const Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');
    });

    ///Login Admin => Landing => Redirect Business List => Business Drawer
    testWidgets('Business Drawer', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      //await login(tester, 'test_admin@buytime.network', 'test2020');

      ///Scroll up and down
      final listFinder = find.byType(ListView);
      /*await binding.watchPerformance(() async {
        await tester.fling(listFinder, const Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, const Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');*/
      await tester.pumpAndSettle(const Duration(seconds: 2));
      ///Business List => First Business of the list
      debugPrint('KEY VALUE: ${find.byKey(ValueKey('business_drawer_key')).toString()}');
      if(!find.byKey(ValueKey('business_drawer_key')).toString().contains('zero widgets with')){
        await tester.tap(find.byKey(ValueKey('business_drawer_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }else{
        debugPrint('KEY \'business_drawer_key\' not found');
      }
    });

    ///Login Admin => Landing => Redirect Business List => Business Drawer => Notification Center
    testWidgets('Business Drawer', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      //await login(tester, 'test_admin@buytime.network', 'test2020');

      ///Scroll up and down
      final listFinder = find.byType(ListView);
      /*await binding.watchPerformance(() async {
        await tester.fling(listFinder, const Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, const Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');*/
      await tester.pumpAndSettle(const Duration(seconds: 2));
      ///Business List => First Business of the list
      debugPrint('KEY VALUE: ${find.byKey(ValueKey('business_drawer_key')).toString()}');
      if(!find.byKey(ValueKey('business_drawer_key')).toString().contains('zero widgets with')){
        await tester.tap(find.byKey(ValueKey('business_drawer_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('notification_center_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }else{
        debugPrint('KEY \'business_drawer_key\' not found');
      }
    });

    ///Login Admin => Landing => Redirect Business List => Business Drawer => Activity Management
    testWidgets('Business Drawer', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      //await login(tester, 'test_admin@buytime.network', 'test2020');

      ///Scroll up and down
      final listFinder = find.byType(ListView);
      /*await binding.watchPerformance(() async {
        await tester.fling(listFinder, const Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, const Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');*/
      await tester.pumpAndSettle(const Duration(seconds: 2));
      ///Business List => First Business of the list
      debugPrint('KEY VALUE: ${find.byKey(ValueKey('business_drawer_key')).toString()}');
      if(!find.byKey(ValueKey('business_drawer_key')).toString().contains('zero widgets with')){
        await tester.tap(find.byKey(ValueKey('business_drawer_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('activity_management_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(ValueKey('activity_period_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }else{
        debugPrint('KEY \'business_drawer_key\' not found');
      }
    });

    ///Login Admin => Landing => Redirect Business List => Business Drawer => Slot Management
    testWidgets('Business Drawer', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      //await login(tester, 'test_admin@buytime.network', 'test2020');

      ///Scroll up and down
      final listFinder = find.byType(ListView);
      /*await binding.watchPerformance(() async {
        await tester.fling(listFinder, const Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, const Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');*/
      await tester.pumpAndSettle(const Duration(seconds: 2));
      ///Business List => First Business of the list
      debugPrint('KEY VALUE: ${find.byKey(ValueKey('business_drawer_key')).toString()}');
      if(!find.byKey(ValueKey('business_drawer_key')).toString().contains('zero widgets with')){
        await tester.tap(find.byKey(ValueKey('business_drawer_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('slot_management_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        if(!find.byKey(ValueKey('slot_management_service_0_key')).toString().contains('zero widgets with')){
          await tester.tap(find.byKey(ValueKey('slot_management_service_0_key')));
          await tester.pumpAndSettle(const Duration(seconds: 3));

          if(!find.byKey(ValueKey('remove_0_0_key')).toString().contains('zero widgets with')){
            await tester.tap(find.byKey(ValueKey('remove_0_0_key')).first);
            await tester.pumpAndSettle(const Duration(seconds: 3));
          }else{
            debugPrint('KEY \'remove_0_0_key\' not found');
          }

          if(!find.byKey(ValueKey('add_0_0_key')).toString().contains('zero widgets with')){
            await tester.tap(find.byKey(ValueKey('add_0_0_key')).first);
            await tester.pumpAndSettle(const Duration(seconds: 3));
          }else{
            debugPrint('KEY \'add_0_0_key\' not found');
          }
        }else{
          debugPrint('KEY \'slot_management_service_0_key\' not found');
        }
      }else{
        debugPrint('KEY \'business_drawer_key\' not found');
      }
    });

    ///Login Admin => Landing => Redirect Business List => Business => Internal Service if exists => Manage Category if exists
    testWidgets('Internal Service', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      //await login(tester, 'test_admin@buytime.network', 'test2020');

      ///Scroll up and down
      final listFinder = find.byType(ListView);
      /*await binding.watchPerformance(() async {
        await tester.fling(listFinder, const Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, const Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');*/

      ///Business List => First Business of the list
      if(!find.byKey(ValueKey('business_0_key')).toString().contains('zero widgets with')){
        debugPrint('KEY VALUE: ${find.byKey(ValueKey('business_0_key')).toString()}');
        await tester.tap(find.byKey(ValueKey('business_0_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        ///Business => Internal Service List
        if(!find.byKey(ValueKey('internal_service_manage_key')).toString().contains('zero widgets with')){
          await tester.tap(find.byKey(ValueKey('internal_service_manage_key')));
          await tester.pumpAndSettle(const Duration(seconds: 2));

          if(!find.byKey(ValueKey('manage_category_key')).toString().contains('zero widgets with')){
            await tester.tap(find.byKey(ValueKey('manage_category_key')));
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
          ///Internal Service List => Business
          //await tester.tap(find.byKey(ValueKey('back_from_interval_service_key')));
          //await tester.pumpAndSettle(const Duration(seconds: 2));
        }else{
          debugPrint('KEY \'internal_service_manage_key\' not found');
        }

        /*await tester.ensureVisible(find.byKey(ValueKey('external_business_manage_key')));
      await tester.tap(find.byKey(ValueKey('external_business_manage_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));*/
      }else{
        debugPrint('KEY \'business_0_key\' not found');
      }
    });

    ///Login Admin => Landing => Redirect Business List => Business => Internal Service if exists => First service details if exists
    testWidgets('Service Details', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      //await login(tester, 'test_admin@buytime.network', 'test2020');


      ///Scroll up and down
      final listFinder = find.byType(ListView);
      /*await binding.watchPerformance(() async {
        await tester.fling(listFinder, const Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, const Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');*/

      ///Business List => First Business of the list
      if(!find.byKey(ValueKey('business_0_key')).toString().contains('zero widgets with')){
        debugPrint('KEY VALUE: ${find.byKey(ValueKey('business_0_key')).toString()}');
        await tester.tap(find.byKey(ValueKey('business_0_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        ///Business => Internal Service List
        if(!find.byKey(ValueKey('internal_service_manage_key')).toString().contains('zero widgets with')){
          await tester.tap(find.byKey(ValueKey('internal_service_manage_key')));
          await tester.pumpAndSettle(const Duration(seconds: 2));

          if(!find.byKey(ValueKey('service_0_0_key')).toString().contains('zero widgets with')){
            await tester.tap(find.byKey(ValueKey('service_0_0_key')));
            await tester.pumpAndSettle(const Duration(seconds: 4));
          }else{
            debugPrint('KEY \'service_0_0_key\' not found');
          }
          ///Internal Service List => Business
          //await tester.tap(find.byKey(ValueKey('back_from_interval_service_key')));
          //await tester.pumpAndSettle(const Duration(seconds: 2));
        }else{
          debugPrint('KEY \'internal_service_manage_key\' not found');
        }
        /*await tester.ensureVisible(find.byKey(ValueKey('external_business_manage_key')));
        await tester.tap(find.byKey(ValueKey('external_business_manage_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));*/

      }else{
        debugPrint('KEY \'business_0_key\' not found');
      }
    });

    ///Login Admin => Landing => Redirect Business List => Business => Internal Service if exists => Manage Category if exists => First Category Details if exists
    testWidgets('Category Details', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      //await login(tester, 'test_admin@buytime.network', 'test2020');

      ///Scroll up and down
      final listFinder = find.byType(ListView);
      /*await binding.watchPerformance(() async {
        await tester.fling(listFinder, const Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, const Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');*/

      ///Business List => First Business of the list
      if(!find.byKey(ValueKey('business_0_key')).toString().contains('zero widgets with')){
        debugPrint('KEY VALUE: ${find.byKey(ValueKey('business_0_key')).toString()}');
        await tester.tap(find.byKey(ValueKey('business_0_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        ///Business => Internal Service List
        if(!find.byKey(ValueKey('internal_service_manage_key')).toString().contains('zero widgets with')){
          await tester.tap(find.byKey(ValueKey('internal_service_manage_key')));
          await tester.pumpAndSettle(const Duration(seconds: 2));

          if(!find.byKey(ValueKey('manage_category_key')).toString().contains('zero widgets with')){
            await tester.tap(find.byKey(ValueKey('manage_category_key')));
            await tester.pumpAndSettle(const Duration(seconds: 2));
            //if(!find.byKey(ValueKey('C0pt9ZYzORrHnr0VbPNB')).toString().contains('zero widgets with')){
            if(!find.text('Arroceria').toString().contains('zero widgets with')){
              //await tester.tap(find.byKey(ValueKey('C0pt9ZYzORrHnr0VbPNB')));
              await tester.tap(find.text('Arroceria'));
              await tester.pumpAndSettle(const Duration(seconds: 4));
            }else{
              debugPrint('KEY \'Arroceria\' not found');
            }
          }
          ///Internal Service List => Business
          //await tester.tap(find.byKey(ValueKey('back_from_interval_service_key')));
          //await tester.pumpAndSettle(const Duration(seconds: 2));
        }else{
          debugPrint('KEY \'internal_service_manage_key\' not found');
        }

        /*await tester.ensureVisible(find.byKey(ValueKey('external_business_manage_key')));
      await tester.tap(find.byKey(ValueKey('external_business_manage_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));*/
      }else{
        debugPrint('KEY \'business_0_key\' not found');
      }
    });

    ///Login Admin => Landing => Redirect Business List => Business => External Service if exists
    testWidgets('External Service', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      //await login(tester, 'test_admin@buytime.network', 'test2020');

      ///Scroll up and down
      final listFinder = find.byType(ListView);
      await binding.watchPerformance(() async {
        await tester.fling(listFinder, const Offset(0, -500), 2000);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        /* await tester.fling(listFinder, const Offset(0, 500), 10000);
        await tester.pumpAndSettle();*/
      }, reportKey: 'scrolling_summary');

      debugPrint('KEY VALUE: ${find.text('Hotel Danila').toString()}');
      ///Business List => First Business of the list
      await tester.ensureVisible(find.text('Hotel Danila', skipOffstage: false));
      if(!find.text('Hotel Danila').toString().contains('zero widgets with')){
        //debugPrint('KEY VALUE: ${find.byKey(ValueKey('business_0_key')).toString()}');
        await tester.tap(find.text('Hotel Danila'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        ///Business => External Business List
        debugPrint('KEY VALUE: ${find.byKey(ValueKey('external_business_manage_key')).toString()}');
        if(!find.byKey(ValueKey('external_business_manage_key')).toString().contains('zero widgets with')){
          await tester.tap(find.byKey(ValueKey('external_business_manage_key')));
          await tester.pumpAndSettle(const Duration(seconds: 1));

          await tester.tap(find.byKey(ValueKey('add_external_business_list_key')));
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }else{
          debugPrint('KEY \'external_business_manage_key\' not found');
        }
        /*await tester.ensureVisible(find.byKey(ValueKey('external_business_manage_key')));
      await tester.tap(find.byKey(ValueKey('external_business_manage_key')));
      await tester.pumpAndSettle(const Duration(seconds: 2));*/
      }else{
        debugPrint('KEY \'Hotel Danila\' not found');
      }
    });

    ///Login Admin => Landing => Redirect Business List => Business Drawer => Log Out
    testWidgets('Business Drawer', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      //await login(tester, 'test_admin@buytime.network', 'test2020');

      ///Scroll up and down
      final listFinder = find.byType(ListView);
      /*await binding.watchPerformance(() async {
        await tester.fling(listFinder, const Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, const Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');*/
      await tester.pumpAndSettle(const Duration(seconds: 2));
      ///Business List => First Business of the list
      debugPrint('KEY VALUE: ${find.byKey(ValueKey('business_drawer_key')).toString()}');
      if(!find.byKey(ValueKey('business_drawer_key')).toString().contains('zero widgets with')){
        await tester.tap(find.byKey(ValueKey('business_drawer_key')));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        await tester.tap(find.byKey(ValueKey('log_out_key')));
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }else{
        debugPrint('KEY \'business_drawer_key\' not found');
      }
    });

    ///Login Admin => Landing => Redirect Business List => Business => External Service if exists => Add/Remove test
    /*testWidgets('Add External Service', (tester) async {
      await loadApp(tester);

      //await tester.tap(find.byKey(ValueKey('login')));
      ///Home => Login
      await login(tester, 'test_salesman@buytime.network', 'test2020');

      ///Scroll up and down
      final listFinder = find.byType(ListView);
      debugPrint('KEY VALUE: ${find.byType(ListView).toString()}');
      if(!find.byType(ListView).toString().contains('zero widgets with')){
        await binding.watchPerformance(() async {
          await tester.fling(listFinder, const Offset(0, -500), 4000);
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }, reportKey: 'scrolling_summary');

        debugPrint('KEY VALUE: ${find.text('Scoglio Bianco').toString()}');
        ///Business List => First Business of the list
        await tester.ensureVisible(find.text('Hotel Danila', skipOffstage: false));
        if(!find.text('Scoglio Bianco').toString().contains('zero widgets with')){
          //debugPrint('KEY VALUE: ${find.byKey(ValueKey('business_0_key')).toString()}');
          await tester.tap(find.text('Scoglio Bianco'));
          await tester.pumpAndSettle(const Duration(seconds: 2));

          ///Business => External Business List
          debugPrint('KEY VALUE: ${find.byKey(ValueKey('external_business_manage_key')).toString()}');
          if(!find.byKey(ValueKey('external_business_manage_key')).toString().contains('zero widgets with')){
            await tester.tap(find.byKey(ValueKey('external_business_manage_key')));
            await tester.pumpAndSettle(const Duration(seconds: 1));

            await tester.tap(find.byKey(ValueKey('add_external_business_list_key')));
            await tester.pumpAndSettle(const Duration(seconds: 1));

            await tester.tap(find.text('Stefano sub'));
            await tester.pumpAndSettle(const Duration(seconds: 2));

            debugPrint('KEY VALUE: ${find.text('Discovery Scuba Diving').toString()}');
            await tester.drag(find.text('Discovery Scuba Diving').first, const Offset(-700, 0));
            await tester.pumpAndSettle(const Duration(seconds: 4));

            await tester.tap(find.byKey(ValueKey('external_business_details_back_key')));
            await tester.pumpAndSettle(const Duration(seconds: 2));

            await tester.tap(find.byKey(ValueKey('add_external_business_back_key')));
            await tester.pumpAndSettle(const Duration(seconds: 3));

            debugPrint('KEY VALUE: ${find.text('Stefano sub').toString()}');
            await tester.drag(find.text('Stefano sub').first, const Offset(-700, 0));
            await tester.pumpAndSettle(const Duration(seconds: 2));

            await tester.tap(find.byKey(ValueKey('add_external_business_list_key')));
            await tester.pumpAndSettle(const Duration(seconds: 1));

            await tester.tap(find.text('Stefano sub'));
            await tester.pumpAndSettle(const Duration(seconds: 2));

            await tester.tap(find.text('add_entire_business_key'));
            await tester.pumpAndSettle(const Duration(seconds: 6));

            await tester.tap(find.byKey(ValueKey('external_business_details_back_key')));
            await tester.pumpAndSettle(const Duration(seconds: 2));

            await tester.tap(find.byKey(ValueKey('add_external_business_back_key')));
            await tester.pumpAndSettle(const Duration(seconds: 3));

            await tester.tap(find.text('Stefano sub'));
            await tester.pumpAndSettle(const Duration(seconds: 2));

            await tester.drag(find.text('Discovery Scuba Diving').first, const Offset(-700, 0));
            await tester.pumpAndSettle(const Duration(seconds: 4));

            await tester.tap(find.text('view_business_key'));
            await tester.pumpAndSettle(const Duration(seconds: 3));

            await tester.tap(find.byKey(ValueKey('external_business_details_back_key')));
            await tester.pumpAndSettle(const Duration(seconds: 2));

            await tester.tap(find.byKey(ValueKey('external_business_details_back_key')));
            await tester.pumpAndSettle(const Duration(seconds: 3));

            debugPrint('KEY VALUE: ${find.text('Stefano sub').toString()}');
            await tester.drag(find.text('Stefano sub').first, const Offset(-700, 0));
            await tester.pumpAndSettle(const Duration(seconds: 2));

          }else{
            debugPrint('KEY \'external_business_manage_key\' not found');
          }
        }else{
          debugPrint('KEY \'Hotel Danila\' not found');
        }
      }else{
        debugPrint('listview not found');
      }

    });*/

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
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.PROD,
  );
  Environment().initConfig(environment);
  ///App Load
  await tester.pumpWidget(MultiProvider(
    providers: [
      //ChangeNotifierProvider(create: (_) => NavigationState()),
      ChangeNotifierProvider(create: (_) => Spinner([], [])),
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

  ///Login => Error
  await tester.tap(find.byKey(ValueKey('login_key')));
  await tester.pumpAndSettle(const Duration(seconds: 2));
}