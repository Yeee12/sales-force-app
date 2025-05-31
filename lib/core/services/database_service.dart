//database
import 'package:sales_force_automation/core/models/customer_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/visit.dart';
import '../models/activity.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'visits_tracker.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE visits(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        visit_date TEXT NOT NULL,
        status TEXT NOT NULL,
        location TEXT NOT NULL,
        notes TEXT NOT NULL,
        activities_done TEXT NOT NULL,
        created_at TEXT,
        is_local INTEGER DEFAULT 1,
        synced INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE activities(
        id INTEGER PRIMARY KEY,
        description TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertVisit(Visit visit) async {
    final db = await database;
    final visitData = visit.toLocalJson();
    visitData['is_local'] = visit.isLocal ? 1 : 0;
    visitData['synced'] = 0;
    return await db.insert('visits', visitData);
  }

  Future<List<Visit>> getLocalVisits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('visits');

    return List<Visit>.from(
      maps.map((map) {
        final mutableMap = Map<String, dynamic>.from(map); // 🔧 make it writable

        if (mutableMap['activities_done'] is String) {
          String activitiesStr = mutableMap['activities_done'].toString();
          mutableMap['activities_done'] =
          activitiesStr.isEmpty ? [] : activitiesStr.split(',');
        }

        mutableMap['is_local'] = mutableMap['is_local'] == 1;

        return Visit.fromJson(mutableMap);
      }),
    );
  }


  Future<List<Visit>> getUnsyncedVisits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'visits',
      where: 'synced = ? AND is_local = ?',
      whereArgs: [0, 1],
    );

    return List<Visit>.from(
      maps.map((map) {
        final mutableMap = Map<String, dynamic>.from(map); // 🔧 make it mutable

        if (mutableMap['activities_done'] is String) {
          String activitiesStr = mutableMap['activities_done'].toString();
          List<String> activitiesList = <String>[];
          if (activitiesStr.isNotEmpty) {
            activitiesList.addAll(
              activitiesStr.split(',').map((e) => e.trim()),
            );
          }
          mutableMap['activities_done'] = activitiesList;
        }

        mutableMap['is_local'] = mutableMap['is_local'] == 1;

        return Visit.fromJson(mutableMap);
      }),
    );
  }


  Future<void> markVisitAsSynced(int localId) async {
    final db = await database;
    await db.update(
      'visits',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [localId],
    );
  }

  Future<void> insertCustomers(List<Customer> customers) async {
    final db = await database;
    final batch = db.batch();
    for (final customer in customers) {
      batch.insert(
        'customers',
        customer.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<Customer>> getLocalCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return List<Customer>.from(maps.map((map) => Customer.fromJson(map)));
  }

  // Activity operations
  Future<void> insertActivities(List<Activity> activities) async {
    final db = await database;
    final batch = db.batch();
    for (final activity in activities) {
      batch.insert(
        'activities',
        activity.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<Activity>> getLocalActivities() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('activities');
    return List<Activity>.from(maps.map((map) => Activity.fromJson(map)));
  }
}
