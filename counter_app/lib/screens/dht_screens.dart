import 'package:counter_app/local_database.dart';
import 'package:counter_app/screens/documentos.dart';
import 'package:counter_app/screens/llenado_maestros.dart';
import 'package:counter_app/screens/mn_screens.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DhtScreens extends StatefulWidget {
  final List<dynamic>? datos;

  DhtScreens({Key? key, this.datos}) : super(key: key);

  @override
  _DhtScreensState createState() => _DhtScreensState();
}

class _DhtScreensState extends State<DhtScreens> {
  final _formKey2 = GlobalKey<FormState>();
  dynamic selectedFinca;
  dynamic selectedLote;
  dynamic slectedTipoObservacion;
  dynamic selectedEtapaRubro;
  dynamic selectedConvenio;
  dynamic selectedSubLote;


  int? fap_farm_id;
  int ? fap_technicalform_ade_id; 
  List<dynamic>? lotes = [];
  List<dynamic>? tipo_observacion = [];
  List<dynamic>? convenio = [];
  List<dynamic>? etaparubro = [];
  List<dynamic>? sublotes = [];


  // List<Map<String, dynamic>> lotes = [];

  @override
  void initState() {
    super.initState();
    print(widget.datos![0]['finca'][0]['fap_farm_id']);
    setState(() {
      selectedFinca = widget.datos![0]['finca'];
      fap_farm_id = widget.datos![0]['finca'][0]['fap_farm_id'];
      fap_technicalform_ade_id = widget.datos![0]['fap_technicalform_ade_id'];
    });
    CargaCampos();
    
  }

  Future<void> GetLotesFica(int fap_farmdivision_id) async {
    final db = await LocalDataBase.instance.database;
    print("esta es la finca menor !! : $fap_farm_id");

    List<Map<String, dynamic>> _lotes = await db.rawQuery(
        'SELECT  fap_farmdivision_id , name FROM fap_farmdivision WHERE fap_farmdivision_id= ? ',
        [fap_farmdivision_id]);
    print("LOTES CARGADOS !! : $_lotes");
    _lotes = _lotes.toSet().toList();
    setState(() {
      
      lotes = _lotes;
    });
  }

  Future<void> GetConveneo() async {
    final db = await LocalDataBase.instance.database;

    print(widget.datos![0]['rubro']);


    if (widget.datos![0]['rubro']>0){
      
      List<Map<String, dynamic>> _convenio = await db.rawQuery(
          'SELECT  fap_farming_id, name, fap_farmdivision_id FROM fap_farming WHERE m_product_id= ? and fap_plantingcycle_id = ? ',
          [widget.datos![0]['rubro'], widget.datos![0]['fap_plantingcycle_id']]);
      print("LOTES CONVENIOS !! : $_convenio");
      _convenio = _convenio.toSet().toList();
      setState(() {
        convenio = _convenio;
      });
    } else{
           List<Map<String, dynamic>> _convenio = await db.rawQuery(
          'SELECT  fap_farming_id, name, fap_farmdivision_id FROM fap_farming');
      print("LOTES CONVENIOS !! : $_convenio");
      _convenio = _convenio.toSet().toList();
      setState(() {
        convenio = _convenio;
      });
    }
  }


