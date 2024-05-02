import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:counter_app/screens/sidebar_menu.dart';
import 'package:counter_app/models/refresh.dart';
import 'package:counter_app/widgets/database.dart';
import 'package:postgres/postgres.dart';
import 'package:counter_app/models/siembra.dart';


class HtScreens extends StatefulWidget {
  final String? tecnico; // Campo para recibir el nombre de usuario
  static const String routeName = '/ht_screens';

  const HtScreens({Key? key, this.tecnico}) : super(key: key);

  @override
  _HtScreensState createState() => _HtScreensState();
}

class _HtScreensState extends State<HtScreens> {
// Controladores y variables de estado:
//usuario
late TextEditingController _tecnicoController;

//iniliciacion de base de datos
  final dbHelper = DatabaseHelper();
  

  //variables ciclos de siembra
  final List<String> _cicloSiem = []; String? _siemValue;

  final List<String> _socioDelNegocio = [];  String? _socioValue;
 
  final List<String> _fincas = [];  String? _finca;
  

  
  final _formKey1 = GlobalKey<FormState>();
  
  final model = MyModel();
 
  final fincaTextEditingController  = TextEditingController();
  final dateTextEditingController  = TextEditingController();
  final TextEditingController _htScreen = TextEditingController();
 
  //final TextEditingController _nombreCompania = TextEditingController();
  //final TextEditingController _nroDocumento = TextEditingController();
  //final TextEditingController _organizacion = TextEditingController();
  //final TextEditingController _tipoDocumento = TextEditingController();
@override
void initState() {
  super.initState();
  _getDataFromDatabase();
  _setInitialDate();
  _tecnicoController = TextEditingController(text: widget.tecnico);
}
   // Método para obtener datos de la base de datos
  void _getDataFromDatabase() async {
    final connection = await dbHelper.connect();

  final String? nombreUsuario = widget.tecnico;
  if (nombreUsuario != null) {
    final futures = [
      
    dbHelper.getCiclosDeSiembraFromDatabase(connection),
    dbHelper.getSocioDelNegocio(connection, nombreUsuario),
    dbHelper.getFincas(connection, nombreUsuario),
  ];
  
  final results = await Future.wait(futures);
  
  setState(() {
    //_listOrga.addAll(results[1] as List<String>);
    _cicloSiem.addAll(results[0] as List<String>);
    _socioDelNegocio.addAll((results[1] as List<SocioDeNegocio>).map((socio) => socio.name).toList());
     _socioDelNegocio.sort();
    _fincas.addAll(results[2] as List<String>);
    _fincas.sort(); 
  });
  }
  await connection.close();
}

