import 'dart:ffi';

import 'package:counter_app/local_database.dart';
import 'package:counter_app/screens/dht_screens.dart';
import 'package:counter_app/screens/llenado_maestros.dart';
import 'package:counter_app/widgets/secion_usuario.dart';
import 'package:flutter/material.dart';
import 'package:counter_app/widgets/peticione_api.dart';
import 'package:counter_app/screens/sidebar_menu.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:sqflite/sqflite.dart';

class HtScreens extends StatefulWidget {
  final int? tecnico;
  static const String routeName = '/ht_screens';
  const HtScreens({Key? key, this.tecnico}) : super(key: key);
  @override
  _HtScreensState createState() => _HtScreensState();
}

class _HtScreensState extends State<HtScreens> {

  final _formKey1 = GlobalKey<FormState>();
  final con_api = Peticiones();
  List<dynamic>? partners_ids = [];
  List<dynamic>? rubros_ids = [];

  List<dynamic>? data_ciclos = [];
  List<dynamic>? data_fincas = [];
  List<dynamic>? fincas = [];
  bool isLoading = false;
  dynamic selectedPartner;
  dynamic selectedRubro;

  dynamic selectedCliclo;
  Map<String, dynamic>? selectedFinca;
  DateTime selectedDate = DateTime.now();
  int? global_ad_user_id;

  @override
  void initState() {
    isLoading = true;
    super.initState();
    final secionUsuario = Provider.of<SecionUsuario>(context, listen: false);
    if (secionUsuario.userId != null) {
      setState(() {
        global_ad_user_id = secionUsuario.userId;
      });
        CargaCampos();
      isLoading = false;
    }
  }

  Future<void> deleteAllData() async {
    final db = await LocalDataBase.instance.database;
    await db.delete('c_bpartner'); // Borra todos los registros de 'c_bpartner'
    await db.delete('farms_ranches'); // Borra todos los registros de 'farms_ranches'
    await db.delete('fap_plantingcycle'); // Borra todos los registros de 'fap_plantingcycle'
  }
  Future<void> InicioDeLosTiempos() async {
    LlenadoTablasMaestras llenado_maestras = LlenadoTablasMaestras(global_ad_user_id);
    await llenado_maestras.InsertDbLocal();

  }  
  Future<void> GetDataPartnerIds() async {
    final db = await LocalDataBase.instance.database;
    List<dynamic> partners = await db.rawQuery('SELECT DISTINCT c_bpartner_id, name FROM c_bpartner WHERE ad_user_id = ? ', [global_ad_user_id]);
    // Eliminar duplicados
    partners = partners.toSet().toList();
    setState(() {
      partners_ids = partners;
    });
  }

  Future<void> GetFincas(int c_bpartner_id) async {
    final db = await LocalDataBase.instance.database;
    List<dynamic> _fincas = await db.rawQuery(
      'SELECT DISTINCT fap_farm_id, name, c_bpartner_id FROM farms_ranches WHERE c_bpartner_id = ?',
      [c_bpartner_id]
    );
    // Eliminar duplicados
    _fincas = _fincas.toSet().toList();
    setState(() {
      fincas = _fincas;
    });
  }

  Future<void> GetRubros() async {
    final db = await LocalDataBase.instance.database;
    List<dynamic> _rubro = await db.rawQuery(
      'SELECT DISTINCT m_product_id, name FROM m_product WHERE is_finca =?',[0]
    );
    // Eliminar duplicados
    _rubro = _rubro.toSet().toList();
    setState(() {
      rubros_ids = _rubro;
    });
  }

  Future<void> GetDataCiclos() async {
    final db = await LocalDataBase.instance.database;
    List<dynamic> _ciclos = await db.rawQuery('SELECT DISTINCT * FROM fap_plantingcycle');
    // Eliminar duplicados
    _ciclos = _ciclos.toSet().toList();
    setState(() {
      data_ciclos = _ciclos;
    });
  }

  Future<void> CargaCampos() async {
    await GetDataPartnerIds();
    await GetDataCiclos();
    await GetRubros();
  }



  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _clearSelections() {
    setState(() {
      selectedPartner = null;
      selectedFinca = null;
      selectedCliclo = null;
      fincas = [];
    });
  }

