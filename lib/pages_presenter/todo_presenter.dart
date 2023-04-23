import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../pages_model/todo_model.dart';
import '../pages_view/todo_view.dart';

class TodoListPresenter with ChangeNotifier {
  TodoListModel model;
  late final TodoView view;

  TodoListPresenter({required this.model});

  void attachView(TodoView view) {
    this.view = view;
  }

  void updateStartDate(String date) {
    model.startDate = date;
    notifyListeners();
  }

  void updateEndDate(String date) {
    model.endDate = date;
    notifyListeners();
  }

  void updateRemainTime(String time) {
    model.remainTime = time;
    notifyListeners();
  }

  // void updateStatus(bool status) {
  //   model.status = status;
  //   notifyListeners();
  // }

  void initializeData(DocumentSnapshot dsData) {
    model.notes = dsData['title'];
    model.startDate = dsData['stDate'];
    model.endDate = dsData['edDate'];
    model.remainTime = dsData['time'];
    model.firebaseId = dsData.id;
    model.rawStartDate = dsData['rawStDate'];
    model.rawEndDate = dsData['rawEdDate'];
    model.status = dsData['complete'];
  }

  void processStartDate() {}

  void processEndDate() {}
}
