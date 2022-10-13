import 'package:flutter/material.dart';
import '../objects/dataObj.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        home: ItemInfoLst());
  }
}

class ItemInfoLst extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ItemInfoLstState();
}

class ItemInfoLstState extends State<ItemInfoLst> {
  List<IDataObj> dataLst = <IDataObj>[
    IDataObj(
        sTitle: "Title",
        sStartDate: "12:00",
        sEndDate: "12:00",
        sTime: "12:00",
        sStatus: "Incomplete",
        bComplete: false),
    IDataObj(
        sTitle: "Title",
        sStartDate: "12:00",
        sEndDate: "12:00",
        sTime: "12:00",
        sStatus: "Incomplete",
        bComplete: false),
    IDataObj(
        sTitle: "Title",
        sStartDate: "12:00",
        sEndDate: "12:00",
        sTime: "12:00",
        sStatus: "Incomplete",
        bComplete: false),
    IDataObj(
        sTitle: "Title",
        sStartDate: "12:00",
        sEndDate: "12:00",
        sTime: "12:00",
        sStatus: "Incomplete",
        bComplete: false),
    IDataObj(
        sTitle: "Title",
        sStartDate: "12:00",
        sEndDate: "12:00",
        sTime: "12:00",
        sStatus: "Incomplete",
        bComplete: false),
    IDataObj(
        sTitle: "Title",
        sStartDate: "12:00",
        sEndDate: "12:00",
        sTime: "12:00",
        sStatus: "Incomplete",
        bComplete: false),
    IDataObj(
        sTitle: "Title",
        sStartDate: "12:00",
        sEndDate: "12:00",
        sTime: "12:00",
        sStatus: "Incomplete",
        bComplete: false),
    IDataObj(
        sTitle: "Title",
        sStartDate: "12:00",
        sEndDate: "12:00",
        sTime: "12:00",
        sStatus: "Incomplete",
        bComplete: false),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
          child: ListView.builder(
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
                          bComplete: dataLst[index].bComplete)),
                );
              }),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class ItemInfoCard extends StatefulWidget {
  var sTitle, sStartDate, sEndDate, sTime, sStatus;
  bool bComplete = false;

  ItemInfoCard(
      {Key? key,
      required this.sTitle,
      required this.sStartDate,
      required this.sEndDate,
      required this.sTime,
      required this.sStatus,
      required this.bComplete})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ItemInfoCardState();
}

class ItemInfoCardState extends State<ItemInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      elevation: 5,
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
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
                        "Dino Ng",
                      ),
                    ),
                    Container(
                      child: Text(
                        "Hi,",
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(

                      child: Text(
                        "Dino Ng",
                      ),
                    ),
                    Container(
                      child: Text(
                        "Hi,",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
