import 'dart:io';
import 'package:counter_app/local_database.dart';
import 'package:counter_app/screens/documentos.dart';
import 'package:flutter/material.dart';
import 'package:counter_app/screens/sidebar_menu.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MnScreens extends StatefulWidget {
  final List<dynamic>? datos;
  // static String routeName = '/MnSreens';
  MnScreens({Key? key, this.datos}) : super(key: key);

  @override
  _MnScreensState createState() => _MnScreensState();
}

class _MnScreensState extends State<MnScreens> {


  
  
  dynamic selectedTipoEvento;
  dynamic selectedEvento;
  dynamic selectedProductSugerido;
  dynamic selectedProductAlmacen;
  dynamic selectedCategoryProduct;




  final _TipEnfer = [{"tipo_evento_id": 'UN', "name" : 'Maleza'} ,{"tipo_evento_id": 'DI', "name" : 'Enfermedad'} ,{"tipo_evento_id": 'FE', "name" : 'Fertilizante'},{"tipo_evento_id": 'OT', "name" : 'Otros'} ,{"tipo_evento_id": 'PL', "name" : 'Plaga'}];
  List<dynamic>? evento = [];
  List<dynamic>? producto_sugerido = [];
  List<dynamic>? producto_almacenes = [];
  List<dynamic>? categoria_productos = [];

  int? quantity_apply;
  int? dose_area;


  final _productos = [];
  String? _product ;

  final _almacenes = [];
  String? _alm;

final TextEditingController _dateEven = TextEditingController()  ;
final TextEditingController _date = TextEditingController()  ;
TextEditingController quantityController = TextEditingController();
TextEditingController _observationController = TextEditingController();
TextEditingController doseAreaController = TextEditingController();

  // Campos adicionales

final ImagePicker _picker = ImagePicker();
XFile? _image;
stt.SpeechToText _speech = stt.SpeechToText();
bool _isListening = false;
String _description = '';

  final _formKey1 = GlobalKey<FormState>();



  @override
  void initState() {
    super.initState();
    print(widget.datos![0]);
   
    CargaCampos();
  }

  
  Future<void>GetEventoCultivo(tipo_evento) async {
    final db = await LocalDataBase.instance.database;
    List<dynamic> _eventos = await db.rawQuery('SELECT  * FROM fap_symptomatology where symptomatologytype = ?', [tipo_evento]);
    // Eliminar duplicados
    _eventos = _eventos.toSet().toList();
    setState(() {
      evento = _eventos;
    });
  }

  Future<void>GetProductFinca() async {
    final db = await LocalDataBase.instance.database;
    List<dynamic> _product_finca_sujerido = await db.rawQuery('SELECT  m_product_id, name FROM m_product where is_finca = ?', [1]);
    // Eliminar duplicados
    _product_finca_sujerido= _product_finca_sujerido.toSet().toList();
    setState(() {
      producto_sugerido = _product_finca_sujerido;
    });
  }

  Future<void>GetProductAlamacen(m_product_category_id) async {
    final db = await LocalDataBase.instance.database;
    List<dynamic>_product_almacen = await db.rawQuery('SELECT * FROM m_warehouse where m_product_category_id = ?', [m_product_category_id]);
    // Eliminar duplicados
    print("ALMACEN PRODUCT ___ :$_product_almacen");
    _product_almacen= _product_almacen.toSet().toList();
    setState(() {
      producto_almacenes = _product_almacen;
    });
  }


  Future<void>GetCategoryProduct() async {
    final db = await LocalDataBase.instance.database;
    List<dynamic> _categoria_productos = await db.rawQuery('SELECT * FROM m_product_category');
    // Eliminar duplicados
    print("Categoria Cargadas  : $_categoria_productos");
    _categoria_productos= _categoria_productos.toSet().toList();
    setState(() {
      categoria_productos = _categoria_productos;
    });
  }

