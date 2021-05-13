import 'package:Buytime/reblox/model/autoComplete/auto_complete_list_state.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/reblox/model/booking/booking_list_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/business/external_business_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/business/snippet/order_business_snippet_state.dart';
import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/invitation/category_invite_state.dart';
import 'package:Buytime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:Buytime/reblox/model/email/email_state.dart';
import 'package:Buytime/reblox/model/email/template_data_state.dart';
import 'package:Buytime/reblox/model/email/template_state.dart';
import 'package:Buytime/reblox/model/notification/notification_list_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/order/order_list_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_list_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline_list_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_list_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_list_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:flutter/foundation.dart';
import 'category/tree/category_tree_state.dart';

class AppRoutes {
  static const home = "/home";
  static const registration = "/registration";
  static const login = "/login";
  static const landing = "/landing";
  static const orderDetail = "/orderDetail";
  static const bookingDetails = "/bookingDetails";
  static const categories = "/categories";
  static const businessList = "/businessList";
  static const business = "/business";
  static const confirmBooking = "/confirmBooking";
  static const bookingPage = "/bookingPage";
  static const managerServiceList = "/managerServiceList";
  static const myBookings = "/myBookings";
  static const confirmOrder = "/confirmOrder";
  static const bookingList = "/bookingList";
  static const serviceDetails = "/serviceDetails";
  static const serviceExplorer = "/serviceExplorer";

}

class AppState {
  BusinessState business;
  ExternalBusinessState externalBusiness;
  BookingState booking;
  BusinessListState businessList;
  ExternalBusinessListState externalBusinessList;
  BookingListState bookingList;
  OrderState order;
  OrderReservableState orderReservable;
  OrderListState orderList;
  OrderReservableListState orderReservableList;
  StripeState stripe;
  UserState user;
  CategoryState category;
  CategoryInviteState categoryInvite;
  CategoryListState categoryList;
  CategoryTree categoryTree;
  ServiceState serviceState;
  ServiceListState serviceList;
  ServiceSlot serviceSlot;
  Pipeline pipeline;
  PipelineList pipelineList;
  List<String> route;
  StatisticsState statistics;
  CardState cardState;
  CardListState cardListState;
  AutoCompleteState autoCompleteState;
  AutoCompleteListState autoCompleteListState;
  NotificationState notificationState;
  NotificationListState notificationListState;
  EmailState emailState;
  TemplateState templateState;
  TemplateDataState templateDataState;
  String lastError;
  String previousError;
  ServiceListSnippetState serviceListSnippetState;
  ServiceListSnippetListState serviceListSnippetListState;
  BusinessSnippetState businessSnippetState;
  OrderBusinessSnippetState orderBusinessSnippetState;
  CategorySnippetState categorySnippetState;
  ServiceSnippetState serviceSnippetState;
  ExternalBusinessImportedState externalBusinessImportedState;
  ExternalBusinessImportedListState externalBusinessImportedListState;
  ExternalServiceImportedState externalServiceImportedState;
  ExternalServiceImportedListState externalServiceImportedListState;

  AppState({
    @required this.business,
    @required this.externalBusiness,
    @required this.booking,
    @required this.order,
    @required this.orderReservable,
    @required this.orderList,
    @required this.orderReservableList,
    @required this.stripe,
    @required this.businessList,
    @required this.externalBusinessList,
    @required this.bookingList,
    @required this.user,
    @required this.category,
    @required this.categoryInvite,
    @required this.categoryList,
    @required this.categoryTree,
    @required this.serviceState,
    @required this.serviceList,
    @required this.serviceSlot,
    @required this.pipeline,
    @required this.pipelineList,
    this.route = const [AppRoutes.home],
    this.statistics,
    this.cardState,
    this.cardListState,
    this.autoCompleteState,
    this.autoCompleteListState,
    this.notificationState,
    this.notificationListState,
    this.emailState,
    this.templateState,
    this.templateDataState,
    this.serviceListSnippetState,
    this.serviceListSnippetListState,
    this.businessSnippetState,
    this.orderBusinessSnippetState,
    this.categorySnippetState,
    this.serviceSnippetState,
    this.externalBusinessImportedState,
    this.externalBusinessImportedListState,
    this.externalServiceImportedState,
    this.externalServiceImportedListState,
    this.lastError = "",
    this.previousError = ""
  });

  AppState.initialState() {
    business = BusinessState();
    externalBusiness = ExternalBusinessState();
    booking = BookingState();
    order = OrderState();
    orderReservable = OrderReservableState();
    stripe = StripeState();
    orderList = OrderListState();
    orderReservableList = OrderReservableListState();
    businessList = BusinessListState();
    externalBusinessList = ExternalBusinessListState();
    bookingList = BookingListState();
    user = UserState();
    category = CategoryState();
    categoryInvite = CategoryInviteState();
    categoryList = CategoryListState();
    categoryTree = CategoryTree();
    serviceState = ServiceState();
    serviceList = ServiceListState();
    serviceSlot = ServiceSlot();
    pipeline = Pipeline();
    pipelineList = PipelineList();
    statistics = StatisticsState();
    cardState = CardState();
    cardListState = CardListState();
    autoCompleteState = AutoCompleteState();
    autoCompleteListState = AutoCompleteListState();
    notificationState = NotificationState();
    notificationListState = NotificationListState();
    emailState = EmailState();
    templateState = TemplateState();
    templateDataState = TemplateDataState();
    serviceListSnippetState = ServiceListSnippetState();
    serviceListSnippetListState = ServiceListSnippetListState();
    businessSnippetState = BusinessSnippetState();
    orderBusinessSnippetState = OrderBusinessSnippetState();
    categorySnippetState = CategorySnippetState();
    serviceSnippetState = ServiceSnippetState();
    externalBusinessImportedState = ExternalBusinessImportedState();
    externalBusinessImportedListState = ExternalBusinessImportedListState();
    externalServiceImportedState = ExternalServiceImportedState();
    externalServiceImportedListState = ExternalServiceImportedListState();
    lastError = "";
    previousError = "";

  }

