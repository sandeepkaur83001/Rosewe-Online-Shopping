import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<void> printAllDrafts() async {
    final db = await database;
    final res = await db.query('drafts');
    for (final row in res) {
      print('📄 Draft -> chatId: ${row['chatId']}, message: ${row['message']}, updatedAt: ${row['updatedAt']}');
    }
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat_drafts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE drafts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            chatId TEXT UNIQUE,
            message TEXT,
            updatedAt TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveDraft(String chatId, String message) async {
    final db = await database;
    await db.insert(
      'drafts',
      {
        'chatId': chatId,
        'message': message,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace existing draft
    );
  }

  Future<String?> getDraft(String chatId) async {
    final db = await database;
    final res = await db.query(
      'drafts',
      where: 'chatId = ?',
      whereArgs: [chatId],
    );
    if (res.isNotEmpty) return res.first['message'] as String?;
    return null;
  }

  Future<void> deleteDraft(String chatId) async {
    final db = await database;
    await db.delete('drafts', where: 'chatId = ?', whereArgs: [chatId]);
  }

  Future<void> clearAllDrafts() async {
    final db = await database;
    await db.delete('drafts');
  }
}
