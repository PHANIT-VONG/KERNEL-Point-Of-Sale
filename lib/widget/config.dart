class Config {
  static String baseurl = "http://192.168.0.230:8088/";
  static String group1Url = "${baseurl}api/master/getgroup1";
  static String group2Url = "${baseurl}api/master/getgroup2";
  static String group2UrlLocal = "${baseurl}api/master/getg2local";
  static String group3Url = "${baseurl}api/master/getgroup3";
  static String group3UrlLocal = "${baseurl}api/master/getg3Local";
  static String itemUrl = "${baseurl}api/master/getitem";
  static String itemUrlLocal = "${baseurl}api/master/getitemlocal";
  static String image = "http://192.168.0.230:8088";
  static String paymentMean = "${baseurl}api/master/paymentmean";
  static String searchItemUrl = "${baseurl}api/master/searchitem";
  static String companyUrl = "${baseurl}api/master/getcompany";
  static String warehouseUrl = "${baseurl}api/master/getwarehouse";
  static String priceListUrl = "${baseurl}api/master/getpricelist";
  static String branchUrl = "${baseurl}api/master/getbranch";
  static String customerUrl = "${baseurl}api/master/getcustomer";
  static String displayCurrUrl = "${baseurl}api/master/getdisplaycurrency";
  static String receiptInfo = "${baseurl}api/master/getreceiptinfo";

  static String urlSetting = "${baseurl}api/master/getsetting";
  static String urlLogin = "${baseurl}api/accountapi/loginaccount";
  static String urlGroupTable = "${baseurl}api/master/getgrouptable";
  static String urlTable = "${baseurl}api/master/gettable";
  static String urlSearchTable = "${baseurl}api/master/searchtable";
  static String urlTax = "${baseurl}api/master/gettax";
  static String urlMember = "${baseurl}api/master/getmembercard";
  static String urlSystemType = "${baseurl}api/master/getsystemtype";
  static String urlLocalCurrency = "${baseurl}api/master/getlocalcurrency";
  static String urlGetOrder = "${baseurl}api/master/getorder";
  static String urlCheckOpenShift = "${baseurl}api/master/checkopenshift";
  static String urlPostOpenShift = "${baseurl}api/postmaster/postopenshift";
  static String postOrder = "${baseurl}api/postmaster/postorder";
  static String urlExchange = "${baseurl}api/master/getexchangerate";

  static String voidOrder = "${baseurl}api/master/voidorder";
  static String getTableInfo = "${baseurl}api/master/gettableinfo";
  static String getTableMove = "${baseurl}api/master/gettablemove";
  static String movTable = "${baseurl}api/master/movetable";

  static String getReceiptCombine = "${baseurl}api/master/getreceiptcombine";
  static String postCombineReceipt = "${baseurl}api/postmaster/postcombine";
  static String searchMember = "${baseurl}api/master/searchmember";
  static String receipt = "${baseurl}api/master/getreceipt";
  static String receiptDetail = "${baseurl}api/master/getreceiptdetail";
  static String getCancelReceipt = "${baseurl}api/master/getcancelreceipt";
  static String getReturnReceipt = "${baseurl}api/master/getreturnreceipt";

  // permission
  static String urlCheckPerOpenShift =
      "${baseurl}api/permissionapi/checkpermission";
  static String permisBill = "${baseurl}api/permissionapi/permissionbill";
  static String permisPay = "${baseurl}api/permissionapi/permissionpay";
  static String permisVoidOrder =
      "${baseurl}api/permissionapi/permissionvoidorder";

  static String permisMoveTable =
      "${baseurl}api/permissionapi/permissionmovetable";
  static String permiscombine = "${baseurl}api/permissionapi/permissioncombine";
  static String permissplit = "${baseurl}api/permissionapi/permissionsplit";

  static String permisDeleteItem = "${baseurl}api/permissionapi/deleteitem";
  static String permisMemberCard = "${baseurl}api/permissionapi/membercard";
  static String permisReturnOrder = "${baseurl}api/permissionapi/returnorder";
  static String permisCancelOrder = "${baseurl}api/permissionapi/cancelorder";
  static String permisDiscountItem = "${baseurl}api/permissionapi/discountitem";
}
