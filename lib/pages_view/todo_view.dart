import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maybank_etiqa/model/FirebaseModel.dart';
import 'package:maybank_etiqa/pages_presenter/todo_presenter.dart';
import 'package:provider/provider.dart';

import '../objects/dataObj.dart';
import '../pages/create_item.dart';
import '../pages/main.dart';
import '../pages_model/todo_model.dart';

class TodoView extends StatelessWidget {
  final TodoListPresenter presenter;

  TodoView({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          title: Text(
            'To-Do-List',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ChangeNotifierProvider(
          create: (context) => presenter,
          child: FutureBuilder(
            future: firebaseModel().fbApp,
            builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
              if (snapshot.hasError) {
                print('Firebase Error !! ${snapshot.error.toString()}');
                return Text('Firebase Somethine went wrong!!');
              } else if (snapshot.hasData) {
                return ItemInfoLst(
                  presenter: presenter,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ItemInfoLst extends StatefulWidget {
  final TodoListPresenter presenter;

  ItemInfoLst({required this.presenter});

  @override
  State<StatefulWidget> createState() => ItemInfoLstState();
}

class ItemInfoLstState extends State<ItemInfoLst> {
  late Timer time;
  final CollectionReference _user = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
          colors: [Colors.redAccent, Colors.cyanAccent],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Container(
              color: Colors.grey[250],
              child: StreamBuilder(
                stream: _user.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final DocumentSnapshot dsData = streamSnapshot.data!.docs[index];
                        return Container(
                          child: Center(
                            child: ItemInfoCard(
                              sTitle: dsData['title'],
                              sStartDate: dsData['stDate'],
                              sEndDate: dsData['edDate'],
                              sTime: dsData['time'],
                              sFbDocId: dsData.id,
                              sRwStDate: dsData['rawStDate'],
                              sRwEdDate: dsData['rawEdDate'],
                              bComplete: dsData['complete'],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: FloatingActionButton(
                  backgroundColor: Colors.deepOrange,
                  onPressed: () {
                    _navigateAndDisplaySelection(context);
                  },
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<IDataObj>> readUsers() => FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) => snapshot.docs.map((doc) => IDataObj.fromJson(doc.data())).toList());

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateItem(
                sTitle: "",
                sStartDate: "",
                sEndDate: "",
                sTime: "",
                bIsEdit: false,
                sFbDocId: "",
                sRwStDate: "",
                sRwEdDate: "",
              )),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    setState(() {
      print('checking refresh list  = ${result}');
    });
    // //
  }
}


class ItemInfoCard extends StatefulWidget {
  var sTitle, sStartDate, sEndDate, sTime, sFbDocId, sRwStDate, sRwEdDate;
  bool bComplete = false;

  ItemInfoCard(
      {Key? key,
        required this.sTitle,
        required this.sStartDate,
        required this.sEndDate,
        required this.sTime,
        required this.sFbDocId,
        required this.bComplete,
        required this.sRwEdDate,
        required this.sRwStDate})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ItemInfoCardState();
}

class ItemInfoCardState extends State<ItemInfoCard> {
  bool isChecked = false;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.grey;
    }
    return Colors.black;
  }

  @override
  void initState() {
    super.initState();
    isChecked = widget.bComplete;
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateItem(
          sTitle: widget.sTitle,
          sStartDate: widget.sStartDate,
          sEndDate: widget.sEndDate,
          sTime: widget.sTime,
          bIsEdit: true,
          // inform page is update
          sRwStDate: widget.sRwStDate,
          sRwEdDate: widget.sRwEdDate,
          sFbDocId: widget.sFbDocId,
        ),
      ),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    setState(() {
      print('checking refresh list  = ${result}');
      // FirebaseStoreLoadData();
    });
    // //
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Delete Alert'),
              content: const Text('Are you sure to  delete?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      FirebaseFirestore.instance.collection('users').doc(widget.sFbDocId).delete();

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have successfully deleted a product ')));
                      Navigator.pop(context, 'OK');
                    }),
              ],
            ),
          );
        });
      },
      onTap: () {
        print('checking sTitle ${widget.sTitle}');
        print('checking sStartDate ${widget.sStartDate}');
        print('checking sEndDate ${widget.sEndDate}');
        print('checking sTime ${widget.sTime}');
        print('checking bComplete ${widget.bComplete}');
        print('checking sRwStDate ${widget.sRwStDate}');
        print('checking sRwEdDate ${widget.sRwEdDate}');
        print('checking sFbDocId ${widget.sFbDocId}');

        _navigateAndDisplaySelection(context);
      },
      child: Card(
        margin: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        elevation: 10,
        child: Wrap(
          children: [
            Container(
              height: 130,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    child: Text(
                      widget.sTitle,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              child: Text(
                                'Start Date',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Container(
                              child: Text(
                                widget.sStartDate,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              child: Text(
                                'End Date',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Container(
                              child: Text(
                                widget.sEndDate,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              child: Text(
                                'Time Left',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Container(
                              child: Text(
                                widget.sTime,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Text(
                          "Status",
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: isChecked
                            ? Text(
                          'Completed',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                            : Text(
                          'Incomplete',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Text(
                          "Tick if Completed",
                        ),
                      ),
                      Container(
                        child: Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isChecked,
                          onChanged: (bool? value) {
                            FirebaseFirestore.instance.collection('users').doc(widget.sFbDocId).update({"complete": value});

                            print('id ===== ${widget.sFbDocId}');

                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

