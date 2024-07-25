class SiembraData {
  final String id;
  final String name2;

  SiembraData(this.id, this.name2);
}

class Login{
  final String   usuario;
  final String password;
  final String tecnico; // Nuevo campo para almacenar el nombre de usuario

  Login(this.usuario, this.password,this.tecnico);
}

class SocioDeNegocio {
  final String id;
  final String value;
  final String name;

  SocioDeNegocio({
    required this.id,
    required this.value,
    required this.name,
  });
}

class Fincas{
    final int idFinca;
    final String finca;
    
  Fincas(this.idFinca, this.finca,);
   factory Fincas.fromMap(Map<String, dynamic> map) {
    return Fincas(
      map['idFinca'] as int,
      map['finca'] as String,
    );
  }
  }