class ObjectState {
  String name;
  String surname;
  String id;
  int level;
  String business_thumbnail;
  String user_uid;

  ObjectState({
    this.name = "",
    this.surname = "",
    this.id = "",
    this.level = 0,
    this.business_thumbnail = "",
    this.user_uid,
  });

  ObjectState.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        surname = json['surname'],
        id = json['id'],
        business_thumbnail = json['business_thumbnail'],
        level = json['level'],
        user_uid = json['user_uid'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'surname': surname,
        'id': id,
        'level': level,
        'business_thumbnail': business_thumbnail,
        'user_uid': user_uid,
      };
}
