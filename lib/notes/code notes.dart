/// some of the old payment flow
// final http.Response response = await http.get(url);
// print('ORDER_SERVICE_EPIC - OrderCreateService => RESPONSE: $response');
// if (response != null && response.body == "Error: could not handle the request\n") {
// // verify why this happens.
// state = 'paid';
// } else {
// var jsonResponse;
// try{
// jsonResponse = jsonDecode(response.body);
// }catch(e){
// debugPrint('order_service_epic => ERROR: $e');
// state = 'failed';
// }
// if(jsonResponse!= null && response.body != "error") {
// print('ORDER_SERVICE_EPIC - OrderCreateService => JSON RESPONSE: $jsonResponse');
// // if an action is required, send the user to the confirmation link
// if (jsonResponse != null && jsonResponse["next_action_url"] != null ) {
// // final Stripe stripe = Stripe(
// //   stripeTestKey, // our publishable key
// //   stripeAccount: jsonResponse["stripeAccount"], // the connected account
// //   returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
// // );
// var clientSecret = jsonResponse["client_secret"];
// // var paymentIntentRes = await confirmPayment3DSecure(clientSecret, jsonResponse["payment_method_id"], stripe);
// } else {
// var updatedOrder = await FirebaseFirestore.instance.collection("order/").doc(addedOrder.id.toString()).update({ /// 1 WRITE
// 'progress': "paid",
// 'orderId': addedOrder.id
// });
// state = 'paid';
// return SetOrderProgress("paid");
// }
// }
// else {
// state = 'failed';
// return SetOrderProgress("failed");
// }
// }
