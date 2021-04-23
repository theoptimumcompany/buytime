import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class CategorySnippetState {
  @JsonKey(defaultValue: "")
  String categoryAbsolutePath;
  @JsonKey(defaultValue: "")
  String categoryName;
  @JsonKey(defaultValue: '')
  String categoryImage;
  @JsonKey(defaultValue: 0)
  int serviceNumberInternal;
  @JsonKey(defaultValue: 0)
  int serviceNumberExternal;
  @JsonKey(defaultValue: [])
  List<String> tags;
  @JsonKey(defaultValue: [])
  List<ServiceSnippetState> serviceList;

  CategorySnippetState({
    this.categoryAbsolutePath,
    this.categoryName,
    this.categoryImage,
    this.serviceNumberInternal,
    this.serviceNumberExternal,
    this.tags,
    this.serviceList,
  });

  CategorySnippetState.fromState(CategorySnippetState categorySnippet) {
    this.categoryAbsolutePath = categorySnippet.categoryAbsolutePath;
    this.categoryName = categorySnippet.categoryName;
    this.categoryImage = categorySnippet.categoryImage;
    this.serviceNumberInternal = categorySnippet.serviceNumberInternal;
    this.serviceNumberExternal = categorySnippet.serviceNumberExternal;
    this.tags = categorySnippet.tags;
    this.serviceList = categorySnippet.serviceList;
  }

  CategorySnippetState copyWith({
    String categoryAbsolutePath,
    String categoryName,
    String categoryImage,
    int serviceNumberInternal,
    int serviceNumberExternal,
    List<String> tags,
    List<ServiceSnippetState> serviceList,
  }) {
    return CategorySnippetState(
      categoryAbsolutePath: categoryAbsolutePath ?? this.categoryAbsolutePath,
      categoryName: categoryName ?? this.categoryName,
      categoryImage: categoryImage ?? this.categoryImage,
      serviceNumberInternal: serviceNumberInternal ?? this.serviceNumberInternal,
      serviceNumberExternal: serviceNumberExternal ?? this.serviceNumberExternal,
      tags: tags ?? this.tags,
      serviceList: serviceList ?? this.serviceList,
    );
  }

  factory CategorySnippetState.fromJson(Map<String, dynamic> json) => _$CategorySnippetStateFromJson(json);

  Map<String, dynamic> toJson() => _$CategorySnippetStateToJson(this);

  CategorySnippetState toEmpty() {
    return CategorySnippetState(
      categoryAbsolutePath: '',
      categoryName: '',
      categoryImage: '',
      serviceNumberInternal: 0,
      serviceNumberExternal: 0,
      tags: [],
      serviceList: [],
    );
  }
}
