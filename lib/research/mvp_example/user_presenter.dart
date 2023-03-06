import 'package:flutter/cupertino.dart';

import 'user_model.dart';
import 'user_view.dart';

class UserPresenter {
  final UserModel model;
  late final UserView view;

  UserPresenter({required this.model});

  void updateName(String name) {
    model.name = name;
  }

  void greetUser(BuildContext context) {
    final name = model.name;
    view.showGreeting('Hello, $name!',context);
  }

  void attachView(UserView view) {
    this.view = view;
  }
}