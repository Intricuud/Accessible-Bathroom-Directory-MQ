import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bathrooms.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE bathrooms (
      id TEXT PRIMARY KEY,
      building TEXT,
      level TEXT,
      manual_auto TEXT,
      grab_bar TEXT,
      paper_towel_air_dryer TEXT,
      shower TEXT,
      notes TEXT
    )
    ''');
  }

  Future<void> clearBathrooms() async {
    final db = await database;
    await db.delete('bathrooms');
  }

  Future<void> updateBathroomsFromJson() async {
    final db = await database;

    // Clear existing data
    await clearBathrooms();

    // Read JSON file
    String jsonString = await rootBundle.loadString('assets/bathrooms.json');
    final data = json.decode(jsonString) as Map<String, dynamic>;

    // Insert new data into database
    await db.transaction((txn) async {
      for (var building in data.keys) {
        for (var bathroom in data[building]) {
          await txn.insert(
              'bathrooms',
              {
                'id': bathroom['id'],
                'building': bathroom['Building'],
                'level': bathroom['Level'],
                'manual_auto': bathroom['Manual/Auto'],
                'grab_bar': bathroom['Grab Bar'],
                'paper_towel_air_dryer': bathroom['Paper Towel/Air Dryer'],
                'shower': bathroom['Shower'],
                'notes': bathroom['Notes'],
              },
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    });
    print('Data updated successfully');
  }

  Future<List<String>> getAllBuildings() async {
    final db = await database;
    final result =
        await db.query('bathrooms', distinct: true, columns: ['building']);
    return result.map((row) => row['building'] as String).toList();
  }

  Future<List<Map<String, dynamic>>> getBathroomsByBuilding(
      String building) async {
    final db = await database;
    return db.query('bathrooms', where: 'building = ?', whereArgs: [building]);
  }

  Future<List<String>> getAllBuildingsSorted() async {
    final db = await database;
    final result = await db.query(
      'bathrooms',
      distinct: true,
      columns: ['building'],
      orderBy: 'building ASC', // This sorts the buildings alphabetically
    );
    return result.map((row) => row['building'] as String).toList();
  }
}
