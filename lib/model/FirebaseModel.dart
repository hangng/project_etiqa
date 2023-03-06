import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class firebaseModel extends ChangeNotifier {
  Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  Future<FirebaseApp> get fbApp => _fbApp;

  set fbApp(Future<FirebaseApp> value) {
    _fbApp = value;
    notifyListeners();
  }
}
