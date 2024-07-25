import 'package:counter_app/local_database.dart';
import 'package:counter_app/models/siembra.dart';
import 'package:counter_app/screens/documentos.dart';
import 'package:counter_app/screens/register_screens.dart';
import 'package:counter_app/widgets/peticione_api.dart';
import 'package:counter_app/widgets/secion_usuario.dart';
import 'package:flutter/material.dart';
import 'package:counter_app/screens/ht_screens.dart';
import 'package:counter_app/widgets/database.dart'; // Importar el archivo database.dart
import 'package:postgres/postgres.dart';
import 'package:provider/provider.dart';


class LoginScreens extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreens({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<LoginScreens> {
  
  final _formKey1 = GlobalKey<FormState>();
  late DatabaseHelper _databaseHelper; // Declaración sin inicialización
  late PostgreSQLConnection _connection;
  final   TextEditingController _usuarioController = TextEditingController();
  final TextEditingController  _passwordController = TextEditingController();
  final con_api = Peticiones();
  List<dynamic> socios = [];
  
   bool _obscureText = true;
  
  @override
  void initState() {
    super.initState();
    
  // Inicialización en el método initState
  _databaseHelper = DatabaseHelper(); 
  _databaseHelper.connectToDatabase();
   
  }


  Future<List> user_id(int ad_user_id) async {
    
    List<dynamic> data_partner = await con_api.data_user_id(ad_user_id);
    
    return data_partner ;
  }
  
  Future<List>process_login() async {
    final db = await LocalDataBase.instance.database;
    try {
      var user= _usuarioController.text;
      var password=_passwordController.text;
      List<dynamic> user_local = await db.query('ad_user', where: " username = '$user' and password = '$password'");
      if (user_local.isEmpty) {
        print("No se encuentra el Usuario local");
        List<dynamic> search_user_adempiere = await con_api.search_user(user);   
        final insert = await insert_user_local(search_user_adempiere[0]);
        
        return search_user_adempiere;
      }else{
        
        print("USUARIO LOCAL ENTRANDO ");
       
        return user_local;
      }
      
    } catch (e) {
      print('Error inserting user: $e'); 
      throw e;
    } finally {
      print("LOG FINALIZADO ");
      // db.close();
    }
  }

  Future<void> insert_user_local(obj_user_adempiere) async {
    try {
      final db = await LocalDataBase.instance.database;
      List<dynamic> data = await db.query('ad_user');
      final  insert_base_datolocal = await db.insert('ad_user',  obj_user_adempiere as Map<String, Object?>);
      print('user inserted successfully'); 
    } catch (e) {
      print('Error inserting user: $e'); 
      throw e;
    }
  }


  Future<void> _inscert_user_local(user, password) async {
    try {
      final db = await LocalDataBase.instance.database;
      user = con_api.search_user(_usuarioController.text) ;
      print('Database instance: $db'); // Verificar que la base de datos está abierta
      await db.insert('ad_user',  user as Map<String, Object?>);
      print('user inserted successfully'); 
    } catch (e) {
      print('Error inserting user: $e'); 
      throw e;
    }
  }
  Future<List<dynamic>> login_user() async {
    // Llamar a la función para obtener las coordenadas de la API
    List<dynamic> newpartners = await con_api.login_user(_usuarioController.text, _passwordController.text);
    // Actualizar el estado con los nuevos vehículos obtenidos
    socios= newpartners;
    return socios;
    }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _cajaRoja(size),
            _logo(),
            _loginForm(context),
          ],
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Form(
      key: _formKey1,
      child: Column(
        children: [
          const SizedBox(height: 250),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 30,
                  offset: Offset(2, 7),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _usuarioController,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    labelText: 'Usuario',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'campo obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                   controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      hintText: '*******',
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'campo obligatorio';
                      }
                      return null;
                    },
                  ), 
                //const PasswordField(),
                const SizedBox(height: 20),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledColor: Colors.grey,
                  color: Colors.red,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: const Text(
                      'Ingresar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                // En tu función onPressed del botón de "Ingresar", llama a buscarUsuario
                  onPressed: () async {
                    if (_formKey1.currentState!.validate()) {
                      //  print(connection);
                      final usuario = await process_login();
                      print(usuario[0]["user"]);
                      if (usuario != null) {
                        print('estamos aqui');
                        final secionUsuario = Provider.of<SecionUsuario>(context, listen: false);
                        secionUsuario.setUser(usuario[0]["ad_user_id"], usuario[0]["adempiere_user"]);
                        print('Acceso permitido: $usuario');
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => Documents(tecnico:usuario[0]["ad_user_id"]),
                          ),
                        );
                      } else {
                        print('Nombre de usuario o contraseña incorrectos $usuario');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nombre de usuario o contraseña incorrectos:')
                          ),
                        );
                      }
                    
                  }
                  }
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: const Text(
                'Registrarse',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SafeArea _logo() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  Container _cajaRoja(Size size) {
    return Container(
      color: Colors.red,
      width: double.infinity,
      height: size.height * 0.4,
    );
  }
}
