/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'package:Buytime/UI/user/turist/RUI_U_service_explorer.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/area/area_list_state.dart';
import 'package:Buytime/reblox/model/area/area_state.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_list_state.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/booking/booking_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/business/external_business_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/invitation/category_invite_state.dart';
import 'package:Buytime/reblox/model/email/email_state.dart';
import 'package:Buytime/reblox/model/notification/notification_list_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/order/order_detail_state.dart';
import 'package:Buytime/reblox/model/order/order_list_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_list_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline_list_state.dart';
import 'package:Buytime/reblox/model/promotion/promotion_list_state.dart';
import 'package:Buytime/reblox/model/promotion/promotion_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_list_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/slot/slot_list_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/reservations_orders_list_snippet_list_state.dart';
import 'package:Buytime/reblox/model/snippet/reservations_orders_list_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_list_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/area_list_reducer.dart';
import 'package:Buytime/reblox/reducer/area_reducer.dart';
import 'package:Buytime/reblox/reducer/auto_complete_list_reducer.dart';
import 'package:Buytime/reblox/reducer/auto_complete_reducer.dart';
import 'package:Buytime/reblox/reducer/category_invite_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/email_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_reducer.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_reducer.dart';
import 'package:Buytime/reblox/reducer/notification_list_reducer.dart';
import 'package:Buytime/reblox/reducer/notification_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_reducer.dart';
import 'package:Buytime/reblox/reducer/promotion/promotion_list_reducer.dart';
import 'package:Buytime/reblox/reducer/promotion/promotion_reducer.dart';
import 'package:Buytime/reblox/reducer/reservations_orders_list_snippet_list_reducer.dart';
import 'package:Buytime/reblox/reducer/reservations_orders_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/slot_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_imported_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_imported_list_reducer.dart';
import 'business_reducer.dart';
import 'business_list_reducer.dart';
import 'category_reducer.dart';
import 'order_detail_reducer.dart';

class ClickOnBusinessState {}

class ErrorAction {
  String _error;

  ErrorAction(this._error);

  String get error => _error;
}

class ErrorReset {}

class SetAppStateToEmpty {
  SetAppStateToEmpty();
}

