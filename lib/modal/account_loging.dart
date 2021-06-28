class AccountLogin {
  int branchId;
  String userName;
  String password;

  AccountLogin({this.branchId, this.userName, this.password});

  factory AccountLogin.fromJson(Map<String, dynamic> json) => AccountLogin(
        branchId: json["branchId"] as int,
        userName: json["userName"] as String,
        password: json["password"] as String,
      );

  Map<String, dynamic> toJson() =>
      {"branchId": branchId, "userName": userName, "password": password};
}
