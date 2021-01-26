import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';

class CategorySnippet {
  String id;
  String name;
  int numberOfServices;
  ServiceSnippet mostSoldService;
  int numberOfSubCategories;
  int numberOfLevels;
  int numberOfManagers;
  int numberOfWorkers;

  CategorySnippet({
    this.id,
    this.name,
    this.numberOfServices,
    this.mostSoldService,
    this.numberOfSubCategories,
    this.numberOfLevels,
    this.numberOfManagers,
    this.numberOfWorkers,
  });

  CategorySnippet.fromState(CategorySnippet categorySnippet) {
    this.id = categorySnippet.id;
    this.name = categorySnippet.name;
    this.numberOfServices = categorySnippet.numberOfServices;
    this.mostSoldService = categorySnippet.mostSoldService;
    this.numberOfSubCategories = categorySnippet.numberOfSubCategories;
    this.numberOfLevels = categorySnippet.numberOfLevels;
    this.numberOfManagers = categorySnippet.numberOfManagers;
    this.numberOfWorkers = categorySnippet.numberOfWorkers;
  }

  CategorySnippet copyWith(
      {String id,
      String name,
      int numberOfServices,
      ServiceSnippet mostSoldService,
      int numberOfSubCategories,
      int numberOfLevels,
      int numberOfManagers,
      int numberOfWorkers}) {
    return CategorySnippet(
      id: id ?? this.id,
      name: name ?? this.name,
      numberOfServices: numberOfServices ?? this.numberOfServices,
      mostSoldService: mostSoldService ?? this.mostSoldService,
      numberOfSubCategories: numberOfSubCategories ?? this.numberOfSubCategories,
      numberOfLevels: numberOfLevels ?? this.numberOfLevels,
      numberOfManagers: numberOfManagers ?? this.numberOfManagers,
      numberOfWorkers: numberOfWorkers ?? this.numberOfWorkers,
    );
  }

  CategorySnippet.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        numberOfServices = json['numberOfServices'],
        mostSoldService = ServiceSnippet.fromJson(json["mostSoldService"]),
        numberOfSubCategories = json['numberOfSubCategories'],
        numberOfLevels = json['numberOfLevels'],
        numberOfManagers = json['numberOfManagers'],
        numberOfWorkers = json['numberOfWorkers'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'numberOfServices': numberOfServices,
        'mostSoldService': mostSoldService.toJson(),
        'numberOfSubCategories': numberOfSubCategories,
        'numberOfLevels': numberOfLevels,
        'numberOfManagers': numberOfManagers,
        'numberOfWorkers': numberOfWorkers,
      };

  CategorySnippet toEmpty() {
    return CategorySnippet(
      id: "",
      name: "",
      numberOfServices: 0,
      mostSoldService: ServiceSnippet().toEmpty(),
      numberOfSubCategories: 0,
      numberOfLevels: 0,
      numberOfManagers: 0,
      numberOfWorkers: 0,
    );
  }
}
