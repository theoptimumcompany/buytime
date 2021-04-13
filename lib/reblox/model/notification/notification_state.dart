import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:json_annotation/json_annotation.dart';
part 'notification_state.g.dart';


@JsonSerializable(explicitToJson: true)
class NotificationState {
  String businessId;
  String orderId;
  String serviceId;
  String serviceName;
  String serviceState;
  UserSnippet manager;
  UserSnippet user;
  DateTime notifyDate;

  NotificationState({
    this.businessId,
    this.orderId,
    this.serviceId,
    this.serviceName,
    this.serviceState,
    this.manager,
    this.user,
    this.notifyDate,
  });

  NotificationState toEmpty() {
    return NotificationState(
        businessId: '',
        orderId: '',
        serviceId: '',
        serviceName: '',
        serviceState: '',
        manager: UserSnippet().toEmpty(),
        user: UserSnippet().toEmpty(),
        notifyDate: DateTime.now().toUtc()
    );
  }

  NotificationState.fromState(NotificationState state) {
    this.businessId = state.businessId;
    this.orderId = state.orderId;
    this.serviceId = state.serviceId;
    this.serviceName = state.serviceName;
    this.serviceState = state.serviceState;
    this.manager = state.manager;
    this.user = state.user;
    this.notifyDate = state.notifyDate;
  }

  NotificationState copyWith({
    String businessId,
    String orderId,
    String serviceId,
    String serviceName,
    String serviceState,
    UserSnippet manager,
    UserSnippet user,
    DateTime notifyDate,
  }) {
    return NotificationState(
      businessId: businessId ?? this.businessId,
      orderId: orderId ?? this.orderId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceState: serviceState ?? this.serviceState,
      manager: manager ?? this.manager,
      user: user ?? this.user,
      notifyDate: notifyDate ?? this.notifyDate,
    );
  }

  factory NotificationState.fromJson(Map<String, dynamic> json) => _$NotificationStateFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationStateToJson(this);

}