 // Método para establecer la fecha inicial
   void _setInitialDate() {
    dateTextEditingController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hoja Técnica',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
        shadowColor: Colors.white,
        elevation: 8,
      ),
      drawer: const SidebarScreens(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
   //             Row(
   //               children: [
   //                 Expanded(
   //                   child: TextFormField(
   //                     controller: _nombreCompania,
   //                     decoration: const InputDecoration(
   //                       labelText: '*Compañia',
   //                       prefixIcon: Icon(Icons.home_work),
   //                       border: OutlineInputBorder(
   //                         borderSide: BorderSide(color: Colors.red),
   //                       ),
   //                       focusedBorder: UnderlineInputBorder(
   //                         borderSide: BorderSide(color: Colors.red, width: 2),
   //                       ),
   //                     ),
   //                     validator: (value) {
   //                       if (value == null || value.isEmpty) {
   //                         return 'Campo vacío';
   //                       }
   //                       if (
   //                         value.contains('-') ||
   //                         value.contains('\$') ||
   //                         value.contains('#') ||
   //                         value.contains('@') ||
   //                         value.contains('*')
   //                       ) {
   //                         return 'Los campos no pueden tener caracteres especiales';
   //                       }
   //                       return null;
   //                     },
   //                   ),
   //                 ),
   //                 const SizedBox(width: 10),
   //                 Expanded(
   //                   child: TextFormField(
   //                     controller: _nroDocumento,
   //                     keyboardType: TextInputType.number,
   //                     decoration: const InputDecoration(
   //                       labelText: '*Nro. de documento',
   //                       prefixIcon: Icon(Icons.credit_card),
   //                       border: OutlineInputBorder(
   //                         borderSide: BorderSide(color: Colors.red),
   //                       ),
   //                       focusedBorder: UnderlineInputBorder(
   //                         borderSide: BorderSide(color: Colors.red, width: 2),
   //                       ),
   //                     ),
   //                   ),
   //                 ),
   //               ],
   //             ),
                //const SizedBox(height: 10),
            
                const Text('*Ciclo de siembra'),
            
                const SizedBox(height: 10),

                Container(
                  
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                  decoration: BoxDecoration(
                    
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black38),
                  ),
                  child:DropdownButton<String>(
                   hint: const Text('Selecciona ciclo de siembra'),
              value: _siemValue,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                     _siemValue = newValue;
                  });
                }
              },
              items: _cicloSiem.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
                isExpanded: true),
                ),
                
  //              Row(
  //                children: [
  //                  Expanded(
  //                    child: TextFormField(
  //                      controller: _tipoDocumento,
  //                      decoration: const InputDecoration(
  //                        labelText: '*Tipo de Documento',
  //                        border: OutlineInputBorder(
  //                          borderSide: BorderSide(color: Colors.red),
  //                        ),
  //                        focusedBorder: UnderlineInputBorder(
  //                          borderSide: BorderSide(color: Colors.red, width: 2),
  //                        ),
  //                      ),
  //                   
  //                    ),
  //                  ),
  //                  const SizedBox(width: 10),
  //                  
  //                  const SizedBox(height: 10),
  //                 Expanded(
  //                  child: Column(
  //                    crossAxisAlignment: CrossAxisAlignment.stretch,
  //                    children: [
  //                      const SizedBox(height: 10),
  //                      Container(
  //                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
  //                        decoration: BoxDecoration(
  //                          borderRadius: BorderRadius.circular(8.0),
  //                          border: Border.all(color: Colors.black38),
  //                        ),
  //                        child:  DropdownButton<String>(
  //                          hint: const Text('Selecciona organización'),
  //                          value: _orga,
  //                          onChanged: (String? newValue) {
  //                             if (newValue != null) {
  //                               setState(() {
  //                                  _orga = newValue;
  //                               });
  //                               _orga = newValue;
  //                             }
  //                          },
  //                             items: _listOrga.map<DropdownMenuItem<String>>((String value) {
  //                            return DropdownMenuItem<String>(
  //                              value: value,
  //                              child: Text(value),
  //                            );
  //                          }).toList(),
  //                            isExpanded: true)
  //                   
  //                      ),
  //                    ],
  //                  ),
  //                 ),
  //                ],
  //              ),
                const SizedBox(height: 10),

                const Text('*Socio del negocio'),

                const SizedBox(height: 10),

               Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.black38),
              ),
              child:  DropdownButton<String>(
                hint: const Text('Selecciona socio de negocio'),
                value: _socioValue,
                onChanged: (String? newValue) {
                   if (newValue != null) {
                     setState(() {
                        _socioValue = newValue;
                     });
                     _socioValue = newValue;
                   }
                },
                   items: _socioDelNegocio.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                  isExpanded: true)),
                
                const SizedBox(height: 15),

                TextFormField(
                  controller: _tecnicoController,
                  enabled: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color:Colors.black12),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color:Colors.black12 ),
                    ),
                    labelText: 'Usuario',
                    prefixIcon: Icon(Icons.person, color: Colors.black38),
                    // Estilos específicos para cuando el campo está deshabilitado
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    // Puedes agregar más estilos aquí según tus necesidades
                  ),
                  // Resto de las propiedades y validaciones
                ),

                const SizedBox(height: 10),

                const Text('*Finca'),

                const SizedBox(height: 10),

               Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.black38),
              ),
              child:  DropdownButton<String>(
                hint: const Text('Selecciona la finca'),
                value: _finca,
                onChanged: (String? newValue) {
                   if (newValue != null) {
                     setState(() {
                        _finca = newValue;
                     });
                     _finca = newValue;
                   }
                },
                   items: _fincas.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                  isExpanded: true)),
                
                const SizedBox(height: 15),

               

                TextFormField(
                  controller: dateTextEditingController,
                  enabled: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                    prefixIconColor: Colors.black26,
                    labelText: '*Fecha de Documento',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color:Colors.black12),
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
                      dateTextEditingController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {});
                    }
                  },
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: '*Comentarios',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        disabledColor: Colors.grey,
                        elevation: 6,
                        color: Colors.red[400],
                        onPressed: () async {
                        if (_formKey1.currentState?.validate() ?? false) {
                            // Insertar datos en la base de datos
                      
                          }  else{
                           showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Alerta'),
                                  content: const Text('Hay campos vacíos. Por favor, llene todos los campos.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );        
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          child: const Text(
                            'Completar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          disabledColor: Colors.grey,
                          elevation: 6,
                          color: Colors.red[400],
                          onPressed: () {
                            if (_formKey1.currentState!.validate()) {
                              model.setName1(_htScreen.text);
                              Navigator.of(context).pushNamed('DetHojTecn', arguments: model);
                            } else {
                              // Handle form validation if needed
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            child: const Text(
                              'Siguiente',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );    
  }
}
