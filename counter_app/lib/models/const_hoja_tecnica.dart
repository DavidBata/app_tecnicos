import 'dart:ui';

class TechnicalForm {
  final int? fap_technicalform_id;
  final int? ad_user_id;
  final int? c_bpartner_id;
  final int? fap_farm_id;
  final int? m_product_id;
  final int? fap_plantingcycle_id;
  final String? date_created;
  final String? finca_name;
 final String?  socio_name;
 final String?  ciclo_name;
 final String?  product_name;
 final int ? fap_technicalform_ade_id;

  final int? synced;

  TechnicalForm({
    required this.fap_technicalform_id,
    required this.ad_user_id,
    required this.c_bpartner_id,
    required this.fap_farm_id,
    required this.m_product_id,
    required this.fap_plantingcycle_id,
    required this.date_created,
    required this.finca_name,
    required this.socio_name,
    required this.ciclo_name,
    required this.product_name,
    required this.fap_technicalform_ade_id,
    required this.synced,

  });

  factory TechnicalForm.fromMap(Map<String, dynamic> map) {
    return TechnicalForm(
      fap_technicalform_id: map['fap_technicalform_id'] as int? ,
      ad_user_id: map['ad_user_id'] as int?,
      c_bpartner_id: map['c_bpartner_id'] as int? ,
      fap_farm_id: map['fap_farm_id'],
      m_product_id: map['m_product_id'],
      fap_plantingcycle_id: map['fap_plantingcycle_id'] as int? ,
      synced: map['synced'] as int? ,
      date_created: map['date_created'] as String?,
      finca_name: map['finca_name'] as String?,
      socio_name :  map['socio_name'] as String?,
      ciclo_name :  map['ciclo_name'] as String?,
      product_name :  map['product_name'] as String?,
      fap_technicalform_ade_id : map['fap_technicalform_ade_id'] as int? ,
    );
  }
}