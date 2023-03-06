

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'user_presenter.dart';

class UserView extends StatelessWidget {
  final UserPresenter presenter;
  final _nameController = TextEditingController();

  UserView({required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MVP Example')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter your name',
              ),
              onChanged: presenter.updateName,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                presenter.greetUser(context);
              },
              child: Text('Greet'),
            ),
          ],
        ),
      ),
    );
  }

  void showGreeting(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Greeting'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
