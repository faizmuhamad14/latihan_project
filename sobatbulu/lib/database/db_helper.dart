import 'package:path/path.dart';
import 'package:sobatbulu_app/models/pet_model.dart';
import 'package:sobatbulu_app/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ppkd.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            nama TEXT,
            email TEXT UNIQUE,
            password TEXT,
            kota TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE pets(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            jenis TEXT,
            umur TEXT,
            ras TEXT,

            gender TEXT,
            berat INTEGER,
            tanggalLahir TEXT,
            tanggalAdop TEXT,

            catatan TEXT,
            ownerEmail TEXT,
            gambarPet TEXT
          )
        ''');
      },
    );
  }

  // CRUD User
  Future<bool> registerUser(UserModelSQL pengguna) async {
    final db = await database;

    try {
      await db.insert('users', pengguna.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModelSQL?> loginUser(String email, String password) async {
    final db = await database;

    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      return UserModelSQL.fromMap(results.first);
    }
    return null;
  }

  Future<List<UserModelSQL>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query('users');
    return results.map((map) => UserModelSQL.fromMap(map)).toList();
  }

  Future<void> deleteUser(String email) async {
    final db = await database;
    await db.delete('users', where: 'email = ?', whereArgs: [email]);
  }

  Future<bool> updateUser(UserModelSQL pengguna) async {
    final db = await database;
    try {
      int count = await db.update(
        'users',
        pengguna.toMap(),
        where: 'nama = ?',
        whereArgs: [pengguna.nama],
      );
      return count > 0;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserByEmail(String oldEmail, {String? nama, String? email, String? password}) async {
    final db = await database;
    try {
      final Map<String, dynamic> updates = {};
      if (nama != null) updates['nama'] = nama;
      if (email != null) updates['email'] = email;
      if (password != null) updates['password'] = password;

      if (updates.isEmpty) return false;

      int count = await db.update(
        'users',
        updates,
        where: 'email = ?',
        whereArgs: [oldEmail],
      );
      return count > 0;
    } catch (e) {
      return false;
    }
  }

  Future<UserModelSQL?> getUserByEmail(String email) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (results.isNotEmpty) {
      return UserModelSQL.fromMap(results.first);
    }
    return null;
  }

  //CRUD Petshop
  Future<int> insertPet(PetModel pet) async {
    print("INSERT DATA = ${pet.toMap()}");

    print("OWNER EMAIL = ${pet.ownerEmail}");
    final db = await database;
    return await db.insert('pets', pet.toMap());
  }

  Future<List<PetModel>> getAllPet() async {
    final db = await database;

    final result = await db.query('pets');

    return result.map((e) => PetModel.fromMap(e)).toList();
  }

  Future<void> deletePet(int id) async {
    final db = await database;

    await db.delete('pets', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updatePet(PetModel pet) async {
    final db = await database;

    await db.update('pets', pet.toMap(), where: 'id = ?', whereArgs: [pet.id]);
  }

  Future<void> feedPet(int id) async {
    final db = await database;

    await db.update('pets', {'isFed': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> drinkPet(int id) async {
    final db = await database;

    await db.update('pets', {'isDrink': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<PetModel>> getPetByUser(String email) async {
    final db = await database;

    final result = await db.query(
      'pets',
      where: 'ownerEmail = ?',
      whereArgs: [email],
    );

    return result.map((e) => PetModel.fromMap(e)).toList();
  }
}
