import 'dart:convert';
import 'package:Buytime/environment_abstract.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/order/order_detail_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/order_detail_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/services/statistic/util.dart';
import 'package:Buytime/services/stripe_payment_service_epic.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../main.dart';
import 'order/util.dart';

class OrderReservableDeleteService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteOrderReservable>().asyncMap((event) {
    });
  }
}

class OrderReservableListRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  List<OrderReservableState> orderStateList;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableListRequestService =>  CATCHED ACTION");
     return actions.whereType<OrderReservableListRequest>().asyncMap((event) async {
       debugPrint("ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableListRequestService =>  SERVICE ID: ${event.userId}");
       //debugPrint("ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableListRequestService =>  BUSINESS ID: ${store.state.business.id_firestore}");
        String userId = store.state.business.id_firestore;
        List<BusinessState> businessList = store.state.businessList.businessListState;
        orderStateList = [];
        int ordersFirebaseDocs = 0;
        int read = 0;
       DateTime currentTime = DateTime.now();
       currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);
        QuerySnapshot ordersFirebase = await FirebaseFirestore.instance.collection("order") /// 1 READ - ? DOC
            .where("progress", isEqualTo: "paid")
            .where("serviceId", isEqualTo: event.userId)
            .where("date", isGreaterThanOrEqualTo: currentTime).limit(100)
            .get();

        read++;

        ordersFirebaseDocs += ordersFirebase.docs.length;
        debugPrint("ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableListRequestService => OrderReservableListService Firestore request");
        /*ordersFirebase.docs.forEach((element) {
          if(event.userId != "any"){
            OrderReservableState orderState = OrderReservableState.fromJson(element.data());
            if(orderState.progress == "paid" && orderState.user.id == store.state.stripe.u){
              orderStateList.add(orderState);
            }
          }
          else{
            OrderReservableState orderState = OrderReservableState.fromJson(element.data());
            if(orderState.progress == "paid" && orderState.user.id == store.state.business.ownerId && orderState.businessId == store.state.business.id_firestore){
              orderStateList.add(orderState);
            }
          }
        });*/
        ordersFirebase.docs.forEach((element) {
          OrderReservableState orderState = OrderReservableState.fromJson(element.data());
          orderStateList.add(orderState);
        });
        debugPrint("ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableListRequestService => OrderReservableListService return list with " + orderStateList.length.toString());

        statisticsState = store.state.statistics;
        int reads = statisticsState.orderListRequestServiceRead;
        int writes = statisticsState.orderListRequestServiceWrite;
        int documents = statisticsState.orderListRequestServiceDocuments;
        debugPrint('ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
        reads = reads + read;
        documents = documents + ordersFirebaseDocs;
        debugPrint('ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
        statisticsState.orderListRequestServiceRead = reads;
        statisticsState.orderListRequestServiceWrite = writes;
        statisticsState.orderListRequestServiceDocuments = documents;

        ///Return
        //return new OrderReservableListReturned(orderStateList);
     }).expand((element) => [
       OrderReservableListReturned(orderStateList),
       UpdateStatistics(statisticsState),
     ]);
  }
}

class OrderReservableRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  OrderReservableState orderState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<OrderReservableRequest>().asyncMap((event) async{
      debugPrint("ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableRequestService => OrderReservableRequest requests document id:" + event.orderReservableStateId);
     DocumentSnapshot snapshot= await FirebaseFirestore.instance /// 1 READ - 1 DOC
         .collection("order").doc(event.orderReservableStateId).get();

     orderState = OrderReservableState.fromJson(snapshot.data());

     statisticsState = store.state.statistics;
     int reads = statisticsState.orderRequestServiceRead;
     int writes = statisticsState.orderRequestServiceWrite;
     int documents = statisticsState.orderRequestServiceDocuments;
     debugPrint('ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
     ++reads;
     ++documents;
     debugPrint('ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
     statisticsState.orderRequestServiceRead = reads;
     statisticsState.orderRequestServiceWrite = writes;
     statisticsState.orderRequestServiceDocuments = documents;

    }).expand((element) => [
      OrderReservableRequestResponse(orderState),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class OrderReservableUpdateService implements EpicClass<AppState> {
  OrderReservableState orderReservableState;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateOrderReservable>().asyncMap((event) async {
    //   if (event.serviceState.fileToUploadList != null) {
    //     uploadFiles(event.serviceState.fileToUploadList, event.serviceState).then((ServiceState updatedServiceState) {
    //       return updateService(updatedServiceState);
    //     });
    //   }
    //   return updateService(event.serviceState);
      print("BOOKING_SERVICE_EPIC - OrderReservableUpdateService => ORDER ID: ${event.orderReservableState}");

      orderReservableState = event.orderReservableState;

      /*await FirebaseFirestore.instance /// 1 WRITE
          .collection("order")
          .doc(event.orderReservableState.userId)
          .update(event.orderReservableState.toJson());*/

      /*statisticsState = store.state.statistics;
      int reads = statisticsState.bookingListRequestServiceRead;
      int writes = statisticsState.bookingListRequestServiceWrite;
      int documents = statisticsState.bookingListRequestServiceDocuments;
      debugPrint('BOOKING_SERVICE_EPIC - BookingUpdateAndNavigateRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++writes;
      debugPrint('BOOKING_SERVICE_EPIC - BookingUpdateAndNavigateRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.bookingListRequestServiceRead = reads;
      statisticsState.bookingListRequestServiceWrite = writes;
      statisticsState.bookingListRequestServiceDocuments = documents;*/

     });
  }
}

// class OrderReservableCreateService implements EpicClass<AppState> {
//   // String stripeTestKey = "pk_test_51HS20eHr13hxRBpCZl1V0CKFQ7XzJbku7UipKLLIcuNGh3rp4QVsEDCThtV0l2AQ3jMtLsDN2zdC0fQ4JAK6yCOp003FIf3Wjz";
//   String stripeKey = "pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy";
//   StatisticsState statisticsState;
//   String state = '';
//   @override
//   Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
//      return actions.whereType<CreateOrderReservable>().asyncMap((event) async {
//       OrderReservableState orderReservableState = event.orderReservableState;
//       // add needed data to the order state
//       bool isExternal = false;
//       ExternalBusinessState externalBusinessState;
//       store.state.externalBusinessList.externalBusinessListState.forEach((eBL) {
//         if(eBL.id_firestore == event.orderReservableState.itemList.first.id_business){
//           isExternal = true;
//           externalBusinessState = eBL;
//         }
//       });
//
//       int write = 0;
//       orderReservableState.user = UserSnippet();
//       orderReservableState.user.id = store.state.user.uid;
//       orderReservableState.user.name = store.state.user.name;
//       orderReservableState.userId = store.state.user.uid;
//
//       if(isExternal){
//         orderReservableState.businessId = externalBusinessState.id_firestore;
//         orderReservableState.business.thumbnail = externalBusinessState.wide;
//       }else{
//         orderReservableState.businessId = store.state.business.id_firestore;
//         orderReservableState.business.thumbnail = store.state.business.wide;
//       }
//
//       store.state.cardListState.cardList.forEach((element) {
//         if(element.selected){
//           orderReservableState.cardType = element.stripeState.stripeCard.brand;
//           orderReservableState.cardLast4Digit = element.stripeState.stripeCard.last4;
//         }
//       });
//       // send document to orders collection
//       var addedOrderReservable = await FirebaseFirestore.instance.collection("order/").add(orderReservableState.toJson());
//       orderReservableState.orderId = addedOrderReservable.id;
//       //await FirebaseFirestore.instance.collection("order/").doc(addedOrderReservable.id.toString()).update(orderReservableState.toJson()); /// 1 WRITE
//       //++write;
//       String addedOrderReservableId = addedOrderReservable.id;
//       var url = Uri.https(Environment().config.cloudFunctionLink, '/StripePIOnOrder', {'orderId': '$addedOrderReservableId', 'currency': 'EUR'});
//       final http.Response response = await http.get(url);
//       print("ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableCreateService => OrderReservable_service epic - response is done");
//       print('ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableCreateService => RESPONSE: ${response.body}');
//       if (response != null && response.body == "Error: could not handle the request\n") {
//         // verify why this happens.
//         var updatedOrderReservable = await FirebaseFirestore.instance /// 1 WRITE
//             .collection("order/").doc(addedOrderReservable.id.toString()).update({
//           'progress': "paid",
//           'orderId': addedOrderReservable.id
//         });
//         state = 'paid';
//         //return SetOrderReservableProgress("paid");
//       } else {
//         var jsonResponse;
//         try{
//           jsonResponse = jsonDecode(response.body);
//         }catch(e){
//           debugPrint('order_reservable_service_epic => ERROR: $e');
//           state = 'failed';
//         }
//         /*var jsonResponse;
//         if(response.body == 'error'){
//           state = 'failed';
//         }else{
//           var jsonResponse = jsonDecode(response.body);
//         }*/
//         //jsonResponse = jsonDecode(response.body);
//         if(jsonResponse!= null && response.body != "error") {
//           print('ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableCreateService => JSON RESPONSE: $jsonResponse');
//           // if an action is required, send the user to the confirmation link
//           if (jsonResponse != null && jsonResponse["next_action_url"] != null ) {
//             // final Stripe stripe = Stripe(
//             //   stripeKey, // our publishable key
//             //   stripeAccount: jsonResponse["stripeAccount"], // the connected account
//             //   returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
//             // );
//             var clientSecret = jsonResponse["client_secret"];
//             // var paymentIntentRes = await confirmPayment3DSecure(clientSecret, jsonResponse["payment_method_id"], stripe);
//             // if (paymentIntentRes["status"] == "succeeded") {
//             //   ++write;
//             //   var updatedOrderReservable = await FirebaseFirestore.instance.collection("order/").doc(addedOrderReservable.id.toString()).update({ /// 1 WRITE
//             //     'progress': "paid",
//             //     'orderId': addedOrderReservable.id
//             //   });
//             //   state = 'paid';
//             //   //return SetOrderReservableProgress("paid");
//             // } else {
//             //   state = 'failed';
//             //   //return SetOrderReservableProgress("failed");
//             // }
//           } else {
//             ++write;
//             var updatedOrderReservable = await FirebaseFirestore.instance.collection("order/").doc(addedOrderReservable.id.toString()).update({ /// 1 WRITE
//               'progress': "paid",
//               'orderId': addedOrderReservable.id
//             });
//             state = 'paid';
//             //return SetOrderReservableProgress("paid");
//           }
//         }
//         else {
//           state = 'failed';
//           //return SetOrderReservableProgress("failed");
//         }
//       }
//
//       statisticsState = store.state.statistics;
//       int reads = statisticsState.orderCreateServiceRead;
//       int writes = statisticsState.orderCreateServiceWrite;
//       int documents = statisticsState.orderCreateServiceDocuments;
//       debugPrint('ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
//       writes = writes + write;
//       debugPrint('ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
//       statisticsState.orderCreateServiceRead = reads;
//       statisticsState.orderCreateServiceWrite = writes;
//       statisticsState.orderCreateServiceDocuments = documents;
//
//      }).expand((element) => [
//        SetOrderReservableProgress(state),
//        UpdateStatistics(statisticsState),
//      ]);
//   }
// }

// class AddingReservableStripePaymentMethodRequest implements EpicClass<AppState> {
//   StatisticsState statisticsState;
//   String state = '';
//   http.Response response;
//
//   @override
//   Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
//     return actions.whereType<AddingReservableStripePaymentMethodWithNavigation>().asyncMap((event) async {
//       String userId = event.userId;
//       var stripeCustomerSetupIntentCreationReference = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + Environment().config.stripeSuffix +"/setupIntent").doc() ///TODO Remember _test
//         .set({ ///1 WRITE
//       'status': "create request"
//     });
//     // now http request to create the actual setupIntent
//       var url = Uri.https(Environment().config.cloudFunctionLink, '/createSetupIntent', {'userId': '$userId'});
//       response = await http.get(url);
//       statisticsState = store.state.statistics;
//
//       debugPrint('order_service_epic: RESPONSE: ${response.statusCode}');
//
//     }).expand((element) => [
//       //SetOrderReservableProgress(state),,
//       if (response.statusCode == 200) AddedReservableStripePaymentMethodAndNavigate() else AddedReservableStripePaymentMethod(),
//       UpdateStatistics(statisticsState),
//       //response.statusCode == 200 ? NavigatePopAction() : AddedStripePaymentMethod(),
//
//     ]);
//   }
// }

/// an order always have to be created with a payment method attached in its subcollection
/// TODO: research if there is a way to make this two operations in an atomic way
/// IMPORTANT: This function will create a separate order on the database for EACH time slot in the list.
/// this is the way to go at the moment.
class CreateOrderReservableCardAndPayService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  String paymentResult = '';
  OrderReservableState reservable;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateOrderReservableCardAndPay>().asyncMap((event) async {
      for (int i = 0; i < event.orderReservableState.itemList.length; i++) {
        reservable = orderReservableInitialization(event, i);
        debugPrint('UI_U_ConfirmOrder => Date: ${reservable.date}');
        /// add needed data to the order state
        OrderReservableState orderReservableState = configureOrderReservable(reservable, store);
        if(event.selectedCardPaymentMethodId != null && store.state.booking != null && store.state.booking.booking_id != null) {
          /// This is a time based id, meaning that even if 2 users are going to generate a document at the same moment in time
          /// there are really low chances that the rest of the id is also colliding.
          String timeBasedId = Uuid().v1();
          orderReservableState.orderId = timeBasedId;
          /// send document to orders collection
          var addedOrder = await FirebaseFirestore.instance.collection("order").doc(timeBasedId).set(orderReservableState.toJson());
          /// add the payment method to the order sub collection on firebase
          var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderReservableState.orderId + "/orderPaymentMethod").add({
            'paymentMethodId' : event.selectedCardPaymentMethodId,
            'last4': event.last4 ?? '',
            'brand': event.brand ?? '',
            'type':  Utils.enumToString(event.paymentType),
            'country': event.country ?? 'US',
            'booking_id': store.state.booking.booking_id
          });
          StripePaymentService stripePaymentService = StripePaymentService();
          paymentResult = await stripePaymentService.processPaymentAsDirectCharge(orderReservableState.orderId, event.businessStripeAccount );
        }
      }
      statisticsComputation();
    }).expand((element) {
      var actionArray = [];
      actionArray.add(CreatedOrderReservable());
      actionArray.add(UpdateStatistics(statisticsState));
      actionArray.add(SetOrderReservableOrderId(reservable.orderId));
      actionArray.add(SetOrderDetail(OrderDetailState.fromReservableState(reservable)));
      actionArray.add(NavigatePushAction(AppRoutes.orderDetailsRealtime));
      return actionArray;
    });
  }
}

