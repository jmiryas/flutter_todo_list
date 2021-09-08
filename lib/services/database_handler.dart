import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/todo_model.dart';
import '../models/category_model.dart';

class DatabaseHandler {
  void _createDB(Database db) {
    db.execute(
      "CREATE TABLE IF NOT EXISTS categories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT NOT NULL)",
    );

    db.execute(
      "CREATE TABLE IF NOT EXISTS todos(id INTEGER PRIMARY KEY AUTOINCREMENT, todo TEXT NOT NULL, description TEXT NOT NULL, date TEXT NOT NULL, category TEXT NOT NULL)",
    );
  }

  Future<Database> initializeDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "db_todolist.db");

    // await deleteDatabase(path);

    // String path = await getDatabasesPath();

    return await openDatabase(
      path,
      onCreate: (db, version) async {
        _createDB(db);
      },
      version: 1,
    );
  }

  // Category

  Future<int> insertCategory(CategoryModel categoryModel) async {
    int result = 0;

    final Database db = await initializeDB();

    result = await db.insert('categories', categoryModel.toMap());

    return result;
  }

  Future<List<CategoryModel>> retrieveCategories() async {
    final Database db = await initializeDB();

    final List<Map<String, dynamic>> queryResult = await db.query('categories');

    return queryResult.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<int> updateCategory(CategoryModel categoryModel) async {
    int result = 0;

    final Database db = await initializeDB();

    result = await db.update("categories", categoryModel.toMap(),
        where: "id = ?", whereArgs: [categoryModel.id]);

    return result;
  }

  Future<int> deleteCategory(int id) async {
    int result = 0;

    final Database db = await initializeDB();

    result = await db.delete(
      "categories",
      where: "id = ?",
      whereArgs: [id],
    );

    return result;
  }

  // End of category

  // CRUD Todo

  Future<int> insertTodo(TodoModel todoModel) async {
    int result = 0;

    final Database db = await initializeDB();

    result = await db.insert('todos', todoModel.toMap());

    return result;
  }

  Future<List<TodoModel>> retrieveTodos() async {
    final Database db = await initializeDB();

    final List<Map<String, dynamic>> queryResult =
        await db.query('todos', orderBy: "category ASC");

    return queryResult.map((e) => TodoModel.fromMap(e)).toList();
  }

  Future<int> deleteTodo(int id) async {
    int result = 0;

    final Database db = await initializeDB();

    result = await db.delete(
      "todos",
      where: "id = ?",
      whereArgs: [id],
    );

    return result;
  }

  // End of todo
}
