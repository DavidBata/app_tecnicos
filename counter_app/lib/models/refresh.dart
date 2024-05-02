//import 'package:flutter/material.dart';

class MyModel {
  String _name1 = '';
  String _name2 = '';
  String _name3 = '';

  String get name1 => _name1;
  String get name2 => _name2;
  String get name3 => _name3;

  setName1(String name) {
    _name1 = name;
  }

  setName2(String name) {
    _name2 = name;
  }

  setName3(String name) {
    _name3 = name;
  }
}