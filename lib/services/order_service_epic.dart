import 'dart:convert';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:Buytime/services/file_upload_service.dart' if (dart.library.html) 'package:Buytime/services/file_upload_service_web.dart';
import 'package:stripe_sdk/stripe_sdk.dart';

class OrderListRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  List<OrderState> orderStateList;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("ORDER_SERVICE_EPIC - OrderListRequestService =>  CATCHED ACTION");
     return actions.whereType<OrderListRequest>().asyncMap((event) async {
       debugPrint("ORDER_SERVICE_EPIC - OrderListRequestService =>  USER ID: ${store.state.user.uid}");
        String userId = store.state.user.uid;
        QuerySnapshot ordersFirebase = await FirebaseFirestore.instance.collection("order") /// 1 READ - ? DOC
            .where("progress", isEqualTo: "paid")
            .where("userId", isEqualTo: userId)
            .get();

        int ordersFirebaseDocs = ordersFirebase.docs.length;

        debugPrint("ORDER_SERVICE_EPIC - OrderListRequestService => OrderListService Firestore request");
        orderStateList = [];
        ordersFirebase.docs.forEach((element) {
          if(event.userId != "any"){
            OrderState orderState = OrderState.fromJson(element.data());
            if(orderState.progress == "paid" && orderState.user.id == store.state.user.uid){
              orderStateList.add(orderState);
            }
          }
          else{
            OrderState orderState = OrderState.fromJson(element.data());
            if(orderState.progress == "paid" && orderState.user.id == store.state.business.ownerId && orderState.businessId == store.state.business.id_firestore){
              orderStateList.add(orderState);
            }
          }
        });
        debugPrint("ORDER_SERVICE_EPIC - OrderListRequestService => OrderListService return list with " + orderStateList.length.toString());

        statisticsState = store.state.statistics;
        int reads = statisticsState.orderListRequestServiceRead;
        int writes = statisticsState.orderListRequestServiceWrite;
        int documents = statisticsState.orderListRequestServiceDocuments;
        debugPrint('ORDER_SERVICE_EPIC - OrderListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
        ++reads;
        documents = documents + ordersFirebaseDocs;
        debugPrint('ORDER_SERVICE_EPIC - OrderListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
        statisticsState.orderListRequestServiceRead = reads;
        statisticsState.orderListRequestServiceWrite = writes;
        statisticsState.orderListRequestServiceDocuments = documents;

        ///Return
        //return new OrderListReturned(orderStateList);
     }).expand((element) => [
       OrderListReturned(orderStateList),
       UpdateStatistics(statisticsState),
     ]);
  }
}

class OrderRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  OrderState orderState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<OrderRequest>().asyncMap((event) async{
      debugPrint("ORDER_SERVICE_EPIC - OrderRequestService => OrderRequest requests document id:" + event.orderStateId);
     DocumentSnapshot snapshot= await FirebaseFirestore.instance /// 1 READ - 1 DOC
         .collection("order").doc(event.orderStateId).get();

     orderState = OrderState.fromJson(snapshot.data());

     statisticsState = store.state.statistics;
     int reads = statisticsState.orderRequestServiceRead;
     int writes = statisticsState.orderRequestServiceWrite;
     int documents = statisticsState.orderRequestServiceDocuments;
     debugPrint('ORDER_SERVICE_EPIC - OrderRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
     ++reads;
     ++documents;
     debugPrint('ORDER_SERVICE_EPIC - OrderRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
     statisticsState.orderRequestServiceRead = reads;
     statisticsState.orderRequestServiceWrite = writes;
     statisticsState.orderRequestServiceDocuments = documents;

    }).expand((element) => [
      OrderRequestResponse(orderState),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class OrderUpdateService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateOrder>().asyncMap((event) {
    //   if (event.serviceState.fileToUploadList != null) {
    //     uploadFiles(event.serviceState.fileToUploadList, event.serviceState).then((ServiceState updatedServiceState) {
    //       return updateService(updatedServiceState);
    //     });
    //   }
    //   return updateService(event.serviceState);
     });
  }
}

class OrderCreateService implements EpicClass<AppState> {
  String stripeTestKey = "pk_test_51HS20eHr13hxRBpCZl1V0CKFQ7XzJbku7UipKLLIcuNGh3rp4QVsEDCThtV0l2AQ3jMtLsDN2zdC0fQ4JAK6yCOp003FIf3Wjz";
  String stripeKey = "pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy";
  StatisticsState statisticsState;
  String state = '';
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
     return actions.whereType<CreateOrder>().asyncMap((event) async {
      OrderState orderState = event.orderState;
      // add needed data to the order state

      orderState.user = UserSnippet();
      orderState.user.id = store.state.user.uid;
      orderState.user.name = store.state.user.name;
      orderState.businessId = store.state.business.id_firestore;
      orderState.userId = store.state.user.uid;
      // send document to orders collection
      var addedOrder = await FirebaseFirestore.instance.collection("order/").add(orderState.toJson());
      final http.Response response = await http.post('https://europe-west1-buytime-458a1.cloudfunctions.net/StripePIOnOrder?orderId=' + addedOrder.id);
      print("ORDER_SERVICE_EPIC - OrderCreateService => Order_service epic - response is done");
      print('ORDER_SERVICE_EPIC - OrderCreateService => RESPONSE: $response');
      int write = 0;
      if (response != null && response.body == "Error: could not handle the request\n") {
        // verify why this happens.
        var updatedOrder = await FirebaseFirestore.instance /// 1 WRITE
            .collection("order/").doc(addedOrder.id.toString()).update({
          'progress': "paid"
        });
        state = 'paid';
        //return SetOrderProgress("paid");
      } else {
        var jsonResponse = jsonDecode(response.body);
        if(jsonResponse!= null && response.body != "error") {
          print('ORDER_SERVICE_EPIC - OrderCreateService => JSON RESPONSE: $jsonResponse');
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
              var updatedOrder = await FirebaseFirestore.instance.collection("order/").doc(addedOrder.id.toString()).update({ /// 1 WRITE
                'progress': "paid"
              });
              state = 'paid';
              //return SetOrderProgress("paid");
            } else {
              state = 'failed';
              //return SetOrderProgress("failed");
            }
          } else {
            ++write;
            var updatedOrder = await FirebaseFirestore.instance.collection("order/").doc(addedOrder.id.toString()).update({ /// 1 WRITE
              'progress': "paid"
            });
            state = 'paid';
            //return SetOrderProgress("paid");
          }
        }else {
          state = 'failed';
          //return SetOrderProgress("failed");
        }
      }

      statisticsState = store.state.statistics;
      int reads = statisticsState.orderCreateServiceRead;
      int writes = statisticsState.orderCreateServiceWrite;
      int documents = statisticsState.orderCreateServiceDocuments;
      debugPrint('ORDER_SERVICE_EPIC - OrderCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      writes = writes + write;
      debugPrint('ORDER_SERVICE_EPIC - OrderCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.orderCreateServiceRead = reads;
      statisticsState.orderCreateServiceWrite = writes;
      statisticsState.orderCreateServiceDocuments = documents;

     }).expand((element) => [
       SetOrderProgress(state),
       UpdateStatistics(statisticsState),
     ]);
  }
}

class AddingStripePaymentMethodRequest implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  http.Response response;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<AddingStripePaymentMethodWithNavigation>().asyncMap((event) async {
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
      debugPrint('ORDER_SERVICE_EPIC - OrderCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++writes;
      debugPrint('ORDER_SERVICE_EPIC - OrderCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.orderCreateServiceRead = reads;
      statisticsState.orderCreateServiceWrite = writes;
      statisticsState.orderCreateServiceDocuments = documents;*/

      debugPrint('order_service_epic: RESPONSE: ${response.statusCode}');

    }).expand((element) => [
      //SetOrderProgress(state),,
      response.statusCode == 200 ? AddedStripePaymentMethodAndNavigate() : AddedStripePaymentMethod(),
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

class OrderDeleteService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteOrder>().asyncMap((event) {
//      return FirebaseFirestore.instance.collection('business').doc(store.state.business.id_firestore).collection('service').doc(serviceId).delete();
    });
  }
}
