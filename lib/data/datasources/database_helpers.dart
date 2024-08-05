import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_cgi/domain/enitites/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE tasks(
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      isCompleted INTEGER NOT NULL
    )
    ''');
  }

  Future<List<Task>> getTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((json) => Task(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] == 1,
    )).toList();
  }

  Future<void> insertTask(Task task) async {
    final db = await instance.database;
    await db.insert('tasks', {
      'id': task.id,
      'title': task.title,
      'isCompleted': task.isCompleted ? 1 : 0,
    });
  }

  Future<void> updateTask(Task task) async {
    final db = await instance.database;
    await db.update(
      'tasks',
      {
        'title': task.title,
        'isCompleted': task.isCompleted ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await instance.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}