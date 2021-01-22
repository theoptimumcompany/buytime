import 'package:BuyTime/reblox/model/category/tree/category_tree_state.dart';
import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:BuyTime/UI/user/login/UI_U_Home.dart';
import 'package:BuyTime/UI/user/login/UI_U_Login.dart';
import 'package:BuyTime/UI/user/order/UI_U_OrderDetail.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/business/business_list_state.dart';
import 'package:BuyTime/reblox/model/business/business_state.dart';
import 'package:BuyTime/reblox/model/category/category_list_state.dart';
import 'package:BuyTime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:BuyTime/reblox/model/category/category_state.dart';
import 'package:BuyTime/reblox/model/old/filter_search_state.dart';
import 'package:BuyTime/reblox/model/object_state.dart';
import 'package:BuyTime/reblox/model/order/order_entry.dart';
import 'package:BuyTime/reblox/model/order/order_list_state.dart';
import 'package:BuyTime/reblox/model/order/order_state.dart';
import 'package:BuyTime/reblox/model/pipeline/pipeline.dart';
import 'package:BuyTime/reblox/model/pipeline/pipeline_list_state.dart';
import 'package:BuyTime/reblox/model/service/service_list_state.dart';
import 'package:BuyTime/reblox/model/service/service_state.dart';
import 'package:BuyTime/reblox/model/stripe/stripe_card_response.dart';
import 'package:BuyTime/reblox/model/stripe/stripe_state.dart';
import 'package:BuyTime/reblox/model/user/user_state.dart';
import 'package:BuyTime/reblox/reducer/app_reducer.dart';
import 'package:BuyTime/reblox/navigation/route_aware_widget.dart';
import 'package:BuyTime/UI/user/login/UI_U_Registration.dart';
import 'package:BuyTime/services/business_service_epic.dart';
import 'package:BuyTime/services/category_snippet_service_epic.dart';
import 'package:BuyTime/services/category_service_epic.dart';
import 'package:BuyTime/services/order_service_epic.dart';
import 'package:BuyTime/services/pipeline_service_epic.dart';
import 'package:BuyTime/services/service_service_epic.dart';
import 'package:BuyTime/services/stripe_payment_service_epic.dart';
import 'package:BuyTime/services/user_service_epic.dart';
import 'package:BuyTime/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'reblox/navigation/navigation_reducer.dart';

