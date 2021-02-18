import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StatisticsState{
  int numberOfCalls, numberOfDocuments;

  StatisticsState({
    this.numberOfCalls,
    this.numberOfDocuments
  });

  StatisticsState toEmpty() {
    return StatisticsState(
      numberOfCalls: 0,
      numberOfDocuments: 0
    );
  }

  StatisticsState.fromState(StatisticsState state) {
    this.numberOfCalls = state.numberOfCalls;
    this.numberOfDocuments = state.numberOfDocuments;
  }

  StatisticsState copyWith({
    int numberOfCalls,
    int numberOfdocuments,
  }) {
    return StatisticsState(
      numberOfCalls: numberOfCalls ?? this.numberOfCalls,
      numberOfDocuments: numberOfDocuments ?? this.numberOfDocuments,
    );
  }

  final storage = new FlutterSecureStorage();

  writeToStorage(StatisticsState state) async{
    await storage.write(key: 'numberOfCalls', value: state.numberOfCalls.toString());
    await storage.write(key: 'numberOfDocuments', value: state.numberOfDocuments.toString());
  }

  Future<StatisticsState> readFromStorage() async{
    StatisticsState state = StatisticsState().toEmpty();
    state.numberOfCalls = int.parse(await storage.read(key: 'numberOfCalls') ?? '0');
    state.numberOfDocuments = int.parse(await storage.read(key: 'numberOfDocuments') ?? '0');
    return state;
  }

}