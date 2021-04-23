import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'external_service_imported_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ExternalServiceImportedListState {
  List<ExternalServiceImportedState> externalServiceImported;

  ExternalServiceImportedListState({
    @required this.externalServiceImported,
  });

  ExternalServiceImportedListState.fromState(ExternalServiceImportedListState state) {
    this.externalServiceImported = state.externalServiceImported ;
  }

  companyStateFieldUpdate(List<ExternalServiceImportedState> externalServiceImported) {
    ExternalServiceImportedListState(
        externalServiceImported: externalServiceImported ?? this.externalServiceImported
    );
  }

  ExternalServiceImportedListState copyWith({externalBusinessImported}) {
    return ExternalServiceImportedListState(
        externalServiceImported: externalServiceImported ?? this.externalServiceImported
    );
  }

  ExternalServiceImportedListState toEmpty() {
    return ExternalServiceImportedListState(externalServiceImported: []);
  }

  factory ExternalServiceImportedListState.fromJson(Map<String, dynamic> json) => _$ExternalServiceImportedListStateFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalServiceImportedListStateToJson(this);
}