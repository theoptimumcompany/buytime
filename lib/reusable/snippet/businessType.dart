class BusinessType {
  String id;
  String name;

  BusinessType({
    this.id,
    this.name,
  });

  BusinessType.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
