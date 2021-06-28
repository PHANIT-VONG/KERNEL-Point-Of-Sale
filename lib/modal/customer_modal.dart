class Customer {
  int cusId;
  String cusName;
  int priceListId;
  Customer({this.cusId, this.cusName, this.priceListId});

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
      cusId: json["Id"] as int,
      cusName: json["name"] as String,
      priceListId: json["priceListId"] as int);
}
