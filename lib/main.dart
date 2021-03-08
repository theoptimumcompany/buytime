import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/UI/management/invite/UI_M_BookingDetails.dart';
import 'package:Buytime/UI/management/invite/UI_M_BookingList.dart';
import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/UI/user/booking/UI_U_BookingPage.dart';
import 'package:Buytime/UI/user/booking/UI_U_ConfirmBooking.dart';
import 'package:Buytime/UI/user/booking/UI_U_MyBookings.dart';
import 'package:Buytime/UI/user/cart/UI_U_ConfirmOrder.dart';
import 'package:Buytime/UI/user/landing/UI_U_Landing.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_list_state.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/reblox/model/booking/booking_list_state.dart';
import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/category/invitation/category_invite_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_list_state.dart';
import 'package:Buytime/reblox/reducer/auto_complete_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/services/category_invite_service_epic.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/UI/user/login/UI_U_Home.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/old/filter_search_state.dart';
import 'package:Buytime/reblox/model/order/order_list_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline_list_state.dart';
import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/reducer/app_reducer.dart';
import 'package:Buytime/reblox/navigation/route_aware_widget.dart';
import 'package:Buytime/services/business_service_epic.dart';
import 'package:Buytime/services/category_tree_service_epic.dart';
import 'package:Buytime/services/category_service_epic.dart';
import 'package:Buytime/services/order_service_epic.dart';
import 'package:Buytime/services/pipeline_service_epic.dart';
import 'package:Buytime/services/service_service_epic.dart';
import 'package:Buytime/services/stripe_payment_service_epic.dart';
import 'package:Buytime/services/user_service_epic.dart';
import 'package:Buytime/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/services/booking_service_epic.dart';
import 'package:Buytime/reblox/navigation/navigation_middleware.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main(){

  final epics = combineEpics<AppState>([
    BusinessAndNavigateRequestService(),
    BusinessAndNavigateOnConfirmRequestService(),
    BusinessRequestService(),
    BusinessUpdateService(),
    BusinessCreateService(),
    BusinessListRequestService(),
    BookingCreateRequestService(),
    BookingRequestService(),
    UserBookingListRequestService(),
    BookingListRequestService(),
    BookingUpdateRequestService(),
    BookingUpdateAndNavigateRequestService(),
    UserRequestService(),
    UserEditDevice(),
    UserEditToken(),
    CategoryRequestService(),
    CategoryInviteCreateService(),
    CategoryInviteDeleteService(),
    CategoryInviteRequestService(),
    CategoryInviteManagerService(),
    CategoryDeleteManagerService(),
    CategoryInviteWorkerService(),
    CategoryDeleteWorkerService(),
    CategoryUpdateService(),
    CategoryCreateService(),
    CategoryDeleteService(),
    CategoryListRequestService(),
    UserCategoryListRequestService(),
    CategoryRootListRequestService(),
    CategoryTreeRequestService(),
    CategoryTreeCreateIfNotExistsService(),
    CategoryTreeUpdateService(),
    CategoryTreeAddService(),
    CategoryTreeDeleteService(),
    StripePaymentAddPaymentMethod(),
    StripePaymentCardListRequest(),
    StripeListPaymentCardListRequest(),
    StripeDetachPaymentMethodRequest(),
    ServiceUpdateService(),
    ServiceUpdateServiceVisibility(),
    ServiceDeleteService(),
    ServiceCreateService(),
    ServiceListRequestService(),
    ServiceListAndNavigateRequestService(),
    ServiceListAndNavigateOnConfirmRequestService(),
    PipelineRequestService(),
    PipelineListRequestService(),
    OrderListRequestService(),
    OrderRequestService(),
    OrderUpdateService(),
    OrderCreateService(),
    AddingStripePaymentMethodRequest(),
  ]);
  final _initialState = AppState(
    category: CategoryState().toEmpty(),
    categoryInvite: CategoryInviteState().toEmpty(),
    filterSearch: FilterSearchState().toEmpty(),
    categoryTree: CategoryTree().toEmpty(),
    business: BusinessState().toEmpty(),
    booking: BookingState().toEmpty(),
    order: OrderState().toEmpty(),
    orderList: OrderListState().toEmpty(),
    stripe: StripeState().toEmpty(),
    stripeListState: StripeListState().toEmpty(),
    businessList: BusinessListState().toEmpty(),
    bookingList: BookingListState().toEmpty(),
    categoryList: CategoryListState().toEmpty(),
    serviceList: ServiceListState().toEmpty(),
    serviceSlot: ServiceSlot().toEmpty(),
    pipelineList: PipelineList().toEmpty(),
    user: UserState().toEmpty(),
    serviceState: ServiceState().toEmpty(),
    pipeline: Pipeline().toEmpty(),
    statistics: StatisticsState().toEmpty(),
    cardState: CardState().toEmpty(),
    cardListState: CardListState().toEmpty(),
    autoCompleteState: AutoCompleteState().toEmpty(),
    autoCompleteListState: AutoCompleteListState().toEmpty()
  );
  final store = new Store<AppState>(
    appReducer,
    initialState: _initialState,
    middleware: createNavigationMiddleware(epics),
  );

  // Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Buytime(store: store));
}

