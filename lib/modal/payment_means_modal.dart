class PaymentMean {
  int id;
  String type;
  PaymentMean({this.id, this.type});

  factory PaymentMean.fromJson(Map<String, dynamic> json) =>
      PaymentMean(id: json['id'] as int, type: json['type'] as String);

  Map<String, dynamic> toMap() => {'id': id, 'type': type};
}
