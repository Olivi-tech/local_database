// ignore_for_file: camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'student.dart';

class database_helper extends ChangeNotifier {
  Database? _db;

  static database_helper? _instance;

  database_helper._internal();

  factory database_helper() {
    _instance ??= database_helper._internal();
    return _instance!;
  }
  Future<Database> get database async {
    _db ??= await openDatabase(join(await getDatabasesPath(), 'Std.db'),
        version: 1, onCreate: (db, version) {
      return db.execute(Student.createTable);
    });
    return _db!;
  }

  Future<bool> insertStudent(Student student) async {
    var db = await database;
    var rowId = await db.insert(Student.tableName, student.toMap());
    notifyListeners();
    return rowId > 0;
  }

  Future<bool> updateStudent(Student student) async {
    var db = await database;
    var rowId = await db.update(Student.tableName, student.toMap(),
        where: '${Student.keyRollNo}=?', whereArgs: [student.rollNo]);
    notifyListeners();
    return rowId > 0;
  }

  Future<bool> deleteStudent(Student student) async {
    var db = await database;
    var rowId = await db.delete(Student.tableName,
        where: '${Student.keyRollNo}=?', whereArgs: [student.rollNo]);
    notifyListeners();
    return rowId > 0;
  }

  Future<List<Student>> fetchStudent() async {
    var listofMaps = await _db!.query(Student.tableName);
    notifyListeners();
    return listofMaps.map((map) {
      return Student.fromMap(map);
    }).toList();
  }
}
