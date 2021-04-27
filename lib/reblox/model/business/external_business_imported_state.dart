import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'external_business_imported_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ExternalBusinessImportedState {
  String externalBusinessId;
  String externalBusinessName;
  String internalBusinessId;
  String internalBusinessName;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime importTimestamp;
  @JsonKey(defaultValue: false)
  bool imported;

  ExternalBusinessImportedState({
    this.externalBusinessId,
    this.externalBusinessName,
    this.internalBusinessId,
    this.internalBusinessName,
    this.importTimestamp,
    this.imported,
  });

  ExternalBusinessImportedState toEmpty() {
    return ExternalBusinessImportedState(
      externalBusinessId: "",
      externalBusinessName: "",
      internalBusinessId: "",
      internalBusinessName: "",
      importTimestamp: new DateTime.now(),
      imported: false,
    );
  }



  ExternalBusinessImportedState.fromState(ExternalBusinessImportedState state) {
    this.externalBusinessId = state.externalBusinessId;
    this.externalBusinessName = state.externalBusinessName;
    this.internalBusinessId = state.internalBusinessId;
    this.internalBusinessName = state.internalBusinessName;
    this.importTimestamp = state.importTimestamp;
    this.imported = state.imported;
  }

  ExternalBusinessImportedState copyWith({
    String externalBusinessId,
    String externalBusinessName,
    String internalBusinessId,
    String internalBusinessName,
    DateTime importTimestamp,
    bool imported,
  }) {
    return ExternalBusinessImportedState(
      externalBusinessId: externalBusinessId ?? this.externalBusinessId,
      externalBusinessName: externalBusinessName ?? this.externalBusinessName,
      internalBusinessId: internalBusinessId ?? this.internalBusinessId,
      internalBusinessName: internalBusinessName ?? this.internalBusinessName,
      importTimestamp: importTimestamp ?? this.importTimestamp,
      imported: imported ?? this.imported,
    );
  }

  factory ExternalBusinessImportedState.fromJson(Map<String, dynamic> json) => _$ExternalBusinessImportedStateFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalBusinessImportedStateToJson(this);

}
