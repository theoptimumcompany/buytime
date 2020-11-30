class ObjectState {
  String name;
  String id;
  int level;
  String business_thumbnail;
  String user_uid;

  ObjectState({
    this.name = "",
    this.id = "",
    this.level = 0,
    this.business_thumbnail = "",
    this.user_uid,
  });

  ObjectState.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        business_thumbnail = json['business_thumbnail'],
        level = json['level'],
        user_uid = json['user_uid'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'level': level,
        'business_thumbnail': business_thumbnail,
        'user_uid': user_uid,
      };
}
