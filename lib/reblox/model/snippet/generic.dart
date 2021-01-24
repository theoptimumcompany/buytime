class GenericState {
  String content;
  String id;

  GenericState({
    this.content = "",
    this.id = "",
  });

  GenericState.fromJson(Map<String, dynamic> json)
      : content = json['name'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
        'name': content,
        'id': id,
      };
}
