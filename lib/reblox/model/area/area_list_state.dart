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

  getCurrentArea(String userCoordinate) {
    AreaState areaFound;
    if (userCoordinate != null && userCoordinate.isNotEmpty && userCoordinate != null && userCoordinate.isNotEmpty) {
      if (areaList != null) {
        for(int ij = 0; ij < areaList.length; ij++) {
          var distance = Utils.calculateDistanceBetweenPoints(areaList[ij].coordinates, userCoordinate);
          debugPrint('UI_M_edit_business: area distance ' + distance.toString());
          if (distance != null && distance < 100) {
            areaFound = areaList[ij];
          }
        }
      }
    }
    return areaFound;
  }

  factory AreaListState.fromJson(Map<String, dynamic> json) => _$AreaListStateFromJson(json);
  Map<String, dynamic> toJson() => _$AreaListStateToJson(this);

}
