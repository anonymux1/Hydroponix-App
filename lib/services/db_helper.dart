import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/System.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('hydroponics.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE systems_list (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        systemId TEXT NOT NULL,
        Name TEXT NOT NULL,
        version TEXT NOT NULL,
        switches INTEGER NOT NULL,
        heavySwitches INTEGER NOT NULL,
        peristalticPumpsCount INTEGER NOT NULL,      
        sensorType TEXT NOT NULL, // comma separated SensorType in enum SensorType { EC, pH, temp, DO, ambientTemp, ambientHumidity }
        ssid TEXT NOT NULL,
        password TEXT NOT NULL,
        waterPumpDuration INTEGER NOT NULL,
        airPumpDuration INTEGER NOT NULL,
        waterPumpInterval INTEGER NOT NULL,
        airPumpInterval INTEGER NOT NULL,
        phMax real NOT NULL,
        phMin real NOT NULL,
        nutrientTempMax real NOT NULL,
        nutrientTempMin real NOT NULL,
        ambientTempMax real NOT NULL,
        ambientTempMin real NOT NULL,
        )
    ''');

    await db.execute('''
      CREATE TABLE system_modules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        systemId TEXT NOT NULL, 
        moduleType TEXT NOT NULL, //moduleType in enum ModuleType { airPump, waterPump, nutrientHeater, nutrientChiller, desertAirCooler, humidifier, AC, ledLights, uvSterilizer }
        moduleSwitchNum int NOT NULL,
        FOREIGN KEY (systemId) REFERENCES systems_list(systemId) 
      )
    ''');

    await db.execute('''
      CREATE TABLE system_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        systemId TEXT NOT NULL, 
        timestamp TEXT NOT NULL, 
        eventType TEXT, //eventType in Sensor, Module 
        dataType TEXT, //SensorType or ModuleType 
        eventData TEXT //Sensor Reading or Module ON/OFF  
      )
    ''');
  }

  Future<Map<String, dynamic>?> queryRow(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await instance.database;
    final rows =
        await db.query(table, where: where, whereArgs: whereArgs, limit: 1);
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<List<T>> queryColumn<T>(
      String table,
      String column, {
        String? where,
        List<dynamic>? whereArgs,
        String? groupBy,
        String? having,
        String? orderBy,
        bool distinct = false,
        int? limit,
        int? offset,
      }) async {
    final db = await database;
    final result = await db.query(
      table,
      columns: [column],
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      distinct: distinct,
      limit: limit,
      offset: offset,
    );
    return result.map((row) => row[column] as T).toList();
  }

  Future<int> insertRow(String table, Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(table, row);
  }

  Future<int> deleteRow(String table, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
}