/// an order always have to be created with a payment method attached in its subcollection
/// TODO: research if there is a way to make this two operations in an atomic way
/// IMPORTANT: This function will create a separate order on the database for EACH time slot in the list.
/// this is the way to go at the moment.
class CreateOrderReservableCardAndHoldService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  dynamic paymentResult;
  OrderReservableState reservable;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateOrderReservableCardAndHold>().asyncMap((event) async {
      for (int i = 0; i < event.orderReservableState.itemList.length; i++) {
        reservable = orderReservableInitialization(event, i);
        debugPrint('order_reservable_service_epic, CreateOrderReservableCardAndHoldService => Date: ${reservable.date}');
        /// add needed data to the order state
        OrderReservableState orderReservableState = configureOrderReservable(reservable, store);
        if(event.selectedCardPaymentMethodId != null && store.state.booking != null && store.state.booking.booking_id != null) {
          reservable.cardType = Utils.enumToString(PaymentType.card);
          /// This is a time based id, meaning that even if 2 users are going to generate a document at the same moment in time
          /// there are really low chances that the rest of the id is also colliding.
          String timeBasedId = Uuid().v1();
          orderReservableState.orderId = timeBasedId;
          reservable.cardType = Utils.enumToString(PaymentType.card);
          reservable.progress = Utils.enumToString(OrderStatus.holding);
          /// send document to orders collection
          var addedOrder = await FirebaseFirestore.instance.collection("order").doc(timeBasedId).set(orderReservableState.toJson());
          /// add the payment method to the order sub collection on firebase
          var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderReservableState.orderId + "/orderPaymentMethod").add({
            'paymentMethodId' : event.selectedCardPaymentMethodId,
            'last4': event.last4 ?? '',
            'brand': event.brand ?? '',
            'type':  Utils.enumToString(event.paymentType),
            'country': event.country ?? 'US',
            'booking_id': store.state.booking.booking_id
          });
          StripePaymentService stripePaymentService = StripePaymentService();
          paymentResult = await stripePaymentService.processHoldCharge(orderReservableState.orderId, event.businessStripeAccount, event.context);
        }
      }
      statisticsComputation();
    }).expand((element) {
      var actionArray = [];
      actionArray.add(CreatedOrderReservable());
      actionArray.add(UpdateStatistics(statisticsState));
      actionArray.add(SetOrderReservableOrderId(reservable.orderId));
      actionArray.add(SetOrderDetail(OrderDetailState.fromReservableState(reservable)));
      actionArray.add(NavigatePushAction(AppRoutes.orderDetailsRealtime));
      return actionArray;
    });
  }
}

