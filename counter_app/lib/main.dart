// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:counter_app/screens/ht_screens.dart';
import 'package:counter_app/screens/register_screens.dart';
import 'package:counter_app/screens/dht_screens.dart';
import 'package:counter_app/screens/mn_screens.dart';
import 'package:counter_app/screens/login_screens.dart';

// Función principal de la aplicación
void main() {
  runApp(const MyApp());
}

// Clase principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el banner de depuración
      title: 'Material App', // Título de la aplicación
      home: const LoginScreens(), // Pantalla de inicio de sesión como pantalla principal
      initialRoute: '/', // Ruta inicial de la aplicación
      routes: {
        // Definición de rutas
        'login': (_) => const LoginScreens(), // Ruta para la pantalla de inicio de sesión
        'register': (_) => const RegisterScreen(), // Ruta para la pantalla de registro
        'ht_screens': (_) => const HtScreens(), // Ruta para la pantalla ht_screens
        'DetHojTecn': (_) => const DhtScreens(), // Ruta para la pantalla DetHojTecn
        'ManCultivo': (_) => MnScreens(), // Ruta para la pantalla ManCultivo
      },
    );
  }
}
