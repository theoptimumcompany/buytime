abstract class BaseConfig {
  String stripePublicKey;
  String googleMapApiKey;
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
  String get cloudFunctionLink => '';

  String get dynamicLink => '';

  String get fireStorageServiceApiKey => '';

  String get fireStorageServiceAppId => '';

  String get fireStorageServiceAuthDomain => '';

  String get fireStorageServiceDatabaseURL => '';

  String get fireStorageServiceMeasurementId => '';

  String get fireStorageServiceMessagingSenderId => '';

  String get fireStorageServiceProjectId => '';

  String get fireStorageServiceStorageBucket => '';

  String get googleMapApiKey => '';

  String get serverToken => '';

  String get stripePublicKey => 'DEV STRIPE';

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
  set googleMapApiKey(String _googleMapApiKey) {
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
}


class ProdConfig implements BaseConfig {
  String get cloudFunctionLink => '';

  String get dynamicLink => '';

  String get fireStorageServiceApiKey => '';

  String get fireStorageServiceAppId => '';

  String get fireStorageServiceAuthDomain => '';

  String get fireStorageServiceDatabaseURL => '';

  String get fireStorageServiceMeasurementId => '';

  String get fireStorageServiceMessagingSenderId => '';

  String get fireStorageServiceProjectId => '';

  String get fireStorageServiceStorageBucket => '';

  String get googleMapApiKey => '';

  String get serverToken => '';

  String get stripePublicKey => 'PROD STRIPE';

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
  set googleMapApiKey(String _googleMapApiKey) {
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