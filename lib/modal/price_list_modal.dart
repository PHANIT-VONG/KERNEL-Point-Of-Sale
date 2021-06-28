class PriceList {
  int priId;
  String priName;
  int currencyId;
  PriceList({this.priId, this.priName, this.currencyId});

  factory PriceList.fromJson(Map<String, dynamic> json) => PriceList(
      priId: json["Id"] as int,
      priName: json["name"] as String,
      currencyId: json["currencyId"] as int);
}
