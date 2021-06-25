
import 'package:Buytime/reblox/model/app_state.dart';
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
OrderReservableCreateService(),
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
AddingReservableStripePaymentMethodRequest(),
CreateOrderReservableCardPendingService(),
EmailCreateService(),
// ReservationsAndOrdersListSnippetRequestService(),
// ReservationsAndOrdersListSnippetListRequestService(),
ServiceListSnippetRequestService(),
ServiceListSnippetListRequestService(),
ExternalServiceImportedCreateService(),
ExternalServiceImportedListRequestService(),
ServiceListByIdsRequestService(),
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
//DefaultCategoryTreeAddService(),
/*BusinessGenerateDefaultCategoryService(),
DefaultCategoryCreateService(),

ConvertBusinessToSnippetService(),
BeforeConvertBusinessToSnippetService(),*/
]);