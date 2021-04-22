import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_list_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceListSnippetState {
  @JsonKey(defaultValue: [])
  List<BusinessSnippetState> givenConnectedBusinessIds;
  @JsonKey(defaultValue: [])
  List<BusinessSnippetState> takenConnectedBusinessIds;
  String businessId;
  String businessName;
  String businessImage;
  @JsonKey(defaultValue: 0)
  int businessServiceNumberInternal;
  @JsonKey(defaultValue: 0)
  int businessServiceNumberExternal;
  @JsonKey(defaultValue: [])
  List<CategorySnippetState> businessSnippet;

  ServiceListSnippetState({
    this.givenConnectedBusinessIds,
    this.takenConnectedBusinessIds,
    this.businessId,
    this.businessName,
    this.businessImage,
    this.businessServiceNumberInternal,
    this.businessServiceNumberExternal,
    this.businessSnippet,
  });

  ServiceListSnippetState.fromState(ServiceListSnippetState serviceListSnippet) {
    this.givenConnectedBusinessIds = serviceListSnippet.givenConnectedBusinessIds;
    this.takenConnectedBusinessIds = serviceListSnippet.takenConnectedBusinessIds;
    this.businessId = serviceListSnippet.businessId;
    this.businessName = serviceListSnippet.businessName;
    this.businessImage = serviceListSnippet.businessImage;
    this.businessServiceNumberInternal = serviceListSnippet.businessServiceNumberInternal;
    this.businessServiceNumberExternal = serviceListSnippet.businessServiceNumberExternal;
    this.businessSnippet = serviceListSnippet.businessSnippet;
  }

  ServiceListSnippetState copyWith({
    List<BusinessSnippetState> givenConnectedBusinessIds,
    List<BusinessSnippetState> takenConnectedBusinessIds,
    String businessId,
    String businessName,
    String businessImage,
    int businessServiceNumberInternal,
    int businessServiceNumberExternal,
    List<CategorySnippetState> businessSnippet,
  }) {
    return ServiceListSnippetState(
      givenConnectedBusinessIds: givenConnectedBusinessIds ?? this.givenConnectedBusinessIds,
      takenConnectedBusinessIds: takenConnectedBusinessIds ?? this.takenConnectedBusinessIds,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      businessImage: businessImage ?? this.businessImage,
      businessServiceNumberInternal: businessServiceNumberInternal ?? this.businessServiceNumberInternal,
      businessServiceNumberExternal: businessServiceNumberExternal ?? this.businessServiceNumberExternal,
      businessSnippet: businessSnippet ?? this.businessSnippet,
    );
  }

  factory ServiceListSnippetState.fromJson(Map<String, dynamic> json) => _$ServiceListSnippetStateFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceListSnippetStateToJson(this);

  ServiceListSnippetState toEmpty() {
    return ServiceListSnippetState(
      givenConnectedBusinessIds: [],
      takenConnectedBusinessIds: [],
      businessId: '',
      businessName: '',
      businessImage: '',
      businessServiceNumberInternal: 0,
      businessServiceNumberExternal: 0,
      businessSnippet: [],
    );
  }
}
