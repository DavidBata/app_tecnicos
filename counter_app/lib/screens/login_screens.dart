// Importaciones necesarias
import 'package:counter_app/models/siembra.dart';
import 'package:flutter/material.dart';
import 'package:counter_app/screens/ht_screens.dart';
import 'package:counter_app/widgets/database.dart'; // Importa el archivo database.dart
import 'package:postgres/postgres.dart';

// Clase LoginScreens que define la pantalla de inicio de sesión
class LoginScreens extends StatefulWidget {
  static const String routeName = '/login'; // Ruta de la pantalla de inicio de sesión

  const LoginScreens({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreens> {
  final _formKey1 = GlobalKey<FormState>(); // Llave global para el formulario
  late DatabaseHelper _databaseHelper; // Instancia de la clase DatabaseHelper
  late PostgreSQLConnection _connection; // Conexión a la base de datos
  final TextEditingController _usuarioController = TextEditingController(); // Controlador para el campo de usuario
  final TextEditingController _passwordController = TextEditingController(); // Controlador para el campo de contraseña
  bool _obscureText = true; // Variable para controlar la visibilidad de la contraseña

  @override
  void initState() {
    super.initState();
    // Inicialización de DatabaseHelper y conexión a la base de datos al iniciar el estado
    _databaseHelper = DatabaseHelper();
    _databaseHelper.connectToDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _cajaRoja(size), // Widget para la caja roja en la parte superior
            _logo(), // Widget para mostrar el logo
            _loginForm(context), // Widget para el formulario de inicio de sesión
          ],
        ),
      ),
    );
  }

  // Widget para el formulario de inicio de sesión
  Widget _loginForm(BuildContext context) {
    return Form(
      key: _formKey1,
      child: Column(
        children: [
          const SizedBox(height: 250), // Espacio en blanco
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            // Decoración de la caja del formulario
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
                const SizedBox(height: 10), // Espacio en blanco
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.titleLarge,
                ), // Texto "Login"
                const SizedBox(height: 30), // Espacio en blanco
                TextFormField(
                  controller: _usuarioController,
                  autocorrect: false,
                  // Campo de entrada para el usuario
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
                      return 'Campo obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30), // Espacio en blanco
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  // Campo de entrada para la contraseña
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
                      return 'Campo obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20), // Espacio en blanco
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
                  // Función para el botón de "Ingresar" que llama a buscarUsuario
                  onPressed: () async {
                    if (_formKey1.currentState!.validate()) {
                      final connection = _databaseHelper.connection; // Obtiene la conexión
                      if (connection != null) {
                        final usuario = await _databaseHelper.buscarUsuario(
                          connection,
                          _usuarioController.text,
                          _passwordController.text,
                        );
                        if (usuario != null) {
                          print('Acceso permitido: $usuario');
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HtScreens(tecnico: usuario.usuario),
                            ),
                          );
                        } else {
                          print('Nombre de usuario o contraseña incorrectos $usuario');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Nombre de usuario o contraseña incorrectos:'),
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 50), // Espacio en blanco
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            color: Colors.red,
            // Navegación para el botón de "Registrarse"
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HtScreens()));
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

  // Widget para mostrar el logo
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

  // Widget para la caja roja en la parte superior
  Container _cajaRoja(Size size) {
    return Container(
      color: Colors.red,
      width: double.infinity,
  );
  }
  
  }