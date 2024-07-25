import 'package:http/http.dart' as http;
import 'dart:convert';

class Peticiones {


    Future<List<dynamic>> peticion_sencilla(url_peticion) async {
    // URL de la API
    List<dynamic> data = [];
    final url = Uri.parse(url_peticion);
    // Hacer la petición GET
    final response = await http.get(url);
    // Verificar el código de estado de la respuesta
    if (response.statusCode == 200) {
      // Decodificar la respuesta
      final List<dynamic> data = jsonDecode(response.body);
      // print('Datos obtenidos: $data');
      print(data);
      return data;
    } else {
      print('Error en la petición: ${response.statusCode}');
      return data;
    }
  }


  Future<List<dynamic>> peticion_sencilla_post(url_peticion,json) async {
    // URL de la API
    List<dynamic> data = [];
    final url = Uri.parse(url_peticion);

    // Hacer la petición GET

     Map<String, dynamic> body =json;
  

   final response = await http.post(
    url,
    body: jsonEncode(body), // Convertir el mapa a JSON
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    // Verificar el código de estado de la respuesta
    if (response.statusCode == 200) {
      // Decodificar la respuesta JSON
      final List<dynamic> data = jsonDecode(response.body);
      print('Datos obtenidos: $data');
      return data;
    } else {
      print('Error en la petición: ${response.statusCode}');
      return []; // Devolver una lista vacía en caso de error
    }
  }


  Future<List<dynamic>> login_user(user,password) async {
    // URL de la API
    List<dynamic> data = [];
    print(user);
    print(password);
    final url = Uri.parse('http://192.168.1.192:8000/peticion/$user/$password');
    // Hacer la petición GET
    final response = await http.get(url);
    // Verificar el código de estado de la respuesta
    if (response.statusCode == 200) {
      // Decodificar la respuesta
      final List<dynamic> data = jsonDecode(response.body);
      // print('Datos obtenidos: $data');
      print(data);
      return data;
    } else {
      print('Error en la petición: ${response.statusCode}');
      return data;
    }
  }


  Future<List<dynamic>> data_user_id(ad_user_id) async {
    // URL de la API
    List<dynamic> data = [];
    final url = Uri.parse('http://192.168.1.192:8000/partners/$ad_user_id');
    // Hacer la petición GET
    final response = await http.get(url);
    // Verificar el código de estado de la respuesta
    if (response.statusCode == 200) {
      // Decodificar la respuesta
      final List<dynamic> data = jsonDecode(response.body);
      // print('Datos obtenidos: $data');
      // print(data);
      return data;
    } else {
      print('Error en la petición: ${response.statusCode}');
      return data;
    }
  }

  
  Future<List<dynamic>>fincas_socio_negocio(ad_user_id) async {
    final data = peticion_sencilla("http://192.168.1.192:8000/peticion_fincas/$ad_user_id");
    return data;
  }

  Future<List<dynamic>>cliclos_anuales() async {
    final data = peticion_sencilla("http://192.168.1.192:8000/peticion_ciclos");
    return data;
  }
  Future<List<dynamic>>user_name(user_id) async {
    final data = peticion_sencilla("http://192.168.1.192:8000/username/$user_id");
    return data;
  }

  Future<List<dynamic>>search_user(user) async {
    final data = peticion_sencilla("http://192.168.1.192:8000/user_user/$user");
    return data;
  }

  Future<List<dynamic>>lote_fincas(fap_farm_id) async {
    final data = peticion_sencilla("http://192.168.1.192:8000/lotes_finca/$fap_farm_id");
    return data;
  }

 
  Future<List<dynamic>>user_adempiere(user_adempiere) async {
    final data = peticion_sencilla("http://192.168.1.192:8000/user_adempiere/$user_adempiere");
    return data;
  }    
  
  
  Future<List<dynamic>>lotes_fincas(list_ids) async {
    final data = peticion_sencilla("http://192.168.1.192:8000/lotes_fincas/$list_ids");
    return data;
  }

  Future<List<dynamic>>sub_lotes(list_ids) async {
    final data = peticion_sencilla("http://192.168.1.192:8000/sub_lotes/$list_ids");
    return data;
  }
  Future<List<dynamic>>cultivo(farmIds_list,ciclo_ids_list,lotesIds_list,partner_ids_list) async {
    final data = peticion_sencilla("http://192.168.1.192:8000/cultivo/$farmIds_list/$ciclo_ids_list/$lotesIds_list/$partner_ids_list");
    return data;
  }

  Future<List<dynamic>>get_product() async {
    final data = peticion_sencilla("http://192.168.1.192:8000/m_product");
    return data;
  }

  Future<List<dynamic>>get_etapa_rubro(ids) async {
    final data = peticion_sencilla("http://192.168.1.192:8000/etapa_rubro/$ids");
    return data;
  }

  Future<List<dynamic>>get_evento_cultivo() async {
    final data = peticion_sencilla("http://192.168.1.192:8000/evento_cultivo");
    return data;
  }
  Future<List<dynamic>>get_product_fincas() async {
    final data = peticion_sencilla("http://192.168.1.192:8000/m_product_is_finca");
    return data;
  }

  Future<List<dynamic>>get_product_almacen() async {
    final data = peticion_sencilla("http://192.168.1.192:8000/product_alamacen");
    return data;
  }

  Future<List<dynamic>>get_categoria_productos() async {
    final data = peticion_sencilla("http://192.168.1.192:8000/categoria_products");
    return data;
  }

  Future<List<dynamic>>get_conection_api() async {
    final data = peticion_sencilla("http://192.168.1.192:8000/connet_api");
    return data;
  }

  Future<List<dynamic>>get_tipo_observacion() async {
    final data = peticion_sencilla("http://192.168.1.192:8000/tipo_observacion");
    return data;
  }
  Future <List<dynamic>?> createhojatecnica( Map<String, dynamic>  item, ruta) async {

  print(item);
  final url = Uri.parse('http://192.168.1.192:8000/$ruta');  // Asegúrate de usar la dirección correcta
  final  response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(item),
  );
   if (response.statusCode == 200) {
    print('Item creado con éxito');
    // Decodifica la respuesta JSON recibida
    List<dynamic> responseData = jsonDecode(response.body);
    // Accede al valor devuelto por FastAPI
    // print(responseData);
    // int fapTechnicalformAdeId = responseData[0]['fap_technicalform_ade_id'];
    return responseData;
  } else {
    print('Error al crear el item: ${response.statusCode}');
    return null;
  }
}
 
}


