import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import '../file/optimum_file_to_upload.dart';
import 'package:json_annotation/json_annotation.dart';
part 'service_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceState {
  String serviceId;
  String businessId;
  List<String> categoryId;
  List<String> categoryRootId;
  String image1;
  String image2;
  String image3;
  String name;
  String description;
  String visibility;
  double price;
  int timesSold;
  List<String> tag;
  bool switchSlots;
  bool switchAutoConfirm;
  List<ServiceSlot> serviceSlot;
  @JsonKey(defaultValue: false)
  bool spinnerVisibility = false;
  @JsonKey(defaultValue: false)
  bool serviceCreated = false;
  @JsonKey(defaultValue: false)
  bool serviceEdited = false;

  ///Out Database
  @JsonKey(ignore: true)
  List<OptimumFileToUpload> fileToUploadList;



  ServiceState({
    this.serviceId,
    this.businessId,
    this.categoryId,
    this.categoryRootId,
    this.name,
    this.image1,
    this.image2,
    this.image3,
    this.description,
    this.visibility,
    this.price,
    this.fileToUploadList,
    this.timesSold,
    this.tag,
    this.switchSlots,
    this.switchAutoConfirm,
    this.serviceSlot,
    this.spinnerVisibility,
    this.serviceCreated,
    this.serviceEdited,
  });

  ServiceState toEmpty() {
    return ServiceState(
      serviceId: "",
      businessId: "",
      categoryId: [],
      categoryRootId: [],
      name: "",
      image1: "",
      image2: "",
      image3: "",
      description: "",
      visibility: 'Invisible',
      price: 0.00,
      fileToUploadList: [],
      timesSold: 0,
      tag: [],
      switchSlots: false,
      switchAutoConfirm: false,
      serviceSlot: [],
      spinnerVisibility: false,
      serviceCreated: false,
      serviceEdited: false,
    );
  }

  ServiceState.fromState(ServiceState service) {
    this.serviceId = service.serviceId;
    this.businessId = service.businessId;
    this.categoryId = service.categoryId;
    this.categoryRootId = service.categoryRootId;
    this.name = service.name;
    this.image1 = service.image1;
    this.image2 = service.image2;
    this.image3 = service.image3;
    this.description = service.description;
    this.visibility = service.visibility;
    this.price = service.price;
    this.fileToUploadList = service.fileToUploadList;
    this.timesSold = service.timesSold;
    this.tag = service.tag;
    this.switchSlots = service.switchSlots;
    this.switchAutoConfirm = service.switchAutoConfirm;
    this.serviceSlot = service.serviceSlot;
    this.spinnerVisibility = service.spinnerVisibility;
    this.serviceCreated = service.serviceCreated;
    this.serviceEdited = service.serviceEdited;
  }

  ServiceState copyWith({
    String serviceId,
    String businessId,
    List<String> categoryId,
    List<String> categoryRootId,
    String name,
    String image1,
    String image2,
    String image3,
    String description,
    String visibility,
    double price,
    List<OptimumFileToUpload> fileToUploadList,
    int timesSold,
    List<String> tag,
    bool switchSlots,
    bool switchAutoConfirm,
    List<ServiceSlot> serviceSlot,
    bool spinnerVisibility,
    bool serviceCreated,
    bool serviceEdited,
  }) {
    return ServiceState(
      serviceId: serviceId ?? this.serviceId,
      businessId: businessId ?? this.businessId,
      categoryId: categoryId ?? this.categoryId,
      categoryRootId: categoryRootId ?? this.categoryRootId,
      name: name ?? this.name,
      image1: image1 ?? this.image1,
      image2: image2 ?? this.image2,
      image3: image3 ?? this.image3,
      description: description ?? this.description,
      visibility: visibility ?? this.visibility,
      price: price ?? this.price,
      fileToUploadList: fileToUploadList ?? this.fileToUploadList,
      timesSold: timesSold ?? this.timesSold,
      tag: tag ?? this.tag,
      switchSlots: switchSlots ?? this.switchSlots,
      switchAutoConfirm: switchAutoConfirm ?? this.switchAutoConfirm,
      serviceSlot: serviceSlot ?? this.serviceSlot,
      spinnerVisibility: spinnerVisibility ?? this.spinnerVisibility,
      serviceCreated: serviceCreated ?? this.serviceCreated,
      serviceEdited: serviceEdited ?? this.serviceEdited,
    );
  }

  factory ServiceState.fromJson(Map<String, dynamic> json) => _$ServiceStateFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceStateToJson(this);
}
