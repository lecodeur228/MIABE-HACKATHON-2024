import 'dart:async';
import 'package:ctrl_r/models/controle.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ControleDatabase {
  static final ControleDatabase instance = ControleDatabase._init();

  static Database? _database;

  ControleDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('controles.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE controles(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  plaque TEXT,
  nom_conducteur TEXT,
  permit_conduire INTEGER,
  date_validite_carte_grise INTEGER,
  date_expiration INTEGER,
  carte_visite_technique INTEGER,
  assurance INTEGER,
  tvm INTEGER,
  matricule TEXT,
  latitude TEXT,
  longitude TEXT,
  created_at INTEGER,
  is_added INTEGER
)
    ''');
  }

Future<int> createControleInLocal(Controle controle) async {
  final db = await instance.database;
  
  // Exclure la clé 'id' de la map JSON
  Map<String, dynamic> controleJson = controle.toJson();
  controleJson.remove('id');
  
  final id = await db.insert('controles', controleJson);
  // Spécifier is_added sur 0 pour indiquer que la donnée est ajoutée localement
  await db.update('controles', {'is_added': 0}, where: 'id = ?', whereArgs: [id]);
  return id;
}


Future<int> createControleInApi(Controle controle) async {
  final db = await instance.database;
    Map<String, dynamic> controleJson = controle.toJson();
  controleJson.remove('id');
  final id = await db.insert('controles', controle.toJson());
  // Spécifier is_added sur 1 pour indiquer que la donnée est ajoutée localement après récupération depuis l'API
  await db.update('controles', {'is_added': 1}, where: 'id = ?', whereArgs: [id]);
  return id;
}


 Future<List<Controle>> getAllControlesAdd() async {
  final db = await instance.database;
  final List<Map<String, dynamic>> maps = await db.query('controles', where: 'is_added = ?', whereArgs: [0]);
  return List.generate(maps.length, (i) {
    return Controle.fromJson(maps[i]);
  });
}

Future<List<Controle>> getAllControles() async {
  final db = await instance.database;
  final List<Map<String, dynamic>> maps = await db.query('controles');
  return List.generate(maps.length, (i) {
    return Controle.fromJson(maps[i]);
  });
}



  Future<void> updateControle(Controle controle) async {
    final db = await instance.database;
    await db.update('controles', controle.toJson(),
        where: 'id = ?', whereArgs: [controle.id]);
  }

  Future<void> deleteControleOffline() async {
    final db = await instance.database;
    // Supprimer toutes les données pour lesquelles is_added est égal à 0
    await db.delete('controles', where: 'is_added = ?', whereArgs: [0]);
  }

  Future<void> deleteControleOnline() async {
    final db = await instance.database;
    await db.delete('controles');
  }

}
