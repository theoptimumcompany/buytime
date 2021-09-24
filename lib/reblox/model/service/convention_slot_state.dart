import 'package:json_annotation/json_annotation.dart';
part 'convention_slot_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ConventionSlot {
  @JsonKey(defaultValue: '')
  String hubName;
  @JsonKey(defaultValue: '')
  String hubId;
  @JsonKey(defaultValue: 0)
  int discount;

  ConventionSlot({this.hubName, this.hubId, this.discount});


  ConventionSlot copyWith({
    String hubName,
    String hubId,
    int discount,
  }) {
    return ConventionSlot(
      hubName: hubName ?? this.hubName,
      hubId: hubId ?? this.hubId,
      discount: discount ?? this.discount,
    );
  }

  ConventionSlot toEmpty() {
    return ConventionSlot(
      hubName: '',
      hubId: '',
      discount: 0,
    );
  }

  ConventionSlot.fromState(ConventionSlot conventionSlot) {
    this.hubName = conventionSlot.hubName;
    this.hubId = conventionSlot.hubId;
    this.discount = conventionSlot.discount;
  }


  factory ConventionSlot.fromJson(Map<String, dynamic> json) => _$ConventionSlotFromJson(json);
  Map<String, dynamic> toJson() => _$ConventionSlotToJson(this);

}