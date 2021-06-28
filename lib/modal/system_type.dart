class SystemType {
  bool krms;
  bool kbms;
  bool ktms;

  SystemType({this.krms, this.kbms, this.ktms});

  factory SystemType.fromJson(Map<String, dynamic> json) => SystemType(
        krms: json["krms"] as bool,
        kbms: json["kbms"] as bool,
        ktms: json["ktms"] as bool,
      );
  Map<String, dynamic> toMap() => {
        "krms": krms,
        "kbms": kbms,
        "ktms": ktms,
      };
}
