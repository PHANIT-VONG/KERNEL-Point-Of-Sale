class GroupTable {
  int groupId;
  int branchId;
  String name;
  String image;
  String type;

  GroupTable({this.groupId, this.branchId, this.name, this.image, this.type});

  factory GroupTable.fromJson(Map<String, dynamic> json) => GroupTable(
      groupId: json["groupId"] as int,
      branchId: json["branchId"] as int,
      name: json["name"] as String,
      image: json["image"] as String,
      type: json["type"] as String);
  Map<String, dynamic> toMap() => {
        "groupId": groupId,
        "branchId": branchId,
        "name": name,
        "image": image,
        "type": type
      };
}