/// an order always have to be created with a payment method attached in its subcollection
/// TODO: research if there is a way to make this two operations in an atomic way
/// IMPORTANT: This function will create a separate order on the database for EACH time slot in the list.
/// this is the way to go at the moment.
/// IMPORTANT: A paymentReminder document will be created by the cloud function
/// The reminder scheduler will try to perform the payment and if the payment is not performed the user will be asked to pay again.
class CreateOrderReservableCardAndReminderService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  String paymentResult = '';
  OrderReservableState reservable;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateOrderReservableCardAndReminder>().asyncMap((event) async {
      for (int i = 0; i < event.orderReservableState.itemList.length; i++) {
        reservable = orderReservableInitialization(event, i);
        debugPrint('UI_U_ConfirmOrder => Date: ${reservable.date}');
        /// add needed data to the order state
        OrderReservableState orderReservableState = configureOrderReservable(reservable, store);
        if(event.selectedCardPaymentMethodId != null && store.state.booking != null && store.state.booking.booking_id != null) {
          /// This is a time based id, meaning that even if 2 users are going to generate a document at the same moment in time
          /// there are really low chances that the rest of the id is also colliding.
          String timeBasedId = Uuid().v1();
          orderReservableState.orderId = timeBasedId;
          reservable.cardType = Utils.enumToString(PaymentType.card);
          reservable.progress = Utils.enumToString(OrderStatus.holding);
          /// send document to orders collection
          var addedOrder = await FirebaseFirestore.instance.collection("order").doc(timeBasedId).set(orderReservableState.toJson());
          /// add the payment method to the order sub collection on firebase
          var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderReservableState.orderId + "/orderPaymentMethod").add({
            'paymentMethodId' : event.selectedCardPaymentMethodId,
            'last4': event.last4 ?? '',
            'brand': event.brand ?? '',
            'type':  Utils.enumToString(event.paymentType),
            'country': event.country ?? 'US',
            'booking_id': store.state.booking.booking_id
          });
        }
      }
      statisticsComputation();
    }).expand((element) {
      var actionArray = [];
      actionArray.add(CreatedOrderReservable());
      actionArray.add(UpdateStatistics(statisticsState));
      actionArray.add(SetOrderReservableOrderId(reservable.orderId));
      actionArray.add(SetOrderDetail(OrderDetailState.fromReservableState(reservable)));
      actionArray.add(NavigatePushAction(AppRoutes.orderDetailsRealtime));
      return actionArray;
    });
  }
}

