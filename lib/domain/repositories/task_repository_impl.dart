

import 'package:todo_cgi/data/datasources/database_helpers.dart';

import '../enitites/task.dart';
import 'task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<List<Task>> getTasks() async {
    return await _databaseHelper.getTasks();
  }

  @override
  Future<void> addTask(Task task) async {
    await _databaseHelper.insertTask(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await _databaseHelper.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _databaseHelper.deleteTask(id);
  }
}