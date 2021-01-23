class Device {
  String id;
  String name;
  String user_uid;

  Device({
    this.id,
    this.name,
    this.user_uid,
  });

  Device.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        user_uid = json['user_uid'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'user_uid': user_uid,
      };
}
