import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:json_annotation/json_annotation.dart';
part 'id_state.g.dart';


@JsonSerializable(explicitToJson: true)
class IdState {
  String businessId;
  String serviceId;
  String orderId;
  String categoryId;

  IdState({
    this.businessId,
    this.orderId,
    this.serviceId,
    this.categoryId,
  });

  IdState toEmpty() {
    return IdState(
        businessId: '',
        orderId: '',
        serviceId: '',
        categoryId: '',
    );
  }

  IdState.fromState(IdState state) {
    this.businessId = state.businessId;
    this.orderId = state.orderId;
    this.serviceId = state.serviceId;
    this.categoryId = state.categoryId;
  }

  IdState copyWith({
    String businessId,
    String orderId,
    String serviceId,
    String categoryId,
  }) {
    return IdState(
      businessId: businessId ?? this.businessId,
      orderId: orderId ?? this.orderId,
      serviceId: serviceId ?? this.serviceId,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  factory IdState.fromJson(Map<String, dynamic> json) => _$IdStateFromJson(json);
  Map<String, dynamic> toJson() => _$IdStateToJson(this);

}
