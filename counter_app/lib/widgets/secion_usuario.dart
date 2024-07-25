import 'package:flutter/material.dart';

class SecionUsuario extends ChangeNotifier {
  int? _userId;
  String? _userName;
  List<dynamic> _partnerId = [];

  int? get userId => _userId;
  String? get userName => _userName;

  void setUser(int id, String name) {
    _userId = id;
    _userName = name;
    notifyListeners();
  }
  void setPartnerId(List<dynamic> partnerId) {
    _partnerId = partnerId;
    notifyListeners();
  }

  Set<Object?> name_and_id() {
    return {_userId, _userName};
  }
}