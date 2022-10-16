import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                final name = controller.text;
                createUser(name: name);
              },
              icon: Icon(Icons.add)),
          IconButton(
              onPressed: () {
                final docUser =
                    FirebaseFirestore.instance.collection('users').doc();
                docUser.update({
                  'name': 'James',
                });


              },
              icon: Icon(Icons.update)),
        ],
        title: TextField(
          controller: controller,
        ),
      ),
      body: StreamBuilder<List<User>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Firebase Error !! ${snapshot.error.toString()}');
            return Text('Firebase Somethine went wrong!!');
          } else if (snapshot.hasData) {

            // get doc id
            FirebaseFirestore.instance
                .collection('users')
                .get()
                .then((value) {
              value.docs.forEach((element) {
                print(element.id);
              });
            });


            // access all user data from here
            final users = snapshot.data!;
            return ListView(children: users.map(buildUser).toList());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Widget buildUser(User user) => ListTile(
      leading: CircleAvatar(
        child: Text(
          'Age',
        ),
      ),
      title: Text(user.sName),
      subtitle: Text('hi from firebase'),
    );

Stream<List<User>> readUsers() =>
    FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

// User.fromJson(doc.data()).toList());

Future createUser({required String name}) async {
  //Reference to document
  // final docUser = FirebaseFirestore.instance.collection('users').doc('my-id');

  // specific data
  // final json = {
  //   'name': name,
  //   'age': 21,
  //   'birthDay': DateTime(2011, 7, 29),
  // };
  // await docUser.set(json);

  final docUser = FirebaseFirestore.instance.collection('users').doc();
  // specific object
  // final user = User(id: docUser.id, sName: name, iAge: 21);
  final user = User(id: docUser.id, sName: name);
  final json = user.toJson();

  // create document and write data to firebase
  await docUser.set(json);
}

class User {
  String id = '';
  final String sName;

  // final int? iAge;

  User({
    required this.id,
    required this.sName,
    // this.iAge,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': sName,
        // 'age': iAge,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'] ?? ''.toString(),
        sName: json['name'] ?? ''.toString(),
        // iAge: json['age']== null ? 0 : 1,
      );
}
