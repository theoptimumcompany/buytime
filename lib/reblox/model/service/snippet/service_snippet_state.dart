import 'package:json_annotation/json_annotation.dart';

part 'service_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceSnippet {

  @JsonKey(defaultValue: '')
  String serviceAbsolutePath;
  @JsonKey(defaultValue: '')
  String serviceName;
  @JsonKey(defaultValue: 0.0)
  double servicePrice;
  @JsonKey(defaultValue: '')
  String serviceImage;
  @JsonKey(defaultValue: '')
  String serviceVisibility;
  @JsonKey(defaultValue: [])
  List<String> connectedBusinessId;

  ServiceSnippet({
    this.serviceAbsolutePath,
    this.serviceName,
    this.servicePrice,
    this.serviceImage,
    this.serviceVisibility,
    this.connectedBusinessId,
  });

  ServiceSnippet.fromState(ServiceSnippet serviceSnippet) {
    this.serviceAbsolutePath = serviceSnippet.serviceAbsolutePath;
    this.serviceName = serviceSnippet.serviceName;
    this.servicePrice = serviceSnippet.servicePrice;
    this.serviceImage = serviceSnippet.serviceImage;
    this.serviceVisibility = serviceSnippet.serviceVisibility;
    this.connectedBusinessId = serviceSnippet.connectedBusinessId;
  }

  ServiceSnippet copyWith({
    String serviceAbsolutePath,
    String serviceName,
    double servicePrice,
    String serviceImage,
    String serviceVisibility,
    List<String> connectedBusinessId,
  }) {
    return ServiceSnippet(
      serviceAbsolutePath: serviceAbsolutePath ?? this.serviceAbsolutePath,
      serviceName: serviceName ?? this.serviceName,
      servicePrice: servicePrice ?? this.servicePrice,
      serviceImage: serviceImage ?? this.serviceImage,
      serviceVisibility: serviceVisibility ?? this.serviceVisibility,
      connectedBusinessId: connectedBusinessId ?? this.connectedBusinessId,
    );
  }

  ServiceSnippet toEmpty() {
    return ServiceSnippet(
      serviceAbsolutePath: '',
      serviceName: '',
      servicePrice: 0.0,
      serviceImage: '',
      serviceVisibility: '',
      connectedBusinessId: [],
    );
  }

  factory ServiceSnippet.fromJson(Map<String, dynamic> json) => _$ServiceSnippetFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceSnippetToJson(this);
}