/// an order always have to be created with a payment method attached in its subcollection
/// TODO: research if there is a way to make this two operations in an atomic way
/// IMPORTANT: This function will create a separate order on the database for EACH time slot in the list.
/// this is the way to go at the moment.
/// IMPORTANT: A paymentReminder document will be created by the cloud function
/// The reminder scheduler will try to perform the payment and if the payment is not performed the user will be asked to pay again.
class CreateOrderReservableCardPendingService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  String paymentResult = '';
  OrderReservableState reservable;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateOrderReservableCardPending>().asyncMap((event) async {
      debugPrint('order_reservable_service => in epic, itemList: ' + event.orderReservableState.itemList.length.toString());
      for (int i = 0; i < event.orderReservableState.itemList.length; i++) {
        reservable = orderReservableInitialization(event, i);
        debugPrint('UI_U_ConfirmOrder => Date: ${reservable.date}');
        /// add needed data to the order state
        OrderReservableState orderReservableState = configureOrderReservable(reservable, store);
        if(event.selectedCardPaymentMethodId != null && store.state.booking != null && store.state.booking.booking_id != null) {
          reservable.cardType = Utils.enumToString(PaymentType.card);
          reservable.progress = Utils.enumToString(OrderStatus.pending);
          /// This is a time based id, meaning that even if 2 users are going to generate a document at the same moment in time
          /// there are really low chances that the rest of the id is also colliding.
          String timeBasedId = Uuid().v1();
          orderReservableState.orderId = timeBasedId;
          /// send document to orders collection
          var addedOrder = await FirebaseFirestore.instance.collection("order").doc(timeBasedId).set(orderReservableState.toJson());
          /// add the payment method to the order sub collection on firebase
          var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderReservableState.orderId + "/orderPaymentMethod").add({
            'paymentMethodId' : event.selectedCardPaymentMethodId,
            'last4': event.last4 ?? '',
            'brand': event.brand ?? '',
            'type':  Utils.enumToString(event.paymentType),
            'country': event.country ?? 'US',
            'booking_id': store.state.booking.booking_id
          });
        }
      }
      statisticsComputation();
    }).expand((element) {
      var actionArray = [];
      actionArray.add(CreatedOrderReservable());
      actionArray.add(UpdateStatistics(statisticsState));
      actionArray.add(SetOrderReservableOrderId(reservable.orderId));
      actionArray.add(SetOrderDetail(OrderDetailState.fromReservableState(reservable)));
      actionArray.add(NavigatePushAction(AppRoutes.orderDetailsRealtime));
      return actionArray;
    });
  }
}


/// an order always have to be created with a payment method attached in its subcollection
/// TODO: research if there is a way to make this two operations in an atomic way
class CreateOrderReservableNativeAndPayService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  String paymentResult = '';
  OrderReservableState reservable;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateOrderReservableNativeAndPay>().asyncMap((event) async {
      for (int i = 0; i < event.orderReservableState.itemList.length; i++) {
        reservable = orderReservableInitialization(event, i);
        OrderReservableState orderReservableState = configureOrderReservable(reservable, store);
        debugPrint('UI_U_ConfirmOrder => Date: ${reservable.date}');
        if(event.paymentMethod != null && store.state.booking != null && store.state.booking.booking_id != null) {
          reservable.cardType = Utils.enumToString(PaymentType.card);
          reservable.progress = Utils.enumToString(OrderStatus.accepted);
          /// This is a time based id, meaning that even if 2 users are going to generate a document at the same moment in time
          /// there are really low chances that the rest of the id is also colliding.
          String timeBasedId = Uuid().v1();
          orderReservableState.orderId = timeBasedId;
          /// send document to orders collection
          var addedOrder = await FirebaseFirestore.instance.collection("order").doc(timeBasedId).set(orderReservableState.toJson());
          /// add the payment method to the order sub collection on firebase
          var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderReservableState.orderId + "/orderPaymentMethod").add({
            'paymentMethodId' : event.paymentMethod.id,
            'last4': event.paymentMethod.card.last4 ?? '',
            'brand': event.paymentMethod.card.brand ?? '',
            'type':  Utils.enumToString(event.paymentType),
            'country': event.paymentMethod.card.country  ?? 'US',
            'booking_id': store.state.booking.booking_id
          });
          StripePaymentService stripePaymentService = StripePaymentService();
          paymentResult = await stripePaymentService.processPaymentAsDirectCharge(orderReservableState.orderId, event.businessStripeAccount );
        }
      }
      statisticsComputation();
    }).expand((element) {
      var actionArray = [];
      actionArray.add(CreatedOrderReservable());
      actionArray.add(UpdateStatistics(statisticsState));
      actionArray.add(SetOrderReservableOrderId(reservable.orderId));
      actionArray.add(SetOrderDetail(OrderDetailState.fromReservableState(reservable)));
      actionArray.add(NavigatePushAction(AppRoutes.orderDetailsRealtime));
      return actionArray;
    });
  }
}

