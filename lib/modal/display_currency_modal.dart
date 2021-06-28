class DisplayCurrency {
  int id;
  String altCurr;
  String baseCurr;
  double rate;

  DisplayCurrency({this.id, this.altCurr, this.baseCurr, this.rate});

  factory DisplayCurrency.fromJson(Map<String, dynamic> json) =>
      DisplayCurrency(
          id: json["id"] as int,
          altCurr: json["altCurr"] as String,
          baseCurr: json["baseCurr"] as String,
          rate: json["rate"]);
}
