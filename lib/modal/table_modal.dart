class TableOrder {
  int tableId;
  int groupId;
  String name;
  String image;
  String status;
  String time;

  TableOrder(
      {this.tableId,
      this.groupId,
      this.name,
      this.image,
      this.status,
      this.time});

  factory TableOrder.fromJson(Map<String, dynamic> json) => TableOrder(
      tableId: json["tableId"] as int,
      groupId: json["groupId"] as int,
      name: json["name"] as String,
      image: json["image"] as String,
      status: json["status"] as String,
      time: json["time"] as String);
  Map<String, dynamic> toMap() => {
        "tableId": tableId,
        "groupId": groupId,
        "name": name,
        "image": image,
        "status": status,
        "time": time
      };
}
