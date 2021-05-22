import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'area_state.g.dart';

@JsonSerializable(explicitToJson: true)
class AreaState {
  String areaId;
  @JsonKey(defaultValue: '')
  String address;
  @JsonKey(defaultValue: '')
  String coordinates;

  AreaState({
    @required this.areaId,
    @required this.address,
    @required this.coordinates,
  });

  AreaState toEmpty() {
    return AreaState(
      areaId: "",
      address: "",
      coordinates: "",
    );
  }



  AreaState.fromState(AreaState state) {
    this.areaId = state.areaId;
    this.address = state.address;
    this.coordinates = state.coordinates;
  }

  AreaState copyWith({
    String areaId,
    String address,
    String business_name,
  }) {
    return AreaState(
      areaId: areaId ?? this.areaId,
      address: address ?? this.address,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  factory AreaState.fromJson(Map<String, dynamic> json) => _$AreaStateFromJson(json);
  Map<String, dynamic> toJson() => _$AreaStateToJson(this);

}
