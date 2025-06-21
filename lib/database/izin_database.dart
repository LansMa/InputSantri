import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/izin_model.dart';

class IzinDatabase {
  static Database? _db;

  static Future<Database> _getDb() async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'izin_santri.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE izin (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            kamar TEXT,
            tujuan TEXT,
            tanggal TEXT,
            status TEXT, 
          )
        ''');
      },
    );
    return _db!;
  }

  static Future<void> insertIzin(Izin izin) async {
    final db = await _getDb();
    await db.insert(
      'izin',
      izin.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Izin>> getAllIzin() async {
    final db = await _getDb();
    final result = await db.query('izin');
    return result.map((e) => Izin.fromMap(e)).toList();
  }

  static Future<void> updateIzin(int id, Izin izin) async {
    final db = await _getDb();
    await db.update('izin', izin.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteIzin(int id) async {
    final db = await _getDb();
    await db.delete('izin', where: 'id = ?', whereArgs: [id]);
  }
}
