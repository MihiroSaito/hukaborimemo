import 'dart:convert';
import 'dart:io';

import 'package:hukaborimemo/common/model/database/tables.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database? _databaseData;

  Future<Database> get database async {
    if (_databaseData != null) {
      return _databaseData!;
    } else {
      _databaseData = await initDB();
      return _databaseData!;
    }
  }

  Future<Database> initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'hukaborimemo.db');
    Database _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE memo (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            parent_id INTEGER,
            child_ids TEXT,
            text TEXT,
            tag_id INTEGER,
            created_at TEXT,
            updated_at TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE tag (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            used_at TEXT,
            created_at TEXT,
            updated_at TEXT
          )
        ''');
      }
    );
    return _db;
  }


  /// ------------------------ insert ------------------------

  Future<int> insertMemoData(MemoTable memoTable) async {
    final _db = await database;
    final result = await _db.insert(
      'memo',
      memoTable.insertMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    return result;
  }

  Future<int> insertTagData(TagTable tagTable) async {
    final _db = await database;
    final result = await _db.insert(
        'tag',
        tagTable.insertMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return result;
  }


  /// ------------------------ query ------------------------

  Future<List<Map<String, dynamic>>> queryMemoData(int parentId) async {
    final _db = await database;
    List<Map<String, dynamic>> allMemoData = await _db.query('memo');
    List<Map<String, dynamic>> extractedData = allMemoData
        .where((value) => value[MemoTable.memoParentId] == parentId)
        .toList();
    return extractedData;
  }

  Future<Map<String, dynamic>> queryOneMemoData(int memoId) async {
    final _db = await database;
    List<Map<String, dynamic>> allMemoData = await _db.query('memo');
    List<Map<String, dynamic>> extractedData = allMemoData
        .where((value) => value[MemoTable.memoId] == memoId)
        .toList();
    return extractedData.first;
  }

  Future<List<Map<String, dynamic>>> queryTagData() async {
    final _db = await database;
    List<Map<String, dynamic>> allMemoData = await _db.query('tag');
    return allMemoData;
  }


  /// ------------------------ update ------------------------

  Future<int> updateMemoData(MemoTable memoTable) async {
    final _db = await database;
    final result = await _db.update(
      'memo',
      memoTable.updateMap(),
      where: '${MemoTable.memoId} = ?',
      whereArgs: [memoTable.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<int> updateTagData(TagTable tagTable) async {
    final _db = await database;
    final result = await _db.update(
      'tag',
      tagTable.updateMap(),
      where: '${TagTable.tagId} = ?',
      whereArgs: [tagTable.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }


  /// ------------------------ delete ------------------------

  Future<void> deleteMemoData(int memoId) async {
    final _db = await database;
    await _db.delete(
        'memo',
        where: '${MemoTable.memoId} = ?',
        whereArgs: [memoId]
    );
  }

  Future<void> deleteTagData(int tagId) async {
    final _db = await database;
    await _db.delete(
        'tag',
        where: '${TagTable.tagId} = ?',
        whereArgs: [tagId]
    );
  }


}
