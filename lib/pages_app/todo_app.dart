import 'package:flutter/material.dart';

import '../model/FirebaseModel.dart';
import '../pages_model/todo_model.dart';
import '../pages_presenter/todo_presenter.dart';
import '../pages_view/todo_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final modelFB = firebaseModel();
  final modelTodo = TodoListModel();
  final presenter = TodoListPresenter(model: modelTodo);
  final view = TodoView(presenter: presenter);
  presenter.attachView(view);
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: view));
}
