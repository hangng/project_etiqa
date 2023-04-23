import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class firebaseModel extends ChangeNotifier {
  Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  Future<FirebaseApp> get fbApp => _fbApp;

  set fbApp(Future<FirebaseApp> value) {
    _fbApp = value;
    notifyListeners();
  }

  // Future<FirebaseApp> initializeFirebase() async {
  //   _fbApp = Firebase.initializeApp();
  //   dataStream();
  //   return _fbApp;
  // }
  CollectionReference dataStream() {
    final CollectionReference data = FirebaseFirestore.instance.collection('users');

    print("checking data stream called....");
    return data;
  }
}
