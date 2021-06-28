// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';
import 'package:point_of_sale/connection/connection_database.dart';
import 'package:point_of_sale/modal/gorupItem_modal.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  ConnectionDatabase _connectionDatabase;
  Repository() {
    _connectionDatabase = ConnectionDatabase();
  }
  static Database _database;

  Future<Database> get database async {
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentsDirectory.path, "db_pos");
    // await deleteDatabase(path);
    // print("here");

    if (_database != null) return _database;
    _database = await _connectionDatabase.setDatabase();
    return _database;
  }

  //---------------------------------------------setting --------------------

  // insert setting
  insertSetting(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  deleteSetting(table) async {
    var con = await database;
    return await con.delete(table);
  }

  // update setting
  updateSetting(table, data, setId) async {
    var con = await database;
    return await con.update(table, data, where: "setId= ?", whereArgs: [setId]);
  }

  // get setting
  getSetting(table) async {
    var con = await database;
    return await con.query(table);
  }

  hasSetting(table, int key) async {
    var con = await database;
    return await con.query(table, where: "id=?", whereArgs: [key]);
  }

  //--------------------------------------end Setting -------------------------------

  //********************************************* Start Order ***********************
  // insert order
  insertOrder(table, data) async {
    var con = await database;
    return await con.insert(table, data);
  }

  // insertOrderDetail
  insertOrderDetail(table, data) async {
    var con = await database;
    return await con.insert(table, data);
  }

  // get order
  getOrder(table) async {
    var con = await database;
    return await con.query(table);
  }

  getOrderRaw() async {
    var con = await database;
    return await con.rawQuery("Select * from tbOrder");
  }

  //get order detail
  getOrderDetail(table) async {
    var con = await database;
    return await con.query(table);
  }

  getOrderDetailKey(table, lineId) async {
    var con = await database;
    return await con.query(table, where: "lineId = ?", whereArgs: [lineId]);
  }

  getOrderKey(table, id) async {
    var con = await database;
    return await con.query(table, where: "id = ?", whereArgs: [id]);
  }

  getOrderBuild(table, build) async {
    var con = await database;
    return await con.query(table, where: "checkBill= ?", whereArgs: [build]);
  }

  // update order
  updateOrder(table, data, id) async {
    var con = await database;
    return await con.update(table, data, where: "id = ?", whereArgs: [id]);
  }

  // update order detail
  updateOrderDetail(table, data, id) async {
    var con = await database;
    return await con.update(table, data, where: "id = ?", whereArgs: [id]);
  }

  // delete All order
  deleteAllOrder(table) async {
    var con = await database;
    return await con.delete(table);
  }

  // delete order
  deleteOrder(table, id) async {
    var con = await database;
    return await con.delete(table, where: "id = ?", whereArgs: [id]);
  }

  // delete all order detail
  deleteAllOrderDetail(table) async {
    var con = await database;
    return await con.delete(table);
  }

  // delete order detail
  deleteOrderDetail(table, id) async {
    var con = await database;
    return await con.delete(table, where: "id= ?", whereArgs: [id]);
  }
  //*********************************************  end Setting ***************************

  //++++++++++++++++++++++++++++++++++++++++++++++ start bill+++++++++++++++++++++++++++++

  // insert bill
  insertBill(table, data) async {
    var con = await database;
    return await con.insert(table, data);
  }

  // insert bill detail
  insertBillDetail(table, data) async {
    var con = await database;
    return await con.insert(table, data);
  }

  // get bill
  getBill(table) async {
    var con = await database;
    return await con.query(table);
  }

  getFirstBill(table, orderId) async {
    var con = await database;
    return await con.query(table, where: "orderId =?", whereArgs: [orderId]);
  }

  //get bill detail
  getBillDetail(table, orderId) async {
    var con = await database;
    return await con.query(table, where: "orderId = ?", whereArgs: [orderId]);
  }

  //get bill detail
  getFirstBillDetail(table) async {
    var con = await database;
    return await con.query(table);
  }

  // update bill
  updateBill(table, data, orderId) async {
    var con = await database;
    return await con
        .update(table, data, where: "orderId = ?", whereArgs: [orderId]);
  }

  // update bill detail
  updateBillDetail(table, data, orderDetailId) async {
    var con = await database;
    return await con.update(table, data,
        where: "orderDetailId = ?", whereArgs: [orderDetailId]);
  }

  // delete bill
  deleteBill(table) async {
    var con = await database;
    return await con.delete(table);
  }

  // delete bill detail
  deleteBillDetail(table) async {
    var con = await database;
    return await con.delete(table);
  }

  // ---------------------------------------end bill--------------

  //+++++++++++++++++++++++++++++++++++++++++ start item local  store ++++++++++++

  insertItem(table, data) async {
    var con = await database;
    return await con.insert(table, data);
  }

  updateItem(table, data, int key) async {
    var con = await database;
    return await con.update(table, data, where: "key=?", whereArgs: [key]);
  }

  hasitem(table, int key) async {
    var con = await database;
    return await con.query(table, where: "key=?", whereArgs: [key]);
  }

  getitem(table, GroupItem group, int plId) async {
    var con = await database;
    if (group.g1Id != 0 && group.g2Id == 0 && group.g3Id == 0) {
      return await con.query(table,
          where: "g1Id=? and itemType=? and priceListId=?",
          whereArgs: [group.g1Id, "Item", plId]);
    } else if (group.g1Id != 0 && group.g2Id != 0 && group.g3Id == 0) {
      return await con.query(table,
          where: "g1Id=? and g2Id=? and itemType=? and priceListId=?",
          whereArgs: [group.g1Id, group.g2Id, "Item", plId]);
    } else if (group.g1Id != 0 && group.g2Id != 0 && group.g3Id != 0) {
      return await con.query(table,
          where:
              "g1Id=? and g2Id=? and g3Id=? and itemType=? and priceListId=?",
          whereArgs: [group.g1Id, group.g2Id, group.g3Id, "Item", plId]);
    }
  }

  ///++++++++++++++++++++++++++++++++++++++++++++++++++++++ end item ++++++++++++++++++++++++

  //______________________________________________start item group 1 ____________________
  insertGroup1(table, data) async {
    var con = await database;
    return await con.insert(table, data);
  }

  updateGroup1(table, data, g1Id) async {
    var con = await database;
    return await con.update(table, data, where: "g1Id=?", whereArgs: [g1Id]);
  }

  hasGroup1(table, int g1Id) async {
    var con = await database;
    return await con.query(table, where: "g1Id=?", whereArgs: [g1Id]);
  }

  getGorup1(table) async {
    var con = await database;
    return await con.query(table);
  }
  //____________________________________ end group 1 ____________________

  //++++++++++++++++++++++++++++++++++++++++ start group 2 ++++++++++++++

  insertGroup2(table, data) async {
    var con = await database;
    return await con.insert(table, data);
  }

  updateGroup2(table, data, g2Id) async {
    var con = await database;
    return await con.update(table, data, where: "g2Id=?", whereArgs: [g2Id]);
  }

  hasGroup2(table, int g2Id) async {
    var con = await database;
    return await con.query(table, where: "g2Id=?", whereArgs: [g2Id]);
  }

  getGorup2(table, g1Id) async {
    var con = await database;
    return await con.query(table, where: "g1Id=?", whereArgs: [g1Id]);
  }

  //+++++++++++++++++++++++++++++++++++ end group 2 ++++++++++++++++++++

  // __________________________________start group3 ___________________

  insertGroup3(table, data) async {
    var con = await database;
    return await con.insert(table, data);
  }

  updateGroup3(table, data, g3Id) async {
    var con = await database;
    return await con.update(table, data, where: "g3Id=?", whereArgs: [g3Id]);
  }

  hasGroup3(table, int g3Id) async {
    var con = await database;
    return await con.query(table, where: "g3Id=?", whereArgs: [g3Id]);
  }

  getGorup3(table, g1Id, g2Id) async {
    var con = await database;
    return await con
        .query(table, where: "g1Id=? and g2Id=?", whereArgs: [g1Id, g2Id]);
  }

  // +++++++++++++++++++++++++++++++++++++++++++++ end group 3 ++++++++++++++++++++

  //______________________________________________ start payment ___________________

  insertPayment(table, data) async {
    var con = await database;
    return await con.insert(table, data);
  }

  updatePayment(table, data, id) async {
    var con = await database;
    return await con.update(table, data, where: "id=?", whereArgs: [id]);
  }

  hasPayment(table, int id) async {
    var con = await database;
    return await con.query(table, where: "id=?", whereArgs: [id]);
  }

  getPayment(table) async {
    var con = await database;
    return await con.query(table);
  }

  // ___________________________________ end payment  ____________________

  // ___________________________________ start receipt __________________

  insertReceipt(table, data) async {
    var con = await database;
    return await con.insert(table, data);
  }

  updateReceipt(table, data, id) async {
    var con = await database;
    return await con.update(table, data, where: "id=?", whereArgs: [id]);
  }

  hasReceipt(table, int id) async {
    var con = await database;
    return await con.query(table, where: "id =?", whereArgs: [id]);
  }

  getReceipt(table) async {
    var con = await database;
    return await con.query(table);
  }

  // ______________________________  end receipt _________________________
}
