class UserSnippet {
  String id;
  String name;
  String surname;

  UserSnippet({
    this.id,
    this.name,
    this.surname,
  });

  UserSnippet.fromState(UserSnippet userSnippet) {
    this.id = userSnippet.id;
    this.name = userSnippet.name;
    this.surname = userSnippet.surname;
  }

  UserSnippet copyWith({
    String id,
    String name,
    String thumbnail,
  }) {
    return UserSnippet(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: thumbnail ?? this.surname,
    );
  }

  UserSnippet.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        surname = json['surname'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'surname': surname,
      };

  UserSnippet toEmpty() {
    return UserSnippet(
      id: '',
      name: '',
      surname: '',
    );
  }
}