/// an order always have to be created with a payment method attached in its subcollection
/// TODO: research if there is a way to make this two operations in an atomic way
class CreateOrderReservableNativeAndHoldService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  dynamic paymentResult;
  OrderReservableState reservable;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateOrderReservableNativeAndHold>().asyncMap((event) async {
      for (int i = 0; i < event.orderReservableState.itemList.length; i++) {
        reservable = orderReservableInitialization(event, i);
        debugPrint('UI_U_ConfirmOrder => Date: ${reservable.date}');
        /// add needed data to the order state
        OrderReservableState orderReservableState = configureOrderReservable(reservable, store);
        if(event.paymentMethod != null && store.state.booking != null && store.state.booking.booking_id != null) {
          reservable.cardType = Utils.enumToString(PaymentType.card);
          reservable.progress = Utils.enumToString(OrderStatus.holding);
          /// This is a time based id, meaning that even if 2 users are going to generate a document at the same moment in time
          /// there are really low chances that the rest of the id is also colliding.
          String timeBasedId = Uuid().v1();
          orderReservableState.orderId = timeBasedId;
          /// send document to orders collection
          var addedOrder = await FirebaseFirestore.instance.collection("order").doc(timeBasedId).set(orderReservableState.toJson());
          /// add the payment method to the order sub collection on firebase
          var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderReservableState.orderId + "/orderPaymentMethod").add({
            'paymentMethodId' : event.paymentMethod.id,
            'last4': event.paymentMethod.card.last4 ?? '',
            'brand': event.paymentMethod.card.brand ?? '',
            'type':  Utils.enumToString(event.paymentType),
            'country': event.paymentMethod.card.country  ?? 'US',
            'booking_id': store.state.booking.booking_id
          });
          StripePaymentService stripePaymentService = StripePaymentService();
          paymentResult = await stripePaymentService.processHoldCharge(orderReservableState.orderId, event.businessStripeAccount, event.context );
        }
      }
      statisticsComputation();
    }).expand((element) {
      var actionArray = [];
      actionArray.add(CreatedOrderReservable());
      actionArray.add(UpdateStatistics(statisticsState));
      actionArray.add(SetOrderReservableOrderId(reservable.orderId));
      actionArray.add(SetOrderDetail(OrderDetailState.fromReservableState(reservable)));
      actionArray.add(NavigatePushAction(AppRoutes.orderDetailsRealtime));
      return actionArray;
    });
  }
}

/// an order always have to be created with a payment method attached in its subcollection
/// TODO: research if there is a way to make this two operations in an atomic way
class CreateOrderReservableNativeAndReminderService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  String paymentResult = '';
  OrderReservableState reservable;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateOrderReservableNativeAndReminder>().asyncMap((event) async {
      for (int i = 0; i < event.orderReservableState.itemList.length; i++) {
        reservable = orderReservableInitialization(event, i);
        debugPrint('UI_U_ConfirmOrder => Date: ${reservable.date}');
        /// add needed data to the order state
        OrderReservableState orderReservableState = configureOrderReservable(reservable, store);
        if(event.paymentMethod != null && store.state.booking != null && store.state.booking.booking_id != null) {
          reservable.cardType = Utils.enumToString(PaymentType.card);
          reservable.progress = Utils.enumToString(OrderStatus.holding);
          /// This is a time based id, meaning that even if 2 users are going to generate a document at the same moment in time
          /// there are really low chances that the rest of the id is also colliding.
          String timeBasedId = Uuid().v1();
          orderReservableState.orderId = timeBasedId;
          /// send document to orders collection
          var addedOrder = await FirebaseFirestore.instance.collection("order").doc(timeBasedId).set(orderReservableState.toJson());
          /// add the payment method to the order sub collection on firebase
          var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderReservableState.orderId + "/orderPaymentMethod").add({
            'paymentMethodId' : event.paymentMethod.id,
            'last4': event.paymentMethod.card.last4 ?? '',
            'brand': event.paymentMethod.card.brand ?? '',
            'type':  Utils.enumToString(event.paymentType),
            'country': event.paymentMethod.card.country  ?? 'US',
            'booking_id': store.state.booking.booking_id
          });
        }
      }
      statisticsComputation();
    }).expand((element) {
      var actionArray = [];
      actionArray.add(CreatedOrderReservable());
      actionArray.add(UpdateStatistics(statisticsState));
      actionArray.add(SetOrderReservableOrderId(reservable.orderId));
      actionArray.add(SetOrderDetail(OrderDetailState.fromReservableState(reservable)));
      actionArray.add(NavigatePushAction(AppRoutes.orderDetailsRealtime));
      return actionArray;
    });
  }
}