 Future<void> GetEtapaRubro() async {
  final db = await LocalDataBase.instance.database;

  print(widget.datos![0]['rubro']);
  var parametro = widget.datos![0]['rubro'];
  List<Map<String, dynamic>> detallesRegistrados;
  List<Map<String, dynamic>> _etapaRubro;

  if (widget.datos![0]['id_hoja'] > 0) {
    String? andClause;
    List<dynamic> queryArgs = [parametro];

    if (widget.datos![0]['id_hoja'] > 0) {
      andClause = " AND det.fap_technicalform_id = ?";
      queryArgs.add(widget.datos![0]['id_hoja']);
    }

    detallesRegistrados = await db.rawQuery(
      '''
      SELECT 
        det.fap_technicalformline_id,
        etapa.seqno
      FROM 
        fap_technicalformline det
      JOIN fap_farmingstage etapa ON etapa.fap_farmingstage_id = det.fap_farmingstage_id
      WHERE etapa.m_product_id = ? ${andClause ?? ""}
      ''',
      queryArgs,
    );

    print("PRINTE DE LOS DETALLES $detallesRegistrados");

    List<dynamic> listSequencia = detallesRegistrados.map((x) => x['seqno']).toList();
    String listSequenciaIds = listSequencia.isNotEmpty ? listSequencia.join(', ') : 'NULL';
    print("$listSequenciaIds, $parametro");

    _etapaRubro = await db.rawQuery(
      '''
      SELECT fap_farmingstage_id, name 
      FROM fap_farmingstage 
      WHERE m_product_id = ? 
      AND seqno NOT IN ($listSequenciaIds)
      ORDER BY seqno  limit 1
      ''',
      [parametro],
    );
  } else {
    _etapaRubro = await db.rawQuery(
      'SELECT fap_farmingstage_id, name FROM fap_farmingstage limit 1  ',
    );
  }

    print("ETAPA DE RUBROS CARGADOS !! : $_etapaRubro");
    _etapaRubro = _etapaRubro.toSet().toList();
    setState(() {
      etaparubro = _etapaRubro;
    });

  // Utiliza _etapaRubro según tus necesidades
}


Future<void> GetSubLotes(sublote_id) async {
    final db = await LocalDataBase.instance.database;
    List<Map<String, dynamic>> _sublotes = await db.rawQuery(
        'SELECT  fap_farmdivisionchild_id, name FROM fap_farmdivisionchild WHERE fap_farmdivision_id= ? ', [sublote_id]);

    print("SUB LOTES CARGADOS!! : $_sublotes");
    _sublotes = _sublotes.toSet().toList();
    setState(() {
      sublotes = _sublotes;
    });
  }

  Future<void> GetTipoObservacion() async {
    final db = await LocalDataBase.instance.database;
    List<Map<String, dynamic>>  _tipo_observacion= await db.rawQuery(
        'SELECT * FROM fap_observationtype ');

    print("Tipos de Observacion !! : $_tipo_observacion");
    _tipo_observacion = _tipo_observacion.toSet().toList();
    setState(() {
      tipo_observacion = _tipo_observacion;
    });
  }

  Future<void>CargaCampos() async {
    // await GetLotesFica();   
    await GetConveneo(); 
    await GetEtapaRubro();
    await GetTipoObservacion();
  }

