import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';

class SatispayServices {

  ///WHAT WE NEED: https://developers.satispay.com/docs/web-redirect-pay
  ///DEPRECATED: https://s3-eu-west-1.amazonaws.com/docs.online.satispay.com/index.html#section/Web-Redirect/Sequence-diagram

  ///LINK: https://developers.satispay.com/reference/how-to
  /*import requests

  url = "https://authservices.satispay.com/g_business/v1/authentication_keys"

  headers = {
  "Accept": "application/json",
  "Content-Type": "application/json"
  }

  response = requests.request("POST", url, headers=headers)

  print(response.text)*/
  Future<Map<String, String>> obtainKeyId() async {
    try {
      Uri url = Uri.https("staging.authservices.satispay.com", "/g_business/v1/authentication_keys");
      //var response = await http.post("$domain/v1/payments/payment",
      var response = await http.post(url,
          body: {
            "public_key": "",
            "token": "",
          },
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });

      final body = convert.jsonDecode(response.body);

      debugPrint('SATISPAY OBTAIN KEY RESPONSE: $body');

    } catch (e) {
      rethrow;
    }
  }

  ///LINK: https://developers.satispay.com/reference/create-a-payment
  /*import requests

  url = "https://authservices.satispay.com/g_business/v1/payments"

  headers = {
  "Accept": "application/json",
  "Content-Type": "application/json"
  }

  response = requests.request("POST", url, headers=headers)

  print(response.text)*/
  Future<Map<String, String>> createSatispayPayment() async {
    try {
      Uri url = Uri.https("staging.authservices.satispay.com", "/g_business/v1/payments");
      //var response = await http.post("$domain/v1/payments/payment",
      var response = await http.post(url,
          body: {
            "flow": "",
            "amount_unit": "",
            "currency": ""
          },
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Host": "",
            "Date": "",
            "Digest": "SHA-256=",
            "Authorization": "",
            "Idempotency-Key": ""
          });

      final body = convert.jsonDecode(response.body);

      debugPrint('SATISPAY CREATE PAYMENT RESPONSE: $body');

    } catch (e) {
      rethrow;
    }
  }

  ///LINK: https://developers.satispay.com/reference/get-the-details-of-a-payment
  /*import requests

  url = "https://authservices.satispay.com/g_business/v1/payments/id"

  headers = {
  "Accept": "application/json",
  "x-satispay-response-wait-time": "0"
  }

  response = requests.request("GET", url, headers=headers)

  print(response.text)*/
  Future<Map<String, String>> getSatispayPayment() async {
    try {
      Uri url = Uri.https("staging.authservices.satispay.com", "/g_business/v1/payments/id");
      //var response = await http.post("$domain/v1/payments/payment",
      var response = await http.get(url,
          headers: {
            "Accept": "application/json",
            "Host": "",
            "Date": "",
            "Digest": "",
            "Authorization": "",
          });

      final body = convert.jsonDecode(response.body);

      debugPrint('SATISPAY GET PAYMENT RESPONSE: $body');

    } catch (e) {
      rethrow;
    }
  }

}