import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'profitly.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN full_name TEXT');
      await db.update('users', {'full_name': 'Administrator'}, where: 'username = ?', whereArgs: ['admin']);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT,
        email TEXT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');

    // Pre-populate dummy account (Akun Bawaan)
    await db.insert('users', {
      'full_name': 'Administrator',
      'email': 'admin@profitly.com',
      'username': 'admin',
      'password': 'password123',
    });
  }

  // --- CRUD Operations for Users ---

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<bool> registerUser(String fullName, String email, String username, String password) async {
    final db = await database;
    try {
      await db.insert(
        'users',
        {
          'full_name': fullName,
          'email': email,
          'username': username,
          'password': password,
        },
        conflictAlgorithm: ConflictAlgorithm.abort, // will throw exception if username exists
      );
      return true;
    } catch (e) {
      // e.g., Username already exists
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }
  
  Future<bool> checkUsernameExists(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return results.isNotEmpty;
  }
}
