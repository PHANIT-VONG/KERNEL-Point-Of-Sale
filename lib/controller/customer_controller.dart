import 'dart:convert';
import 'package:point_of_sale/modal/customer_modal.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class CustomerController {
  static Future<List<Customer>> eachCustomer() async {
    var url=Config.customerUrl;
    var response= await http.get(url);
    if(response.statusCode==200){
      var cusList =json.decode(response.body) as List;
      List<Customer> item=[];
      cusList.map((items){
        return item.add(Customer.fromJson(items));
      }).toList();
      return item;
    }else{
      return throw Exception('Failed to load customer');
    }
  }
}