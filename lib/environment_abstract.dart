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


class StripeConfig {
  String keyToUse = 'pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy';
  // String keyToUse = 'pk_test_51HS20eHr13hxRBpCZl1V0CKFQ7XzJbku7UipKLLIcuNGh3rp4QVsEDCThtV0l2AQ3jMtLsDN2zdC0fQ4JAK6yCOp003FIf3Wjz';
  String suffixToUse = '';
  // String suffixToUse = '';
}

abstract class BaseConfig {
  String stripePublicKey;
  String stripeSuffix;
  String googleApiKey;
  String cloudFunctionLink;
  String dynamicLink;
  String serverToken;
  String fireStorageServiceApiKey;
  String fireStorageServiceAuthDomain;
  String fireStorageServiceDatabaseURL;
  String fireStorageServiceProjectId;
  String fireStorageServiceStorageBucket;
  String fireStorageServiceMessagingSenderId;
  String fireStorageServiceAppId;
  String fireStorageServiceMeasurementId;
}

class DevConfig implements BaseConfig {
  String get cloudFunctionLink => 'europe-west1-buytimedev-2e17a.cloudfunctions.net';
  String get dynamicLink => 'https://buytimedev.page.link';
  String get fireStorageServiceApiKey => 'AIzaSyA-4Vxvqrs1xSz3AxFk5QJzoL9VbRR7THY';
  String get fireStorageServiceAppId => '1:76896773127:android:2f0ac9868461fa761636a2';
  String get fireStorageServiceAuthDomain => 'buytimedev-2e17a.firebaseapp.com';
  String get fireStorageServiceDatabaseURL => 'https://buytimedev-2e17a.firebaseio.com';
  String get fireStorageServiceMeasurementId => ''; // optional
  String get fireStorageServiceMessagingSenderId => '76896773127';
  String get fireStorageServiceProjectId => 'buytimedev-2e17a';
  String get fireStorageServiceStorageBucket => 'buytimedev-2e17a.appspot.com';
  String get googleApiKey => 'AIzaSyBwDB1i6FveSGC0rFar4ZYcJM3xacQqZ1g';
  String get serverToken => '';
  String get stripePublicKey => 'pk_test_51HS20eHr13hxRBpCZl1V0CKFQ7XzJbku7UipKLLIcuNGh3rp4QVsEDCThtV0l2AQ3jMtLsDN2zdC0fQ4JAK6yCOp003FIf3Wjz';
  String get stripeSuffix => '_test';

  @override
  set cloudFunctionLink(String _cloudFunctionLink) {
    // TODO: implement cloudFunctionLink
  }
  @override
  set dynamicLink(String _dynamicLink) {
    // TODO: implement dynamicLink
  }
  @override
  set fireStorageServiceApiKey(String _fireStorageServiceApiKey) {
    // TODO: implement fireStorageServiceApiKey
  }
  @override
  set fireStorageServiceAppId(String _fireStorageServiceAppId) {
    // TODO: implement fireStorageServiceAppId
  }
  @override
  set fireStorageServiceAuthDomain(String _fireStorageServiceAuthDomain) {
    // TODO: implement fireStorageServiceAuthDomain
  }
  @override
  set fireStorageServiceDatabaseURL(String _fireStorageServiceDatabaseURL) {
    // TODO: implement fireStorageServiceDatabaseURL
  }
  @override
  set fireStorageServiceMeasurementId(String _fireStorageServiceMeasurementId) {
    // TODO: implement fireStorageServiceMeasurementId
  }
  @override
  set fireStorageServiceMessagingSenderId(String _fireStorageServiceMessagingSenderId) {
    // TODO: implement fireStorageServiceMessagingSenderId
  }
  @override
  set fireStorageServiceProjectId(String _fireStorageServiceProjectId) {
    // TODO: implement fireStorageServiceProjectId
  }
  @override
  set fireStorageServiceStorageBucket(String _fireStorageServiceStorageBucket) {
    // TODO: implement fireStorageServiceStorageBucket
  }
  @override
  set googleApiKey(String _googleMapApiKey) {
    // TODO: implement googleMapApiKey
  }
  @override
  set serverToken(String _serverToken) {
    // TODO: implement serverToken
  }
  @override
  set stripePublicKey(String _stripePublicKey) {
    // TODO: implement stripePublicKey
  }

