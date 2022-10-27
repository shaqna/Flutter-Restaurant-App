import 'package:flutter_restaurant_app/data/model/restaurant.dart';
import 'package:flutter_restaurant_app/utils/strings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static late Database _database;
  static LocalDatabase? _localDatabase;
  static const String _tableName = 'restaurant';

  LocalDatabase._internal() {
    _localDatabase = this;
  }

  factory LocalDatabase() => _localDatabase ?? LocalDatabase._internal();

  Future<Database> _initDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'restaurant.db'),
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE $_tableName (
              id TEXT PRIMARY KEY,
              name TEXT,
              description TEXT,
              pictureId TEXT,
              city TEXt,
              rating DOUBLE
            )
          ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database> get database async {
    _database = await _initDb();
    return _database;
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    final Database db = await database;
    await db.insert(_tableName, restaurant.toJson());
  }

  Future<Restaurant> getRestaurantById(String id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results =
        await db.query(_tableName, where: 'id = ?', whereArgs: [id]);

    if (results.isEmpty) {
      throw emptyRestaurantMessage;
    } else {
      return results.map((restaurant) => Restaurant.fromJson(restaurant)).first;
    }
  }

  Future<List<Restaurant>> getRestaurants() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);
    return results
        .map((restaurant) => Restaurant.fromJson(restaurant))
        .toList();
  }

  Future<void> deleteFavorite(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(String id) async {
    try {
      await getRestaurantById(id);
      return true;
    } catch (error) {
      return false;
    }
  }
}
