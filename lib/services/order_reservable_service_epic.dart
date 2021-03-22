import 'dart:convert';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:Buytime/services/file_upload_service.dart' if (dart.library.html) 'package:Buytime/services/file_upload_service_web.dart';
import 'package:stripe_sdk/stripe_sdk.dart';

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
            .where("date", isGreaterThanOrEqualTo: currentTime)
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
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateOrderReservable>().asyncMap((event) {
    //   if (event.serviceState.fileToUploadList != null) {
    //     uploadFiles(event.serviceState.fileToUploadList, event.serviceState).then((ServiceState updatedServiceState) {
    //       return updateService(updatedServiceState);
    //     });
    //   }
    //   return updateService(event.serviceState);
     });
  }
}

class OrderReservableCreateService implements EpicClass<AppState> {
  String stripeTestKey = "pk_test_51HS20eHr13hxRBpCZl1V0CKFQ7XzJbku7UipKLLIcuNGh3rp4QVsEDCThtV0l2AQ3jMtLsDN2zdC0fQ4JAK6yCOp003FIf3Wjz";
  String stripeKey = "pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy";
  StatisticsState statisticsState;
  String state = '';
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
     return actions.whereType<CreateOrderReservable>().asyncMap((event) async {
      OrderReservableState orderReservableState = event.orderReservableState;
      // add needed data to the order state

      orderReservableState.user = UserSnippet();
      orderReservableState.user.id = store.state.user.uid;
      orderReservableState.user.name = store.state.user.name;
      orderReservableState.businessId = store.state.business.id_firestore;
      orderReservableState.userId = store.state.user.uid;
      // send document to orders collection
      var addedOrderReservable = await FirebaseFirestore.instance.collection("order/").add(orderReservableState.toJson());
      final http.Response response = await http.post('https://europe-west1-buytime-458a1.cloudfunctions.net/StripePIOnOrder?orderId=' + addedOrderReservable.id);
      print("ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableCreateService => OrderReservable_service epic - response is done");
      print('ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableCreateService => RESPONSE: ${response.body}');
      int write = 0;
      if (response != null && response.body == "Error: could not handle the request\n") {
        // verify why this happens.
        var updatedOrderReservable = await FirebaseFirestore.instance /// 1 WRITE
            .collection("order/").doc(addedOrderReservable.id.toString()).update({
          'progress': "paid"
        });
        state = 'paid';
        //return SetOrderReservableProgress("paid");
      } else {
        var jsonResponse;
        try{
          jsonResponse = jsonDecode(response.body);
        }catch(e){
          debugPrint('order_reservable_service_epic => ERROR: $e');
          state = 'failed';
        }
        /*var jsonResponse;
        if(response.body == 'error'){
          state = 'failed';
        }else{
          var jsonResponse = jsonDecode(response.body);
        }*/
        //jsonResponse = jsonDecode(response.body);
        if(jsonResponse!= null && response.body != "error") {
          print('ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableCreateService => JSON RESPONSE: $jsonResponse');
          // if an action is required, send the user to the confirmation link
          if (jsonResponse != null && jsonResponse["next_action_url"] != null ) {
            final Stripe stripe = Stripe(
              stripeTestKey, // our publishable key
              stripeAccount: jsonResponse["stripeAccount"], // the connected account
              returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
            );
            var clientSecret = jsonResponse["client_secret"];
            var paymentIntentRes = await confirmPayment3DSecure(clientSecret, jsonResponse["payment_method_id"], stripe);
            if (paymentIntentRes["status"] == "succeeded") {
              ++write;
              var updatedOrderReservable = await FirebaseFirestore.instance.collection("order/").doc(addedOrderReservable.id.toString()).update({ /// 1 WRITE
                'progress': "paid"
              });
              state = 'paid';
              //return SetOrderReservableProgress("paid");
            } else {
              state = 'failed';
              //return SetOrderReservableProgress("failed");
            }
          } else {
            ++write;
            var updatedOrderReservable = await FirebaseFirestore.instance.collection("order/").doc(addedOrderReservable.id.toString()).update({ /// 1 WRITE
              'progress': "paid"
            });
            state = 'paid';
            //return SetOrderReservableProgress("paid");
          }
        }
        else {
          state = 'failed';
          //return SetOrderReservableProgress("failed");
        }
      }

      statisticsState = store.state.statistics;
      int reads = statisticsState.orderCreateServiceRead;
      int writes = statisticsState.orderCreateServiceWrite;
      int documents = statisticsState.orderCreateServiceDocuments;
      debugPrint('ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      writes = writes + write;
      debugPrint('ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.orderCreateServiceRead = reads;
      statisticsState.orderCreateServiceWrite = writes;
      statisticsState.orderCreateServiceDocuments = documents;

     }).expand((element) => [
       SetOrderReservableProgress(state),
       UpdateStatistics(statisticsState),
     ]);
  }
}

class AddingReservableStripePaymentMethodRequest implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  http.Response response;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<AddingReservableStripePaymentMethodWithNavigation>().asyncMap((event) async {
      String userId = event.userId;
      var stripeCustomerSetupIntentCreationReference = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "_test/setupIntent").doc() ///TODO Remember _test
        .set({ ///1 WRITE
      'status': "create request"
    });
    // now http request to create the actual setupIntent
    response = await http.post('https://europe-west1-buytime-458a1.cloudfunctions.net/createSetupIntent?userId=' + userId);

      statisticsState = store.state.statistics;
      /*statisticsState = store.state.statistics;
      int reads = statisticsState.orderCreateServiceRead;
      int writes = statisticsState.orderCreateServiceWrite;
      int documents = statisticsState.orderCreateServiceDocuments;
      debugPrint('ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++writes;
      debugPrint('ORDER_RESERVABLE_SERVICE_EPIC - OrderReservableCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.orderCreateServiceRead = reads;
      statisticsState.orderCreateServiceWrite = writes;
      statisticsState.orderCreateServiceDocuments = documents;*/

      debugPrint('order_service_epic: RESPONSE: ${response.statusCode}');

    }).expand((element) => [
      //SetOrderReservableProgress(state),,
      if (response.statusCode == 200) AddedReservableStripePaymentMethodAndNavigate() else AddedReservableStripePaymentMethod(),
      UpdateStatistics(statisticsState),
      //response.statusCode == 200 ? NavigatePopAction() : AddedStripePaymentMethod(),

    ]);
  }
}

Future<Map<String, dynamic>> confirmPayment3DSecure(String clientSecret, String paymentMethodId, Stripe stripe) async{
  Map<String, dynamic> paymentIntentRes_3dSecure;
  try{
    await stripe.confirmPayment(clientSecret, paymentMethodId: paymentMethodId);
    paymentIntentRes_3dSecure = await stripe.api.retrievePaymentIntent(clientSecret);
  }catch(e){
    print("ERROR_ConfirmPayment3DSecure: $e");
  }
  return paymentIntentRes_3dSecure;
}

class OrderReservableDeleteService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteOrderReservable>().asyncMap((event) {
//      return FirebaseFirestore.instance.collection('business').doc(store.state.business.id_firestore).collection('service').doc(serviceId).delete();
    });
  }
}
