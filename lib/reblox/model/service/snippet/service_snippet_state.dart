// class ServiceSnippet {
//   String id;
//   String name;
//   int timesSold;
//
//   ServiceSnippet({
//     this.id,
//     this.name,
//     this.timesSold,
//   });
//
//   ServiceSnippet.fromState(ServiceSnippet serviceSnippet) {
//     this.id = serviceSnippet.id;
//     this.name = serviceSnippet.name;
//     this.timesSold = serviceSnippet.timesSold;
//   }
//
//   ServiceSnippet copyWith({
//     String id,
//     String name,
//     int timesSold,
//   }) {
//     return ServiceSnippet(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       timesSold: timesSold ?? this.timesSold,
//     );
//   }
//
//   ServiceSnippet.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         name = json['name'],
//         timesSold = json['timesSold'];
//
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'timesSold': timesSold,
//       };
//
//   ServiceSnippet toEmpty() {
//     return ServiceSnippet(
//       id: '',
//       name: '',
//       timesSold: 0,
//     );
//   }
// }
