class Tax {
  int id;
  String name;
  double rate;
  Tax({this.id, this.name, this.rate});

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        id: json["id"] as int,
        name: json["name"] as String,
        rate: json["rate"] as double,
      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "rate": rate,
      };
}
