// ignore_for_file: non_constant_identifier_names

import 'package:counter_app/local_database.dart';
import 'package:counter_app/models/siembra.dart';
import 'package:counter_app/widgets/peticione_api.dart';
import 'package:counter_app/widgets/secion_usuario.dart';
import 'package:flutter/material.dart';
import 'package:counter_app/screens/ht_screens.dart';
import 'package:counter_app/widgets/database.dart'; // Importar el archivo database.dart
import 'package:postgres/postgres.dart';
import 'package:provider/provider.dart';


class LlenadoTablasMaestras {
  // Declara la variable a nivel de instancia
  
   final int? ad_user_id;
   
   

  final con_api = Peticiones();
  // Constructor que recibe el parámetro entero
  LlenadoTablasMaestras(this.ad_user_id);

  // Puedes agregar métodos o propiedades que usen 'ad_user_id'
  void printParameter() {
    print('El valor del parámetro es $ad_user_id');
  }

  Future<void> InsertDbLocal() async {
    await InsertPartner();
    await InsertFincas();
    await InsertCiclos();
  }

  Future<void> InsertTableDetalleHoja() async {
    await InsertLotesFincas();
  }


  // Future<List<dynamic>> ApiConnect() async {
  //   final connection = await con_api.connection();
  //   return connection;
  // }
  Future<void> InsertLotesFincas() async {
    final db = await LocalDataBase.instance.database;
    List<dynamic> lotes = await GetLoteFincas();
    // print(lotes);
    for (var lote in lotes) {
    await db.rawInsert(
        'INSERT OR REPLACE INTO fap_farmdivision (fap_farmdivision_id, fap_farm_id, name, area) VALUES (?, ?, ?, ?)',
        [lote['fap_farmdivision_id'], lote['fap_farm_id'], lote['name'], lote['area']],
      );
    }
    // for (var lote in lotes)  {
    //   await db.insert('fap_farmdivision', lote as Map<String, Object?>);
    // }
  }
  
  Future<void> InsertPartner() async {
    final db = await LocalDataBase.instance.database;
    List<dynamic> partnersids = await GetDataPartnerIds();
    for (var partner in partnersids)  {
      await db.insert('c_bpartner', partner as Map<String, Object?>);
    }
    
  }


  Future<void> InsertFincas() async {
    final db = await LocalDataBase.instance.database;
    List<dynamic> fincas = await GetFinasPartner();
    if (fincas.isNotEmpty) {
      for (var finca in fincas) {
        await db.insert('farms_ranches', finca as Map<String, Object?>);
      }
    }else{
      print("esta vacio las fincas");
    }
  }


  Future<void> InsertCiclos() async {
    final db = await LocalDataBase.instance.database;
    List<dynamic> ciclos = await GetCiclosActivos();
    if (ciclos.isNotEmpty) {
      for (var c in ciclos) {
        await db.insert('fap_plantingcycle', c as Map<String, Object?>);
      }
    }else{
      print("esta vacio los ciclos");
    }
  }
  
  // consulta de partners 
  Future<List> GetDataPartnerIds() async {
    List<dynamic> data_partner = await con_api.data_user_id(ad_user_id);
    return data_partner;
  }

  // consulta de fincas por partner
  Future<List> GetFinasPartner() async {
    // print(" okokokokokokokokokoko $ad_user_id");
    List<dynamic> data_fincas = await con_api.fincas_socio_negocio(ad_user_id);
    return data_fincas;
  }

  Future<List<dynamic>> GetCiclosActivos() async {
    final ciclos = await con_api.cliclos_anuales();
    return ciclos;
  }


// get lotes de la finca
  Future<List<dynamic>> GetLoteFincas() async {
    final lotes = await con_api.lote_fincas(ad_user_id);
    return lotes;
  }


// get lotes de la finca
  Future<List<dynamic>> GetProduct() async {
    final lotes = await con_api.get_product();
    return lotes;
  }
}
