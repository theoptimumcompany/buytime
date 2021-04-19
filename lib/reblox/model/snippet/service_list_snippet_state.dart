import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_list_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceListSnippet {
  @JsonKey(defaultValue: [])
  List<BusinessSnippet> givenConnectedBusinessIds;
  @JsonKey(defaultValue: [])
  List<BusinessSnippet> takenConnectedBusinessIds;
  String businessId;
  @JsonKey(defaultValue: 0)
  int businessServiceNumberInternal;
  @JsonKey(defaultValue: 0)
  int businessServiceNumberExternal;
  @JsonKey(defaultValue: [])
  List<CategorySnippet> businessSnippet;

  ServiceListSnippet({
    this.givenConnectedBusinessIds,
    this.takenConnectedBusinessIds,
    this.businessId,
    this.businessServiceNumberInternal,
    this.businessServiceNumberExternal,
    this.businessSnippet,
  });

  ServiceListSnippet.fromState(ServiceListSnippet serviceListSnippet) {
    this.givenConnectedBusinessIds = serviceListSnippet.givenConnectedBusinessIds;
    this.takenConnectedBusinessIds = serviceListSnippet.takenConnectedBusinessIds;
    this.businessId = serviceListSnippet.businessId;
    this.businessServiceNumberInternal = serviceListSnippet.businessServiceNumberInternal;
    this.businessServiceNumberExternal = serviceListSnippet.businessServiceNumberExternal;
    this.businessSnippet = serviceListSnippet.businessSnippet;
  }

  ServiceListSnippet copyWith({
    List<BusinessSnippet> givenConnectedBusinessIds,
    List<BusinessSnippet> takenConnectedBusinessIds,
    String businessId,
    int businessServiceNumberInternal,
    int businessServiceNumberExternal,
    List<CategorySnippet> businessSnippet,
  }) {
    return ServiceListSnippet(
      givenConnectedBusinessIds: givenConnectedBusinessIds ?? this.givenConnectedBusinessIds,
      takenConnectedBusinessIds: takenConnectedBusinessIds ?? this.takenConnectedBusinessIds,
      businessId: businessId ?? this.businessId,
      businessServiceNumberInternal: businessServiceNumberInternal ?? this.businessServiceNumberInternal,
      businessServiceNumberExternal: businessServiceNumberExternal ?? this.businessServiceNumberExternal,
      businessSnippet: businessSnippet ?? this.businessSnippet,
    );
  }

  factory ServiceListSnippet.fromJson(Map<String, dynamic> json) => _$ServiceListSnippetFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceListSnippetToJson(this);

  ServiceListSnippet toEmpty() {
    return ServiceListSnippet(
      givenConnectedBusinessIds: [],
      takenConnectedBusinessIds: [],
      businessId: '',
      businessServiceNumberInternal: 0,
      businessServiceNumberExternal: 0,
      businessSnippet: [],
    );
  }
}
