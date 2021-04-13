import 'package:Buytime/reblox/model/email/template_data_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:json_annotation/json_annotation.dart';
part 'template_state.g.dart';


@JsonSerializable(explicitToJson: true)
class TemplateState {
  String name;
  TemplateDataState data;

  TemplateState({
    this.name,
    this.data,
  });

  TemplateState toEmpty() {
    return TemplateState(
      name: '',
      data: TemplateDataState().toEmpty(),
    );
  }

  TemplateState.fromState(TemplateState state) {
    this.name = state.name;
    this.data = state.data;
  }

  TemplateState copyWith({
    String name,
    TemplateDataState data,
  }) {
    return TemplateState(
      name: name ?? this.name,
      data: data ?? this.data,
    );
  }

  factory TemplateState.fromJson(Map<String, dynamic> json) => _$TemplateStateFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateStateToJson(this);

}
