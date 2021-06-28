
import 'dart:convert';

import 'package:point_of_sale/modal/compay_modal.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class CompanyController{
  static Future<List<Company>> eachCompany () async {
    var url=Config.companyUrl;
    var response= await http.get(url);
    if(response.statusCode==200){
      var comList =json.decode(response.body) as List;
      List<Company> item=[];
      comList.map((items){
        return item.add(Company.fromJson(items));
      }).toList();
      return item;
    }else{
      return throw Exception('Failed to load customer');
    }
  }
}