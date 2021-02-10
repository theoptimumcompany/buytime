import 'package:Buytime/UI/management/invite/UI_M_BookingList.dart';
import 'package:Buytime/reblox/model/booking/booking_list_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/invitation/category_invite_state.dart';
import 'package:Buytime/reblox/model/order/order_list_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline_list_state.dart';
import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
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
  UserState user;
  CategoryState category;
  CategoryInviteState categoryInvite;
  CategoryListState categoryList;
  CategoryTree categoryTree;
  ServiceState serviceState;
  ServiceListState serviceList;
  Pipeline pipeline;
  PipelineList pipelineList;
  List<String> route;

  AppState({
    @required this.filterSearch,
    @required this.business,
    @required this.booking,
    @required this.order,
    @required this.orderList,
    @required this.stripe,
    @required this.businessList,
    @required this.bookingList,
    @required this.user,
    @required this.category,
    @required this.categoryInvite,
    @required this.categoryList,
    @required this.categoryTree,
    @required this.serviceState,
    @required this.serviceList,
    @required this.pipeline,
    @required this.pipelineList,
    this.route = const [AppRoutes.home],
  });

  AppState.initialState() {
    filterSearch = FilterSearchState();
    business = BusinessState();
    booking = BookingState();
    order = OrderState();
    stripe = StripeState();
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
    pipeline = Pipeline();
    pipelineList = PipelineList();
  }

  AppState.copyWith(
      {FilterSearchState filterSearch,
      BusinessState business,
      BookingState booking,
      OrderState order,
      OrderListState orderList,
      StripeState stripe,
      BusinessListState businessList,
        BookingListState bookingList,
      UserState user,
      CategoryState category,
      CategoryInviteState categoryInvite,
      CategoryListState categoryList,
      CategoryTree categoryTree,
      ServiceState serviceState,
      ServiceListState serviceList,
      Pipeline pipeline,
      PipelineList pipelineList,
      List<String> route}) {
    this.filterSearch = filterSearch;
    this.business = business;
    this.booking = booking;
    this.order = order;
    this.orderList = orderList;
    this.stripe = stripe;
    this.businessList = businessList;
    this.bookingList = bookingList;
    this.user = user;
    this.category = category;
    this.categoryInvite = categoryInvite;
    this.categoryList = categoryList;
    this.categoryTree = categoryTree;
    this.serviceState = serviceState;
    this.serviceList = serviceList;
    this.pipeline = pipeline;
    this.pipelineList = pipelineList;
    this.route = route;
  }

  AppState.fromJson(Map json) {
    filterSearch = json['filterSearch'];
    business = json['business'];
    booking = json['booking'];
    order = json['order'];
    orderList = json['orderList'];
    stripe = json['stripe'];
    businessList = json['businessList'];
    bookingList = json['bookingList'];
    user = json['user'];
    category = json['category'];
    categoryInvite = json['categoryInvite'];
    categoryList = json['categoryList'];
    categoryTree = json['categoryTree'];
    serviceState = json['serviceState'];
    serviceList = json['serviceList'];
    pipeline = json['pipeline'];
    pipelineList = json['pipelineList'];
    route = json['route'];
  }

  Map toJson() => {
        'filterSearch': filterSearch,
        'business': business,
        'booking': booking,
        'order': order,
        'orderList': orderList,
        'stripe': stripe,
        'businessList': businessList,
        'bookingList': bookingList,
        'user': user,
        'category': category,
        'categoryInvite': categoryInvite,
        'categoryList': categoryList,
        'categoryTree': categoryTree,
        'serviceState': serviceState,
        'serviceList': serviceList,
        'pipeline': pipeline,
        'pipelineList': pipelineList,
        'route': route,
      };
}
