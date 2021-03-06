import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tugas_crud_sqflite/model/model_mahasiswa.dart';
import 'package:tugas_crud_sqflite/model/model_user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database _database;

  final String tableName = 'tableMahasiswa';
  final String columnId = 'id';
  final String columnFirstName = 'firstName';
  final String columnLastName = 'lastName';
  final String columnJurusan = 'jurusan';
  final String columnMobileNumber = 'mobileNumber';
  final String columnEmail = 'email';

  final String tableName2 = 'tableUser';
  final String column2Id = 'id';
  final String column2Username = 'username';
  final String column2Password = 'password';
  final String column2Email = 'email';

  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Future<Database> get _db async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDb();
    return _database;
  }

  Future<Database> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'flutter_sqlite.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    var sql = "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, "
        "$columnFirstName TEXT , "
        "$columnLastName TEXT , "
        "$columnJurusan TEXT , "
        "$columnMobileNumber TEXT , "
        "$columnEmail TEXT)";

    var sql2 = "CREATE TABLE $tableName2($column2Id INTEGER PRIMARY KEY, "
        "$column2Username TEXT , "
        "$column2Password TEXT , "
        "$column2Email TEXT)";

    await db.execute(sql);
    await db.execute(sql2);
  }

  Future<int> saveMahasiswa(ModelMahasiswa mahasiswa) async {
    var dbClient = await _db;
    return await dbClient.insert(tableName, mahasiswa.toMap());
  }

  Future<int> saveUser(Modeluser user) async {
    var dbClient = await _db;
    int result = await dbClient.insert(tableName2, user.toMap());
    return result;
  }

  Future<Modeluser> checkLogin(String email, String password) async {
    var dbClient = await _db;
    var result = await dbClient.rawQuery(
        "SELECT * FROM $tableName2 WHERE email = '$email' AND password = '$password'");

    if (result.length > 0) {
      return Modeluser.fromMap(result.first);
    }
    return null;
  }

  // Future<List> getAllUser() async {

  // }

  Future<List> getAllMahasiswa() async {
    var dbClient = await _db;
    var result = await dbClient.query(tableName, columns: [
      columnId,
      columnFirstName,
      columnLastName,
      columnJurusan,
      columnMobileNumber,
      columnEmail,
    ]);

    return result.toList();
  }

  Future<int> updateMahasiswa(ModelMahasiswa mahasiswa) async {
    var dbClient = await _db;
    return await dbClient.update(
      tableName,
      mahasiswa.toMap(),
      where: '$columnId = ?',
      whereArgs: [mahasiswa.id],
    );
  }

  Future<int> deleteMahasiswa(int id) async {
    var dbClient = await _db;
    return await dbClient.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
