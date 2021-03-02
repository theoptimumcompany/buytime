import 'package:Buytime/UI/management/invite/UI_M_BookingList.dart';
import 'package:Buytime/reblox/model/booking/booking_list_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/invitation/category_invite_state.dart';
import 'package:Buytime/reblox/model/order/order_list_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline_list_state.dart';
import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_list_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:flutter/foundation.dart';
import 'category/tree/category_tree_state.dart';
import 'old/filter_search_state.dart';

class AppRoutes {
  static const home = "/home";
  static const login = "/login";
  static const registration = "/history";
  static const orderDetail = "/orderDetail";
  static const bookingDetails = "/bookingDetails";
  static const categories = "/categories";
  static const businessList = "/businessList";
  static const business = "/business";
  static const confirmBooking = "/confirmBooking";
  static const bookingPage = "/bookingPage";
  static const landing = "/landing";
  static const managerServiceList = "/managerServiceList";
  static const myBookings = "/myBookings";
  static const confirmOrder = "/confirmOrder";
  static const bookingList = "/bookingList";

}

class AppState {
  FilterSearchState filterSearch;
  BusinessState business;
  BookingState booking;
  BusinessListState businessList;
  BookingListState bookingList;
  OrderState order;
  OrderListState orderList;
  StripeState stripe;
  StripeListState stripeListState;
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

  AppState({
    @required this.filterSearch,
    @required this.business,
    @required this.booking,
    @required this.order,
    @required this.orderList,
    @required this.stripe,
    this.stripeListState,
    @required this.businessList,
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
    this.cardListState
  });

  AppState.initialState() {
    filterSearch = FilterSearchState();
    business = BusinessState();
    booking = BookingState();
    order = OrderState();
    stripe = StripeState();
    stripeListState = StripeListState();
    orderList = OrderListState();
    businessList = BusinessListState();
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
  }

  AppState.copyWith(
      {FilterSearchState filterSearch,
      BusinessState business,
      BookingState booking,
      OrderState order,
      OrderListState orderList,
      StripeState stripe,
        StripeListState stripeListState,
      BusinessListState businessList,
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
        CardListState cardListState
      }) {
    this.filterSearch = filterSearch;
    this.business = business;
    this.booking = booking;
    this.order = order;
    this.orderList = orderList;
    this.stripe = stripe;
    this.stripeListState = stripeListState;
    this.businessList = businessList;
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
  }

  AppState.fromJson(Map json) {
    filterSearch = json['filterSearch'];
    business = json['business'];
    booking = json['booking'];
    order = json['order'];
    orderList = json['orderList'];
    stripe = json['stripe'];
    stripeListState = json['stripeListState'];
    businessList = json['businessList'];
    bookingList = json['bookingList'];
    user = json['user'];
    category = json['category'];
    categoryInvite = json['categoryInvite'];
    categoryList = json['categoryList'];
    categoryTree = json['categoryTree'];
    serviceState = json['serviceState'];
    serviceList = json['serviceList'];
    serviceSlot = json['serviceSlot'];
    pipeline = json['pipeline'];
    pipelineList = json['pipelineList'];
    route = json['route'];
    statistics = json['statistics'];
    cardState = json['cardState'];
    cardListState = json['cardListState'];
  }

  Map toJson() => {
        'filterSearch': filterSearch,
        'business': business,
        'booking': booking,
        'order': order,
        'orderList': orderList,
        'stripe': stripe,
        'stripeListState': stripeListState,
        'businessList': businessList,
        'bookingList': bookingList,
        'user': user,
        'category': category,
        'categoryInvite': categoryInvite,
        'categoryList': categoryList,
        'categoryTree': categoryTree,
        'serviceState': serviceState,
        'serviceList': serviceList,
        'serviceSlot': serviceSlot,
        'pipeline': pipeline,
        'pipelineList': pipelineList,
        'route': route,
        'statistics': statistics,
        'cardState': cardState,
        'cardListState': cardListState,
      };
}
