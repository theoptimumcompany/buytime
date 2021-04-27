import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'business_state.dart';
part 'external_business_imported_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ExternalBusinessImportedListState {
  List<ExternalBusinessImportedState> externalBusinessImported;

  ExternalBusinessImportedListState({
    @required this.externalBusinessImported,
  });

  ExternalBusinessImportedListState.fromState(ExternalBusinessImportedListState state) {
    this.externalBusinessImported = state.externalBusinessImported ;
  }

  companyStateFieldUpdate(List<ExternalBusinessImportedState> externalBusinessImported) {
    ExternalBusinessImportedListState(
        externalBusinessImported: externalBusinessImported ?? this.externalBusinessImported
    );
  }

  ExternalBusinessImportedListState copyWith({externalBusinessImported}) {
    return ExternalBusinessImportedListState(
        externalBusinessImported: externalBusinessImported ?? this.externalBusinessImported
    );
  }

  ExternalBusinessImportedListState toEmpty() {
    return ExternalBusinessImportedListState(externalBusinessImported: []);
  }

  factory ExternalBusinessImportedListState.fromJson(Map<String, dynamic> json) => _$ExternalBusinessImportedListStateFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalBusinessImportedListStateToJson(this);
}