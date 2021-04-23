import 'package:json_annotation/json_annotation.dart';
part 'order_business_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderBusinessSnippetState {
  String id;
  String name;
  String thumbnail;
  int serviceTakenNumber;

  OrderBusinessSnippetState({
    this.id,
    this.name,
    this.thumbnail,
    this.serviceTakenNumber,
  });

  OrderBusinessSnippetState.fromState(OrderBusinessSnippetState businessSnippet) {
    this.id = businessSnippet.id;
    this.name = businessSnippet.name;
    this.thumbnail = businessSnippet.thumbnail;
    this.serviceTakenNumber = businessSnippet.serviceTakenNumber;
  }

  OrderBusinessSnippetState copyWith({
    String id,
    String name,
    String thumbnail,
    int serviceTakenNumber,
  }) {
    return OrderBusinessSnippetState(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      serviceTakenNumber: serviceTakenNumber ?? this.serviceTakenNumber,
    );
  }

  OrderBusinessSnippetState toEmpty() {
    return OrderBusinessSnippetState(
      id: '',
      name: '',
      thumbnail: '',
      serviceTakenNumber: 0,
    );
  }

  factory OrderBusinessSnippetState.fromJson(Map<String, dynamic> json) => _$OrderBusinessSnippetStateFromJson(json);
  Map<String, dynamic> toJson() => _$OrderBusinessSnippetStateToJson(this);
}
