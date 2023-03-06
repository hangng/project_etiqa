

import 'package:flutter/cupertino.dart';

class TestingModel extends ChangeNotifier{


  String _name1 ="";
  String _name2 ="";

  String get name1 => _name1;

  set name1(String value) {
    _name1 = value;
    notifyListeners();
  }

  String get name2 => _name2;

  set name2(String value) {
    _name2 = value;
    notifyListeners();
  }
}