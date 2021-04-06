import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class CategorySnippet {
  @JsonKey(defaultValue: 0)
  int serviceNumberInternal;
  @JsonKey(defaultValue: 0)
  int serviceNumberExternal;
  @JsonKey(defaultValue: '')
  String image;
  @JsonKey(defaultValue: '')
  String name;
  @JsonKey(defaultValue: '')
  String absolutePath;
  @JsonKey(defaultValue: '')
  String internalPath;
  @JsonKey(defaultValue: '')
  String tag;
  @JsonKey(defaultValue: [])
  List<ServiceSnippet> serviceSnippetList;

  CategorySnippet({
    this.serviceNumberInternal,
    this.serviceNumberExternal,
    this.image,
    this.name,
    this.absolutePath,
    this.internalPath,
    this.tag,
    this.serviceSnippetList,
  });

  CategorySnippet.fromState(CategorySnippet categorySnippet) {
    this.serviceNumberInternal = categorySnippet.serviceNumberInternal;
    this.serviceNumberExternal = categorySnippet.serviceNumberExternal;
    this.image = categorySnippet.image;
    this.name = categorySnippet.name;
    this.absolutePath = categorySnippet.absolutePath;
    this.internalPath = categorySnippet.internalPath;
    this.tag = categorySnippet.tag;
    this.serviceSnippetList = categorySnippet.serviceSnippetList;
  }

  CategorySnippet copyWith({
    int serviceNumberInternal,
    int serviceNumberExternal,
    String image,
    String name,
    String absolutePath,
    String internalPath,
    String tag,
    List<ServiceSnippet> serviceSnippetList,
  }) {
    return CategorySnippet(
      serviceNumberInternal: serviceNumberInternal ?? this.serviceNumberInternal,
      serviceNumberExternal: serviceNumberExternal ?? this.serviceNumberExternal,
      image: image ?? this.image,
      name: name ?? this.name,
      absolutePath: absolutePath ?? this.absolutePath,
      internalPath: internalPath ?? this.internalPath,
      tag: tag ?? this.tag,
      serviceSnippetList: serviceSnippetList ?? this.serviceSnippetList,
    );
  }

  factory CategorySnippet.fromJson(Map<String, dynamic> json) => _$CategorySnippetFromJson(json);

  Map<String, dynamic> toJson() => _$CategorySnippetToJson(this);

  CategorySnippet toEmpty() {
    return CategorySnippet(
      serviceNumberInternal: 0,
      serviceNumberExternal: 0,
      image: '',
      name: '',
      absolutePath: '',
      internalPath: '',
      tag: '',
      serviceSnippetList: [],
    );
  }
}
