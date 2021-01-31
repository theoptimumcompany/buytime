class CategoryInviteState {
  String id;
  String id_business;
  String id_category;
  String mail;
  String link;
  String role;
  DateTime timestamp;

  CategoryInviteState({
    this.id,
    this.id_business,
    this.id_category,
    this.mail,
    this.link,
    this.role,
    this.timestamp,
  });

  CategoryInviteState toEmpty() {
    return CategoryInviteState(
      id: "",
      id_business: "",
      id_category: "",
      mail: "",
      link: "",
      role: "",
      timestamp: DateTime.now(),
    );
  }

  CategoryInviteState.fromState(CategoryInviteState categoryInvite) {
    this.id = categoryInvite.id;
    this.id_business = categoryInvite.id_business;
    this.id_category = categoryInvite.id_category;
    this.mail = categoryInvite.mail;
    this.link = categoryInvite.link;
    this.role = categoryInvite.role;
    this.timestamp = categoryInvite.timestamp;
  }

  categoryStateFieldUpdate(
      String id, String id_business, String id_category, String mail, String link, String role, DateTime timestamp) {
    CategoryInviteState(
      id: id ?? this.id,
      id_business: id_business ?? this.id_business,
      id_category: id_category ?? this.id_category,
      mail: mail ?? this.mail,
      link: link ?? this.link,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  CategoryInviteState copyWith(
      {String id, String id_business, String id_category, String mail, String link, String role, DateTime timestamp}) {
    return CategoryInviteState(
      id: id ?? this.id,
      id_business: id_business ?? this.id_business,
      id_category: id_category ?? this.id_category,
      mail: mail ?? this.mail,
      link: link ?? this.link,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  CategoryInviteState.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        id_business = json['id_business'],
        id_category = json['id_category'],
        mail = json['mail'],
        link = json['link'],
        role = json['role'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_business': id_business,
        'id_category': id_category,
        'mail': mail,
        'link': link,
        'role': role,
        'timestamp': timestamp,
      };
}
