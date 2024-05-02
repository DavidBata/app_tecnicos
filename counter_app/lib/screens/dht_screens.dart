import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:counter_app/models/refresh.dart';
import 'package:counter_app/screens/sidebar_menu.dart';
import 'package:counter_app/widgets/database.dart';

void main() => runApp(const MaterialApp(
      home: DhtScreens(),
    ));

//class FormularioData {
//  String finca = '';
//  String otroCampo = '';
//  String cultivo = '';
//  String detallesCultivo = '';
//  String date = '';
//  String dateCul = '';
//  String dateIC = '';
//  String dateFC = '';
//}

class DhtScreens extends StatefulWidget {
  static const String routeName = '/dht_screens';
  

  const DhtScreens({Key? key,}) : super(key: key);

  @override
  _DhtScreensState createState() => _DhtScreensState();
}

class _DhtScreensState extends State<DhtScreens> {
  final model = MyModel(); 
  
  final _subLote = []; String? _select;
 
List<String> _cicloSiem = [];  String? _cicloSelec;
 
  final _etapas = []; String? _selectedOption;

  final _loteFinca = []; String? _selectLote;

final _variedad = ["a", "b", "c"];
  String? _selectVari = "a";

  final _estado = [];
  String? _selectEstado;

  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _dateCul = TextEditingController();
  final TextEditingController _dateIC = TextEditingController();
  final TextEditingController _dateFC = TextEditingController();
  final TextEditingController _dateVisita = TextEditingController();
  final TextEditingController _detallesCultivoController = TextEditingController();
  final TextEditingController _cultivoController = TextEditingController();
  final TextEditingController _dthScreen = TextEditingController();
  //final TextEditingController _nameController3 = TextEditingController();
  // final TextEditingController _fincaController = TextEditingController();
  // final TextEditingController _otroCampoController = TextEditingController();
 
late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    getCultivoFromDB();
  }
  
  Future<void> getCultivoFromDB() async {
    final connection = await _databaseHelper.connect();
    final cultivo = await _databaseHelper.getCultivo(connection);
    setState(() {
      _cicloSiem = cultivo;
    });
  }