  dynamic getOrNull(dynamic value) {
    if (value == null) return null;
    if (value is List && value.isEmpty) return null;
    return value;
  }
  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe tocar el botón de confirmación
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que deseas completar la hoja sin manejo de Cultivo ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Completar '),
              onPressed: () {
                Navigator.of(context).pop();
                CompleteHoja();
              },
            ),
          ],
        );
      },
    );
  }
  void _onNext() {
      List<dynamic> data_cabeza_detalles= [{
      'c_bpartner_id': widget.datos![0]['c_bpartner_id'],
      'finca' : widget.datos![0]['finca'][0]['fap_farm_id'],
      'fap_plantingcycle_id': widget.datos![0]['fap_plantingcycle_id'],
      'date_hoja': widget.datos![0]['date_hoja'],
      'ad_user_id':widget.datos![0]['ad_user_id'],
      'rubro':widget.datos![0]["rubro"],
      'id_hoja': widget.datos![0]["id_hoja"],
      'detalle_hoja': [{
        'fap_technicalform_ade_id': fap_technicalform_ade_id,
        'fap_farmdivision_id':selectedLote['fap_farmdivision_id'],
        'fap_farmingstage_id':selectedEtapaRubro['fap_farmingstage_id'],
        'fap_farming_id':selectedConvenio['fap_farming_id'],
        'fap_observationtype_id':slectedTipoObservacion['fap_observationtype_id'],
        'fap_farmdivisionchild_id': getOrNull(selectedSubLote is Map ? selectedSubLote['fap_farmdivisionchild_id'] : null),
         }]
      }];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MnScreens(datos: data_cabeza_detalles),
      ),
    );
  }

  void CompleteHoja() async {
    final db = await LocalDataBase.instance.database;
    print(widget.datos![0]['date_hoja']);
    var hojatecnica;
    var id_cabezera;
    if (widget.datos![0]['fap_technicalform_ade_id'] !=null ){
       hojatecnica= {
        'date_hoja': DateFormat('dd-MM-yyyy').format(DateTime.now()) ,
        'ad_user_id':widget.datos![0]['ad_user_id']
      };
      id_cabezera= widget.datos![0]["fap_technicalform_ade_id"];
      
    }else{
      hojatecnica= {
      'c_bpartner_id': widget.datos![0]['c_bpartner_id'],
      'finca' : widget.datos![0]['finca'][0]['fap_farm_id'],
      'fap_plantingcycle_id': widget.datos![0]['fap_plantingcycle_id'],
      'date_hoja': widget.datos![0]['date_hoja'],
      'ad_user_id':widget.datos![0]['ad_user_id'],
      'rubro':widget.datos![0]["rubro"],
      'id_hoja': widget.datos![0]["id_hoja"],
      };
      id_cabezera =await db.rawInsert(
        'INSERT OR REPLACE INTO fap_technicalform (ad_user_id,c_bpartner_id, fap_farm_id, fap_plantingcycle_id, date_created,m_product_id, synced) VALUES (?, ?, ?, ?,?,?,?)',
        [hojatecnica['ad_user_id'], hojatecnica['c_bpartner_id'], hojatecnica['finca'], hojatecnica['fap_plantingcycle_id'],hojatecnica['date_hoja'],hojatecnica['rubro'],0 ],
      );
    }

    var detallehoja= {
      'fap_technicalform_ade_id': fap_technicalform_ade_id,
      'fap_farmdivision_id':selectedLote['fap_farmdivision_id'],
      'fap_farmingstage_id':selectedEtapaRubro['fap_farmingstage_id'],
      'fap_farming_id':selectedConvenio['fap_farming_id'],
      'fap_observationtype_id':slectedTipoObservacion['fap_observationtype_id'],
      'fap_farmdivisionchild_id': getOrNull(selectedSubLote is Map ? selectedSubLote['fap_farmdivisionchild_id'] : null),
      'finca' : widget.datos![0]['finca'][0]['fap_farm_id'],
    };  
 

    // print("AQUI ESTA LA FINCA  ${widget.datos![0]['finca']}");
    // print("AQUI ESTA LA OBSERVACION  ${widget.datos![0]["detalle_hoja"][0]['fap_observationtype_id']}");
    int id_detalle =await db.rawInsert(
        'INSERT OR REPLACE INTO fap_technicalformline (fap_technicalform_id,fap_farming_id, fap_farmdivision_id, fap_farmdivisionchild_id,fap_farmingstage_id, date_created,fap_farm_id,fap_observationtype_id, fap_technicalform_ade_id, synced) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [id_cabezera, detallehoja['fap_farming_id'], detallehoja['fap_farmdivision_id'],detallehoja['fap_farmdivisionchild_id'],detallehoja['fap_farmingstage_id'], hojatecnica['date_hoja'],detallehoja['finca'],detallehoja['fap_observationtype_id'],detallehoja['fap_technicalform_ade_id'], 0 ],
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Datos guardados exitosamente')));

    print(id_cabezera);
    Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>  Documents(tecnico: hojatecnica['ad_user_id']),
                    ),
                  );

}
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle Hoja'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.landscape),
                labelText: 'Finca Seleccionada',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              controller: TextEditingController(
                text: selectedFinca != null ? selectedFinca[0]['name'] : '',
              ),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.card_membership),
                labelText: '*Numero de informe',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
             
              ),
              controller: TextEditingController(
                text: widget.datos![0]['fap_technicalform_ade_id'] != null
                      ? widget.datos![0]['fap_technicalform_ade_id'].toString()
                      : '', // Usar cadena vacía si es null
              ),
              readOnly: true,
            ),
            const  SizedBox(height: 10),
            DropdownButtonFormField<Map<String, dynamic>>(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.assignment_turned_in),
                labelText: 'Seleccionar Convenio',
                
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
               
              ),
              value: selectedConvenio,
              items: convenio!.map((conv) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: conv,
                  child: Text(
                    conv['name'] ?? 'Sin nombre',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10),
                  ),
                );
              }).toList(),
              onChanged: (value) async {
                setState(() {
                  selectedConvenio = value;
                  selectedLote = null;
                });
                if (value != null) {
                  await GetLotesFica(value['fap_farmdivision_id']);
                  print('convenio seleccionado: ${value['fap_farming_id']}');
                } else {
                  print('convenio seleccionado: null');
                }
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<Map<String, dynamic>>(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.visibility),
                labelText: 'Seleccionar Tipo de Observacion',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              value: slectedTipoObservacion,
              items: tipo_observacion!.map((conv) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: conv,
                  child: Text(
                    conv['name'] ?? 'Sin nombre',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) async {
                setState(() {
                  slectedTipoObservacion = value;
                });
                if (value != null) {
                  print('observacion seleccionado: ${value['fap_observationtype_id']}');
                } else {
                  print('observacion seleccionado: null');
                }
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<Map<String, dynamic>>(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.landscape),
                labelText: 'Seleccionar Lote',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              value: selectedLote,
              items: lotes!.map((lote) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: lote,
                  child: Text(
                    lote['name'] ?? 'Sin nombre',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) async {
                setState(() {
                  selectedSubLote = null;
                  selectedLote = value;
                });
                if (value != null) {
                  await GetSubLotes(value['fap_farmdivision_id']);
                  print('Lote seleccionado: ${value['fap_farmdivision_id']}');
                } else {
                  print('Lote seleccionado: null');
                }
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<Map<String, dynamic>>(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.landscape),
                labelText: 'Seleccionar Sub Lote',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              value: selectedSubLote,
              items: sublotes!.map((sublote) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: sublote,
                  child: Text(
                    sublote['name'] ?? 'Sin nombre',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) async {
                setState(() {
                  selectedSubLote = value;
                });
                if (value != null) {
                  print('sublote seleccionado: ${value['fap_farmdivisionchild_id']}');
                } else {
                  print('sublote seleccionado: null');
                }
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<Map<String, dynamic>>(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.timelapse),
                labelText: 'Seleccionar Etapa',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              value: selectedEtapaRubro,
              items: etaparubro!.map((etapa) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: etapa,
                  child: Text(
                    etapa['name'] ?? 'Sin nombre',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedEtapaRubro = value;
                });
                if (value != null) {
                  print('Etapa seleccionada: ${value['fap_farmingstage_id']}');
                } else {
                  print('Etapa seleccionada: null');
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onNext,
              child: const Text('Siguente Manejo de Cultivo'),
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 36, 156, 254), // Color de fondo del botón
                foregroundColor: Colors.white, // Color del texto dentro del botón
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showConfirmationDialog,
              child: const Text('Completar Sin Manejo de Cultivo '),
              style: ElevatedButton.styleFrom(
                backgroundColor : Colors.teal[900], // Color de fondo del botón
                  foregroundColor :  Colors.white, // Color del texto dentro del botón
              ),
            ),
          ],
        ),
      ),
    );
  }
}