void main() {
  final epics = combineEpics<AppState>([
    BusinessRequestService(),
    BusinessUpdateService(),
    BusinessCreateService(),
    BusinessListRequestService(),
    UserRequestService(),
    UserEditField(),
    CategoryRequestService(),
    CategoryInviteManagerService(),
    CategoryInviteWorkerService(),
    CategoryUpdateService(),
    CategoryCreateService(),
    CategoryDeleteService(),
    CategoryListRequestService(),
    CategoryRootListRequestService(),
    CategoryTreeRequestService(),
    CategoryTreeCreateIfNotExistsService(),
    CategoryTreeUpdateService(),
    CategoryTreeAddService(),
    CategoryTreeDeleteService(),
    StripePaymentAddPaymentMethod(),
    StripePaymentCardListRequest(),
    StripeDetachPaymentMethodRequest(),
    ServiceUpdateService(),
    ServiceDeleteService(),
    ServiceCreateService(),
    ServiceListRequestService(),
    PipelineRequestService(),
    PipelineListRequestService(),
    OrderListRequestService(),
    OrderRequestService(),
    OrderUpdateService(),
    OrderCreateService(),
  ]);
  final _initialState = AppState(
    category: CategoryState(
      name: "",
      id: "",
      level: 0,
      children: 0,
      parent: ObjectState(name: "No Parent", id: "no_parent"),
      manager: [],
      businessId: "",
      worker: [],
      categorySnippet: CategorySnippet(),
    ),
    filterSearch: FilterSearchState(
        star: [false, false, false, false, false],
        euro: [false, false, false, false],
        distance: 10.0,
        searchText: "",
        food: false,
        hotel: false),
    categoryTree:
        CategoryTree(nodeName: "", nodeId: "", nodeLevel: 0, numberOfCategories: 0, categoryNodeList: null),
    business: BusinessState(
      name: "",
      responsible_person_name: "",
      responsible_person_surname: "",
      responsible_person_email: "",
      phone_number: '',
      email: "",
      VAT: "",
      street: "",
      street_number: "",
      ZIP: "",
      state_province: "",
      nation: "",
      coordinate: "",
      municipality: "",
      profile: "",
      gallery: [""],
      wide_card_photo: "",
      logo: "",
      business_type: [],
      description: "",
      id_firestore: "",
      salesman: ObjectState(),
      salesmanId: "",
      owner: ObjectState(),
      ownerId: "",
      fileToUploadList: null,
      draft: true,
    ),
    order: OrderState(
        itemList: List<OrderEntry>(),
        date: DateTime.now(),
        position: "",
        total: 0.0,
        business: ObjectState(),
        tip: 0.0,
        tax: 0.0,
        amount: 0,
        taxPercent: 0.0,
        progress: "unpaid",
        addCardProgress: false,
        businessId: ""),
    orderList: OrderListState(orderListState: List<OrderState>()),
    stripe: StripeState(
        paymentMethodList: List<Map<String, dynamic>>(),
        date: DateTime.now(),
        position: "",
        total: 0.0,
        stripeCard: StripeCardResponse(),
        error: ""),
    businessList: BusinessListState(businessListState: List<BusinessState>()),
    categoryList: CategoryListState(categoryListState: List<CategoryState>()),
    serviceList: ServiceListState(serviceListState: List<ServiceState>()),
    pipelineList: PipelineList(pipelineList: List<Pipeline>()),
    user: UserState(
      name: "",
      surname: "",
      email: "",
      uid: "",
      birth: "01-09-1990",
      gender: "",
      city: "",
      zip: 57037,
      street: "",
      nation: "",
      cellularPhone: 3891297061,
      owner: false,
      salesman: false,
      manager: false,
      admin: false,
      worker: false,
      photo: "",
      device: [""],
    ),
    serviceState: ServiceState(
        id: "",
        name: "",
        thumbnail: "",
        image: "",
        description: "",
        availability: false,
        actionList: [],
        categoryList: [],
        externalCategoryList: [],
        positionList: [],
        visibility: "Visible",
        constraintList: [],
        tagList: [],
        price: 0.00,
        write_permission: [],
        pipelineList: []),
    pipeline: Pipeline(
      name: "",
      description: "",
    ),
  );
  final store = new Store<AppState>(
    appReducer,
    initialState: _initialState,
    middleware: [
      EpicMiddleware<AppState>(epics),
      TypedMiddleware<AppState, NavigateReplaceAction>(_navigateReplace),
      TypedMiddleware<AppState, NavigatePushAction>(_navigate),
      TypedMiddleware<AppState, NavigatePopAction>(_navigatePop),
    ],
  );

  // Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  runApp(BuyTime(store: store));
}

class BuyTime extends StatelessWidget {
  final Store<AppState> store;

  BuyTime({this.store});

  MaterialPageRoute _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.orderDetail:
        return MainRoute(UI_U_OrderDetail(), settings: settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        navigatorKey: NavigatorHolder.navigatorKey,
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) => _getRoute(settings),
        title: 'BuyTime',
        debugShowCheckedModeBanner: false,
        theme: BuytimeTheme().userTheme,
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          // Set routes for using the Navigator.
          '/home': (BuildContext context) => new Home(),
          '/login': (BuildContext context) => new Login(),
          '/registration': (BuildContext context) => new Registration(),
          '/orderDetail': (BuildContext context) => new UI_U_OrderDetail(),
        },
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

_navigateReplace(Store<AppState> store, action, NextDispatcher next) {
  final routeName = (action as NavigateReplaceAction).routeName;
  if (store.state.route.last != routeName) {
    navigatorKey.currentState.pushReplacementNamed(routeName);
  }
  next(action); //This need to be after name checks
}

_navigatePop(Store<AppState> store, action, NextDispatcher next) {
  if (action is NavigatePopAction && navigatorKey.currentState.canPop()) {
    navigatorKey.currentState.pop();
  } else if (action is NavigatePushAction) {
    if (store.state.route.last != action.routeName) {
      navigatorKey.currentState.pushNamed(action.routeName);
    }
  }
  next(action); //This need to be after name checks
}

_navigate(Store<AppState> store, action, NextDispatcher next) {
  final routeName = (action as NavigatePushAction).routeName;
  if (store.state.route.last != routeName) {
    navigatorKey.currentState.pushNamed(routeName);
  }
  next(action); //This need to be after name checks
}
