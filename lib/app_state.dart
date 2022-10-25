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

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/area/area_list_state.dart';
import 'package:Buytime/reblox/model/area/area_state.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_list_state.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/reblox/model/booking/booking_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/business/external_business_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/business/snippet/order_business_snippet_state.dart';
import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/category/invitation/category_invite_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/email/email_state.dart';
import 'package:Buytime/reblox/model/email/template_data_state.dart';
import 'package:Buytime/reblox/model/email/template_state.dart';
import 'package:Buytime/reblox/model/notification/notification_list_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/order/order_detail_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_list_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/promotion/promotion_list_state.dart';
import 'package:Buytime/reblox/model/promotion/promotion_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_list_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/slot/slot_list_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/reservations_orders_list_snippet_list_state.dart';
import 'package:Buytime/reblox/model/snippet/reservations_orders_list_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_list_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/order/order_list_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline_list_state.dart';
import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';

var appState = AppState(
category: CategoryState().toEmpty(),
categoryInvite: CategoryInviteState().toEmpty(),
business: BusinessState().toEmpty(),
area: AreaState().toEmpty(),
areaList: AreaListState().toEmpty(),
externalBusiness: ExternalBusinessState().toEmpty(),
booking: BookingState().toEmpty(),
order: OrderState().toEmpty(),
orderDetail: OrderDetailState().toEmpty(),
orderReservable: OrderReservableState().toEmpty(),
orderList: OrderListState().toEmpty(),
orderReservableList: OrderReservableListState().toEmpty(),
stripe: StripeState().toEmpty(),
businessList: BusinessListState().toEmpty(),
externalBusinessList: ExternalBusinessListState().toEmpty(),
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
autoCompleteListState: AutoCompleteListState().toEmpty(),
notificationState: NotificationState().toEmpty(),
notificationListState: NotificationListState().toEmpty(),
emailState: EmailState().toEmpty(),
templateState: TemplateState().toEmpty(),
templateDataState: TemplateDataState().toEmpty(),
serviceListSnippetState: ServiceListSnippetState().toEmpty(),
serviceListSnippetListState: ServiceListSnippetListState().toEmpty(),
reservationsOrdersListSnippetState: ReservationsOrdersListSnippetState().toEmpty(),
reservationsOrdersListSnippetListState: ReservationsOrdersListSnippetListState().toEmpty(),
externalBusinessImportedState: ExternalBusinessImportedState().toEmpty(),
externalBusinessImportedListState: ExternalBusinessImportedListState().toEmpty(),
externalServiceImportedState: ExternalServiceImportedState().toEmpty(),
externalServiceImportedListState: ExternalServiceImportedListState().toEmpty(),
businessSnippetState: BusinessSnippetState().toEmpty(),
orderBusinessSnippetState: OrderBusinessSnippetState().toEmpty(),
slotSnippetListState: SlotListSnippetState().toEmpty(),
promotionState: PromotionState().toEmpty(),
promotionListState: PromotionListState().toEmpty());