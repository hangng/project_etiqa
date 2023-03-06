import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'person_view_model.dart';
class PersonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PersonViewModel model = PersonViewModel();

    return Scaffold(
      appBar: AppBar(
        title: Text('Person Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) => model.name = value,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => model.savePerson(),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
