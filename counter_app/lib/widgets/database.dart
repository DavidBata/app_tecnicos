import 'package:counter_app/models/siembra.dart';
import 'package:postgres/postgres.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<PostgreSQLConnection> connectToDatabase() async {
    try {
      return await connect();
    } catch (e) {
      print('Error al conectar a la base de datos: $e');
      // Devuelve null o lanza una excepción según lo que prefieras en caso de error
      throw e;
    }
  }

  Future<PostgreSQLConnection> connect() async {
    var connection = PostgreSQLConnection(
      //'vmdockerbd',
      // 'oryzaprod',
      // 'losroques',
      '192.168.254.60',
      5434,
      'adempiere',
      username: 'adempiere',
      password: 'ad3mp13r3sf1d4.*',
    );

    try {
      await connection.open();
      print('Conexión exitosa a la base de datos PostgreSQL');
    } catch (e) {
      print('Error al conectar a la base de datos: $e');
      rethrow;
    }

    return connection;
  }

  Future<Map<String, dynamic>?> buscarUsuario() async {
    PostgreSQLConnection connection = await connectToDatabase();

    try {
      var results = await connection.query(
        "SELECT usr.name, usr.value FROM AD_User AS usr WHERE usr.name = 'ACortez' AND usr.value = 'ACortez' AND usr.isactive = 'Y' LIMIT 1",
      );
      if (results.isNotEmpty) {
        return {
          'name': results.first[0],
          'value': results.first[1],
        };
      } else {
        return null;
      }
    } catch (e) {
      print('Error al ejecutar la consulta: $e');
      rethrow;
    } finally {
      await connection.close();
    }
  }

  Future<List<String>> getCultivo() async {
    PostgreSQLConnection connection = await connectToDatabase();

    final List<String> cultivo = [];

    try {
      final result = await connection.query('SELECT * FROM adempiere.c_bpartner LIMIT 6');

      for (final row in result) {
        cultivo.add(row[8]);
        print(row[8]);
      }
      print('Datos traídos correctamente');
    } catch (e) {
      print('Error al obtener Socio del Negocio: $e');
    } finally {
      await connection.close();
    }
    return cultivo;
  }

  Future<List<dynamic>> getSocioDelNegocio(int nombreUsuario) async {
    PostgreSQLConnection connection = await connectToDatabase();

    final List<SocioDeNegocio> socioDelNegocio = [];
    try {
      final result = await connection.query(
        'SELECT DISTINCT cbp.c_bpartner_id, cbp."value", cbp.name '
        'FROM AD_User AS usr '
        'JOIN c_bpartner AS cbp ON cbp.salesrep_id=usr.ad_user_id AND cbp.isfarmer=\'Y\' '
        'WHERE usr.ad_user_id=@name AND usr.isactive=\'Y\'',
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
    } finally {
      await connection.close();
    }

    return socioDelNegocio;
  }

  Future<List<String>> getCiclosDeSiembraFromDatabase() async {
    PostgreSQLConnection connection = await connectToDatabase();

    final List<String> cicloSiem = [];

    try {
      final result = await connection.query('SELECT * FROM c_bpartner LIMIT 6');

      for (final row in result) {
        // Asegúrate de que el valor en la posición 9 sea de tipo String
        if (row[9] is String) {
          cicloSiem.add(row[9] as String);
          print(row[9]);
        }
      }
      print('Datos traídos correctamente Contenido de ciclo siembra: $cicloSiem');
    } catch (e) {
      print('Error al obtener ciclos de siembra: $e');
    } finally {
      await connection.close();
    }

    return cicloSiem;
  }
}
