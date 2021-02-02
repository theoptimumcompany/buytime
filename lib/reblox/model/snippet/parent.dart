class Parent {
  String id;
  int level;
  String name;
  String parentRootId;

  Parent({
    this.id = "",
    this.level = 0,
    this.name = "",
    this.parentRootId = "",
  });

  Parent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        level = json['level'],
        name = json['name'],
        parentRootId = json['parentRootId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'level': level,
        'name': name,
        'parentRootId': parentRootId,
      };
}
