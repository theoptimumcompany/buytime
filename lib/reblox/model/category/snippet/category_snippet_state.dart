import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';

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

  CategorySnippet.fromJson(Map<String, dynamic> json)
      : numberOfServices = json['numberOfServices'],
        //mostSoldService = ServiceState.fromJson(json["mostSoldService"]),
        numberOfManagers = json['numberOfManagers'],
        numberOfWorkers = json['numberOfWorkers'];


  Map<String, dynamic> toJson() => {
        'numberOfServices': numberOfServices,
        //'mostSoldService': mostSoldService.toJson(),
        'numberOfManagers': numberOfManagers,
        'numberOfWorkers': numberOfWorkers,
      };

  CategorySnippet toEmpty() {
    return CategorySnippet(
      numberOfServices: 0,
      mostSoldService: ServiceState().toEmpty(),
      numberOfManagers: 0,
      numberOfWorkers: 0,
    );
  }
}
