class Company {
  int comId;
  String comName;
  String image;
  int priceListId;

  Company({this.comId, this.comName, this.image, this.priceListId});
  factory Company.fromJson(Map<String, dynamic> json) => Company(
      comId: json["Id"] as int,
      comName: json["name"] as String,
      image: json["image"] as String,
      priceListId: json["priceListId"]);
}
