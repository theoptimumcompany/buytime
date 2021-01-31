class CategoryInviteState {
  String id;
  String id_business;
  String id_category;
  String mail;
  DateTime timestamp;

  CategoryInviteState({
    this.id,
    this.id_business,
    this.id_category,
    this.mail,
    this.timestamp,
  });

  CategoryInviteState toEmpty() {
    return CategoryInviteState(
      id: "",
      id_business: "",
      id_category: "",
      mail: "",
      timestamp: DateTime.now(),
    );
  }

  CategoryInviteState.fromState(CategoryInviteState categoryInvite) {
    this.id = categoryInvite.id;
    this.id_business = categoryInvite.id_business;
    this.id_category = categoryInvite.id_category;
    this.mail = categoryInvite.mail;
    this.timestamp = categoryInvite.timestamp;
  }

  categoryStateFieldUpdate(String id, String id_business, String id_category, String mail, DateTime timestamp) {
    CategoryInviteState(
      id: id ?? this.id,
      id_business: id_business ?? this.id_business,
      id_category: id_category ?? this.id_category,
      mail: mail ?? this.mail,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  CategoryInviteState copyWith({String id, String id_business, String id_category, String mail, DateTime timestamp}) {
    return CategoryInviteState(
      id: id ?? this.id,
      id_business: id_business ?? this.id_business,
      id_category: id_category ?? this.id_category,
      mail: mail ?? this.mail,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  CategoryInviteState.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        id_business = json['id_business'],
        id_category = json['id_category'],
        mail = json['mail'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_business': id_business,
        'id_category': id_category,
        'mail': mail,
        'timestamp': timestamp,
      };
}
