class ItemMaster {
  int key;
  int itemId;
  String itemCode;
  String itemName;
  double qty;
  double printQty;
  double cost;
  double unitPrice;
  double disRate;
  double disValue;
  String typeDis;
  double vat;
  int currencyId;
  String currency;
  int uomId;
  String uom;
  String barcode;
  String process;
  String image;
  int priceListId;
  int inStock;
  int commited;
  int ordered;
  int available;
  String printTo;
  String itemType;
  String typeDisItem;
  double disValueItem;
  int status;
  int g1Id;
  int g2Id;
  int g3Id;

  ItemMaster(
      {this.key,
      this.itemId,
      this.itemCode,
      this.itemName,
      this.qty,
      this.printQty,
      this.cost,
      this.unitPrice,
      this.disRate,
      this.disValue,
      this.typeDis,
      this.vat,
      this.currencyId,
      this.currency,
      this.uom,
      this.uomId,
      this.barcode,
      this.process,
      this.image,
      this.priceListId,
      this.inStock,
      this.commited,
      this.ordered,
      this.available,
      this.printTo,
      this.itemType,
      this.typeDisItem,
      this.disValueItem,
      this.status,
      this.g1Id,
      this.g2Id,
      this.g3Id});

  factory ItemMaster.fromJson(Map<String, dynamic> json) => ItemMaster(
      key: json["key"] as int,
      itemId: json["itemId"] as int,
      itemCode: json["itemCode"] as String,
      itemName: json["itemName"] as String,
      qty: json["qty"] as double,
      printQty: json["printQty"] as double,
      cost: json["cost"] as double,
      unitPrice: json["unitPrice"] as double,
      disRate: json["disRate"] as double,
      disValue: json["disValue"] as double,
      typeDis: json["typeDis"] as String,
      vat: json["vat"] as double,
      currencyId: json["currencyId"] as int,
      currency: json["currency"] as String,
      uomId: json["uomId"] as int,
      uom: json["uom"] as String,
      barcode: json["barcode"] as String,
      process: json["process"] as String,
      image: json["image"] as String,
      priceListId: json["priceListId"] as int,
      inStock: json["inStock"] as int,
      commited: json["commited"] as int,
      ordered: json["ordered"] as int,
      available: json["available"] as int,
      printTo: json["printTo"] as String,
      itemType: json["itemType"] as String,
      typeDisItem: json["typeDisItem"] as String,
      disValueItem: json["disValueItem"] as double,
      status: json["status"] as int,
      g1Id: json["g1Id"] as int,
      g2Id: json["g2Id"] as int,
      g3Id: json["g3Id"] as int);

  Map<String, dynamic> toMap() => {
        "key": key,
        "itemId": itemId,
        "itemCode": itemCode,
        "itemName": itemName,
        "qty": qty,
        "printQty": printQty,
        "cost": cost,
        "unitPrice": unitPrice,
        "disRate": disRate,
        "disValue": disValue,
        "typeDis": typeDis,
        "vat": vat,
        "currencyId": currencyId,
        "currency": currency,
        "uomId": uomId,
        "uom": uom,
        "barcode": barcode,
        "process": process,
        "image": image,
        "priceListId": priceListId,
        "inStock": inStock,
        "commited": commited,
        "ordered": ordered,
        "printTo": printTo,
        "itemType": itemType,
        "available": available,
        "typeDisItem": typeDisItem,
        "disValueItem": disValueItem,
        "status": status,
        "g1Id": g1Id,
        "g2Id": g2Id,
        "g3Id": g3Id
      };
}
