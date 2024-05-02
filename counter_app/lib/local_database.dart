//import 'dart:async';
//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';
//import 'package:counter_app/models/model_db_local.dart'; // Asegúrate de importar el modelo adecuado
//
//class LocalDatabase {
//  static final LocalDatabase instance = LocalDatabase._init();
//  static Database? _database;
//
//  LocalDatabase._init();
//
//  Future<Database> get database async {
//    if (_database != null) return _database!;
//    _database = await _initDB('local.db');
//    return _database!;
//  }
//
//  Future<Database> _initDB(String filePath) async {
//    final dbPath = await getDatabasesPath();
//    final path = join(dbPath, filePath);
//
//    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
//  }
//
//  Future<void> _onCreateDB(Database db, int version) async {
//    await db.execute('''
//      CREATE TABLE HojaTecnica(
//        tipoDocumento TEXT,
//        organizacion TEXT,
//        sociodelnegocio TEXT,
//        agentecomercial TEXT,
//        finca TEXT,
//        fecha date
//      )
//    ''');
//  }
// Future<void> insert(HojaTecnica hojaTecnica) async {
//    final db = await instance.database;
//    await db.insert(
//      'HojaTecnica', // Nombre de la tabla en tu base de datos
//      hojaTecnica.toMap(), // Convierte el objeto HojaTecnica a un mapa
//      conflictAlgorithm: ConflictAlgorithm.replace, // Opcional: maneja conflictos
//    );
//  }
//} 
//