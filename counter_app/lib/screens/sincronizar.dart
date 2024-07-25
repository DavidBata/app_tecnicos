import 'package:counter_app/local_database.dart';
import 'package:counter_app/widgets/peticione_api.dart';
import 'package:flutter/material.dart';

class SyncroDocuments {
  final con_api = Peticiones();

  // get universal los parametros son la tabla a consultar,  la ruta de la api, y la tabla hija si tiene tabla hija
  Future<void> Syncronizar() async {
    await get_universal('fap_technicalform', 'hojatecnica','fap_technicalformline');
    await get_universal('fap_technicalformline','detallehoja','fap_htsymptomatology');
    await get_universal('fap_htsymptomatology','manejocultivo', '');
  }

  
  // get universal los parametros son la tabla a consultar,  la ruta de la api, y la tabla hija si tiene tabla hija
  Future<void> get_universal(String tabla, String ruta_peticion, String tabla_hija   ) async {
    final db = await LocalDataBase.instance.database;
    List<Map<String, dynamic>> consulta = await db.rawQuery('SELECT DISTINCT * FROM $tabla where synced = ? ', [0]);
    // print(consulta);
    await recorrer_data_universal(consulta, tabla, ruta_peticion,tabla_hija);
    
  }
  Future<void>recorrer_data_universal(List<Map<String, dynamic>> data, String tabla, String ruta_peticion, String tabla_hija) async {

    if(data.isNotEmpty){
      for (var record in data) {
       
          String idfield = '${tabla}_id';

          List<dynamic>? response = await  con_api.createhojatecnica(record, ruta_peticion) ;

      
          print("ESTE ES EL POST, ¿SERÁ QUE SI LO MANDA? $response");

          if (response != null && response.isNotEmpty && response[0]['recod_id'] != null) {
          int apiId = response[0]['recod_id'];
          
          await actualizarRegistroLocal(record[idfield], apiId, tabla, tabla_hija);
          } else {
            print("Error en la respuesta de la API o ID no encontrado.");
          }
      
      }
    }
  }
  Future<void> actualizarRegistroLocal(int localId, int apiId, String tabla, String tabla_hija ) async {
    final db = await LocalDataBase.instance.database;
    // Esto puede incluir una llamada a la base de datos local o a una función específica
    String idfield_adempiere = '${tabla}_ade_id';
    String record_local_id = '${tabla}_id';


  
    
    int updated = await db.update('$tabla', 
      {
        '$idfield_adempiere': apiId, 
        'synced': 1
      }, 
      where: '$record_local_id = ?', 
      whereArgs: [localId]
    );

    if(tabla_hija!=''){
      int updated_hija = await db.update('$tabla_hija',  
        {
          '$idfield_adempiere': apiId
        }, 
        where: '$record_local_id = ?', 
        whereArgs: [localId]
      );
      if (updated_hija > 0) {
      print('Registro Hijo Actualizado' );
      } else {
      print('Error al actualizar el registro hijo local con ID $localId');
      }

    }

    if (updated > 0) {
      print('Registro local con ID $localId actualizado con ID de la API $apiId');
    } else {
      print('Error al actualizar el registro local con ID $localId');
    }
  }



}