  Future<void> CargaCampos() async {
    await GetProductFinca();
    // await GetProductAlamacen();
    await GetCategoryProduct();
  }

  void CompleteHoja() async {

    final db = await LocalDataBase.instance.database;
    print(selectedTipoEvento['tipo_evento_id']);
    print(selectedProductSugerido['m_product_id']);
    print(selectedProductAlmacen['m_warehouse_id']);
    print(_date.text);
    print(widget.datos![0]['date_hoja']);
    var hojatecnica;
    var id_cabezera;
    if (widget.datos![0]["id_hoja"]>0 ){
       hojatecnica= {
        'date_hoja': DateFormat('dd-MM-yyyy').format(DateTime.now()) ,
        'ad_user_id':widget.datos![0]['ad_user_id']
      };
      id_cabezera= widget.datos![0]["id_hoja"];
      
    }else{
      hojatecnica= {
        'c_bpartner_id': widget.datos![0]['c_bpartner_id'],
        'finca' : widget.datos![0]['finca'],
        'fap_plantingcycle_id': widget.datos![0]['fap_plantingcycle_id'],
        'date_hoja': widget.datos![0]['date_hoja'],
        'ad_user_id':widget.datos![0]['ad_user_id'],
        'rubro':widget.datos![0]["rubro"]
      };
      id_cabezera =await db.rawInsert(
        'INSERT OR REPLACE INTO fap_technicalform (ad_user_id,c_bpartner_id, fap_farm_id, fap_plantingcycle_id, date_created,m_product_id, synced) VALUES (?, ?, ?, ?,?,?,?)',
        [hojatecnica['ad_user_id'], hojatecnica['c_bpartner_id'], hojatecnica['finca'], hojatecnica['fap_plantingcycle_id'],hojatecnica['date_hoja'],hojatecnica['rubro'],0 ],
      );
    }
    var detallehoja= {
      'fap_farmdivision_id':widget.datos![0]["detalle_hoja"][0]['fap_farmdivision_id'],
      'fap_farmingstage_id':widget.datos![0]["detalle_hoja"][0]['fap_farmingstage_id'],
      'fap_farming_id':widget.datos![0]["detalle_hoja"][0]['fap_farming_id'],
      'fap_farmdivisionchild_id':widget.datos![0]["detalle_hoja"][0]['fap_farmdivisionchild_id'],
      'fap_farm_id' : widget.datos![0]['finca'],
      'fap_observationtype_id':widget.datos![0]["detalle_hoja"][0]['fap_observationtype_id'],
      'fap_technicalform_ade_id': widget.datos![0]["detalle_hoja"][0]['fap_technicalform_ade_id'],
      'fap_technicalformline_ade_id': widget.datos![0]["detalle_hoja"][0]['fap_technicalformline_ade_id'],

    };  
 

    // print("AQUI ESTA LA FINCA  ${widget.datos![0]['finca']}");
    // print("AQUI ESTA LA OBSERVACION  ${widget.datos![0]["detalle_hoja"][0]['fap_observationtype_id']}");
    int id_detalle =await db.rawInsert(
        'INSERT OR REPLACE INTO fap_technicalformline (fap_technicalform_id,fap_farming_id, fap_farmdivision_id, fap_farmdivisionchild_id,fap_farmingstage_id, date_created,fap_farm_id,fap_observationtype_id, fap_technicalform_ade_id, synced) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [id_cabezera, detallehoja['fap_farming_id'], detallehoja['fap_farmdivision_id'],detallehoja['fap_farmdivisionchild_id'],detallehoja['fap_farmingstage_id'], hojatecnica['date_hoja'],detallehoja['fap_farm_id'],detallehoja['fap_observationtype_id'],detallehoja['fap_technicalform_ade_id'], 0 ],
    );

    int id_manejo_cultivo =await db.rawInsert(
        '''INSERT OR REPLACE INTO 
        fap_htsymptomatology 
        (fap_technicalformline_id,
        symptomatologytype,
        m_product_id,
        m_warehouse_id,
        date_aplicarion_pro,
        date_created,
        quantity_apply,
        dose_area ,
        observacion,
        fap_technicalformline_ade_id,
        fap_symptomatology_id,
        synced
        ) 
        VALUES (?, ?, ?, ?, ?, ?, ? ,?, ?, ?, ?, ?)''',
        [
        id_detalle, 
        selectedTipoEvento['tipo_evento_id'], 
        selectedProductSugerido['m_product_id'],
        selectedProductAlmacen['m_warehouse_id'],
        _date.text,
        hojatecnica['date_hoja'],
        quantityController.text,
        doseAreaController.text,
        _observationController.text,
        hojatecnica['fap_technicalformline_ade_id'],
        selectedEvento['fap_symptomatology_id'],
        0 
        ],
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Datos guardados exitosamente')));

    print(id_cabezera);
    Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>  Documents(tecnico: hojatecnica['ad_user_id']),
                    ),
                  );

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
                Text('¿Estás seguro de que deseas completar la hoja?'),
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
              child: Text('Aceptar'),
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
Future<bool>InsertLocal(String tabla, List<dynamic> objeto_iterable) async {
    final db = await LocalDataBase.instance.database;
    for(var x in objeto_iterable){
        await db.insert(tabla,x as Map<String, Object?>, conflictAlgorithm: ConflictAlgorithm.replace,);
    }
    return true;
}

// Métodos adicionales para seleccionar una imagen y reconocer voz

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = pickedFile;
    });
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) => setState(() {
              _description = val.recognizedWords;
            }));
      }
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey1,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        '*Tipo Evento',
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
                    hint: const Text('Selecciona Tipo Evento'),
                    value: selectedTipoEvento,
                    isExpanded: true,
                    items: _TipEnfer?.map((dynamic tenv) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: tenv,
                        child: Text(tenv['name'] ?? 'Sin nombre'),
                      );
                    }).toList(),
                    onChanged: (Map<String, dynamic>? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          selectedEvento = null;
                          selectedTipoEvento = newValue;
                        });
                        var tipo_evento_id = newValue['tipo_evento_id'];
                        await GetEventoCultivo(tipo_evento_id);
                        print('Selected rubro ID: $tipo_evento_id');
                      } else {
                        setState(() {
                          selectedTipoEvento = null;
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
                        '*Evento',
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
                    hint: const Text('Selecciona Evento'),
                    value: selectedEvento,
                    isExpanded: true,
                    items: evento?.map((dynamic tenv) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: tenv,
                        child: Text(tenv['name'] ?? 'Sin nombre'),
                      );
                    }).toList(),
                    onChanged: (Map<String, dynamic>? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          selectedEvento = newValue;
                        });
                        var id_evento = newValue['fap_symptomatology_id'];
                        print('Selected rubro ID: $id_evento');
                      } else {
                        setState(() {
                          selectedEvento = null;
                        });
                      }
                    },
                  ),
                ),
    
                   
                const SizedBox(height: 10),
    
              
                const Text('*Evento', textAlign: TextAlign.left),
                  const SizedBox(height: 10),
                const SizedBox(height: 15),  
                                
                const Divider(color: Colors.black12,),
                 const SizedBox(height: 15),
                
                const Text('Productos a Aplicar',style: TextStyle(fontSize: 18),),
                
                const SizedBox(height: 18),
                  
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        '*Producto Sugerido',
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
                    hint: const Text('Selecciona Producto Sugerido'),
                    value: selectedProductSugerido,
                    isExpanded: true,
                    items: producto_sugerido?.map((dynamic sug) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: sug,
                        child: Text(sug['name'] ?? 'Sin nombre'),
                      );
                    }).toList(),
                    onChanged: (Map<String, dynamic>? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          selectedProductSugerido = newValue;
                        });
                        var producto_sujerido = newValue['m_product_id'];
                        print('Selected rubro ID: $producto_sujerido ');
                      } else {
                        setState(() {
                          selectedProductSugerido = null;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 15),
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
             
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '*Cantidad',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      validator: (value) {
                        print(value);
                        if (value == null || value.isEmpty) {
                          return 'Campo vacío';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: doseAreaController,
                      decoration: const InputDecoration(
                        labelText: '*Dosis por Area',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      validator: (value) {
                        print(value);
                        if (value == null || value.isEmpty) {
                          return 'Campo vacío';
                        }
                        if (value.contains('-') ||
                            value.contains('\$') ||
                            value.contains('#') ||
                            value.contains('@') ||
                            value.contains('*')) {
                          return 'Los campos no pueden tener caracteres especiales';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
  
                 
                 const SizedBox(height: 18),
                
                const Divider(color: Colors.black12,),

                const SizedBox(height: 15),
                
                const Text('Productos Existentes',style: TextStyle(fontSize: 18),),
                
                const SizedBox(height: 15),

              Row(
                  children: const [
                    Expanded(
                      child: Text(
                        '*Categoria de Producto',
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
                    hint: const Text('Categoria de Producto'),
                    value: selectedCategoryProduct,
                    isExpanded: true,
                    items: categoria_productos?.map((dynamic sug) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: sug,
                        child: Text(sug['name'] ?? 'Sin nombre'),
                      );
                    }).toList(),
                    onChanged: (Map<String, dynamic>? newValue) async {
                      if (newValue != null) {

                        setState(() {
                          selectedProductAlmacen = null;
                          selectedCategoryProduct = newValue;
                        });
                        var categoria_id= newValue['m_product_category_id'];
                        await GetProductAlamacen(categoria_id);
                        print('Categoria ID ID: $categoria_id');
                      } else {
                        setState(() {
                          selectedCategoryProduct = null;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black38),
                  ),
                  child: DropdownButton<Map<String, dynamic>>(
                    hint: const Text('Productos Disponibles '),
                    value: selectedProductAlmacen,
                    isExpanded: true,
                    items: producto_almacenes?.map((dynamic sug) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: sug,
                        child: Text(sug['name'] ?? 'Sin nombre'),
                      );
                    }).toList(),
                    onChanged: (Map<String, dynamic>? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          selectedProductAlmacen = newValue;
                        });
                        var almacen_id= newValue['m_warehouse_id'];
                        print('ALMACEN _ID: $almacen_id');
                      } else {
                        setState(() {
                          selectedProductAlmacen = null;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                    child: TextFormField(
                      controller: _observationController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: '*Observacion  : ',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      validator: (value) {
                        print(value);
                        if (value == null || value.isEmpty) {
                          return 'Campo vacío';
                        }
                        return null;
                      },
                    ),
                  ),
                const SizedBox(height: 20),
                  ElevatedButton.icon(
                      onPressed: _takePhoto,
                      icon: Icon(Icons.camera_alt),
                      label: Text('Tomar Foto'),
                    ),
                    _image == null
                    ? Text('No se ha seleccionado ninguna imagen.')
                        : Image.file(File(_image!.path)),
                    const SizedBox(height: 10.0),


                  ElevatedButton.icon(
                      onPressed: _isListening ? _stopListening : _startListening,
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                      ),
                      label: Text(_isListening ? 'Detener' : 'Hablar'),
                    ),
                    // Mostrar la descripción reconocida por voz
                    Text(
                      _description,
                      style: TextStyle(fontSize: 16),
                    ),
                ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  child: const Text('Completar'),
                  style: ElevatedButton.styleFrom(
                  backgroundColor : Colors.teal[900], // Color de fondo del botón
                  foregroundColor :  Colors.white, // Color del texto dentro del botón
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


//if (_formKey2.currentState!.validate()) {
//                          model.setName2(_dthScreen.text); 
//                        Navigator.of(context).pushNamed('ManCultivo', arguments: model);
//
//
//                    }
//                }