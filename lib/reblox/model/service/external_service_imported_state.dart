import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'external_service_imported_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ExternalServiceImportedState {
  String externalBusinessId;
  String externalBusinessName;
  String externalCategoryName;
  String externalServiceId;
  String internalBusinessId;
  String internalBusinessName;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime importTimestamp;
  @JsonKey(defaultValue: false)
  bool imported;

  ExternalServiceImportedState({
    this.externalBusinessId,
    this.externalBusinessName,
    this.externalCategoryName,
    this.externalServiceId,
    this.internalBusinessId,
    this.internalBusinessName,
    this.importTimestamp,
    this.imported,
  });

  ExternalServiceImportedState toEmpty() {
    return ExternalServiceImportedState(
      externalBusinessId: "",
      externalBusinessName: "",
      externalCategoryName: "",
      externalServiceId: "",
      internalBusinessId: "",
      internalBusinessName: "",
      importTimestamp: new DateTime.now(),
      imported: false,
    );
  }



  ExternalServiceImportedState.fromState(ExternalServiceImportedState state) {
    this.externalBusinessId = state.externalBusinessId;
    this.externalBusinessName = state.externalBusinessName;
    this.externalCategoryName = state.externalCategoryName;
    this.externalServiceId = state.externalServiceId;
    this.internalBusinessId = state.internalBusinessId;
    this.internalBusinessName = state.internalBusinessName;
    this.importTimestamp = state.importTimestamp;
    this.imported = state.imported;
  }

  ExternalServiceImportedState copyWith({
    String externalBusinessId,
    String externalBusinessName,
    String externalCategoryName,
    String externalServiceId,
    String internalBusinessId,
    String internalBusinessName,
    DateTime importTimestamp,
    bool imported,
  }) {
    return ExternalServiceImportedState(
      externalBusinessId: externalBusinessId ?? this.externalBusinessId,
      externalBusinessName: externalBusinessName ?? this.externalBusinessName,
      externalCategoryName: externalCategoryName ?? this.externalCategoryName,
      externalServiceId: externalServiceId ?? this.externalServiceId,
      internalBusinessId: internalBusinessId ?? this.internalBusinessId,
      internalBusinessName: internalBusinessName ?? this.internalBusinessName,
      importTimestamp: importTimestamp ?? this.importTimestamp,
      imported: imported ?? this.imported,
    );
  }

  factory ExternalServiceImportedState.fromJson(Map<String, dynamic> json) => _$ExternalServiceImportedStateFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalServiceImportedStateToJson(this);

}