//void _getDataFromDatabase() async {
//  final connection = await dbHelper.connect();
//
//  
//
//  final results = await Future.wait(futures);
//
//  setState(() {
//    
//  });
//
//  await connection.close();
//}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Detalles Hoja Técnica', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade400,
        shadowColor: Colors.white,
        elevation: 8,
      ),
      drawer: const SidebarScreens(),
      body: SingleChildScrollView(     
          
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                TextField(
                  controller: _dateVisita,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.card_membership),
                    labelText: '*Numero de informe',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                
                TextField(
                  controller: _dateVisita,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                    labelText: '*Fecha de visita',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateVisita.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                   const Text('*Etapa de Cultivo'),
                   const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.black38),
                            ),
                            child: DropdownButton(
                              hint: const Text('seleccione etapa de cultivo'),
                              value: _selectedOption,
                              items: _etapas
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (val) {
                              
                              },
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.red,
                                size: 30,
                              ),
                              isExpanded: true,
                            ),
                          ),
                      
                const SizedBox(height: 10),
                const Text('*Cultivo'),            
                const SizedBox(height: 10),
                
               Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                decoration: BoxDecoration(           
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.black38),
                ),
                child: DropdownButton<String>(
                  hint: const Text('Selecciona cultivo'),
                  value: _cicloSelec,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _cicloSelec = newValue;
                        print('Dropdown ciclosiem = $_cicloSelec');
                      });
                    }
                  },
                  items: _cicloSiem.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  isExpanded: true,
                ),
              ),
              
                
                    const SizedBox(height: 10),
                    const Text('*Lote de fincas'),
                    const SizedBox(height: 10),
        
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(8.0),
                     border: Border.all(color: Colors.black38),
                   ),
                   child: DropdownButton(
                     hint: const Text('Seleccione Lote de fincas'),
                     value: _selectLote,
                     items: _loteFinca
                         .map((e) => DropdownMenuItem(
                               child: Text(e),
                               value: e,
                             ))
                         .toList(),
                     onChanged: (val) {
                     },
                     style: const TextStyle(
                       fontSize: 16,
                       color: Colors.black,
                     ),
                     icon: const Icon(
                       Icons.arrow_drop_down,
                       color: Colors.red,
                       size: 30,
                     ),
                     isExpanded: true,
                   ),
                 ),
                      
                    
              
                const SizedBox(height: 15),
                const Text('*Sub-lote'),
                const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.black38),
                            ),
                            child: DropdownButtonFormField(
                              hint: const Text('seleccione Sub-lote disponible'),
                              value: _select,
                              items: _subLote
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                
                              },
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.red,
                                size: 30,
                              ),
                              isExpanded: true,
                            ),
                          ),
                        
                    const SizedBox(height: 15),
                    const Text('*Variedad'),
                    const SizedBox(height: 15),

                     Container(
                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
                       decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black38),
                      ),
                      child: DropdownButton(
                        value: _selectVari,
                        items: _variedad
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectVari = val;
                          });
                        },
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.red,
                          size: 30,
                        ),
                        isExpanded: true,
                      ),
                    ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: _detallesCultivoController,
                  onTap: () {},
                  decoration: const InputDecoration(
                    labelText: '*Area efectiva',
                    prefixIcon: Icon(Icons.comment),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Campo vacío';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const Divider(color: Colors.black12),
                const SizedBox(height: 14),
                const Text('Fechas siembra', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 15),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _date,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_month_outlined),
                              labelText: 'fecha inicio de siembra',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2),
                              ),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  _date.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 10),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _dateCul,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_month_outlined),
                              labelText: 'fecha final de siembra',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                              ),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  _dateCul.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cultivoController,
                  decoration: const InputDecoration(
                    labelText: '*Rendimiento estimado',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Divider(color: Colors.black12),
                const SizedBox(height: 14),
                const Text('Fechas de cosechas', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 15),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _dateIC,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_month_outlined),
                              labelText: 'fecha inicio de cosecha',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                              ),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  _dateIC.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _dateFC,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_month_outlined),
                              labelText: 'fecha final de cosecha',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                              ),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  _dateFC.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _cultivoController,
                  decoration: const InputDecoration(
                    labelText: '*Cantidad estimada',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text('*Estado', textAlign: TextAlign.left),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black38),
                  ),
                  child: DropdownButton(
                    hint: const Text('Seleccione estado del cultivo'),
                    value: _selectEstado,
                    items: _estado
                        .map((e) => DropdownMenuItem(child: Text(e), value: e))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectEstado = val as String?;
                      });
                    },
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.red,
                      size: 30,
                    ),
                    isExpanded: true,
                  ),
                ),
                const SizedBox(height: 18),
 //               MaterialButton(
 //                 shape: RoundedRectangleBorder(
 //                   borderRadius: BorderRadius.circular(10),
 //                 ),
 //                 disabledColor: Colors.grey,
 //                 elevation: 6,
 //                 color: Colors.red,
 //                 child: Container(
 //                   padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
 //                   child: const Text(
 //                     'Enviar',
 //                     style: TextStyle(color: Colors.white),
 //                   ),
 //                 ),
 //                 onPressed: () {
 //                   if (_formKey2.currentState?.validate() ?? false) {
 //                     // Puedes añadir lógica para manejar el botón aquí
 //                   } else {
 //                     showDialog(
 //                       context: context,
 //                       builder: (BuildContext context) {
 //                         return AlertDialog(
 //                           title: const Text('Alerta'),
 //                           content: const Text('Hay campos vacíos. Por favor, llene todos los campos.'),
 //                           actions: [
 //                             TextButton(
 //                               onPressed: () {
 //                                 Navigator.pop(context);
 //                               },
 //                               child: const Text('OK'),
 //                             ),
 //                           ],
 //                         );
 //                       },
 //                     );
 //                   }
 //                 },
 //               ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledColor: Colors.grey,
                      elevation: 6,
                      color: Colors.red[400],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
                        child: const Text(
                          'Atras',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 15),
                    
                       MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        disabledColor: Colors.grey,
                        elevation: 6,
                        color: Colors.red,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 15),
                          child: const Text(
                            'Siguiente',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey2.currentState!.validate()) {
                            model.setName2(_dthScreen.text); 
                            Navigator.of(context).pushNamed('ManCultivo', arguments: model);
                          }
                        }
                      ),
                  ],
                ),
                  const SizedBox(height: 15),
                 MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  disabledColor: Colors.grey,
                  color: Colors.red,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: const Text(
                      'Completar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey2.currentState?.validate() ?? false) {
                      // Si el formulario es válido, mostramos la alerta
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Formulario válido'),
                            content: const Text('¿Desea agregar otro registro?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                  _cicloSelec= null; 
                                  print('_cicloSelect es = $_cicloSelec');
                                  });
                                  _formKey2.currentState?.reset();
                                  _dateVisita.clear();
                                  _selectedOption = null;
                                  _selectLote = null;
                                  _select = null;
                                  _selectVari = _variedad[0]; // Suponiendo que deseas seleccionar la primera opción por defecto
                                  _detallesCultivoController.clear();
                                  _date.clear();
                                  _dateCul.clear();
                                  _dateIC.clear();
                                  _dateFC.clear();
                                  _cultivoController.clear();
                                  _selectEstado = null;
                                      // Reseteamos los campos del formulario
                                  Navigator.pop(context); // Cerrar el diálogo
                                },
                                child: const Text('Sí'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Cerrar el diálogo sin resetear los campos
                                },
                                child: const Text('Cancelar'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Si el formulario no es válido, mostramos la alerta de campos vacíos
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Campos vacíos'),
                            content: const Text('Por favor, complete todos los campos.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Cerrar el diálogo
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
       ),
      )
   );
  }
}