  @override
  set stripeSuffix(String _stripeSuffix) {
    // TODO: implement stripeSuffix
  }
}


class ProdConfig implements BaseConfig {
  String get cloudFunctionLink => 'europe-west1-buytime-458a1.cloudfunctions.net';
  String get dynamicLink => 'https://buytime.page.link';
  String get fireStorageServiceApiKey => 'AIzaSyAqLCyfL4leWMXJoLKM1_He-p400XIuAmo';
  String get fireStorageServiceAppId => '1:1009672636913:web:8c0345f639441bc0cfdc50';
  String get fireStorageServiceAuthDomain => 'buytime-458a1.firebaseapp.com';
  String get fireStorageServiceDatabaseURL => 'https://buytime-458a1.firebaseio.com';
  String get fireStorageServiceMeasurementId => 'G-3L79M45JSN';
  String get fireStorageServiceMessagingSenderId => '1009672636913';
  String get fireStorageServiceProjectId => 'buytime-458a1';
  String get fireStorageServiceStorageBucket => 'buytime-458a1.appspot.com';
  String get googleApiKey => 'AIzaSyBwDB1i6FveSGC0rFar4ZYcJM3xacQqZ1g';
  String get serverToken => '';
  // String get stripePublicKey => 'pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy';
  String get stripePublicKey => 'pk_test_51HS20eHr13hxRBpCZl1V0CKFQ7XzJbku7UipKLLIcuNGh3rp4QVsEDCThtV0l2AQ3jMtLsDN2zdC0fQ4JAK6yCOp003FIf3Wjz';
  String get stripeSuffix => '_test';

  @override
  set cloudFunctionLink(String _cloudFunctionLink) {
    // TODO: implement cloudFunctionLink
  }
  @override
  set dynamicLink(String _dynamicLink) {
    // TODO: implement dynamicLink
  }
  @override
  set fireStorageServiceApiKey(String _fireStorageServiceApiKey) {
    // TODO: implement fireStorageServiceApiKey
  }
  @override
  set fireStorageServiceAppId(String _fireStorageServiceAppId) {
    // TODO: implement fireStorageServiceAppId
  }
  @override
  set fireStorageServiceAuthDomain(String _fireStorageServiceAuthDomain) {
    // TODO: implement fireStorageServiceAuthDomain
  }
  @override
  set fireStorageServiceDatabaseURL(String _fireStorageServiceDatabaseURL) {
    // TODO: implement fireStorageServiceDatabaseURL
  }
  @override
  set fireStorageServiceMeasurementId(String _fireStorageServiceMeasurementId) {
    // TODO: implement fireStorageServiceMeasurementId
  }
  @override
  set fireStorageServiceMessagingSenderId(String _fireStorageServiceMessagingSenderId) {
    // TODO: implement fireStorageServiceMessagingSenderId
  }
  @override
  set fireStorageServiceProjectId(String _fireStorageServiceProjectId) {
    // TODO: implement fireStorageServiceProjectId
  }
  @override
  set fireStorageServiceStorageBucket(String _fireStorageServiceStorageBucket) {
    // TODO: implement fireStorageServiceStorageBucket
  }
  @override
  set googleApiKey(String _googleMapApiKey) {
    // TODO: implement googleMapApiKey
  }
  @override
  set serverToken(String _serverToken) {
    // TODO: implement serverToken
  }
  @override
  set stripePublicKey(String _stripePublicKey) {
    // TODO: implement stripePublicKey
  }

  @override
  set stripeSuffix(String _stripeSuffix) {
    // TODO: implement stripeSuffix
  }


}

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String DEV = 'DEV';
  static const String PROD = 'PROD';

  BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.PROD:
        return ProdConfig();
      default:
        return DevConfig();
    }
  }
}