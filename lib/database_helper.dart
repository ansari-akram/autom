// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper db = DatabaseHelper._();
  static Database? _database;

  static const String deviceTable = 'device';
  static const String roomTable = 'room';
  static const String applianceTable = 'appliance';
  static const String userTable = 'user';

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'internal.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $userTable(id INTEGER PRIMARY KEY, user_id TEXT)');
      await db.execute(
          'CREATE TABLE $deviceTable(id INTEGER PRIMARY KEY, mcu_name TEXT, mcu_type INTEGER, mcu_ip TEXT, is_new TEXT)');
      await db.execute(
          'CREATE TABLE $roomTable(id INTEGER PRIMARY KEY, room_name TEXT, is_new TEXT)');
      await db.execute(
          'CREATE TABLE $applianceTable(id INTEGER PRIMARY KEY, room TEXT, mcu TEXT, btn_no TEXT, btn_state TEXT, appliance_name TEXT, is_new TEXT, state_changed TEXT)');
    });
  }

  Future<List> getAll(String _tableName) async {
    final db = await database;
    List<Map> results = await db!.query(_tableName, orderBy: 'id ASC');
    return results;
  }

  Future<Map> getById(String id, String _tableName) async {
    final db = await database;
    List<Map> results =
        await db!.query(_tableName, where: "id = ?", whereArgs: [id]);
    return results.first;
  }

  Future<String> getIdByRoomName(String roomName) async {
    final db = await database;
    List<Map> results = await db!.query(DatabaseHelper.roomTable,
        where: "room_name = ?", whereArgs: [roomName]);
    Map result = results.first;
    return result['id'].toString();
  }

  Future<String> getIdByDeviceName(String deviceName) async {
    final db = await database;
    List<Map> results = await db!.query(DatabaseHelper.deviceTable,
        where: "mcu_name = ?", whereArgs: [deviceName]);
    Map result = results.first;
    return result['id'].toString();
  }

  insert(String _query, List _values) async {
    final db = await database;
    var result = await db!.rawInsert(_query, _values);
    return result;
  }

  update(String _query, List _values) async {
    final db = await database;
    var result = await db!.rawUpdate(_query, _values);
    print(result);
    return result;
  }

  delete(String _query, List _values) async {
    final db = await database;
    var result = await db!.rawDelete(_query, _values);
    return result;
  }

  Future<Map> getByQuery(String _query, List _values) async {
    final db = await database;
    var result = await db!.rawQuery(_query, _values);
    return result.isNotEmpty ? result.first : {};
  }

  Future<Map> query(String _query) async {
    final db = await database;
    var result = await db!.rawQuery(_query);
    return result.isNotEmpty ? result.first : {};
  }
}
