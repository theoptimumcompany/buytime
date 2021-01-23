class BusinessSnippet {
  String id;
  String name;
  String thumbnail;

  BusinessSnippet({
    this.id,
    this.name,
    this.thumbnail,
  });

  BusinessSnippet.fromState(BusinessSnippet businessSnippet) {
    this.id = businessSnippet.id;
    this.name = businessSnippet.name;
    this.thumbnail = businessSnippet.thumbnail;
  }

  BusinessSnippet copyWith({
    String id,
    String name,
    String thumbnail,
  }) {
    return BusinessSnippet(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  BusinessSnippet.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        thumbnail = json['thumbnail'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'thumbnail': thumbnail,
      };

  BusinessSnippet toEmpty() {
    return BusinessSnippet(
      id: '',
      name: '',
      thumbnail: '',
    );
  }
}
