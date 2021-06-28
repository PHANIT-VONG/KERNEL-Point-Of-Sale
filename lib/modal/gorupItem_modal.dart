class GroupItem {
  final int g1Id;
  final int g2Id;
  final int g3Id;
  final String name;
  final String image;
  GroupItem({this.g1Id, this.g2Id, this.g3Id, this.name, this.image});

  factory GroupItem.fromJson(Map<String, dynamic> json) => GroupItem(
        g1Id: json["g1Id"] as int,
        g2Id: json["g2Id"] as int,
        g3Id: json["g3Id"] as int,
        name: json["name"] as String,
        image: json["image"] as String,
      );
  Map<String, dynamic> toMap() =>
      {"g1Id": g1Id, "g2Id": g2Id, "g3Id": g3Id, "name": name, "image": image};
}
