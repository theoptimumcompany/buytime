import 'package:Buytime/reblox/model/email/template_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:json_annotation/json_annotation.dart';
part 'email_state.g.dart';


@JsonSerializable(explicitToJson: true)
class EmailState {
  String to;
  String cc;
  TemplateState template;
  bool sent;

  EmailState({
    this.to,
    this.cc,
    this.template,
    this.sent,
  });

  EmailState toEmpty() {
    return EmailState(
        to: '',
        cc: '',
        template: TemplateState().toEmpty(),
        sent: null,
    );
  }

  EmailState.fromState(EmailState state) {
    this.to = state.to;
    this.cc = state.cc;
    this.template = state.template;
    this.sent = state.sent;
  }

  EmailState copyWith({
    String to,
    String cc,
    TemplateState template,
    bool sent,
  }) {
    return EmailState(
      to: to ?? this.to,
      cc: cc ?? this.cc,
      template: template ?? this.template,
      sent: sent ?? this.sent,
    );
  }

  factory EmailState.fromJson(Map<String, dynamic> json) => _$EmailStateFromJson(json);
  Map<String, dynamic> toJson() => _$EmailStateToJson(this);

}
