import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';

class PaypalServices {

  //String domain = "api.sandbox.paypal.com"; // for sandbox mode
  String domain = "api-m.sandbox.paypal.com"; // for sandbox mode
  //  String domain = "https://api.paypal.com"; // for production mode

  // change clientId and secret with your own, provided by paypal
  String clientId = 'AQCFN-vKDWJTCp88ZT3OsBVgCfuvJ_GX3xENVwTHX2k5PJsVN4xR07TrJwEaqSEcUSBzDfBN0qQ7qIVd';
  String secret = 'EGZEMRnnql7u8NrwKmLJp97BmHFAyEL7CJe8KJeEBBEDGdOGa6arWXXHO8KasS6inkSwy2dCalPP7xBY';
  // String clientId = 'AQ0QCIi2gd_n8bDTEr-S14n8OkVoNLUXWPTftbWzvQxsC2ZvIzlY_rRA6DHivfpQz5F0fCmJnKNJKRWo';
  // String secret = 'EFsg0t2hbmCit8RDkncn43S0LUWsfhDl92cs8koItB7K_EM-VvgOUMhFVy0htbtOw83SBtygzDCn3xDF';

  // for getting the access token from Paypal
  Future<String> getAccessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      Uri url = Uri.https("$domain", "/v1/oauth2/token", {
        'grant_type': 'client_credentials'});
      //var response = await client.post('$domain/v1/oauth2/token?grant_type=grant_type');
      var response = await client.post(url);
      debugPrint('PAYPAL GET ACCESS TOKEN RESPONSE CODE: ${response.statusCode} | BODY: ${response.body}');
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> identifyUser(String accessToken) async {
    try {
      Uri url = Uri.https("$domain", "/v1/identity/oauth2/userinfo", {
        'schema': 'paypalv1.1'});
      //var response = await client.post('$domain/v1/oauth2/token?grant_type=grant_type');
      var response = await http.get(url,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer $accessToken"
          });
      debugPrint('PAYPAL IDENTIFY USER RESPONSE CODE: ${response.statusCode} | BODY: ${response.body}');
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        debugPrint('PAYER ID: ${body["payer_id"]}');
        debugPrint('NAME: ${body["name"]}');
        return body["payer_id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>> createPaypalPayment(transactions, accessToken) async {
    try {
      debugPrint('ACCESS TOKEN: $accessToken');
      //Uri url = Uri.https("$domain", "/v1/payments/payment");
      Uri url = Uri.https("$domain", "/v2/checkout/orders");
      //var response = await http.post("$domain/v1/payments/payment",
      var response = await http.post(url,
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer $accessToken'
          });

      final body = convert.jsonDecode(response.body);
      debugPrint('PAYPAL CREATE PAYMENT RESPONSE CODE: ${response.statusCode} | BODY: ${response.body}');
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          final item2 = links.firstWhere((o) => o["rel"] == "approve",
              orElse: () => null);
          if (item2 != null) {
            approvalUrl = item2["href"];
          }
          final item3 = links.firstWhere((o) => o["rel"] == "authorize",
              orElse: () => null);
          if (item3 != null) {
            executeUrl = item3["href"];
          }
          final item4 = links.firstWhere((o) => o["rel"] == "capture",
              orElse: () => null);
          if (item4 != null) {
            executeUrl = item4["href"];
          }
          debugPrint('APPROVAL URL: $approvalUrl');
          debugPrint('EXECUTE URL: $executeUrl');
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  ///PAYID-MFXN6LI4TH50762UD956613V
  // for executing the payment transaction
  Future<String> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(url,
          //body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      debugPrint('PAYPAL EXECUTE PAYMENT RESPONSE CODE: ${response.statusCode} | BODY: ${response.body}');
      if (response.statusCode == 201) {
        return body["id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}