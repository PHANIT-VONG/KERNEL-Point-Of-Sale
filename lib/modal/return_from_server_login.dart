class ReturnFromServerLogin {
  int userId;
  int branchId;
  bool permission;
  bool statusLogin;
  ReturnFromServerLogin({
    this.userId,
    this.branchId,
    this.statusLogin,
    this.permission,
  });

  factory ReturnFromServerLogin.fromJson(Map<String, dynamic> json) =>
      ReturnFromServerLogin(
        userId: json["userId"] as int,
        branchId: json["branchId"] as int,
        statusLogin: json["statusLogin"] as bool,
        permission: json["permission"] as bool,
      );
  Map<String, dynamic> toMap() => {
        "branchId": branchId,
        "userId": userId,
        "statusLogin": statusLogin,
        "permission": permission
      };
}
