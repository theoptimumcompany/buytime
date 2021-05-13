import 'package:Buytime/UI/management/service_internal/class/service_slot_classes.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'interval_slot_state.g.dart';

@JsonSerializable(explicitToJson: true)
class SquareSlotState {
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime date;
  String startTime;
  String stopTime;
  double price;
  int availablePlaces;
  int maxAvailablePlace;
  int parallelDelivery;
  @JsonKey(defaultValue: true)
  bool visibility;

  SquareSlotState({
    this.date,
    this.startTime,
    this.stopTime,
    this.price,
    this.availablePlaces,
    this.maxAvailablePlace,
    this.parallelDelivery,
    this.visibility,
  });

  SquareSlotState copyWith({
    DateTime date,
    String startTime,
    String stopTime,
    double price,
    int availablePlaces,
    int maxAvailablePlace,
    int parallelDelivery,
    bool visibility,
  }) {
    return SquareSlotState(
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      stopTime: stopTime ?? this.stopTime,
      price: price ?? this.price,
      availablePlaces: availablePlaces ?? this.availablePlaces,
      maxAvailablePlace: maxAvailablePlace ?? this.maxAvailablePlace,
      parallelDelivery: parallelDelivery ?? this.parallelDelivery,
      visibility: visibility ?? this.visibility,
    );
  }

  SquareSlotState toEmpty() {
    return SquareSlotState(
      date: DateTime.now(),
      startTime: '',
      stopTime: '',
      price: 0.0,
      availablePlaces: 0,
      maxAvailablePlace: 0,
      parallelDelivery: 0,
      visibility: true,
    );
  }

  SquareSlotState.fromState(SquareSlotState serviceSlot) {
    this.date = serviceSlot.date;
    this.startTime = serviceSlot.startTime;
    this.stopTime = serviceSlot.stopTime;
    this.price = serviceSlot.price;
    this.availablePlaces = serviceSlot.availablePlaces;
    this.maxAvailablePlace = serviceSlot.maxAvailablePlace;
    this.parallelDelivery = serviceSlot.parallelDelivery;
    this.visibility = serviceSlot.visibility;
  }


  factory SquareSlotState.fromJson(Map<String, dynamic> json) => _$SquareSlotStateFromJson(json);
  Map<String, dynamic> toJson() => _$SquareSlotStateToJson(this);
}
