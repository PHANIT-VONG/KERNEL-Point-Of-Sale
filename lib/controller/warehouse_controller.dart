
import 'dart:convert';
import 'package:point_of_sale/modal/warehouse_modal.dart';
import 'package:point_of_sale/widget/config.dart';
import 'package:http/http.dart' as http;

class WarehouseController{
  static Future<List<Warehouse>> eachWarehouse () async {
    var url=Config.warehouseUrl;
    var response= await http.get(url);
    if(response.statusCode==200){
      var wareList =json.decode(response.body) as List;
      List<Warehouse> item=[];
      wareList.map((items){
        return item.add(Warehouse.fromJson(items));
      }).toList();
      return item;
    }else{
      return throw Exception('Failed to load price list');
    }
  }
}