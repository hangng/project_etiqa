import 'package:flutter/material.dart';

import 'person_data_model.dart';

class PersonViewModel extends ChangeNotifier {
  String _name = '';

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  void savePerson() {
    final person = Person(name: _name);
    print("checking person == ${person.name}");
    // Save the person to the database or perform any other necessary operations
  }
}
