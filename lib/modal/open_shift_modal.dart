class OpenShift {
  int id;
  String dateIn;
  String timeIn;
  int branchID;
  int userID;
  double cashAmountSys;
  String currency;
  double transFrom;
  bool open;

  OpenShift(
      {this.id,
      this.dateIn,
      this.timeIn,
      this.branchID,
      this.userID,
      this.cashAmountSys,
      this.currency,
      this.transFrom,
      this.open});

  OpenShift.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    dateIn = json['DateIn'];
    timeIn = json['TimeIn'];
    branchID = json['BranchID'];
    userID = json['UserID'];
    cashAmountSys = json['CashAmount_Sys'];
    currency = json['Currency'];
    transFrom = json['Trans_From'];
    open = json['Open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['DateIn'] = this.dateIn;
    data['TimeIn'] = this.timeIn;
    data['BranchID'] = this.branchID;
    data['UserID'] = this.userID;
    data['CashAmount_Sys'] = this.cashAmountSys;
    data['Currency'] = this.currency;
    data['Trans_From'] = this.transFrom;
    data['Open'] = this.open;
    return data;
  }
}

class PostOpenShift {
  int userId;
  double cash;
  PostOpenShift({this.userId, this.cash});

  PostOpenShift.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    cash = json['cash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['cash'] = this.cash;
    return data;
  }
}
