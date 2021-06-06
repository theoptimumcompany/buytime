import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'default_category_state.g.dart';

@JsonSerializable(explicitToJson: true)
class DefaultCategoryState {
  List<String> businessType;
  CategoryState category;

  DefaultCategoryState({
    this.businessType,
    this.category,
  });

  DefaultCategoryState toEmpty() {
    return DefaultCategoryState(
      businessType: [],
      category: CategoryState().toEmpty(),
    );
  }

  DefaultCategoryState.fromState(DefaultCategoryState category) {
    this.businessType = category.businessType;
    this.category = category.category;
  }

  DefaultCategoryState copyWith({
    List<String> businessType,
    CategoryState category,
  }) {
    return DefaultCategoryState(
      businessType: businessType ?? this.businessType,
      category: category ?? this.category,
    );
  }

  factory DefaultCategoryState.fromJson(Map<String, dynamic> json) => _$DefaultCategoryStateFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultCategoryStateToJson(this);
}
