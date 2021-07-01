class Config {
  static String baseUrl = "http://192.168.0.106:8891/";
  static String group1Url = "${baseUrl}api/master/getgroup1";
  static String group2Url = "${baseUrl}api/master/getgroup2";
  static String group2UrlLocal = "${baseUrl}api/master/getg2local";
  static String group3Url = "${baseUrl}api/master/getgroup3";
  static String group3UrlLocal = "${baseUrl}api/master/getg3Local";
  static String itemUrl = "${baseUrl}api/master/getitem";
  static String itemUrlLocal = "${baseUrl}api/master/getitemlocal";
  static String image = "http://192.168.0.230:8088";
  static String paymentMean = "${baseUrl}api/master/paymentmean";
  static String searchItemUrl = "${baseUrl}api/master/searchitem";
  static String companyUrl = "${baseUrl}api/master/getcompany";
  static String warehouseUrl = "${baseUrl}api/master/getwarehouse";
  static String priceListUrl = "${baseUrl}api/master/getpricelist";
  static String branchUrl = "${baseUrl}api/master/getbranch";
  static String customerUrl = "${baseUrl}api/master/getcustomer";
  static String displayCurrUrl = "${baseUrl}api/master/getdisplaycurrency";
  static String receiptInfo = "${baseUrl}api/master/getreceiptinfo";

  static String urlSetting = "${baseUrl}api/master/getsetting";
  static String urlLogin = "${baseUrl}api/accountapi/loginaccount";
  static String urlGroupTable = "${baseUrl}api/master/getgrouptable";
  static String urlTable = "${baseUrl}api/master/gettable";
  static String urlSearchTable = "${baseUrl}api/master/searchtable";
  static String urlTax = "${baseUrl}api/master/gettax";
  static String urlMember = "${baseUrl}api/master/getmembercard";
  static String urlSystemType = "${baseUrl}api/master/getsystemtype";
  static String urlLocalCurrency = "${baseUrl}api/master/getlocalcurrency";
  static String urlGetOrder = "${baseUrl}api/master/getorder";
  static String urlCheckOpenShift = "${baseUrl}api/master/checkopenshift";
  static String urlPostOpenShift = "${baseUrl}api/postmaster/postopenshift";
  static String postOrder = "${baseUrl}api/postmaster/postorder";
  static String urlExchange = "${baseUrl}api/master/getexchangerate";

  static String voidOrder = "${baseUrl}api/master/voidorder";
  static String getTableInfo = "${baseUrl}api/master/gettableinfo";
  static String getTableMove = "${baseUrl}api/master/gettablemove";
  static String movTable = "${baseUrl}api/master/movetable";

  static String getReceiptCombine = "${baseUrl}api/master/getreceiptcombine";
  static String postCombineReceipt = "${baseUrl}api/postmaster/postcombine";
  static String searchMember = "${baseUrl}api/master/searchmember";
  static String receipt = "${baseUrl}api/master/getreceipt";
  static String receiptDetail = "${baseUrl}api/master/getreceiptdetail";
  static String getCancelReceipt = "${baseUrl}api/master/getcancelreceipt";
  static String getReturnReceipt = "${baseUrl}api/master/getreturnreceipt";

  // permission
  static String urlCheckPerOpenShift =
      "${baseUrl}api/permissionapi/checkpermission";
  static String permisBill = "${baseUrl}api/permissionapi/permissionbill";
  static String permisPay = "${baseUrl}api/permissionapi/permissionpay";
  static String permisVoidOrder =
      "${baseUrl}api/permissionapi/permissionvoidorder";

  static String permisMoveTable =
      "${baseUrl}api/permissionapi/permissionmovetable";
  static String permiscombine = "${baseUrl}api/permissionapi/permissioncombine";
  static String permissplit = "${baseUrl}api/permissionapi/permissionsplit";

  static String permisDeleteItem = "${baseUrl}api/permissionapi/deleteitem";
  static String permisMemberCard = "${baseUrl}api/permissionapi/membercard";
  static String permisReturnOrder = "${baseUrl}api/permissionapi/returnorder";
  static String permisCancelOrder = "${baseUrl}api/permissionapi/cancelorder";
  static String permisDiscountItem = "${baseUrl}api/permissionapi/discountitem";
}
