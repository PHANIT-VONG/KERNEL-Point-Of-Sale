class Setting {
  int setId;
  int id;
  int branchId;
  String receiptSize;
  String receiptTemplate;
  bool printReceiptOrder;
  bool printReceiptTender;
  int printCountReceipt;
  int queueCount;
  int sysCurrencyId;
  int localCurrencyId;
  double rateIn;
  double rateOut;
  String printer;
  int paymentMeansId;
  int companyId;
  int warehouseId;
  int customerId;
  int priceListId;
  bool vatAble;
  String vatNum;
  String wifi;
  String currencyDisplay;
  double displayRate;
  String macAddress;
  bool autoQueue;
  bool printLabel;
  int closeShift;

  Setting(
      {this.setId,
      this.id,
      this.branchId,
      this.receiptSize,
      this.receiptTemplate,
      this.printReceiptOrder,
      this.printReceiptTender,
      this.printCountReceipt,
      this.queueCount,
      this.sysCurrencyId,
      this.localCurrencyId,
      this.rateIn,
      this.rateOut,
      this.printer,
      this.paymentMeansId,
      this.companyId,
      this.warehouseId,
      this.customerId,
      this.priceListId,
      this.vatAble,
      this.vatNum,
      this.wifi,
      this.currencyDisplay,
      this.displayRate,
      this.macAddress,
      this.autoQueue,
      this.printLabel,
      this.closeShift});

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
      setId: json["setId"] as int,
      id: json["id"] as int,
      branchId: json["branchId"] as int,
      receiptSize: json["receiptSize"] as String,
      receiptTemplate: json["receiptTemplate"] as String,
      printReceiptOrder: json["printReceiptOrder"] as bool,
      printReceiptTender: json["printReceiptTender"] as bool,
      printCountReceipt: json["printCountReceipt"] as int,
      queueCount: json["queueCount"] as int,
      sysCurrencyId: json["sysCurrencyId"] as int,
      localCurrencyId: json["localCurrencyId"] as int,
      rateIn: json["rateIn"] as double,
      rateOut: json["rateOut"] as double,
      printer: json["printer"] as String,
      paymentMeansId: json["paymentMeansId"] as int,
      companyId: json["companyId"] as int,
      warehouseId: json["warehouseId"] as int,
      customerId: json["customerId"] as int,
      priceListId: json["priceListId"] as int,
      vatAble: json["vatAble"] as bool,
      vatNum: json["vatNum"] as String,
      wifi: json["wifi"] as String,
      currencyDisplay: json["currencyDisplay"] as String,
      displayRate: json["displayRate"] as double,
      macAddress: json["macAddress"] as String,
      autoQueue: json["autoQueue"] as bool,
      printLabel: json["printLabel"] as bool,
      closeShift: json["closeShift"] as int);

  Map<String, dynamic> toMap() => {
        "setId": setId,
        "id": id,
        "branchId": branchId,
        "receiptSize": receiptSize,
        "receiptTemplate": receiptTemplate,
        "printReceiptOrder": printReceiptOrder,
        "printReceiptTender": printReceiptTender,
        "printCountReceipt": printCountReceipt,
        "queueCount": queueCount,
        "sysCurrencyId": sysCurrencyId,
        "localCurrencyId": localCurrencyId,
        "rateIn": rateIn,
        "rateOut": rateOut,
        "printer": printer,
        "paymentMeansId": paymentMeansId,
        "companyId": companyId,
        "warehouseId": warehouseId,
        "customerId": customerId,
        "priceListId": priceListId,
        "vatAble": vatAble,
        "vatNum": vatNum,
        "wifi": wifi,
        "currencyDisplay": currencyDisplay,
        "displayRate": displayRate,
        "macAddress": macAddress,
        "autoQueue": autoQueue,
        "printLabel": printLabel,
        "closeShift": closeShift
      };
}
