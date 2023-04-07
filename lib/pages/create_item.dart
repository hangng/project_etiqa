import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../objects/dataObj.dart';
import 'package:intl/intl.dart';

class CreateItem extends StatefulWidget {
  var sTitle = "", sStartDate = "", sEndDate = "", sTime = "", sFbDocId = "", sRwStDate = "", sRwEdDate = "";

  // final int? startDate; // end date checking
  bool bIsEdit = false;

  CreateItem({
    Key? key,
    required this.sTitle,
    required this.sStartDate,
    required this.sEndDate,
    required this.sTime,
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
  String sStartDate = "", sEndDate = "", sFbDocId = "", sRwStDate = "", sRwEdDate = "";

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
      print("checking sEndDate == ${sEndDate}");
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
          backgroundColor: Colors.yellow,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          title: Text('To Do List'), // Testing
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: ListView(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Wrap(
                          children: [
                            Container(
                              child: Text('TO DO List'),
                            ),
                          ],
                        ),
                        Flexible(
                          flex: 5,
                          child: Wrap(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  minHeight: 200,
                                ),
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                                child: widget.bIsEdit
                                    ? TextField(
                                        controller: contTitle,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                      )
                                    : TextField(
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        decoration: new InputDecoration.collapsed(hintText: 'Please Enter Todo List'),
                                        controller: contTitle,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Wrap(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Text('Start Date'),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            child: StartDate(
                              customFeature: startDate,
                              isEdit: widget.bIsEdit,
                              sRwDate: widget.sRwStDate,
                              sDisplayDate: widget.sStartDate,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Wrap(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Text('End Date'),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    child: widget.bIsEdit ? Text('Edit') : Text('Create Now'),
                    onPressed: () {
                      widget.sTitle = contTitle.text.toString();
                      // Close the screen and return "Nope." as the result.

                      if (widget.bIsEdit) {
                        if (contTitle.text.isEmpty) {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              content: const Text('Please enter To Do List'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');
                                    }),
                              ],
                            ),
                          );
                          return;
                        }
                      } else {
                        if (contTitle.text.isEmpty) {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              content: const Text('Please enter To Do List'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');
                                    }),
                              ],
                            ),
                          );
                          return;
                        }
                      }

                      DateTime dtTime = DateTime.now();
                      var receiveDate = DateFormat('hh:mm aa').format(dtTime).toString();

                      sFbDocId = widget.sFbDocId;

                      if (sStartDate.isEmpty && widget.sStartDate.isEmpty) {
                        DateTime dtTime = DateTime.now();
                        var receiveDate = DateFormat('dd MMM yyyy').format(dtTime).toString();
                        sStartDate = receiveDate;

                        var receiveRwDate = DateFormat('yyyy-MM-dd').format(dtTime).toString();
                        sRwStDate = receiveRwDate;
                      } else if (sStartDate.isEmpty) {
                        sStartDate = widget.sStartDate;
                      }

                      if (sEndDate.isEmpty && widget.sEndDate.isEmpty) {
                        var dateMonthFormat;
                        dateMonthFormat = DateTime.now().month.toString();
                        if (DateTime.now().month < 10) {
                          dateMonthFormat = "0$dateMonthFormat";
                        } else {
                          dateMonthFormat = dateMonthFormat;
                        }

                        var sFwdDate = '${DateTime.now().year}-${dateMonthFormat}-${DateTime.now().day + 1}';
                        var initDate = DateTime.parse(sFwdDate);
                        var receiveDate = DateFormat('dd MMM yyyy').format(initDate).toString();
                        sEndDate = receiveDate;

                        var receiveRwDate = DateFormat('yyyy-MM-dd').format(initDate).toString();
                        sRwEdDate = receiveRwDate;
                      } else if (sEndDate.isEmpty) {
                        sEndDate = widget.sEndDate;
                      }
                      if (sRwStDate.isEmpty) {
                        sRwStDate = widget.sRwStDate;
                      }
                      if (sRwEdDate.isEmpty) {
                        sRwEdDate = widget.sRwEdDate;
                      }

                      // print
                      createUser(
                          sTitle: contTitle.text, sStDate: sStartDate, sEdDate: sEndDate, sTime: receiveDate, sFbDocId: sFbDocId, sRawStDate: sRwStDate, sRawEdDate: sRwEdDate, isComplete: false);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class StartDate extends StatefulWidget {
  StartDate({super.key, required this.customFeature, required this.isEdit, required this.sRwDate, required this.sDisplayDate});

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selectDate.isNotEmpty) ...[Text(selectDate)] else if (widget.isEdit) ...[Text(widget.sDisplayDate)] else ...[Text('Select a date')]
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

                  late var initDate, initLastDate, firstDate;
                  if (widget.isEdit) {
                    initDate = DateTime.parse(widget.sRwDate);
                    firstDate = DateTime.parse(widget.sRwDate);
                    initLastDate = DateTime.parse(widget.sRwDate).year + 100;
                  } else {
                    initDate = DateTime.now();
                    firstDate = DateTime.now();
                    initLastDate = DateTime.now().year + 100;
                  }
                  showDatePicker(context: context, initialDate: initDate, firstDate: firstDate, lastDate: DateTime(initLastDate)).then((value) {
                    setState(() {
                      _dateTime = value!;
                      processDate(_dateTime); // sent to list

                      // for display in same field only
                      final receiveStartDate = DateTime.parse(_dateTime.toString());
                      final receiveDate = DateFormat('dd MMM yyyy').format(receiveStartDate);
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
    var dateMonthFormat;
    if (dateTime.toString().isNotEmpty) {
      dateDayFormat = dateTime.day.toString();
      dateMonthFormat = dateTime.month.toString();
      if (dateTime.day < 10) {
        dateDayFormat = "0$dateDayFormat";
      } else {
        dateDayFormat = dateTime.day;
      }
      if (dateTime.month < 10) {
        dateMonthFormat = "0$dateMonthFormat";
      } else {
        dateMonthFormat = dateTime.month;
      }
      var rawDate = '${dateTime.year}-${dateMonthFormat}-${dateDayFormat}';

      final receiveStartDate = DateTime.parse(rawDate);
      receiveDate = DateFormat('dd MMM yyyy').format(receiveStartDate);
    } else {
      receiveDate = "-";
      dateDayFormat = "";
    }
    // print("receive data ===== ${receiveDate}");
    widget.customFeature(dateTime.year, dateMonthFormat, dateDayFormat);
  }
}

class EndDate extends StatefulWidget {
  EndDate({super.key, required this.customFeature, required this.sStartYear, required this.sDisplayDate, required this.sRawDate, required this.isEdit});

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
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectDate.isNotEmpty) ...[Text(selectDate)] else if (widget.isEdit) ...[Text(widget.sDisplayDate)] else ...[Text('Select a date')]
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
                  showDatePicker(context: context, initialDate: initDate, firstDate: DateTime.now(), lastDate: DateTime(lastDate)).then((value) {
                    setState(() {
                      print('select value == ${value}');
                      _dateTime = value!;
                      processDate(_dateTime); // sent to list
                      // for display in same field only
                      final receiveStartDate = DateTime.parse(_dateTime.toString());
                      final receiveDate = DateFormat('dd MMM yyyy').format(receiveStartDate);

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
    var dateMonthFormat;

    if (dateTime.toString().isNotEmpty) {
      dateDayFormat = dateTime.day.toString();
      if (dateTime.day < 10) {
        dateDayFormat = "0$dateDayFormat";
      } else {
        dateDayFormat = dateTime.day;
      }

      dateMonthFormat = dateTime.month.toString();
      if (dateTime.month < 10) {
        dateMonthFormat = "0$dateMonthFormat";
      } else {
        dateMonthFormat = dateMonthFormat;
      }
      var rawDate = '${dateTime.year}-${dateMonthFormat}-${dateDayFormat}';
      print("checking rawDate == ${rawDate}");

      final receiveEndDate = DateTime.parse(rawDate);
      receiveDate = DateFormat('dd MMM yyyy').format(receiveEndDate);
    } else {
      receiveDate = "-";
      dateDayFormat = "";
    }

    widget.customFeature(dateTime.year, dateMonthFormat, dateDayFormat);
  }
}

Future createUser(
    {required String sTitle,
    required String sStDate,
    required String sEdDate,
    required String sTime,
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
  final user = IDataObj(sTitle: sTitle, sStartDate: sStDate, sEndDate: sEdDate, sTime: sTime, sRawStDate: sRawStDate, sRawEdDate: sRawEdDate, bComplete: isComplete);

  final json = user.toJson();

  // create document and write data to firebase
  await docUser.set(json);
}
