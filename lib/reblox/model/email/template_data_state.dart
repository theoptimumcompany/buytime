import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:json_annotation/json_annotation.dart';
part 'template_data_state.g.dart';


@JsonSerializable(explicitToJson: true)
class TemplateDataState {
  String name;
  String link;
  String userEmail;
  String businessName;
  String businessId;
  String searched;

  TemplateDataState({
    this.name,
    this.link,
    this.userEmail,
    this.businessName,
    this.businessId,
    this.searched,
  });

  TemplateDataState toEmpty() {
    return TemplateDataState(
      name: '',
      link: '',
      userEmail: '',
      businessName: '',
      businessId: '',
      searched: '',
    );
  }

  TemplateDataState.fromState(TemplateDataState state) {
    this.name = state.name;
    this.link = state.link;
    this.userEmail = state.userEmail;
    this.businessName = state.businessName;
    this.businessId = state.businessId;
    this.searched = state.searched;
  }

  TemplateDataState copyWith({
    String name,
    String link,
    String userEmail,
    String businessName,
    String businessId,
    String searched,
  }) {
    return TemplateDataState(
      name: name ?? this.name,
      link: link ?? this.link,
      userEmail: userEmail ?? this.userEmail,
      businessName: businessName ?? this.businessName,
      businessId: businessId ?? this.businessId,
      searched: searched ?? this.searched,
    );
  }

  factory TemplateDataState.fromJson(Map<String, dynamic> json) => _$TemplateDataStateFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateDataStateToJson(this);

}
