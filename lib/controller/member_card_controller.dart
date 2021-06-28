import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:point_of_sale/modal/member_card.dart';
import 'package:point_of_sale/widget/config.dart';

class MemberCardController {
  static Future<List<MemberCard>> eachMember() async {
    var url = Config.urlMember;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var memberList = json.decode(response.body) as List;
      List<MemberCard> item = [];
      memberList.map((items) {
        return item.add(MemberCard.fromJson(items));
      }).toList();
      return item;
    } else {
      return throw Exception('Failed to load member card');
    }
  }

  static Future<List<MemberCard>> searchMember(String name) async {
    var url = Config.searchMember + "?name=$name";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var memberList = json.decode(response.body) as List;
      List<MemberCard> item = [];
      memberList.map((items) {
        return item.add(MemberCard.fromJson(items));
      }).toList();
      return item;
    } else {
      return throw Exception('Failed to load search member card');
    }
  }
}
