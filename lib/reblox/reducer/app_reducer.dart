import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_list_state.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/booking/booking_list_state.dart';
import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/invitation/category_invite_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/old/filter_search_state.dart';
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
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/auto_complete_list_reducer.dart';
import 'package:Buytime/reblox/reducer/auto_complete_reducer.dart';
import 'package:Buytime/reblox/reducer/category_invite_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_list_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/utils/globals.dart';

import 'business_reducer.dart';
import 'business_list_reducer.dart';
import 'category_reducer.dart';
import 'category_tree_reducer.dart';
import 'filter_reducer.dart';

class ClickOnBusinessState {}

AppState appReducer(AppState state, dynamic action) {
  FilterSearchState filterSearchState = filterReducer(state.filterSearch, action);
  BusinessState businessState = businessReducer(state.business, action);
  BookingState bookingState = bookingReducer(state.booking, action);
  OrderState orderState = orderReducer(state.order, action);
  OrderListState orderListState = orderListReducer(state.orderList, action);
  BusinessListState businessListState = businessListReducer(state.businessList, action);
  BookingListState bookingListState = bookingListReducer(state.bookingList, action);
  StripeState stripeState = stripePaymentReducer(state.stripe, action);
  StripeListState stripeListState = stripeListPaymentReducer(state.stripeListState, action);
  UserState userState = userReducer(state.user, action);
  CategoryState categoryState = categoryReducer(state.category, action);
  CategoryInviteState categoryInviteState = categoryInviteReducer(state.categoryInvite, action);
  CategoryListState categoryListState = categoryListReducer(state.categoryList, action);
  CategoryTree categoryTree = categoryTreeReducer(state.categoryTree, action);
  ServiceState serviceState = serviceReducer(state.serviceState, action);
  ServiceListState serviceListState = serviceListReducer(state.serviceList, action);
  ServiceSlot serviceSlot = serviceSlotReducer(state.serviceSlot, action);
  Pipeline pipeline = pipelineReducer(state.pipeline, action);
  PipelineList pipelineList = pipelineListReducer(state.pipelineList, action);
  StatisticsState statisticsState = statisticsReducer(state.statistics, action);
  CardState cardState = cardReducer(state.cardState, action);
  CardListState cardListState = cardListReducer(state.cardListState, action);
  AutoCompleteState autoCompleteState = autoCompleteReducer(state.autoCompleteState, action);
  AutoCompleteListState autoCompleteListState = autoCompleteListReducer(state.autoCompleteListState, action);

  AppState newState = AppState.copyWith(
      filterSearch: filterSearchState,
      business: businessState,
      booking: bookingState,
      order: orderState,
      orderList: orderListState,
      businessList: businessListState,
      bookingList: bookingListState,
      user: userState,
      stripe: stripeState,
      stripeListState: stripeListState,
      category: categoryState,
      categoryInvite: categoryInviteState,
      categoryList: categoryListState,
      categoryTree: categoryTree,
      serviceState: serviceState,
      serviceList: serviceListState,
      serviceSlot: serviceSlot,
      pipeline: pipeline,
      pipelineList: pipelineList,
      route: navigationReducer(state.route, action),
      statistics: statisticsState,
      cardState: cardState,
      cardListState: cardListState,
      autoCompleteState: autoCompleteState,
      autoCompleteListState: autoCompleteListState
  );

  if (action is ClickOnBusinessState) {
    // reset the store before going to the service list
    newState.order = OrderState().toEmpty();
    newState.serviceList = ServiceListState().toEmpty();
    newState.serviceState = ServiceState().toEmpty();
    cartCounter = 0;
  }

  return newState;
}