  void _onNext() {
    if (_formKey1.currentState!.validate()) {
       List<dynamic> datos= [{
      'c_bpartner_id': selectedPartner["c_bpartner_id"],
      'finca': [{ 'fap_farm_id': selectedFinca?['fap_farm_id'], 'name': selectedFinca?['name']}],
      'fap_plantingcycle_id': selectedCliclo['fap_plantingcycle_id'],
      'date_hoja': DateFormat('dd-MM-yyyy').format(selectedDate),
      'ad_user_id':global_ad_user_id,
      'rubro':selectedRubro["m_product_id"],
      'id_hoja':0,

      }];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DhtScreens(datos: datos),
      ),
    );
    }

  }

  @override
  Widget build(BuildContext context) {
    final secionUsuario = Provider.of<SecionUsuario>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hoja Técnica',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
        shadowColor: Colors.white,
        elevation: 8,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "Usuario: ${secionUsuario.userName}",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey1,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        '*Socio de Negocio',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black38),
                  ),
                  child: DropdownButton<Map<String, dynamic>>(
                    hint: const Text('Selecciona socio de negocio'),
                    value: selectedPartner,
                    isExpanded: true,
                    items: partners_ids?.map((dynamic partner) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: partner,
                        child: Text(partner['name'] ?? 'Sin nombre'),
                      );
                    }).toList(),
                    onChanged: (Map<String, dynamic>? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          selectedPartner = newValue;
                          selectedFinca = null; // Reset the selected finca
                          fincas = []; // Clear the list of fincas
                        });
                        var id_partner = newValue['c_bpartner_id'];
                        await GetFincas(id_partner);
                        print('Selected Partner ID: ${newValue['c_bpartner_id']}');
                      } else {
                        setState(() {
                          selectedPartner = null;
                          selectedFinca = null;
                          fincas = [];
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        '*Rubro',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black38),
                  ),
                  child: DropdownButton<Map<String, dynamic>>(
                    hint: const Text('Selecciona el Rubro'),
                    value: selectedRubro,
                    isExpanded: true,
                    items: rubros_ids?.map((dynamic rubro) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: rubro,
                        child: Text(rubro['name'] ?? 'Sin nombre'),
                      );
                    }).toList(),
                    onChanged: (Map<String, dynamic>? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          selectedRubro = newValue;
                        });
                        var id_rubro = newValue['m_product_id'];
                        // await GetFincas(id_rubro);
                        print('Selected rubro ID: $id_rubro');
                      } else {
                        setState(() {
                          selectedRubro = null;
                          
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        '*Fincas',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black38),
                  ),
                  child: DropdownButton<Map<String, dynamic>>(
                    hint: const Text('Selecciona La Finca'),
                    value: selectedFinca,
                    isExpanded: true,
                    items: fincas!.map((finca) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: finca,
                        child: Text(finca['name'] ?? 'Sin nombre'),
                      );
                    }).toList(),
                    onChanged: (Map<String, dynamic>? newValue) {
                      if (newValue != null && fincas!.contains(newValue)) {
                        setState(() {
                          selectedFinca = newValue;
                        });
                      } else {
                        setState(() {
                          selectedFinca = null;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        '*Ciclo',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black38),
                  ),
                  child: DropdownButton<Map<String, dynamic>>(
                    hint: const Text('Selecciona otro campo'),
                    value: selectedCliclo,
                    isExpanded: true,
                    items: data_ciclos?.map((dynamic ciclo) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: ciclo,
                        child: Text(ciclo['name'] ?? 'Sin nombre'),
                      );
                    }).toList(),
                    onChanged: (Map<String, dynamic>? newValue) {
                      setState(() {
                        selectedCliclo = newValue;
                      });
                      if (newValue != null) {
                        print('Selected Ciclo ID: ${newValue['fap_plantingcycle_id']}');
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        DateFormat('dd-MM-yyyy').format(selectedDate),
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onNext,
                  child: const Text(' Detalle de Hoja >>>   '),
                  style: ElevatedButton.styleFrom(
                   backgroundColor : Colors.teal[900], // Color de fondo del botón
                  foregroundColor :  Colors.white, /// Color del texto dentro del botón
              ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