  AppState.copyWith({
      BusinessState business,
      ExternalBusinessState externalBusiness,
      BookingState booking,
      OrderState order,
      OrderReservableState orderReservable,
      OrderListState orderList,
      OrderReservableListState orderReservableList,
      StripeState stripe,
      BusinessListState businessList,
      ExternalBusinessListState externalBusinessList,
        BookingListState bookingList,
      UserState user,
      CategoryState category,
      CategoryInviteState categoryInvite,
      CategoryListState categoryList,
      CategoryTree categoryTree,
      ServiceState serviceState,
      ServiceListState serviceList,
      ServiceSlot serviceSlot,
      Pipeline pipeline,
      PipelineList pipelineList,
      List<String> route,
      StatisticsState statistics,
        CardState cardState,
        CardListState cardListState,
        AutoCompleteState autoCompleteState,
        AutoCompleteListState autoCompleteListState,
        NotificationState notificationState,
        NotificationListState notificationListState,
        EmailState emailState,
        TemplateState templateState,
        TemplateDataState templateDataState,
    ServiceListSnippetState serviceListSnippetState,
    ServiceListSnippetListState serviceListSnippetListState,
    BusinessSnippetState businessSnippetState,
    OrderBusinessSnippetState orderBusinessSnippetState,
    CategorySnippetState categorySnippetState,
    ServiceSnippetState serviceSnippetState,
    ExternalBusinessImportedState externalBusinessImportedState,
    ExternalBusinessImportedListState externalBusinessImportedListState,
    ExternalServiceImportedState externalServiceImportedState,
    ExternalServiceImportedListState externalServiceImportedListState,
    String lastError,
    String previousError
      }) {
    this.business = business;
    this.externalBusiness = externalBusiness;
    this.booking = booking;
    this.order = order;
    this.orderReservable = orderReservable;
    this.orderList = orderList;
    this.orderReservableList = orderReservableList;
    this.stripe = stripe;
    this.businessList = businessList;
    this.externalBusinessList = externalBusinessList;
    this.bookingList = bookingList;
    this.user = user;
    this.category = category;
    this.categoryInvite = categoryInvite;
    this.categoryList = categoryList;
    this.categoryTree = categoryTree;
    this.serviceState = serviceState;
    this.serviceList = serviceList;
    this.serviceSlot = serviceSlot;
    this.pipeline = pipeline;
    this.pipelineList = pipelineList;
    this.route = route;
    this.statistics = statistics;
    this.cardState = cardState;
    this.cardListState = cardListState;
    this.autoCompleteState = autoCompleteState;
    this.autoCompleteListState = autoCompleteListState;
    this.notificationState = notificationState;
    this.notificationListState = notificationListState;
    this.emailState = emailState;
    this.templateState = templateState;
    this.templateDataState = templateDataState;
    this.serviceListSnippetState = serviceListSnippetState;
    this.serviceListSnippetListState = serviceListSnippetListState;
    this.businessSnippetState = businessSnippetState;
    this.orderBusinessSnippetState = orderBusinessSnippetState;
    this.categorySnippetState = categorySnippetState;
    this.serviceSnippetState = serviceSnippetState;
    this.externalBusinessImportedState = externalBusinessImportedState;
    this.externalBusinessImportedListState = externalBusinessImportedListState;
    this.externalServiceImportedState = externalServiceImportedState;
    this.externalServiceImportedListState = externalServiceImportedListState;
    this.lastError = lastError;
    this.previousError = previousError;
  }
  //
  // AppState.fromJson(Map json) {
  //   business = json['business'];
  //   booking = json['booking'];
  //   order = json['order'];
  //   orderList = json['orderList'];
  //   stripe = json['stripe'];
  //   stripeListState = json['stripeListState'];
  //   businessList = json['businessList'];
  //   bookingList = json['bookingList'];
  //   user = json['user'];
  //   category = json['category'];
  //   categoryInvite = json['categoryInvite'];
  //   categoryList = json['categoryList'];
  //   categoryTree = json['categoryTree'];
  //   serviceState = json['serviceState'];
  //   serviceList = json['serviceList'];
  //   serviceSlot = json['serviceSlot'];
  //   pipeline = json['pipeline'];
  //   pipelineList = json['pipelineList'];
  //   route = json['route'];
  //   statistics = json['statistics'];
  //   cardState = json['cardState'];
  //   cardListState = json['cardListState'];
  //   autoCompleteState = json['autoCompleteState'];
  //   autoCompleteListState = json['autoCompleteListState'];
  // }
  //
  // Map toJson() => {
  //       'business': business,
  //       'booking': booking,
  //       'order': order,
  //       'orderList': orderList,
  //       'stripe': stripe,
  //       'stripeListState': stripeListState,
  //       'businessList': businessList,
  //       'bookingList': bookingList,
  //       'user': user,
  //       'category': category,
  //       'categoryInvite': categoryInvite,
  //       'categoryList': categoryList,
  //       'categoryTree': categoryTree,
  //       'serviceState': serviceState,
  //       'serviceList': serviceList,
  //       'serviceSlot': serviceSlot,
  //       'pipeline': pipeline,
  //       'pipelineList': pipelineList,
  //       'route': route,
  //       'statistics': statistics,
  //       'cardState': cardState,
  //       'cardListState': cardListState,
  //       'autoCompleteState': autoCompleteState,
  //       'autoCompleteListState': autoCompleteListState,
  //     };
}