/// an order always have to be created with a payment method attached in its subcollection
/// TODO: research if there is a way to make this two operations in an atomic way
class CreateOrderReservableNativePendingService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  String paymentResult = '';
  OrderReservableState reservable;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateOrderReservableNativePending>().asyncMap((event) async {
      for (int i = 0; i < event.orderReservableState.itemList.length; i++) {
         reservable = orderReservableInitialization(event, i);
        debugPrint('UI_U_ConfirmOrder => Date: ${reservable.date}');
        /// add needed data to the order state
        OrderReservableState orderReservableState = configureOrderReservable(reservable, store);
        if(event.paymentMethod != null && store.state.booking != null && store.state.booking.booking_id != null) {
          reservable.cardType = Utils.enumToString(PaymentType.card);
          reservable.progress = Utils.enumToString(OrderStatus.pending);
          /// This is a time based id, meaning that even if 2 users are going to generate a document at the same moment in time
          /// there are really low chances that the rest of the id is also colliding.
          String timeBasedId = Uuid().v1();
          orderReservableState.orderId = timeBasedId;
          /// send document to orders collection
          var addedOrder = await FirebaseFirestore.instance.collection("order").doc(timeBasedId).set(orderReservableState.toJson());
          /// add the payment method to the order sub collection on firebase
          var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderReservableState.orderId + "/orderPaymentMethod").add({
            'paymentMethodId' : event.paymentMethod.id,
            'last4': event.paymentMethod.card.last4 ?? '',
            'brand': event.paymentMethod.card.brand ?? '',
            'type':  Utils.enumToString(event.paymentType),
            'country': event.paymentMethod.card.country  ?? 'US',
            'booking_id': store.state.booking.booking_id
          });
        }
      }
      statisticsComputation();
    }).expand((element) {
      var actionArray = [];
      actionArray.add(CreatedOrderReservable());
      actionArray.add(UpdateStatistics(statisticsState));
      actionArray.add(SetOrderReservableOrderId(reservable.orderId));
      actionArray.add(SetOrderDetail(OrderDetailState.fromReservableState(reservable)));
      actionArray.add(NavigatePushAction(AppRoutes.orderDetailsRealtime));
      return actionArray;
    });
  }
}

/// an order always have to be created with a payment method attached in its subcollection
/// TODO: research if there is a way to make this two operations in an atomic way
class CreateOrderReservableRoomAndPayService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  String paymentResult = '';
  OrderReservableState reservable;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateOrderReservableRoomAndPay>().asyncMap((event) async {
      for (int i = 0; i < event.orderReservableState.itemList.length; i++) {
        reservable = orderReservableInitialization(event, i);
        debugPrint('UI_U_ConfirmOrder => Date: ${reservable.date}');
        /// add needed data to the order state
        OrderReservableState orderReservableState = configureOrderReservable(reservable, store);
        if(store.state.booking != null && store.state.booking.booking_id != null) {
          reservable.cardType = Utils.enumToString(PaymentType.room);
          reservable.progress = Utils.enumToString(OrderStatus.accepted);
          /// send document to orders collection
          /// This is a time based id, meaning that even if 2 users are going to generate a document at the same moment in time
          /// there are really low chances that the rest of the id is also colliding.
          String timeBasedId = Uuid().v1();
          orderReservableState.orderId = timeBasedId;
          var addedOrder = await FirebaseFirestore.instance.collection("order").doc(timeBasedId).set(orderReservableState.toJson());
          /// add the payment method to the order sub collection on firebase
          var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderReservableState.orderId + "/orderPaymentMethod").add({
            'paymentMethodId' : '',
            'last4': '',
            'brand': '',
            'type':  Utils.enumToString(event.paymentType),
            'country': '',
            'bookingId': store.state.booking.booking_id
          });
        }
      }
      statisticsComputation();
    }).expand((element) {
      var actionArray = [];
      actionArray.add(CreatedOrderReservable());
      actionArray.add(UpdateStatistics(statisticsState));
      actionArray.add(SetOrderReservableOrderId(reservable.orderId));
      actionArray.add(SetOrderDetail(OrderDetailState.fromReservableState(reservable)));
      actionArray.add(NavigatePushAction(AppRoutes.orderDetailsRealtime));
      return actionArray;
    });
  }
}
/// an order always have to be created with a payment method attached in its subcollection
/// TODO: research if there is a way to make this two operations in an atomic way
class CreateOrderReservableOnSiteAndPayService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  String paymentResult = '';
  OrderReservableState reservable;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateOrderReservableOnSiteAndPay>().asyncMap((event) async {
      for (int i = 0; i < event.orderReservableState.itemList.length; i++) {
        reservable = orderReservableInitialization(event, i);
        debugPrint('UI_U_ConfirmOrder => Date: ${reservable.date}');
        /// add needed data to the order state
        OrderReservableState orderReservableState = configureOrderReservable(reservable, store);
          reservable.cardType = Utils.enumToString(PaymentType.onSite);
          reservable.progress = Utils.enumToString(OrderStatus.accepted);
          /// send document to orders collection
          /// This is a time based id, meaning that even if 2 users are going to generate a document at the same moment in time
          /// there are really low chances that the rest of the id is also colliding.
          String timeBasedId = Uuid().v1();
          orderReservableState.orderId = timeBasedId;
          debugPrint("order_reservable_service_epic RULE TEST" + store.state.user.uid + " " + orderReservableState.user.id.toString() + " " +  orderReservableState.userId + " " + orderReservableState.progress);
          orderReservableState.user.id = store.state.user.uid;
          orderReservableState.userId = store.state.user.uid;

          var addedOrder = await FirebaseFirestore.instance.collection("order").doc(timeBasedId).set(orderReservableState.toJson());
          /// add the payment method to the order sub collection on firebase
          String bookingId = '';
          if(store.state.booking != null && store.state.booking.booking_id != null) {
            bookingId = store.state.booking.booking_id;
          }
          var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderReservableState.orderId + "/orderPaymentMethod").add({
            'paymentMethodId' : '',
            'last4': '',
            'brand': '',
            'type':  Utils.enumToString(event.paymentType),
            'country': '',
            'bookingId': bookingId
          });
      }
      statisticsComputation();
    }).expand((element) {
      var actionArray = [];
      actionArray.add(CreatedOrderReservable());
      actionArray.add(UpdateStatistics(statisticsState));
      actionArray.add(SetOrderReservableOrderId(reservable.orderId));
      actionArray.add(SetOrderDetail(OrderDetailState.fromReservableState(reservable)));
      actionArray.add(NavigatePushAction(AppRoutes.orderDetailsRealtime));
      return actionArray;
    });
  }
}

