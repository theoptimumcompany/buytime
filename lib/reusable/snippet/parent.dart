class Parent {
  String id;
  int level;
  String name;

  Parent({
    this.id = "",
    this.level = 0,
    this.name = "",
  });

  Parent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        level = json['level'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'level': level,
        'name': name,
      };
}