AppState appReducer(AppState state, dynamic action) {
  AreaListState areaListState = areaListReducer(state.areaList, action);
  AreaState areaState = areaReducer(state.area, action);
  AutoCompleteListState autoCompleteListState = autoCompleteListReducer(state.autoCompleteListState, action);
  AutoCompleteState autoCompleteState = autoCompleteReducer(state.autoCompleteState, action);
  BookingListState bookingListState = bookingListReducer(state.bookingList, action);
  BookingState bookingState = bookingReducer(state.booking, action);
  BusinessListState businessListState = businessListReducer(state.businessList, action);
  BusinessState businessState = businessReducer(state.business, action);
  CardListState cardListState = cardListReducer(state.cardListState, action);
  CardState cardState = cardReducer(state.cardState, action);
  CategoryInviteState categoryInviteState = categoryInviteReducer(state.categoryInvite, action);
  CategoryListState categoryListState = categoryListReducer(state.categoryList, action);
  CategoryState categoryState = categoryReducer(state.category, action);
  EmailState emailState = emailReducer(state.emailState, action);
  ExternalBusinessImportedListState externalBusinessImportedListState = externalBusinessImportedListReducer(state.externalBusinessImportedListState, action);
  ExternalBusinessImportedState externalBusinessImportedState = externalBusinessImportedReducer(state.externalBusinessImportedState, action);
  ExternalBusinessListState externalBusinessListState = externalBusinessListReducer(state.externalBusinessList, action);
  ExternalBusinessState externalBusinessState = externalBusinessReducer(state.externalBusiness, action);
  ExternalServiceImportedListState externalServiceImportedListState = externalServiceImportedListReducer(state.externalServiceImportedListState, action);
  ExternalServiceImportedState externalServiceImportedState = externalServiceImportedReducer(state.externalServiceImportedState, action);
  NotificationListState notificationListState = notificationListReducer(state.notificationListState, action);
  NotificationState notificationState = notificationReducer(state.notificationState, action);
  OrderDetailState orderDetailState = orderDetailReducer(state.orderDetail, action);
  OrderListState orderListState = orderListReducer(state.orderList, action);
  OrderReservableListState orderReservableListState = orderReservableListReducer(state.orderReservableList, action);
  OrderReservableState orderReservableState = orderReservableReducer(state.orderReservable, action);
  OrderState orderState = orderReducer(state.order, action);
  Pipeline pipeline = pipelineReducer(state.pipeline, action);
  PipelineList pipelineList = pipelineListReducer(state.pipelineList, action);
  PromotionListState promotionListState = promotionListReducer(state.promotionListState, action);
  PromotionState promotionState = promotionReducer(state.promotionState, action);
  ReservationsOrdersListSnippetListState reservationsOrdersListSnippetListState = reservationsOrdersListSnippetListReducer(state.reservationsOrdersListSnippetListState, action);
  ReservationsOrdersListSnippetState reservationsOrdersListSnippetState = reservationsOrdersListSnippetReducer(state.reservationsOrdersListSnippetState, action);
  ServiceListSnippetListState serviceListSnippetListState = serviceListSnippetListReducer(state.serviceListSnippetListState, action);
  ServiceListSnippetState serviceListSnippetState = serviceListSnippetReducer(state.serviceListSnippetState, action);
  ServiceListState serviceListState = serviceListReducer(state.serviceList, action);
  ServiceSlot serviceSlot = serviceSlotReducer(state.serviceSlot, action);
  ServiceState serviceState = serviceReducer(state.serviceState, action);
  SlotListSnippetState slotSnippetListState = slotListSnippetReducer(state.slotSnippetListState, action);
  StatisticsState statisticsState = statisticsReducer(state.statistics, action);
  String lastError = "";
  String previousError = "";
  StripeState stripeState = stripePaymentReducer(state.stripe, action);
  UserState userState = userReducer(state.user, action);

  AppState newState = AppState.copyWith(
      //route: navigationReducer(state.route, action),
      area: areaState,
      areaList: areaListState,
      autoCompleteListState: autoCompleteListState,
      autoCompleteState: autoCompleteState,
      booking: bookingState,
      bookingList: bookingListState,
      business: businessState,
      businessList: businessListState,
      cardListState: cardListState,
      cardState: cardState,
      category: categoryState,
      categoryInvite: categoryInviteState,
      categoryList: categoryListState,
      emailState: emailState,
      externalBusiness: externalBusinessState,
      externalBusinessImportedListState: externalBusinessImportedListState,
      externalBusinessImportedState: externalBusinessImportedState,
      externalBusinessList: externalBusinessListState,
      externalServiceImportedListState: externalServiceImportedListState,
      externalServiceImportedState: externalServiceImportedState,
      lastError: lastError,
      notificationListState: notificationListState,
      notificationState: notificationState,
      order: orderState,
      orderDetail: orderDetailState,
      orderList: orderListState,
      orderReservable: orderReservableState,
      orderReservableList: orderReservableListState,
      pipeline: pipeline,
      pipelineList: pipelineList,
      previousError: previousError,
      promotionListState: promotionListState,
      promotionState: promotionState,
      reservationsOrdersListSnippetListState: reservationsOrdersListSnippetListState,
      reservationsOrdersListSnippetState: reservationsOrdersListSnippetState,
      route: navigationReducer(state.route, action),
      serviceList: serviceListState,
      serviceListSnippetListState: serviceListSnippetListState,
      serviceListSnippetState: serviceListSnippetState,
      serviceSlot: serviceSlot,
      serviceState: serviceState,
      slotSnippetListState: slotSnippetListState,
      statistics: statisticsState,
      stripe: stripeState,
      user: userState);

  if (action is ClickOnBusinessState) {
    // reset the store before going to the service list
    newState.order = OrderState().toEmpty();
    newState.serviceList = ServiceListState().toEmpty();
    newState.serviceState = ServiceState().toEmpty();
    //cartCounter = 0;
  }

  if (action is ErrorAction) {
    // reset the store before going to the service list
    newState.lastError = action.error;
    return newState;
    //cartCounter = 0;
  }

  if (action is ErrorReset) {
    // reset the store before going to the service list
    newState.lastError = "";
    return newState;
    //cartCounter = 0;
  }

  if (action is SetAppStateToEmpty) {
    newState.area = AreaState().toEmpty();
    newState.areaList = AreaListState().toEmpty();
    newState.autoCompleteListState = autoCompleteListState;
    newState.autoCompleteState = autoCompleteState;
    newState.booking = BookingState().toEmpty();
    newState.bookingList = BookingListState().toEmpty();
    newState.business = BusinessState().toEmpty();
    newState.businessList = BusinessListState().toEmpty();
    newState.cardListState = CardListState().toEmpty();
    newState.cardState = CardState().toEmpty();
    newState.category = CategoryState().toEmpty();
    newState.categoryInvite = CategoryInviteState().toEmpty();
    newState.categoryList = CategoryListState().toEmpty();
    newState.emailState = EmailState().toEmpty();
    newState.externalBusiness = ExternalBusinessState().toEmpty();
    newState.externalBusinessImportedListState = ExternalBusinessImportedListState().toEmpty();
    newState.externalBusinessImportedState = ExternalBusinessImportedState().toEmpty();
    newState.externalBusinessList = ExternalBusinessListState().toEmpty();
    newState.externalServiceImportedListState = ExternalServiceImportedListState().toEmpty();
    newState.externalServiceImportedState = ExternalServiceImportedState().toEmpty();
    newState.notificationListState = NotificationListState().toEmpty();
    newState.notificationState = NotificationState().toEmpty();
    newState.order = OrderState().toEmpty();
    newState.order = OrderState().toEmpty();
    newState.orderDetail = OrderDetailState().toEmpty();
    newState.orderList = OrderListState().toEmpty();
    newState.orderReservable = OrderReservableState().toEmpty();
    newState.orderReservableList = OrderReservableListState().toEmpty();
    newState.pipeline = Pipeline().toEmpty();
    newState.pipelineList = PipelineList().toEmpty();
    newState.promotionListState = PromotionListState().toEmpty();
    newState.promotionState = PromotionState().toEmpty();
    newState.reservationsOrdersListSnippetListState = ReservationsOrdersListSnippetListState().toEmpty();
    newState.reservationsOrdersListSnippetState = ReservationsOrdersListSnippetState().toEmpty();
    newState.serviceList = ServiceListState().toEmpty();
    newState.serviceListSnippetListState = ServiceListSnippetListState().toEmpty();
    newState.serviceListSnippetState = ServiceListSnippetState().toEmpty();
    newState.serviceSlot = ServiceSlot().toEmpty();
    newState.serviceState = ServiceState().toEmpty();
    newState.slotSnippetListState = SlotListSnippetState().toEmpty();
    newState.statistics = StatisticsState().toEmpty();
    newState.stripe = StripeState().toEmpty();
    newState.user = UserState().toEmpty();
    return newState;
  }

  return newState;
}
