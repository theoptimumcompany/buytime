class GenericState {
  String name;
  String surname;
  String id;

  GenericState({
    this.name = "",
    this.surname = "",
    this.id = "",
  });

  GenericState.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        surname = json['surname'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'surname': surname,
        'id': id,
      };
}
