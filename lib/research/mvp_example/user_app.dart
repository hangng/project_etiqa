import 'package:flutter/material.dart';

import 'user_model.dart';
import 'user_presenter.dart';
import 'user_view.dart';

void main() {
  final model = UserModel();
  final presenter = UserPresenter(model: model);
  final view = UserView(presenter: presenter);
  presenter.attachView(view);
  runApp(MaterialApp(home: view));
}
