import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maybank_etiqa/main.dart';
import 'package:maybank_etiqa/objects/timeData.dart';
import '../objects/dataObj.dart';
import '../objects/timeData.dart';
import 'package:intl/intl.dart';

class CreateItem extends StatefulWidget {
  var sTitle = "",
      sStartDate = "",
      sEndDate = "",
      sTime = "",
      sStatus = "",
      sFbDocId = "",
      sRwStDate = "",
      sRwEdDate = "";

  // final int? startDate; // end date checking
  bool bIsEdit = false;

  CreateItem({
    Key? key,
    required this.sTitle,
    required this.sStartDate,
    required this.sEndDate,
    required this.sTime,
    required this.sStatus,
    required this.bIsEdit,
    required this.sFbDocId,
    required this.sRwStDate,
    required this.sRwEdDate,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CreateItemState();
}

class CreateItemState extends State<CreateItem> {
  final TextEditingController contTitle = TextEditingController();

  int _yearOnly = 0;
  String sStartDate = "",
      sEndDate = "",
      sFbDocId = "",
      sRwStDate = "",
      sRwEdDate = "";

  @override
  void initState() {
    super.initState();
    contTitle.text = widget.sTitle;
  }

  void startDate(
    selectStartYear,
    selectStartMonth,
    selectStartDay,
  ) {
    setState(() {
      _yearOnly = selectStartYear;
      sStartDate = '$selectStartYear-$selectStartMonth-$selectStartDay';
      sRwStDate = sStartDate;

      final receiveEndDate = DateTime.parse(sStartDate);
      sStartDate = DateFormat('dd MMM yyyy').format(receiveEndDate);
    });
  }

  void endDate(selectStartYear, selectStartMonth, selectStartDay) {
    setState(() {
      sEndDate = '$selectStartYear-$selectStartMonth-$selectStartDay';
      sRwEdDate = sEndDate;
      final receiveEndDate = DateTime.parse(sEndDate);
      sEndDate = DateFormat('dd MMM yyyy').format(receiveEndDate);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    contTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'), // Testing
      ),
      body: Container(
        padding: EdgeInsets.all(50),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Wrap(
                      children: [
                        Container(
                          child: Text('TO DO List'),
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          constraints: BoxConstraints(
                              minHeight: 200,
                              minWidth: double.infinity,
                              maxHeight: 400),
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent)),
                          child: widget.bIsEdit
                              ? TextField(
                                  controller: contTitle,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: new InputDecoration.collapsed(
                                      hintText: 'is edit'),
                                )
                              : TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: new InputDecoration.collapsed(
                                      hintText: 'Please Enter Todo List'),
                                  controller: contTitle,
                                ),
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Text('Start Date'),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: StartDate(
                        customFeature: startDate,
                        isEdit: widget.bIsEdit,
                        sRwDate: widget.sRwStDate,
                        sDisplayDate: widget.sStartDate,
                      ),
                    ),
                    Wrap(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Text('End Date'),
                        ),
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: EndDate(
                        customFeature: endDate,
                        isEdit: widget.bIsEdit,
                        sStartYear: _yearOnly,
                        sDisplayDate: widget.sEndDate,
                        sRawDate: widget.sRwEdDate,
                      ),
                    ),
                    // Wrap(
                    //   children: [
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.sTitle = contTitle.text.toString();
                            // Close the screen and return "Nope." as the result.

                            DateTime dtTime = DateTime.now();
                            var receiveDate =
                                DateFormat('hh:mm ').format(dtTime).toString();

                            print('current time ${receiveDate}');
                            setState(() {
                              sFbDocId = widget.sFbDocId;

                              createUser(
                                  sTitle: contTitle.text,
                                  sStDate: sStartDate,
                                  sEdDate: sEndDate,
                                  sTime: receiveDate,
                                  sStatus: sStartDate,
                                  sFbDocId: sFbDocId,
                                  sRawStDate: sRwStDate,
                                  sRawEdDate: sRwEdDate,
                                  isComplete: false);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyApp(),
                                ),
                              );

                              // Navigator.pop(
                              //   context,
                              // );
                            });
                          },
                          child: const Text('Nope.'),
                        ),
                      ),
                    ),
                    // ],
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StartDate extends StatefulWidget {
  StartDate(
      {super.key,
      required this.customFeature,
      required this.isEdit,
      required this.sRwDate,
      required this.sDisplayDate});

  final customFeature;
  final sDisplayDate;
  bool isEdit;
  var sRwDate;

  @override
  StartDateState createState() => StartDateState();
}

