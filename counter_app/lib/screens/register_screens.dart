// import 'dart:html';

import 'package:counter_app/widgets/peticione_api.dart';
import 'package:flutter/material.dart';
import 'package:counter_app/local_database.dart';
import 'package:sqflite/sqflite.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _adempiereUserController = TextEditingController();
  final con_api = Peticiones();

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
            Text("Registrando usuario..."),
          ],
        ),
      );
    },
  );
}

void _hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}

Future<void> _registerUser() async {
  if (_formKey.currentState!.validate()) {
    // Mostrar el diálogo de carga
    _showLoadingDialog(context);
    try {
      // Get the database instance
      final db = await LocalDataBase.instance.database;
      List<dynamic> user_id = await UserPrinciPal(_adempiereUserController.text);
      bool llenado = await LlenadoTablasMaestra(_adempiereUserController.text);
      if (llenado) {
        await db.insert('ad_user', {
          'username': _usernameController.text,
          'password': _passwordController.text,
          'email': _emailController.text,
          'adempiere_user': _adempiereUserController.text,
          'ad_user_id': user_id[0]['ad_user_id'], 
        }, conflictAlgorithm: ConflictAlgorithm.replace);
        

        // Ocultar el diálogo de carga
        _hideLoadingDialog(context);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User registered successfully!')),
        );

        // Optionally, you can navigate to another page or clear the form
        _formKey.currentState!.reset();
      } else {
        print("error en llenado de tablas");

        // Ocultar el diálogo de carga
        _hideLoadingDialog(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en llenado de tablas')),
        );
        _formKey.currentState!.reset();
      }
    } catch (error) {
      // Ocultar el diálogo de carga en caso de error
      _hideLoadingDialog(context);
      // Manejar el error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar usuario')),
      );
      print("Error: $error");
    }
  }
}



  Future<bool>InsertLocal(String tabla, List<dynamic> objeto_iterable) async {
    final db = await LocalDataBase.instance.database;
    for(var x in objeto_iterable){
        await db.insert(tabla,x as Map<String, Object?>, conflictAlgorithm: ConflictAlgorithm.replace,);
    }
    return true;
  }

  Future<bool>LlenadoTablasMaestra(String user_adempiere) async {
    List<dynamic> user_principal= await UserPrinciPal(user_adempiere);
    final db = await LocalDataBase.instance.database;
    if  (user_principal.isNotEmpty){
      int ad_user_id = user_principal[0]['ad_user_id'];
      var x= true;
      print("ID DE USUARIO $ad_user_id");
      
      // INSERTAR PRODUCTORES
      List<dynamic> productores = await SocioNegocioProductores(ad_user_id);
      await InsertLocal('c_bpartner',productores);

      // PODUCTOS
      List<dynamic> products =  await con_api.get_product();
      await InsertLocal('m_product',products);
      // productos para la finca
      List<dynamic> products_is_finca =  await con_api.get_product_fincas();
      await InsertLocal('m_product',products_is_finca);
      // PODUCTOS


      // INSERTAR FINCAS
      List<dynamic> fincas =  await con_api.fincas_socio_negocio(ad_user_id);
      await InsertLocal('farms_ranches',fincas);

      // INSERTAR CiCLOS
      List<dynamic> ciclos =  await con_api.cliclos_anuales();
      await InsertLocal('fap_plantingcycle',ciclos);
      List<dynamic> ciclosIds = ciclos.map((x) => x['fap_plantingcycle_id']).toList();
      String ciclo_ids = ciclosIds.join(', '); //Lista de ciclos
      

      // INSERTAR lotes
      List<dynamic> farmIds = fincas.map((x) => x['fap_farm_id']).toList();
      String farmIdsString = farmIds.join(', ');
      List<dynamic> lotes_fincas =  await con_api.lotes_fincas(farmIdsString);
      await InsertLocal('fap_farmdivision',lotes_fincas);

      // Sub Lotes 
      List<dynamic> lotesIds = lotes_fincas.map((x) => x['fap_farmdivision_id']).toList();
      String framdiviChills = lotesIds.join(', ');
      List<dynamic>sublotes =  await con_api.sub_lotes(framdiviChills);
      await InsertLocal('fap_farmdivisionchild', sublotes);
      
      // CULTIVO -----------
      List<dynamic> partnerIds = productores.map((x) => x['c_bpartner_id']).toList();
      String partner_ids = partnerIds.join(', ');
      List<dynamic> etapa_cultivo =  await con_api.cultivo(farmIdsString,ciclo_ids,farmIdsString,partner_ids);
      await InsertLocal('fap_farming', etapa_cultivo);
      // CULTIVO 


      // ETAPA RUBROS
      List<dynamic> m_productids = etapa_cultivo.map((x) => x['m_product_id']).toList();
      String m_product_ids = m_productids.join(', ');
      List<dynamic> etapa_rubro  =  await con_api.get_etapa_rubro(m_product_ids);
      await InsertLocal('fap_farmingstage', etapa_rubro);
      // ETAPA RUBROS

      // EVENTOS DE CULTIVO 
      List<dynamic> evento_cultivo =  await con_api.get_evento_cultivo();
      await InsertLocal('fap_symptomatology', evento_cultivo);
      // EVENTOS DE CULTIVO 

    // PRODUCTOS EN ALMACEN
    List<dynamic> pro_almacenes =  await con_api.get_product_almacen();
    await InsertLocal('m_warehouse', pro_almacenes);
    // PRODUCTOS EN ALMACEN


    // CATEGORIA DE PRODUCTO PARA ALMACEN
    List<dynamic> m_product_category =  await con_api.get_categoria_productos();
    await InsertLocal('m_product_category', m_product_category);
    // CATEGORIA DE PRODUCTO PARA ALMACEN



    // Tipo de Observaciones
    List<dynamic>tipo_observacion =  await con_api.get_tipo_observacion();
    await InsertLocal('fap_observationtype', tipo_observacion);
    // Tipo de Observaciones


      
      return x;
    }else{
      return false;
    }
  }

  Future<List>UserPrinciPal(String user_adempiere) async {
    List<dynamic>data_user_adempiere =  await con_api.user_adempiere(user_adempiere);
    return data_user_adempiere;
  }

  Future<List>SocioNegocioProductores(int ad_user_id) async {
    List<dynamic>data_user_adempiere =  await con_api.data_user_id(ad_user_id);
    return data_user_adempiere;
  }
  

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _adempiereUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _adempiereUserController,
                decoration: InputDecoration(labelText: 'Adempiere User'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Adempiere user';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