/// an order always have to be created with a payment method attached in its subcollection
/// TODO: research if there is a way to make this two operations in an atomic way
class CreateOrderReservableRoomPendingService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  String paymentResult = '';
  OrderReservableState reservable;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateOrderReservableRoomPending>().asyncMap((event) async {
      for (int i = 0; i < event.orderReservableState.itemList.length; i++) {
        reservable = orderReservableInitialization(event, i);
        debugPrint('UI_U_ConfirmOrder => Date: ${reservable.date}');
        /// add needed data to the order state
        OrderReservableState orderReservableState = configureOrderReservable(reservable, store);
        if(store.state.booking != null && store.state.booking.booking_id != null) {
          reservable.cardType = Utils.enumToString(PaymentType.room);
          reservable.progress = Utils.enumToString(OrderStatus.pending);
          /// send document to orders collection
          /// This is a time based id, meaning that even if 2 users are going to generate a document at the same moment in time
          /// there are really low chances that the rest of the id is also colliding.
          String timeBasedId = Uuid().v1();
          orderReservableState.orderId = timeBasedId;
          var addedOrder = await FirebaseFirestore.instance.collection("order").doc(timeBasedId).set(orderReservableState.toJson());
          /// add the payment method to the order sub collection on firebase
          var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderReservableState.orderId + "/orderPaymentMethod").add({
            'paymentMethodId' : '',
            'last4': '',
            'brand': '',
            'type':  Utils.enumToString(event.paymentType),
            'country': '',
            'bookingId': store.state.booking.booking_id
          });
        }
      }
      statisticsComputation();
    }).expand((element) {
      var actionArray = [];
      actionArray.add(CreatedOrderReservable());
      actionArray.add(UpdateStatistics(statisticsState));
      actionArray.add(SetOrderReservableOrderId(reservable.orderId));
      actionArray.add(SetOrderDetail(OrderDetailState.fromReservableState(reservable)));
      actionArray.add(NavigatePushAction(AppRoutes.orderDetailsRealtime));
      return actionArray;
    });
  }
}

/// an order always have to be created with a payment method attached in its subcollection
class CreateOrderReservableOnSitePendingService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  String paymentResult = '';
  OrderReservableState reservable;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateOrderReservableOnSitePending>().asyncMap((event) async {
      for (int i = 0; i < event.orderReservableState.itemList.length; i++) {
        reservable = orderReservableInitialization(event, i);
        debugPrint('UI_U_ConfirmOrder => Date: ${reservable.date}');
        /// add needed data to the order state
        OrderReservableState orderReservableState = configureOrderReservable(reservable, store);
          reservable.cardType = Utils.enumToString(PaymentType.onSite);
          reservable.progress = Utils.enumToString(OrderStatus.pending);
          /// send document to orders collection
          /// This is a time based id, meaning that even if 2 users are going to generate a document at the same moment in time
          /// there are really low chances that the rest of the id is also colliding.
          String timeBasedId = Uuid().v1();
          orderReservableState.orderId = timeBasedId;
          var addedOrder = await FirebaseFirestore.instance.collection("order").doc(timeBasedId).set(orderReservableState.toJson());
          /// add the payment method to the order sub collection on firebase
          String bookingId = '';
          if(store.state.booking != null && store.state.booking.booking_id != null) {
            bookingId = store.state.booking.booking_id;
          }
          var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderReservableState.orderId + "/orderPaymentMethod").add({
            'paymentMethodId' : '',
            'last4': '',
            'brand': '',
            'type':  Utils.enumToString(event.paymentType),
            'country': '',
            'bookingId': bookingId
          });
      }
      statisticsComputation();
    }).expand((element) {
      var actionArray = [];
      actionArray.add(CreatedOrderReservable());
      actionArray.add(UpdateStatistics(statisticsState));
      actionArray.add(SetOrderReservableOrderId(reservable.orderId));
      actionArray.add(SetOrderDetail(OrderDetailState.fromReservableState(reservable)));
      actionArray.add(NavigatePushAction(AppRoutes.orderDetailsRealtime));
      return actionArray;
    });
  }
}
