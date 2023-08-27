import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LeavesDatabaseHelper {
  static final LeavesDatabaseHelper instance = LeavesDatabaseHelper._init();
  static Database? _database;

  LeavesDatabaseHelper._init();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB('leaves_database.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
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

  // Insert a leave application into the database
  Future<int> insertLeaveApplication(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db!.insert('leaves', row);
  }

  // Get leave applications for a specific employee
  Future<List<Map<String, dynamic>>> getLeaveApplications(int employeeId) async {
    final db = await instance.database;
    return await db!.query('leaves', where: 'employeeId = ?', whereArgs: [employeeId]);
  }

  // Update the approval status of a leave application
  Future<void> updateLeaveApproval(int id, int isApproved) async {
    final db = await instance.database;
    await db!.update(
      'leaves',
      {'isApproved': isApproved},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
