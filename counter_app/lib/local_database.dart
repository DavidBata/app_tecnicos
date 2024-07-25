import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path/path.dart';

class LocalDataBase {
  LocalDataBase._privateConstructor();
  static final LocalDataBase instance = LocalDataBase._privateConstructor();

  static Database? _database;

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'base_datolocal.db');
    print('Database path: $path'); // Verificar la ruta de la base de datos
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      // Para `sqflite_common_ffi` y `sqflite_common_ffi_web`, no se necesita especificar factory aquí
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    print('Database initialized'); // Verificar que la base de datos se ha inicializado
    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    print('Creando tablas'); // Verificar la creación de tablas
    // socios "Productores"

    await db.execute(
      'CREATE TABLE IF NOT EXISTS c_bpartner (c_bpartner_id INTEGER PRIMARY KEY, ad_user_id INTEGER, name TEXT, FOREIGN KEY (ad_user_id) REFERENCES c_bpartner(ad_user_id))'
    );
    // fincas
    await db.execute(
      'CREATE TABLE IF NOT EXISTS farms_ranches (fap_farm_id INTEGER PRIMARY KEY, c_bpartner_id INTEGER, ad_user_id INTEGER, name TEXT, FOREIGN KEY (c_bpartner_id) REFERENCES c_bpartner(c_bpartner_id))'
    );
    // ciclo
    await db.execute(
      'CREATE TABLE IF NOT EXISTS fap_plantingcycle (fap_plantingcycle_id INTEGER PRIMARY KEY, name TEXT)'
    );
    // usuario
    await db.execute(
      'CREATE TABLE IF NOT EXISTS ad_user (ad_user_id INTEGER PRIMARY KEY,  username TEXT, email TEXT,  password TEXT,  adempiere_user TEXT)'
    );
    // lotes de la finca
    await db.execute(
      'CREATE TABLE IF NOT EXISTS fap_farmdivision  (fap_farmdivision_id INTEGER PRIMARY KEY, fap_farm_id INTEGER, name TEXT, area  FLOAT, FOREIGN KEY (fap_farm_id) REFERENCES farms_ranches(fap_farm_id))'
    );
    // sub lotes
    await db.execute(
      'CREATE TABLE IF NOT EXISTS fap_farmdivisionchild  (fap_farmdivisionchild_id INTEGER PRIMARY KEY, fap_farmdivision_id INTEGER, name TEXT, area  FLOAT, FOREIGN KEY (fap_farmdivision_id) REFERENCES fap_farmdivision(fap_farmdivision_id))'
    );
    // Productos
    await db.execute(
      'CREATE TABLE IF NOT EXISTS m_product  (m_product_id INTEGER PRIMARY KEY, name TEXT,  is_finca INTEGER)'
    );

      // PRODUCT EN ALMACENES 
    await db.execute(
      'CREATE TABLE IF NOT EXISTS m_warehouse  (m_warehoselocal_id INTEGER PRIMARY KEY, m_warehouse_id INTEGER, name TEXT,  m_product_id INTEGER, m_product_category_id INTEGER,  FOREIGN KEY (m_product_category_id) REFERENCES m_product_category(m_product_category_id))'
    );

    // PRODUCT EN CATEGORIA   
    await db.execute(
      'CREATE TABLE IF NOT EXISTS m_product_category  (m_product_category_id INTEGER PRIMARY KEY, name TEXT)'
    );

    // ETAPA DEL  /// ETAPA 
     await db.execute(
      'CREATE TABLE IF NOT EXISTS fap_farmingstage (fap_farmingstage_id INTEGER PRIMARY KEY, name TEXT, m_product_id INTEGER, seqno INTEGER, FOREIGN KEY (m_product_id) REFERENCES m_product(m_product_id))'
    );
    // CULTIVO 
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS fap_farming  (fap_farming_id INTEGER PRIMARY KEY, name TEXT, m_product_id INTEGER, product_name TEXT, 
      fap_farm_id INTEGER, 
      fap_plantingcycle_id INTEGER, 
      c_bpartner_id INTEGER, 
      fap_farmdivision_id INTEGER , 
      FOREIGN KEY (fap_farm_id) REFERENCES farms_ranches(fap_farm_id),
      FOREIGN KEY (fap_plantingcycle_id) REFERENCES fap_plantingcycle(fap_plantingcycle_id),
      FOREIGN KEY (c_bpartner_id) REFERENCES c_bpartner(c_bpartner_id),
      FOREIGN KEY (fap_farmdivision_id) REFERENCES fap_farmdivision(fap_farmdivision_id),
      FOREIGN KEY (m_product_id) REFERENCES m_product(m_product_id)
      )
      '''
      
    );
    // EVENTO DE CULTIVO
     await db.execute(
      'CREATE TABLE IF NOT EXISTS fap_symptomatology  (fap_symptomatology_id INTEGER PRIMARY KEY, name TEXT, symptomatologytype TEXT)'
    );

    // Tipo de Observacion
    await db.execute(
      'CREATE TABLE IF NOT EXISTS fap_observationtype  (fap_observationtype_id INTEGER PRIMARY KEY, name TEXT, value TEXT)'
    );


  // -----------------------------------------------TABLAS DE TRANSACCIONALES---------------------------------------------------------------
    //  HOJA TECNICA 
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS fap_technicalform 
      (fap_technicalform_id INTEGER PRIMARY KEY, 
      fap_technicalform_ade_id INTEGER UNIQUE,
      ad_user_id INTEGER, 
      c_bpartner_id INTEGER,
      fap_farm_id INTEGER,
      fap_plantingcycle_id INTEGER,
      date_created DATE,
      m_product_id INTEGER,
      synced INTEGER, 
      FOREIGN KEY (fap_farm_id) REFERENCES farms_ranches(fap_farm_id),
      FOREIGN KEY (fap_plantingcycle_id) REFERENCES fap_plantingcycle(fap_plantingcycle_id),
      FOREIGN KEY (m_product_id) REFERENCES m_product(m_product_id),
      FOREIGN KEY (c_bpartner_id) REFERENCES c_bpartner(c_bpartner_id)
      )'''

    );
    // HOJA TECNICA 

    // DETALLE DE HOJA
    await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS fap_technicalformline  
      (fap_technicalformline_id INTEGER PRIMARY KEY, 
      fap_technicalform_id INTEGER,
      fap_technicalform_ade_id INTEGER,
      fap_technicalformline_ade_id INTEGER UNIQUE,
      fap_farm_id INTEGER,
      fap_observationtype_id INTEGER,
      fap_farming_id INTEGER,
      fap_farmdivision_id INTEGER,
      fap_farmdivisionchild_id INTEGER,
      fap_farmingstage_id INTEGER,
      date_created DATE,
      synced INTEGER, 
      FOREIGN KEY (fap_technicalform_id ) REFERENCES fap_technicalform(fap_technicalform_id),
      FOREIGN KEY (fap_technicalform_ade_id) REFERENCES fap_technicalform(fap_technicalform_ade_id),
      FOREIGN KEY (fap_farming_id) REFERENCES fap_farming(fap_farming_id),
      FOREIGN KEY (fap_farmdivision_id) REFERENCES fap_farmdivision(fap_farmdivision_id),
      FOREIGN KEY (fap_farmdivisionchild_id) REFERENCES fap_farmdivisionchild(fap_farmdivisionchild_id),
      FOREIGN KEY (fap_observationtype_id) REFERENCES fap_observationtype(fap_observationtype_id),
      FOREIGN KEY (fap_farmingstage_id) REFERENCES fap_farmingstage(fap_farmingstage_id)
      )'''

    );
    // DETALLE DE HOJA

    // MANEJO DE CULTIVO
        await db.execute(
      '''
      CREATE TABLE IF NOT EXISTS fap_htsymptomatology   
      (fap_htsymptomatology_id INTEGER PRIMARY KEY, 
      fap_technicalformline_id INTEGER,
      fap_technicalformline_ade_id INTEGER,
      fap_htsymptomatology_ade_id INTEGER UNIQUE,
      fap_symptomatology_id INTEGUER,
      symptomatologytype TEXT,
      m_product_id INTEGER,
      m_warehouse_id IANTEGER,
      date_aplicarion_pro DATE,
      quantity_apply IANTEGER ,
      dose_area INTEGER,
      observacion TEXT,
      date_created DATE,
      synced INTEGER, 
      FOREIGN KEY (fap_technicalformline_id ) REFERENCES fap_technicalformline(fap_technicalformline_id),
      FOREIGN KEY (fap_technicalformline_ade_id) REFERENCES fap_technicalformline(fap_technicalformline_ade_id),
      FOREIGN KEY (fap_symptomatology_id) REFERENCES fap_symptomatology(fap_symptomatology_id),
      FOREIGN KEY (m_product_id) REFERENCES m_product(m_product_id)
      )'''
    // MANEJO DE CULTIVO
    );
    print('Tablas creadas'); // Verificar que las tablas se han creado
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }
}
