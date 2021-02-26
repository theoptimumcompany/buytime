import 'package:Buytime/UI/management/service/widget/W_service_step_availabile_time.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';

import '../file/optimum_file_to_upload.dart';

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
  List<OptimumFileToUpload> fileToUploadList;
  int timesSold;
  List<String> tag;
  bool switchSlots;
  bool switchAutoConfirm;
  List<ServiceSlot> serviceSlot;
  bool spinnerVisibility = false;

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
  });

  // String enumToString(ServiceVisibility serviceVisibility) {
  //   return serviceVisibility.toString().split('.').last;
  // }
  //
  // ServiceVisibility stringToEnum(String serviceVisibility) {
  //   switch (serviceVisibility) {
  //     case 'Active':
  //       return ServiceVisibility.Active;
  //       break;
  //     case 'Deactivated':
  //       return ServiceVisibility.Deactivated;
  //       break;
  //     case 'Invisible':
  //       return ServiceVisibility.Invisible;
  //       break;
  //   }
  // }

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
  }

  serviceStateFieldUpdate(
    String serviceId,
    String businessId,
    List<String> categoryId,
    List<String> categoryRootId,
    String image1,
    String image2,
    String image3,
    String name,
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
  ) {
    ServiceState(
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
    );
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
    );
  }

  List<dynamic> convertToJson(List<ServiceSlot> objectStateList) {
    List<dynamic> list = [];
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  ServiceState.fromJson(Map<String, dynamic> json)
      : serviceId = json['serviceId'],
        businessId = json['businessId'],
        categoryId = List<String>.from(json['categoryId']),
        categoryRootId = List<String>.from(json['categoryRootId']),
        name = json['name'],
        image1 = json.containsKey('image1') ? json['image1'] : '',
        image2 = json.containsKey('image2') ? json['image2'] : '',
        image3 = json.containsKey('image3') ? json['image3'] : '',
        description = json['description'],
        visibility = json.containsKey('visibility') ? json['visibility'] : 'Invisible',
        price = json.containsKey('price') ? json['price'] : 0.0,
        timesSold = json.containsKey('switchSlots') ? json['timesSold'] : 0,
        tag = json.containsKey('tag') && json['tag'] != null ? List<String>.from(json['tag']) : [],
        switchSlots = json.containsKey('switchSlots') ? json['switchSlots'] : false,
        switchAutoConfirm = json.containsKey('switchAutoConfirm') ? json['switchAutoConfirm'] : false,
        serviceSlot = json.containsKey('serviceSlot')
            ? List<ServiceSlot>.from(json["serviceSlot"].map((item) {
                return ServiceSlot.fromJson(item);
              }))
            : [];

  Map<String, dynamic> toJson() => {
        'serviceId': serviceId,
        'businessId': businessId,
        'categoryId': categoryId,
        'categoryRootId': categoryRootId,
        'name': name,
        'image1': image1,
        'image2': image2,
        'image3': image3,
        'description': description,
        'visibility': visibility,
        'price': price,
        'timesSold': timesSold,
        'tag': tag,
        'switchSlots': switchSlots,
        'switchAutoConfirm': switchAutoConfirm,
        'serviceSlot': convertToJson(serviceSlot),
      };
}