class Buytime extends StatelessWidget {
  final Store<AppState> store;

  Buytime({this.store});

  MaterialPageRoute _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MainRoute(Home(), settings: settings);
      case AppRoutes.bookingDetails:
        return FabRoute(BookingDetails(), settings: settings);
      case AppRoutes.categories:
        return FabRoute(ManageCategory(), settings: settings);
      case AppRoutes.businessList:
        return FabRoute(UI_M_BusinessList(), settings: settings);
      case AppRoutes.business:
        return FabRoute(UI_M_Business(), settings: settings);
      case AppRoutes.confirmBooking:
        return FabRoute(ConfirmBooking(), settings: settings);
      case AppRoutes.bookingPage:
        return FabRoute(BookingPage(), settings: settings);
      case AppRoutes.landing:
        return FabRoute(Landing(), settings: settings);
      case AppRoutes.managerServiceList:
        return FabRoute(UI_M_ServiceList(), settings: settings);
      case AppRoutes.myBookings:
        return FabRoute(MyBookings(), settings: settings);
      case AppRoutes.confirmOrder:
        return FabRoute(ConfirmOrder(), settings: settings);
      case AppRoutes.bookingList:
        return FabRoute(BookingList(), settings: settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    //SizeConfig().init(context);
    //ScreenUtil.init(bcontext, width: 1125, height: 2436, allowFontScaling: true);
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('it', ''),
          const Locale('es', ''),
          const Locale('de', ''),
          const Locale('fr', ''),
        ],
        navigatorKey: navigatorKey,
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) => _getRoute(settings),
        title: 'Buytime',
        debugShowCheckedModeBanner: false,
        theme: BuytimeTheme().userTheme,
        home: SplashScreen(),
        /*routes: <String, WidgetBuilder>{
          // Set routes for using the Navigator.
          '/home': (BuildContext context) => Home(),
          '/login': (BuildContext context) => Login(),
          '/registration': (BuildContext context) => Registration(),
          '/orderDetail': (BuildContext context) => UI_U_OrderDetail(),
          '/tabs': (BuildContext context) => UI_U_Tabs(),
          '/bookingDetails': (BuildContext context) => BookingDetails(),
        },*/
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MainRoute<T> extends MaterialPageRoute<T> {
  MainRoute(Widget widget, {RouteSettings settings})
      : super(builder: (_) => RouteAwareWidget(child: widget), settings: settings);

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return FadeTransition(opacity: animation, child: child);
  }
}

class FabRoute<T> extends MaterialPageRoute<T> {
  FabRoute(Widget widget, {RouteSettings settings})
      : super(builder: (_) => RouteAwareWidget(child: widget), settings: settings);

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child);
  }
}


