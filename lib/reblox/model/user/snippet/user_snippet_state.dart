class UserSnippet {
  String id;
  String name;
  String surname;
  String email;

  UserSnippet({
    this.id,
    this.name,
    this.surname,
    this.email,
  });

  UserSnippet.fromState(UserSnippet userSnippet) {
    this.id = userSnippet.id;
    this.name = userSnippet.name;
    this.surname = userSnippet.surname;
    this.email = userSnippet.email;
  }

  UserSnippet copyWith({
    String id,
    String name,
    String surname,
    String email,
  }) {
    return UserSnippet(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
    );
  }

  UserSnippet.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        surname = json['surname'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'surname': surname,
        'email': email,
      };

  UserSnippet toEmpty() {
    return UserSnippet(
      id: '',
      name: '',
      surname: '',
      email: '',
    );
  }
}
