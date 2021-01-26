import 'dart:convert';

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:Buytime/services/file_upload_service.dart' if (dart.library.html) 'package:Buytime/services/file_upload_service_web.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderListRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
     print("OrderListService catched action");
     return actions.whereType<OrderListRequest>().asyncMap((event) async {
        String userId = store.state.user.uid;
        var ordersFirebase = await FirebaseFirestore.instance.collection("order")
            .where("progress", isEqualTo: "paid")
            .where("userId", isEqualTo: userId)
            .get();
        print("OrderListService Firestore request");
        List<OrderState> orderStateList = List<OrderState>();
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
        print("OrderListService return list with " + orderStateList.length.toString());
        return new OrderListReturned(orderStateList);
     });
  }
}

class OrderRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<OrderRequest>().asyncMap((event) {
     print("OrderRequest requests document id:" + event.orderStateId);
     return FirebaseFirestore.instance.collection("order").doc(event.orderStateId).get().then((snapshot) {
       OrderState orderState = OrderState.fromJson(snapshot.data());
       return new OrderRequestResponse(orderState);
     });
    });
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
      print("order_service epic - response is done");
      print(response);
      if (response != null && response.body == "Error: could not handle the request\n") {
        // verify why this happens.
        var updatedOrder = await FirebaseFirestore.instance.collection("order/").doc(addedOrder.id.toString()).update({
          'progress': "paid"
        });

        return SetOrderProgress("paid");
      } else {
        var jsonResponse = jsonDecode(response.body);
        if(jsonResponse!= null && response.body != "error") {
          print(jsonResponse);
          // if an action is required, send the user to the confirmation link
          if (jsonResponse != null && jsonResponse["next_action_url"] != null ) {
            final Stripe stripe = Stripe(
              stripeKey, // our publishable key
              stripeAccount: jsonResponse["stripeAccount"], // the connected account
              returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
            );
            var clientSecret = jsonResponse["client_secret"];
            var paymentIntentRes = await confirmPayment3DSecure(clientSecret, jsonResponse["payment_method_id"], stripe);
            if (paymentIntentRes["status"] == "succeeded") {
              var updatedOrder = await FirebaseFirestore.instance.collection("order/").doc(addedOrder.id.toString()).update({
                'progress': "paid"
              });
              return SetOrderProgress("paid");
            } else {
              return SetOrderProgress("failed");
            }
          } else {
            var updatedOrder = await FirebaseFirestore.instance.collection("order/").doc(addedOrder.id.toString()).update({
              'progress': "paid"
            });
            return SetOrderProgress("paid");
          }
        }else {
          return SetOrderProgress("failed");
        }
      }
     });
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
