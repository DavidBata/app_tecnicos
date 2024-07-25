import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:counter_app/screens/documentos.dart';
import 'package:counter_app/screens/sincronizar.dart';
import 'package:counter_app/widgets/peticione_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:counter_app/widgets/secion_usuario.dart';
import 'package:counter_app/screens/ht_screens.dart';
import 'package:counter_app/screens/register_screens.dart';
import 'package:counter_app/screens/dht_screens.dart';
import 'package:counter_app/screens/mn_screens.dart';
import 'package:counter_app/screens/login_screens.dart';
import 'package:flutter_background_service/flutter_background_service.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final syncro=  SyncroDocuments();
final con_api = Peticiones();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await onStart();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SecionUsuario()),
      ],
      child: const MyApp(),
    ),
  );
} 

Future<void> onStart() async {
  print('Tarea Por segundo plano ');
  // Configurar un temporizador para ejecutar la tarea cada 2 minutos
  Timer.periodic(Duration(minutes: 2), (timer) async {
    List<dynamic> conect =  await con_api.get_conection_api();
    if (conect[0]['connect'] == 200){
      await syncro.Syncronizar();
    }else{
      print('aun sin intert conectate a una red');
    }
  
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: const LoginScreens(),
      initialRoute: '/',
     
     
      routes: {
        'register': (_) => RegisterPage(),
        'login': (_) => const LoginScreens(),
        'document': (context) => const Documents(),
        'ht_screens': (context) => const HtScreens(),
        'detaillhoja': (context) =>  DhtScreens(),
        'ManCultivo': (context) => MnScreens(),
      },
    );
  }
}
