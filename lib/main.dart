import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../objects/dataObj.dart';
import 'create_item.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: _fbApp,
          builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
            if (snapshot.hasError) {
              print('Firebase Error !! ${snapshot.error.toString()}');
              return Text('Firebase Somethine went wrong!!');
            } else if (snapshot.hasData) {
              return ItemInfoLst();
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class ItemInfoLst extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ItemInfoLstState();
}

class ItemInfoLstState extends State<ItemInfoLst> {
  List<IDataObj> dataLst = <IDataObj>[];
  late Timer time;

  @override
  void initState() {
    super.initState();
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   setState((){
    //     print('checking time ${DateTime.now().second}');
    //   });
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amberAccent,
            title: Text(
              'To-Do-List',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Center(
            child: StreamBuilder<List<IDataObj>>(
              // tell db return what kind of obj data
              stream: readUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('Firebase Error !! ${snapshot.error.toString()}');
                  return Text('Firebase Somethine went wrong!!');
                } else if (snapshot.hasData) {
                  // access all user data from here
                  final users = snapshot.data!;
                  // call list once only
                  // get doc id
                  FirebaseFirestore.instance
                      .collection('users')
                      .get()
                      .then((value) {
                    setState(() {
                      if (dataLst.isEmpty) {
                        for (var i = 0; i < users.length; i++) {
                          dataLst.add(IDataObj(
                              sTitle: users.elementAt(i).sTitle,
                              sStartDate: users.elementAt(i).sStartDate,
                              sEndDate: users.elementAt(i).sEndDate,
                              sTime: users.elementAt(i).sTime,
                              sStatus: users.elementAt(i).sStatus,
                              sFbDocId: value.docs.elementAt(i).id,
                              sRawStDate: users.elementAt(i).sRawStDate,
                              sRawEdDate: users.elementAt(i).sRawEdDate,
                              bComplete: users.elementAt(i).bComplete));
                          // print('checking ${value.docs.elementAt(i).id}');
                        }
                      }
                    });
                  });

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: dataLst.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Center(
                            child: ItemInfoCard(
                                sTitle: dataLst[index].sTitle,
                                sStartDate: dataLst[index].sStartDate,
                                sEndDate: dataLst[index].sEndDate,
                                sTime: dataLst[index].sTime,
                                sStatus: dataLst[index].sStatus,
                                sFbDocId: dataLst[index].sFbDocId,
                                sRwStDate: dataLst[index].sRawStDate,
                                sRwEdDate: dataLst[index].sRawEdDate,
                                bComplete: dataLst[index].bComplete)),
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
          floatingActionButton: Container(
              child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () {
                  _navigateAndDisplaySelection(context);
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ],
          ))

          // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }

  Widget buildUser(IDataObj user) {
    List<IDataObj> datas = <IDataObj>[];

    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        datas.add(IDataObj(
            sTitle: user.sTitle,
            sStartDate: user.sStartDate,
            sEndDate: user.sEndDate,
            sTime: user.sTime,
            sStatus: user.sTitle,
            sFbDocId: element.id,
            bComplete: user.bComplete));
        print(element.id);
      });
    });

    print('checking list size = ${user.sTitle}');

    return Container(
        child: ItemInfoCard(
            sTitle: user.sTitle,
            sStartDate: user.sStartDate,
            sEndDate: user.sEndDate,
            sTime: user.sTime,
            sStatus: user.sTitle,
            sRwStDate: user.sRawStDate,
            sRwEdDate: user.sRawEdDate,
            sFbDocId: "",
            bComplete: user.bComplete));
  }

  // Widget buildUserOri(IDataObj user) =>
  //     Container(
  //     child: ItemInfoCard(
  //         sTitle:user.sTitle,
  //         sStartDate: user.sStartDate,
  //         sEndDate: user.sEndDate,
  //         sTime: user.sTitle,
  //         sStatus:user.sTitle,
  //         bComplete: user.bComplete),
  // );

  Stream<List<IDataObj>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => IDataObj.fromJson(doc.data())).toList());

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.

    final IDataObj result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateItem(
                sTitle: "",
                sStartDate: "",
                sEndDate: "",
                sTime: "",
                sStatus: "",
                bIsEdit: false,
                sFbDocId: "",
                sRwStDate: "",
                sRwEdDate: "",
              )),
    );
    print('checking refresh list  = ${result}');
    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('checking refresh list')));
    setState(() {
      dataLst.add(IDataObj(
          sTitle: " ${result.sTitle}",
          sStartDate: result.sStartDate,
          sEndDate: result.sEndDate,
          sTime: result.sTime,
          sStatus: result.sStatus,
          bComplete: result.bComplete));

      // MyApp();
    });
    // //
  }
}

class ItemInfoCard extends StatefulWidget {
  var sTitle,
      sStartDate,
      sEndDate,
      sTime,
      sStatus,
      sFbDocId,
      sRwStDate,
      sRwEdDate;
  bool bComplete = false;

  ItemInfoCard(
      {Key? key,
      required this.sTitle,
      required this.sStartDate,
      required this.sEndDate,
      required this.sTime,
      required this.sStatus,
      required this.sFbDocId,
      required this.bComplete,
      required this.sRwEdDate,
      required this.sRwStDate})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ItemInfoCardState();
}

class ItemInfoCardState extends State<ItemInfoCard> {
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

  bool isChecked = false;

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
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.sFbDocId)
                          .delete();
                      Navigator.pop(context, 'OK');


                    }),
              ],
            ),
          );
        });
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateItem(
              sTitle: widget.sTitle,
              sStartDate: widget.sStartDate,
              sEndDate: widget.sEndDate,
              sTime: widget.sTime,
              sStatus: widget.sStatus,
              bIsEdit: true,
              sRwStDate: widget.sRwStDate,
              sRwEdDate: widget.sRwEdDate,
              sFbDocId: widget.sFbDocId,
            ),
          ),
        );
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
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
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
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0)),
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
                        child:
                            isChecked ? Text('Completed') : Text('Incomplete '),
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
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: isChecked,
                          onChanged: (bool? value) {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.sFbDocId)
                                .update({"complete": value});

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
