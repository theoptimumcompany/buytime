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
import 'package:Buytime/services/promotion_service_epic.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:Buytime/services/area_service_epic.dart';
import 'package:Buytime/services/category_invite_service_epic.dart';
import 'package:Buytime/services/email_service_epic.dart';
import 'package:Buytime/services/external_business_imported_service_epic.dart';
import 'package:Buytime/services/external_business_service_epic.dart';
import 'package:Buytime/services/external_service_imported_service_epic.dart';
import 'package:Buytime/services/notification_service_epic.dart';
import 'package:Buytime/services/order_reservable_service_epic.dart';
import 'package:Buytime/services/slot_service_epic.dart';
import 'package:Buytime/services/business_service_epic.dart';
import 'package:Buytime/services/category_tree_service_epic.dart';
import 'package:Buytime/services/category_service_epic.dart';
import 'package:Buytime/services/order_service_epic.dart';
import 'package:Buytime/services/pipeline_service_epic.dart';
import 'package:Buytime/services/service_service_epic.dart';
import 'package:Buytime/services/stripe_payment_service_epic.dart';
import 'package:Buytime/services/user_service_epic.dart';
import 'package:Buytime/services/booking_service_epic.dart';

var combinedEpics = combineEpics<AppState>([
  BusinessAndNavigateRequestService(),
  BusinessAndNavigateOnConfirmRequestService(),
  BusinessRequestService(),
  BusinessRequestAndNavigateService(),
  BusinessUpdateService(),
  AreaListRequestService(),
  BusinessCreateService(),
  BusinessListRequestService(),
  ExternalBusinessAndNavigateRequestService(),
  ExternalBusinessAndNavigateOnConfirmRequestService(),
  ExternalBusinessRequestService(),
  ExternalBusinessRequestAndNavigateService(),
  ExternalBusinessUpdateService(),
  ExternalBusinessCreateService(),
  ExternalBusinessListRequestService(),
  BookingCreateRequestService(),
  BookingRequestService(),
  UserBookingListRequestService(),
  BookingListRequestService(),
  BookingUpdateRequestService(),
  BookingUpdateAndNavigateRequestService(),
  SelfBookingCreateRequestService(),
  UserRequestService(),
  UserEditDevice(),
  UserEditToken(),
  SetOrderDetailAndNavigateService(),
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
  AllCategoryListRequestService(),
  CategoryListRequestService(),
  UserCategoryListRequestService(),
  CategoryRootListRequestService(),
/*CategoryTreeRequestService(),
CategoryTreeCreateIfNotExistsService(),
CategoryTreeUpdateService(),
CategoryTreeAddService(),
CategoryTreeDeleteService(), */
  StripePaymentAddPaymentMethod(),
  StripeCardListRequestService(),
  StripeCardListRequestAndNavigateService(),
  StripeDetachPaymentMethodRequest(),
  SetOrderDetailAndNavigateRoomService(),
  CheckStripeCustomerService(),
  ServiceUpdateService(),
  ServiceRequestService(),
  ServiceUpdateServiceVisibility(),
  ServiceDeleteService(),
  ServiceCreateService(),
  ServiceDuplicateService(),
  ServiceListRequestService(),
  ServiceListAndNavigateRequestService(),
  ServiceListAndNavigateOnConfirmRequestService(),
  PipelineRequestService(),
  PipelineListRequestService(),
  OrderListRequestService(),
  UserOrderListRequestService(),
  OrderReservableListRequestService(),
  OrderRequestService(),
  OrderReservableRequestService(),
  OrderUpdateByManagerService(),
  OrderReservableUpdateService(),
  OrderCreateNativeAndPayService(),
  OrderCreateCardAndPayService(),
  OrderCreateRoomAndPayService(),
  OrderCreateCardPendingService(),
  OrderCreateNativePendingService(),
  OrderCreateRoomPendingService(),
  CreateOrderReservableCardAndPayService(),
  OrderRefundByUserService(),
  CreateOrderReservableCardAndHoldService(),
  CreateOrderReservableCardAndReminderService(),
  CreateOrderReservableNativeAndPayService(),
  CreateOrderReservableNativeAndHoldService(),
  CreateOrderReservableNativeAndReminderService(),
  CreateOrderReservableNativePendingService(),
  CreateOrderReservableRoomAndPayService(),
  CreateOrderReservableRoomPendingService(),
  SetOrderDetailAndNavigatePopService(),
  CreateOrderReservableCardPendingService(),
  EmailCreateService(),
  ServiceListSnippetRequestService(),
  ServiceListSnippetListRequestService(),
  ExternalServiceImportedCreateService(),
  ExternalServiceImportedListRequestService(),
  ServiceListByIdsRequestService(),
  ServiceListByBusinessIdsRequestService(),
  ServiceListByIdsRequestNavigateService(),
  ServiceListSnippetRequestServiceNavigate(),
  UserCategoryListByIdsRequestService(),
  ExternalBusinessListRequestByIdsService(),
  ExternalBusinessImportedListRequestService(),
  ExternalBusinessImportedCreateService(),
  ExternalServiceImportedCanceledService(),
  ExternalBusinessImportedCanceledService(),
  NotificationRequestService(),
  NotificationListRequestService(),
  NotificationUpdateRequestService(),
  SlotListSnippetRequestService(),
  OrderCreateOnSitePendingService(),
  OrderCreateOnSiteAndPayService(),
  CreateOrderReservableOnSitePendingService(),
  CreateOrderReservableOnSiteAndPayService(),
  ServiceUpdateSlotSnippetService(),
  StripeCardListRequestAndNavigatePop(),
  PromotionListRequestService(),
  PromotionRequestService()
//DefaultCategoryTreeAddService(),
/*BusinessGenerateDefaultCategoryService(),
DefaultCategoryCreateService(),

ConvertBusinessToSnippetService(),
BeforeConvertBusinessToSnippetService(),*/
]);
