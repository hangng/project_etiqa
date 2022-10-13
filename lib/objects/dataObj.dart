import 'package:flutter/material.dart';

class IDataObj {
  var sTitle, sStartDate, sEndDate, sTime, sStatus;
  bool bComplete = false;

  IDataObj(
      {required this.sTitle,
      required this.sStartDate,
      required this.sEndDate,
      required this.sTime,
      required this.sStatus,
      required this.bComplete});

  // prevent initialize issue
  static IDataObj empty() {
    return new IDataObj(
        sTitle: "",
        sStartDate: "",
        sEndDate: "",
        sTime: "",
        sStatus: "",
        bComplete: false);
  }
}
