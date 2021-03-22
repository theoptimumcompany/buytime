
import 'package:json_annotation/json_annotation.dart';

part 'selected_entry.g.dart';

@JsonSerializable(explicitToJson: true)
class SelectedEntry {
  int first;
  int last;

  SelectedEntry({
    this.first = 0,
    this.last = 0
  });

  factory SelectedEntry.fromJson(Map<String, dynamic> json) => _$SelectedEntryFromJson(json);
  Map<String, dynamic> toJson() => _$SelectedEntryToJson(this);
}
