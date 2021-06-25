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
  String get dynamicLink => '';
  String get fireStorageServiceApiKey => '';
  String get fireStorageServiceAppId => '';
  String get fireStorageServiceAuthDomain => '';
  String get fireStorageServiceDatabaseURL => '';
  String get fireStorageServiceMeasurementId => '';
  String get fireStorageServiceMessagingSenderId => '';
  String get fireStorageServiceProjectId => '';
  String get fireStorageServiceStorageBucket => '';
  String get googleApiKey => 'AIzaSyBwDB1i6FveSGC0rFar4ZYcJM3xacQqZ1g';
  String get serverToken => 'AAAAEednpAc:APA91bEoNyQrUKghz6Mlrg7kA6kMaXM2DqDCkFmGnDJSiNXD6T3jgtfbDbl1Dm4QeJ6uzfg0H888YAqa2tIOLM4VhLp3CmuzOXaxe3v3sIWABGmyxi_nm73g1vfDHoFv9PQj2YhG1A9o';
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
  String get fireStorageServiceApiKey => '';
  String get fireStorageServiceAppId => '';
  String get fireStorageServiceAuthDomain => '';
  String get fireStorageServiceDatabaseURL => '';
  String get fireStorageServiceMeasurementId => '';
  String get fireStorageServiceMessagingSenderId => '';
  String get fireStorageServiceProjectId => '';
  String get fireStorageServiceStorageBucket => '';
  String get googleApiKey => 'AIzaSyBwDB1i6FveSGC0rFar4ZYcJM3xacQqZ1g';
  String get serverToken => 'AAAA6xUtyfE:APA91bGHhEzVUY9fnj4FbTXJX57qcgF-8GBrfBbGIa8kEpEIdsXRgQxbtsvbhL-w-_MQYKIj0XVlSaDSf2s6O3D3SM3o-z_AZnHQwBNLiw1ygyZOuVAKa5YmXeu6Da9eBqRD9uwFHSPi';
  String get stripePublicKey => 'pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy';
  String get stripeSuffix => '';

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