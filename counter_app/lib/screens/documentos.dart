import 'dart:ffi';
import 'package:counter_app/main.dart';
import 'package:counter_app/screens/dht_screens.dart';
import 'package:counter_app/screens/ht_screens.dart';
import 'package:counter_app/screens/sidebar_menu.dart';
import 'package:counter_app/screens/sincronizar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:counter_app/local_database.dart';
import 'package:counter_app/models/const_hoja_tecnica.dart';
import 'package:counter_app/widgets/secion_usuario.dart';


class Documents extends StatefulWidget {
  final int? tecnico;
  
  static const String routeName = '/document';

  const Documents({Key? key, this.tecnico}) : super(key: key);

  @override
  DocumentPage createState() => DocumentPage();
}

class DocumentPage extends State<Documents> {
  bool isLoading = false;
  int? globalAdUserId;
  String? user_name;
  
  late Future<List<TechnicalForm>> futureHojasTecnica;

  @override
  void initState() {
    super.initState();
    final secionUsuario = Provider.of<SecionUsuario>(context, listen: false);
    globalAdUserId = secionUsuario.userId;
    user_name= secionUsuario.userName;
    futureHojasTecnica = GetHojaTecnica();
    // Programar tarea en segundo plano
 
    
  }
  Future<void> _refreshDocuments() async {
    setState(() {
      futureHojasTecnica = GetHojaTecnica();
    });
  }
  Future<List<TechnicalForm>>GetHojaTecnica() async {
    print(globalAdUserId);
    final db = await LocalDataBase.instance.database;
      List<Map<String, dynamic>> hojasTecnicaMaps = await db.rawQuery(
        '''SELECT  
          hoja.fap_technicalform_id
          ,hoja.ad_user_id
          ,hoja.c_bpartner_id
          ,hoja.fap_farm_id
          ,hoja.m_product_id
          ,hoja.fap_technicalform_ade_id
          ,hoja.fap_plantingcycle_id
          ,finca.name  as finca_name
          ,cb.name  as socio_name
          ,ci.name  as ciclo_name
          ,pro.name  as product_name
          ,hoja.synced
          FROM fap_technicalform hoja
          join farms_ranches finca on finca.fap_farm_id = hoja.fap_farm_id
          join m_product pro on pro.m_product_id = hoja.m_product_id
          Join c_bpartner  cb on cb.c_bpartner_id = hoja.c_bpartner_id
          join fap_plantingcycle ci on ci.fap_plantingcycle_id = hoja.fap_plantingcycle_id
          WHERE hoja.ad_user_id = ?''', 
        [globalAdUserId]
      );
      
      List<TechnicalForm> hojasTecnica = hojasTecnicaMaps
          .map((map) => TechnicalForm.fromMap(map))
          .toSet()
          .toList();
      print(" NO LA LLEVE TAN ASELERADA :____ $hojasTecnicaMaps");
      print(" HOJADAAAA :____ $hojasTecnica");
      return hojasTecnica;
    
    
  }
  
  Future<void> syncDocuments() async {
    setState(() {
      isLoading = true;
    });


    List<dynamic> conect =  await con_api.get_conection_api();
    _showLoadingDialog(context);
    
    await SyncroDocuments().Syncronizar();
    _hideLoadingDialog(context);

     // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Syncro Successfully!')),
        );
    // await performSync();
    setState(() {
      isLoading = false;
    });

    // Mostrar un mensaje al usuario indicando que la sincronización ha terminado
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sincronización completada')),
    );
  }

  
void _hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}

void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Syncronizando..."),
          ],
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final secionUsuario = Provider.of<SecionUsuario>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doc.Creados',
          style: TextStyle(color: Colors.white, fontSize:15.5),
        ),
        backgroundColor: Colors.red[400],
        shadowColor: Colors.white,
        elevation: 8,
        actions: <Widget>[
        
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "${secionUsuario.userName}",
                style: TextStyle(fontSize: 15.5, color: Colors.white, ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.sync, color: Colors.white),
            onPressed: isLoading ? null : syncDocuments,
          ),
        ],
      ),
      drawer: const SidebarScreens(),
      body: FutureBuilder<List<TechnicalForm>>(
        future: futureHojasTecnica,
       
        builder: (context, snapshot) {
          print(futureHojasTecnica);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay documentos técnicos disponibles.'));
          } else {
            return   RefreshIndicator(
              onRefresh: _refreshDocuments,
              child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                TechnicalForm form = snapshot.data![index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: Icon(Icons.description, color: Colors.blue[900]),
                    title: Text(
                      'Documento ID : ${form.fap_technicalform_id} || ${form.finca_name}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Productor: ${form.socio_name}'),
                        Text('Ciclo/Rubro: ${form.ciclo_name} || ${form.product_name}'),
                      ],
                    ),
                    
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue[900], size: 20),
                    onTap: () {
                      print(form.socio_name);
                    List<dynamic> datos= [{
                      'c_bpartner_id':form.c_bpartner_id,
                      'finca': [{ 'fap_farm_id': form.fap_farm_id, 'name': form.finca_name}],
                      'fap_plantingcycle_id': form.fap_plantingcycle_id,
                      'date_hoja': form.date_created,
                      'ad_user_id':globalAdUserId,
                      'rubro': form.m_product_id,
                      'id_hoja': form.fap_technicalform_id,
                      'fap_technicalform_ade_id':form.fap_technicalform_ade_id,

                      }]; 

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DhtScreens(datos: datos),
                        ),
                      );
                    },
                  ),
                );
              },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HtScreens(tecnico:globalAdUserId),
                          ),
                        );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
