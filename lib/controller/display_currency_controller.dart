import 'dart:convert';
import 'package:point_of_sale/modal/display_currency_modal.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class DisplayCurrController {
  static Future<List<DisplayCurrency>> eachDisCurr () async {
      var url=Config.displayCurrUrl;
      var response= await http.get(url);
      if(response.statusCode==200){
        var disList =json.decode(response.body) as List;
        List<DisplayCurrency> item=[];
        disList.map((items){
          return item.add(DisplayCurrency.fromJson(items));
        }).toList();
        return item;
      }else{
        return throw Exception('Failed to load display currency');
      }
  }
}