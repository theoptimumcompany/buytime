
class OrderEntry {
  int number;
  String name;
  String description;
  double price;
  String thumbnail;
  String id;
  String id_business;
  String id_owner;

  OrderEntry({
    this.number = 0,
    this.name,
    this.description,
    this.price,
    this.thumbnail,
    this.id,
    this.id_business,
    this.id_owner,
  });

  OrderEntry.fromJson(Map<String, dynamic> json)
      : number = json['number'],
        name = json['name'],
        description = json['description'],
        price = json['price'],
        thumbnail = json['thumbnail'],
        id = json['id'],
        id_business = json['id_business'],
  id_owner = json['id_owner'];

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
        'description': description,
        'price': price,
        'thumbnail': thumbnail,
        'id': id,
        'id_business': id_business,
        'id_owner': id_owner,
      };
}
