class  HojaTecnica{
  final String cicloSiem;
  final String tipoDocumento;
  final String organizacion;
  final String sociodelnegocio;
  final String agentecomercial;
  final String finca;
  final String fecha;
  
  HojaTecnica(this.cicloSiem, this.tipoDocumento, this.organizacion, this.sociodelnegocio,this.agentecomercial, this.finca, this.fecha);



Map<String , dynamic> toMap(){
  return{
  'ciclosem':        cicloSiem,
  'tipoDocumento':   tipoDocumento,
  'organizacion':    organizacion,
  'sociodelnegocio': sociodelnegocio,
  'agentecomercial': agentecomercial,
  'finca':           finca,
  'fecha':           fecha,
  };
}
}

