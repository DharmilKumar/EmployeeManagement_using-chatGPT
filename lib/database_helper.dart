import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();



  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB('employee_database.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);

  }
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add any migration or table creation for the new version
      await db.execute('''
      CREATE TABLE leaves(
        id INTEGER PRIMARY KEY,
        employeeId INTEGER,
        startDate TEXT,
        endDate TEXT,
        reason TEXT,
        isApproved INTEGER DEFAULT 0
      )
    ''');
    }
  }
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees(
        id INTEGER PRIMARY KEY,
        employeeNumber TEXT,
        name TEXT,
        email TEXT,
        password TEXT,
        contactNumber TEXT,
        gender TEXT,
        city TEXT,
        dateOfBirth TEXT,
        designation TEXT,
        salary REAL,
        isApproved INTEGER DEFAULT 0
      )
    ''');


  }

  Future<int> insertLeaveApplication(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db!.insert('leaves', row);
  }

  // Method to insert an employee record
  Future<int> insertEmployee(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db!.insert('employees', row);
  }

  // Method to get pending registration requests
  Future<List<Map<String, dynamic>>> getPendingRegistrationRequests() async {
    final db = await instance.database;
    return await db!
        .query('employees', where: 'isApproved = ?', whereArgs: [0]);
  }

  // Method to update the approval status of an employee
  Future<void> updateEmployeeApproval(int id, bool isApproved) async {
    final db = await instance.database;
    await db!.update(
      'employees',
      {'isApproved': isApproved ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>> getEmployeeById(int id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return {};
    }
  }


  Future<Map<String, dynamic>> getEmployeeByEmail(String email) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db!.query(
      'employees',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {};
    }
  }


  Future<List<Map<String, dynamic>>> getPendingLeaveApplications(int employeeId) async {
    final db = await instance.database;
    return await db!.query('leaves', where: 'employeeId = ? AND isApproved = ?', whereArgs: [employeeId, 0]);
  }


  // Method to get leave applications for a specific employee
  Future<List<Map<String, dynamic>>> getLeaveApplications(int employeeId) async {
    final db = await instance.database;
    return await db!.query('leaves', where: 'employeeId = ?', whereArgs: [employeeId]);
  }
  Future<List<Map<String, dynamic>>> getAllEmployees() async {
    final Database? db = await instance.database;
    return await db!.query('employees');
  }
  Future<void> updateEmployeeSalary(int employeeId, double newSalary) async {
    final db = await instance.database;
    await db!.update(
      'employees',
      {'salary': newSalary},
      where: 'id = ?',
      whereArgs: [employeeId],
    );
  }
}
