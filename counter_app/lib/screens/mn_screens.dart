import 'package:flutter/material.dart';
import 'package:counter_app/screens/sidebar_menu.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:counter_app/models/refresh.dart';


class MnScreens extends StatefulWidget {
  static String routeName = '/MnSreens';

  MnScreens({Key? key}) : super(key: key);

  @override
  _MnScreensState createState() => _MnScreensState();
}

class _MnScreensState extends State<MnScreens> {
   final model = MyModel();

   final _TipEnfer = ["Maleza", "Plagas", "Otros"];
  String? _enfermedad = "Maleza";

  final _productos = [];  String? _product ;

  final _almacenes = [];  String? _alm;

final TextEditingController _dateEven = TextEditingController()  ;
final TextEditingController _date = TextEditingController()  ;

  final _formKey1 = GlobalKey<FormState>();
var Numask = MaskTextInputFormatter(mask: ' ####', filter: { "#": RegExp(r'[0-9]') });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manejo de cultivo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade400,
        shadowColor: Colors.black,
        elevation: 8,
      ),
      drawer: const SidebarScreens(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey1,
            child: Column(
              children: [
                
                const SizedBox(height: 10),
                const Text('*Tipo de evento', textAlign: TextAlign.left),
                const SizedBox(height: 10),
               Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(8.0),
                     border: Border.all(color: Colors.black38),
                   ),
                   child: DropdownButton<String>(
                    hint: Text('Seleccione el tipo de evento'),
                     value: _enfermedad,
                     items: _TipEnfer
                         .map((e) => DropdownMenuItem(child: Text(e), value: e))
                         .toList(),
                     onChanged: (val) {
                       setState(() {
                         _enfermedad = val;
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
                  
                   
                const SizedBox(height: 10),
     //       const Text('*Organización', textAlign: TextAlign.left),

     //      Container(
     //          padding: EdgeInsets.symmetric(horizontal: 16.0),
     //          decoration: BoxDecoration(
     //            borderRadius: BorderRadius.circular(8.0),
     //            border: Border.all(color: Colors.black38),
     //          ),
     //          child: DropdownButton(
     //            value: _organizacion,
     //            items: _Tiporg
     //                .map((e) => DropdownMenuItem(child: Text(e), value: e))
     //                .toList(),
     //            onChanged: (val) {
     //              setState(() {
     //                 _organizacion = val;
     //              });
     //            },
     //            style: const TextStyle(
     //              fontSize: 16,
     //              color: Colors.black,
     //            ),
     //            icon: const Icon(
     //              Icons.arrow_drop_down,
     //              color: Colors.red,
     //              size: 30,
     //            ),
     //            isExpanded: true,
     //          ),
     //      ),
                  
              
                const Text('*Evento', textAlign: TextAlign.left),
                  const SizedBox(height: 10),
               Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(8.0),
                     border: Border.all(color: Colors.black38),
                   ),
                   child: DropdownButton(
                    hint: const Text('Seleccione el evento'),
                     value: _enfermedad,
                     items: _TipEnfer
                         .map((e) => DropdownMenuItem(child: Text(e), value: e))
                         .toList(),
                     onChanged: (val) {
                       setState(() {
                         _enfermedad = val;
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
 
                const SizedBox(height: 15),  
                                
                const Divider(color: Colors.black12,),
                 const SizedBox(height: 15),
                
                const Text('Productos a Aplicar',style: TextStyle(fontSize: 18),),
                
                const SizedBox(height: 18),
                  
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(8.0),
                     border: Border.all(color: Colors.black38),
                   ),
                
                  child: DropdownButton(
                    hint: const Text('Seleccione el producto '),
                     value: _product,
                     items: _productos
                         .map((e) => DropdownMenuItem(child: Text(e), value: e))
                         .toList(),
                     onChanged: (val) {
                       setState(() {
                         _product = val as String?;
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _date,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_month_outlined),
                              labelText: 'Desde',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
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
                                  _date.text = DateFormat('yyy-MM-dd').format(pickedDate);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10), // Agregado un SizedBox para espacio entre los campos
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _dateEven,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              prefixIcon: Icon(Icons.calendar_month_outlined),
                              labelText: 'Hasta',
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
                                  _dateEven.text = DateFormat('yyy-MM-dd').format(pickedDate);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        inputFormatters: [Numask],
                         keyboardType : TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '*Cantidad',
                         // prefixIcon: Icon(Icons.home_work),
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
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: '*Dosis por Area',
                       //   prefixIcon: Icon(Icons.refresh_outlined),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo vacío';
                          }
                        if (
                          value.contains('-') ||
                          value.contains('\$') ||
                          value.contains('#')  ||
                          value.contains('@')  ||
                          value.contains('*')  
                        ) {
                            return 'Los campos no pueden tener caracteres especiales';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
    //           const SizedBox(height: 10),
    //           // Nro. Documento
    //           TextFormField(
    //             decoration:const InputDecoration(
    //               labelText: '*Dosis por área',
    //             //  prefixIcon: Icon(Icons.credit_card),
    //               border: OutlineInputBorder(
    //                 borderSide: BorderSide(color: Colors.red),
    //               ),
    //               focusedBorder: UnderlineInputBorder(
    //                 borderSide: BorderSide(color: Colors.red, width: 2),
    //               ),
    //             ),
    //             validator: (value) {
    //               if (value?.isEmpty ?? true) {
    //                 return 'Campo vacío';
    //               }
    //               return null;
    //             },
    //           ),
                 
                 const SizedBox(height: 18),
                
                const Divider(color: Colors.black12,),

                const SizedBox(height: 15),
                
                const Text('Cantidades a Ordenar',style: TextStyle(fontSize: 18),),
                
                const SizedBox(height: 15),

                const Text('*Unidad de medida', textAlign: TextAlign.left),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(8.0),
                     border: Border.all(color: Colors.black38),
                   ),
                   child: DropdownButton(
                    hint: const Text('Seleccione la cantidad'),
                     value: _product,
                     items: _productos
                         .map((e) => DropdownMenuItem(child: Text(e), value: e))
                         .toList(),
                     onChanged: (val) {
                       setState(() {
                         _product = val as String?;
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
                 
                 const SizedBox(height: 16),
                
                const Text('*Almacén', textAlign: TextAlign.left),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(8.0),
                     border: Border.all(color: Colors.black38),
                   ),
                   child: DropdownButton(
                    hint: const Text('Seleccione el almacen'),
                     value: _alm,
                     items: _almacenes
                         .map((e) => DropdownMenuItem(child: Text(e), value: e))
                         .toList(),
                     onChanged: (val) {
                       setState(() {
                         _alm = val as String?;
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
                
                const SizedBox(height: 10),
                // Botón Enviar
               Row(
                children: [  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5), // Ajusta el padding aquí
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledColor: Colors.grey,
                      elevation: 6,
                      color: Colors.red[400],
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Ajusta el padding aquí
                        child: const Text(
                          'Atrás',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 1), // Ajusta el espacio entre los botones si es necesario
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10), // Ajusta el padding aquí
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledColor: Colors.grey,
                      elevation: 6,
                      color: Colors.red[400],
                      onPressed: () {
                        // Validar el formulario antes de realizar la acción
                        if (_formKey1.currentState?.validate() ?? false) {
                          // Puedes añadir lógica para manejar el botón aquí
                        } else {
                          // Muestra una alerta si hay campos vacíos
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
                            }
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Ajusta el padding aquí
                        child: const Text(
                          'Completar',
                          style: TextStyle(color: Colors.white),
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


//if (_formKey2.currentState!.validate()) {
//                          model.setName2(_dthScreen.text); 
//                        Navigator.of(context).pushNamed('ManCultivo', arguments: model);
//
//
//                    }
//                }