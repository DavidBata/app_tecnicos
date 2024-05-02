import 'package:counter_app/screens/dht_screens.dart';
import 'package:counter_app/screens/ht_screens.dart';
import 'package:counter_app/screens/login_screens.dart';
import 'package:counter_app/screens/mn_screens.dart';
import 'package:flutter/material.dart';

class SidebarScreens extends StatelessWidget {
  const SidebarScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
     child:Container(  
      color:const Color.fromARGB(255, 37, 34, 34),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox( height: 48),
          ListTile(
            title: const Text('Hoja técnica'),
             leading: const Icon(Icons.article,color: Colors.white),
             onTap: () {
               Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HtScreens(),
                ));

             // Navigator.of(context).push(MaterialPageRoute(builder:(context) =>  const HtScreens(),));
             },
            textColor: Colors.white
          ),
          const SizedBox(height: 8),
          ListTile(
            title: const Text('Detalles Hoja Tecnica'),
            onTap: () {
               Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const DhtScreens(),
                ));
              
              //Navigator.of(context).push(MaterialPageRoute(builder:(context) => const DhtScreens(), ));
             
             },
            leading: const Icon(Icons.article_rounded,color: Colors.white),
            textColor: Colors.white
          ),
          const SizedBox(height: 8),
          ListTile(
            title: const Text('Manejo de Cultivo'),
            onTap: () {
              
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) =>  MnScreens(),
                )); 
             
              //Navigator.of(context).push(MaterialPageRoute(builder:(context) =>  MnScreens(),));
             
             
             },
            leading: const Icon(Icons.vaccines_rounded,  color: Colors.white,),
            textColor:Colors.white
          ),

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
