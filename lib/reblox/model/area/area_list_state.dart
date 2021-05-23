import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'area_state.dart';
part 'area_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class AreaListState {
  List<AreaState> areaList;

  AreaListState({
    @required this.areaList,
  });

  AreaListState toEmpty() {
    return AreaListState(
      areaList: [],
    );
  }



  AreaListState.fromState(AreaListState state) {
    this.areaList = state.areaList;
  }

  AreaListState copyWith({
    List<AreaState> areaList,
  }) {
    return AreaListState(
      areaList: areaList ?? this.areaList,
    );
  }



  factory AreaListState.fromJson(Map<String, dynamic> json) => _$AreaListStateFromJson(json);
  Map<String, dynamic> toJson() => _$AreaListStateToJson(this);

}
