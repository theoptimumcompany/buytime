import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:json_annotation/json_annotation.dart';
part 'category_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class CategorySnippet {
  int numberOfServices;
  ServiceState mostSoldService;
  int numberOfManagers;
  int numberOfWorkers;

  CategorySnippet({
    this.numberOfServices,
    this.mostSoldService,
    this.numberOfManagers,
    this.numberOfWorkers,
  });

  CategorySnippet.fromState(CategorySnippet categorySnippet) {
    this.numberOfServices = categorySnippet.numberOfServices;
    this.mostSoldService = categorySnippet.mostSoldService;
    this.numberOfManagers = categorySnippet.numberOfManagers;
    this.numberOfWorkers = categorySnippet.numberOfWorkers;
  }

  CategorySnippet copyWith({int numberOfServices, ServiceState mostSoldService, int numberOfManagers, int numberOfWorkers}) {
    return CategorySnippet(
      numberOfServices: numberOfServices ?? this.numberOfServices,
      mostSoldService: mostSoldService ?? this.mostSoldService,
      numberOfManagers: numberOfManagers ?? this.numberOfManagers,
      numberOfWorkers: numberOfWorkers ?? this.numberOfWorkers,
    );
  }

  factory CategorySnippet.fromJson(Map<String, dynamic> json) => _$CategorySnippetFromJson(json);
  Map<String, dynamic> toJson() => _$CategorySnippetToJson(this);

  CategorySnippet toEmpty() {
    return CategorySnippet(
      numberOfServices: 0,
      mostSoldService: ServiceState().toEmpty(),
      numberOfManagers: 0,
      numberOfWorkers: 0,
    );
  }
}
