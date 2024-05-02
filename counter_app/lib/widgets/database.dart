// Importaciones necesarias
import 'package:counter_app/models/siembra.dart';
import 'package:postgres/postgres.dart';

// Clase DatabaseHelper para manejar la conexión y las consultas a la base de datos
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  PostgreSQLConnection? _connection;
  PostgreSQLConnection? get connection => _connection;

  // Método para conectarse a la base de datos
  Future<PostgreSQLConnection> connectToDatabase() async {
    try {
      _connection = await connect();
    } catch (e) {
      print('Error al conectar a la base de datos: $e');
      throw e;
    }
    return _connection!;
  }

  // Método privado para establecer la conexión a la base de datos
  Future<PostgreSQLConnection> connect() async {
    _connection = PostgreSQLConnection(
      //'vmdockerbd',
      '192.168.59.18',
      55323,
      'adempiere_yesterday',
      username: 'adempiere',
      password: 'adempiere'
    );

    try {
      await _connection!.open();
      print('Conexión exitosa a la base de datos PostgreSQL');
    } catch (e) {
      print('Error al conectar a la base de datos: $e');
      rethrow;
    }

    return _connection!;
  }

  // Método para obtener los ciclos de siembra desde la base de datos
  Future<List<String>> getCiclosDeSiembraFromDatabase(PostgreSQLConnection connection) async {
    final List<String> cicloSiem = [];

    try {
      final result = await connection.query('SELECT * FROM c_bpartner LIMIT 6');

      for (final row in result) {
        if (row[9] is String) {
          cicloSiem.add(row[9] as String);
          print(row[9]);
        }
      }
      print('Datos traídos correctamente Contenido de ciclo siembra: $cicloSiem');
    } catch (e) {
      print('Error al obtener ciclos de siembra: $e');
    }

    return cicloSiem;  
  }

  // Método para obtener información del socio del negocio
  Future<List<SocioDeNegocio>> getSocioDelNegocio(PostgreSQLConnection connection, String nombreUsuario) async {
    final List<SocioDeNegocio> socioDelNegocio = [];

    try {
      final result = await connection.query(
        'SELECT DISTINCT cbp.c_bpartner_id, cbp."value", cbp.name '
        'FROM AD_User AS usr '
        'JOIN c_bpartner AS cbp ON cbp.salesrep_id=usr.ad_user_id AND cbp.isfarmer=\'Y\' '
        'WHERE usr.name=@name AND usr.isactive=\'Y\'',
        substitutionValues: {'name': nombreUsuario},
      );

      for (final row in result) { 
        socioDelNegocio.add(
          SocioDeNegocio(
            id: row[0] as String,
            value: row[1] as String,
            name: row[2] as String,
          ),
        );
      }
      
      print('Datos traídos correctamente');
    } catch (e) {
      print('Error al obtener Socio del Negocio: $e');
    }

    return socioDelNegocio;
  }

  // Método para obtener las fincas relacionadas con un usuario
  Future<List<Fincas>> getFincas(PostgreSQLConnection connection, String nombreUsuario) async {
    final List<Fincas> fincasList = [];

    try {
      final result = await connection.query(
        'SELECT DISTINCT fap.fap_farm_id AS idFinca, fap.name AS finca '
        'FROM AD_User AS usr '
        'JOIN c_bpartner AS cbp ON cbp.salesrep_id = usr.ad_user_id AND cbp.isfarmer = \'Y\' '
        'JOIN fap_farm AS fap ON fap.c_bpartner_id = cbp.c_bpartner_id AND fap.isactive = \'Y\' '
        'WHERE usr.name = @name AND usr.isactive = \'Y\'',
        substitutionValues: {'name': nombreUsuario},
      );

      for (final row in result) {
        fincasList.add(
          Fincas.fromMap({
            'idFinca': row['id_productor'] as String,
            'finca': row['finca'] as String,
          }),
        );
      }
      print('Datos traídos correctamente');
    } catch (e) {
      print('Error al obtener las fincas: $e');
    }

    return fincasList;
  }

  // Método para obtener los cultivos desde la base de datos
  Future<List<String>> getCultivo(PostgreSQLConnection connection) async {
    final List<String> cultivo = [];

    try {
      final result = await connection.query('SELECT * FROM c_bpartner LIMIT 6');

      for (final row in result) {
        cultivo.add(row[8]);
        print(row[8]);
      }
      print('Datos traídos correctamente');
    } catch (e) {
      print('Error al obtener Socio del Negocio: $e');
    }
    return cultivo;
  }

  // Método para buscar un usuario en la base de datos
  Future<Login?> buscarUsuario(PostgreSQLConnection connection, String usuario, String password) async {
    Login? login;

    try {
      final result = await connection.query(
        'SELECT usr.name, usr.value FROM AD_User AS usr WHERE usr.name = @name AND usr.value = @value AND usr.isactive = \'Y\' LIMIT 1',
        substitutionValues: {'name': usuario, 'value': password},
      );

      if (result.isNotEmpty) {
        final row = result.first;
        final String usuario = row[0] as String;
        final String password = row[1] as String;

        login = Login(usuario, password, usuario);
        getSocioDelNegocio(connection, usuario);

        print('Usuario: $usuario, Contraseña: $password');
        print('Objeto creado: $login');
        print('Datos traídos correctamente $result Usuario: $usuario, Contraseña: $password');
        return login;
      } else {
        print('Usuario no encontrado');
        print('Datos traídos correctamente $result Usuario: $usuario, Contraseña: $password');
        return null;
      }
    } catch (e) {
      print('Error al obtener Socio del Negocio: $e');
    }

    // Devolvemos el usuario encontrado (puede ser null si no se encontraron datos)
    return login;
  }
}
