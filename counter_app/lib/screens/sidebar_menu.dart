import 'package:counter_app/screens/dht_screens.dart';
import 'package:counter_app/screens/ht_screens.dart';
import 'package:counter_app/screens/login_screens.dart';
import 'package:counter_app/screens/mn_screens.dart';
import 'package:flutter/material.dart';

class SidebarScreens extends StatelessWidget {
  const SidebarScreens({Key? key}) : super(key: key);
  static const String routeName = '/detallehojaTecnica';
  @override
  Widget build(BuildContext context) {
    return Drawer(
     child:Container(  
      color:const Color.fromARGB(255, 37, 34, 34),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const Divider(color: Color.fromARGB(255, 148, 183, 201), height: 40,
          //endIndent: 40,
          ),
          ListTile(
            title: const Text('Cerrar sesión '),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder:(context) =>  LoginScreens(),));
            },
            leading: const Icon(Icons.login, color: Colors.white),
            textColor:Colors.white
          )
        ],

      ),
      )
    );


  }
}
