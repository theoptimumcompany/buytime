class Worker {
  String id;
  String mail;
  String name;
  String surname;

  Worker({
    this.id,
    this.mail,
    this.name,
    this.surname,
  });

  Worker.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        mail = json['mail'],
        name = json['name'],
        surname = json['surname'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'mail': mail,
        'name': name,
        'surname': surname,
      };
}