class StartDateState extends State<StartDate> {
  DateTime _dateTime = DateTime.now();
  var selectDate = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              child: Column(
                children: [
                  if (selectDate.isNotEmpty) ...[
                    Text(selectDate)
                  ] else if (widget.isEdit) ...[
                    Text(widget.sDisplayDate)
                  ] else ...[
                    Text('Select a date')
                  ]
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              child: IconButton(
                icon: const Icon(Icons.arrow_drop_down),
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  late var initDate, initLastDate;
                  if (widget.isEdit) {
                    initDate = DateTime.parse(widget.sRwDate);
                    initLastDate = DateTime.parse(widget.sRwDate).year + 100;
                  } else {
                    initDate = DateTime.now();
                    initLastDate = DateTime.now().year + 100;
                  }
                  showDatePicker(
                          context: context,
                          initialDate: initDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(initLastDate))
                      .then((value) {
                    setState(() {
                      _dateTime = value!;
                      processDate(_dateTime); // sent to list

                      // for display in same field only
                      final receiveStartDate =
                          DateTime.parse(_dateTime.toString());
                      final receiveDate =
                          DateFormat('dd MMM yyyy').format(receiveStartDate);
                      print('select date == ${receiveDate}');
                      selectDate = receiveDate;
                    });
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void processDate(DateTime dateTime) {
    final receiveDate;
    var dateDayFormat;
    if (dateTime.toString().isNotEmpty) {
      dateDayFormat = dateTime.day.toString();
      if (dateTime.day < 10) {
        dateDayFormat = "0$dateDayFormat";
      } else {
        dateDayFormat = dateTime.day;
      }
      var rawDate = '${dateTime.year}-${dateTime.month}-${dateDayFormat}';

      final receiveStartDate = DateTime.parse(rawDate);
      receiveDate = DateFormat('dd MMM yyyy').format(receiveStartDate);
    } else {
      receiveDate = "-";
      dateDayFormat = "";
    }
    // print("receive data ===== ${receiveDate}");
    widget.customFeature(dateTime.year, dateTime.month, dateDayFormat);
  }
}

class EndDate extends StatefulWidget {
  EndDate(
      {super.key,
      required this.customFeature,
      required this.sStartYear,
      required this.sDisplayDate,
      required this.sRawDate,
      required this.isEdit});

  final customFeature;
  bool isEdit;
  var sStartYear; // set lastDdate for date picker
  var sRawDate;
  var sDisplayDate;

  @override
  EndDateState createState() => EndDateState();
}

class EndDateState extends State<EndDate> {
  late DateTime _dateTime;
  var selectDate = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Container(
                child: Column(
              children: [
                if (selectDate.isNotEmpty) ...[
                  Text(selectDate)
                ] else if (widget.isEdit) ...[
                  Text(widget.sDisplayDate)
                ] else ...[
                  Text('Select a date')
                ]
              ],
            )),
          ),
          Flexible(
            flex: 1,
            child: Container(
              child: IconButton(
                icon: const Icon(Icons.arrow_drop_down),
                onPressed: () {
                  late var initDate, lastDate;
                  if (widget.isEdit) {
                    initDate = DateTime.parse(widget.sRawDate);
                    lastDate = DateTime.parse(widget.sRawDate).year + 100;
                  } else {
                    initDate = DateTime.now();
                    lastDate = DateTime.now().year + 100;
                  }
                  showDatePicker(
                          context: context,
                          initialDate: initDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(lastDate))
                      .then((value) {
                    setState(() {
                      _dateTime = value!;
                      processDate(_dateTime); // sent to list

                      // for display in same field only
                      final receiveStartDate =
                          DateTime.parse(_dateTime.toString());
                      final receiveDate =
                          DateFormat('dd MMM yyyy').format(receiveStartDate);
                      print('select date == ${receiveDate}');
                      selectDate = receiveDate;
                    });
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void processDate(DateTime dateTime) {
    var receiveDate;
    var dateDayFormat;

    if (dateTime.toString().isNotEmpty) {
      dateDayFormat = dateTime.day.toString();
      if (dateTime.day < 10) {
        dateDayFormat = "0$dateDayFormat";
      } else {
        dateDayFormat = dateTime.day;
      }
      var rawDate = '${dateTime.year}-${dateTime.month}-${dateDayFormat}';
      final receiveEndDate = DateTime.parse(rawDate);
      receiveDate = DateFormat('dd MMM yyyy').format(receiveEndDate);
    } else {
      receiveDate = "-";
      dateDayFormat = "";
    }

    widget.customFeature(dateTime.year, dateTime.month, dateDayFormat);
  }
}

Future createUser(
    {required String sTitle,
    required String sStDate,
    required String sEdDate,
    required String sTime,
    required String sStatus,
    required String sFbDocId,
    required String sRawStDate,
    required String sRawEdDate,
    required bool isComplete}) async {
  //Reference to document
  // final docUser = FirebaseFirestore.instance.collection('users').doc('my-id');

  // specific data
  // final json = {
  //   'name': name,
  //   'age': 21,
  //   'birthDay': DateTime(2011, 7, 29),
  // };
  // await docUser.set(json);
  final docUser;
  if (sFbDocId.isEmpty) {
    docUser = FirebaseFirestore.instance.collection('users').doc();
  } else {
    docUser = FirebaseFirestore.instance.collection('users').doc(sFbDocId);
  }

  // specific object
  // final user = User(id: docUser.id, sName: name, iAge: 21);
  // final user = User(id: docUser.id, sName: name);
  final user = IDataObj(
      sTitle: sTitle,
      sStartDate: sStDate,
      sEndDate: sEdDate,
      sTime: sTime,
      sStatus: sStatus,
      sRawStDate: sRawStDate,
      sRawEdDate: sRawEdDate,
      bComplete: isComplete);

  final json = user.toJson();

  // create document and write data to firebase
  await docUser.set(json);
}
