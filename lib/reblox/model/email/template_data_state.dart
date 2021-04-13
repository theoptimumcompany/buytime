import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:json_annotation/json_annotation.dart';
part 'template_data_state.g.dart';


@JsonSerializable(explicitToJson: true)
class TemplateDataState {
  String name;
  String link;

  TemplateDataState({
    this.name,
    this.link,
  });

  TemplateDataState toEmpty() {
    return TemplateDataState(
      name: '',
      link: '',
    );
  }

  TemplateDataState.fromState(TemplateDataState state) {
    this.name = state.name;
    this.link = state.link;
  }

  TemplateDataState copyWith({
    String name,
    String link,
  }) {
    return TemplateDataState(
      name: name ?? this.name,
      link: link ?? this.link,
    );
  }

  factory TemplateDataState.fromJson(Map<String, dynamic> json) => _$TemplateDataStateFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateDataStateToJson(this);

}
