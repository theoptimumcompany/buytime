import 'package:json_annotation/json_annotation.dart';

part 'service_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceSnippetState {

  @JsonKey(defaultValue: '')
  String serviceAbsolutePath;
  @JsonKey(defaultValue: '')
  String serviceName;
  @JsonKey(defaultValue: 0.0)
  double servicePrice;
  @JsonKey(defaultValue: 0)
  int serviceTimesSold;
  @JsonKey(defaultValue: '')
  String serviceImage;
  @JsonKey(defaultValue: '')
  String serviceVisibility;
  @JsonKey(defaultValue: [])
  List<String> connectedBusinessId;

  ServiceSnippetState({
    this.serviceAbsolutePath,
    this.serviceName,
    this.servicePrice,
    this.serviceTimesSold,
    this.serviceImage,
    this.serviceVisibility,
    this.connectedBusinessId,
  });

  ServiceSnippetState.fromState(ServiceSnippetState serviceSnippet) {
    this.serviceAbsolutePath = serviceSnippet.serviceAbsolutePath;
    this.serviceName = serviceSnippet.serviceName;
    this.servicePrice = serviceSnippet.servicePrice;
    this.serviceTimesSold = serviceSnippet.serviceTimesSold;
    this.serviceImage = serviceSnippet.serviceImage;
    this.serviceVisibility = serviceSnippet.serviceVisibility;
    this.connectedBusinessId = serviceSnippet.connectedBusinessId;
  }

  ServiceSnippetState copyWith({
    String serviceAbsolutePath,
    String serviceName,
    double servicePrice,
    int serviceTimesSold,
    String serviceImage,
    String serviceVisibility,
    List<String> connectedBusinessId,
  }) {
    return ServiceSnippetState(
      serviceAbsolutePath: serviceAbsolutePath ?? this.serviceAbsolutePath,
      serviceName: serviceName ?? this.serviceName,
      servicePrice: servicePrice ?? this.servicePrice,
      serviceTimesSold: serviceTimesSold ?? this.serviceTimesSold,
      serviceImage: serviceImage ?? this.serviceImage,
      serviceVisibility: serviceVisibility ?? this.serviceVisibility,
      connectedBusinessId: connectedBusinessId ?? this.connectedBusinessId,
    );
  }

  ServiceSnippetState toEmpty() {
    return ServiceSnippetState(
      serviceAbsolutePath: '',
      serviceName: '',
      servicePrice: 0.0,
      serviceTimesSold: 0,
      serviceImage: '',
      serviceVisibility: '',
      connectedBusinessId: [],
    );
  }

  factory ServiceSnippetState.fromJson(Map<String, dynamic> json) => _$ServiceSnippetStateFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceSnippetStateToJson(this);
}
