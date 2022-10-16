import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IDataObj {
  String? sTitle;
  String? sStartDate;
  String? sEndDate;
  String? sTime;
  String? sStatus;
  String? sFbDocId;
  String? sRawStDate;
  String? sRawEdDate;

  bool bComplete = false;

  IDataObj(
      {this.sTitle,
      this.sStartDate,
      this.sEndDate,
      this.sTime,
      this.sStatus,
      this.sFbDocId,
      this.sRawStDate,
      this.sRawEdDate,
      required this.bComplete});

  // prevent initialize issue
  static IDataObj empty() {
    return new IDataObj(
        sTitle: "",
        sStartDate: "",
        sEndDate: "",
        sTime: "",
        sStatus: "",
        sFbDocId: "",
        bComplete: false);
  }

  Map<String, dynamic> toJson() => {
        'title': sTitle,
        'stDate': sStartDate,
        'edDate': sEndDate,
        'time': sTime,
        'status': sStatus,
        'complete': bComplete,
        'rawStDate': sRawStDate,
        'rawEdDate': sRawEdDate,
      };

  static IDataObj fromJson(Map<String, dynamic> json) => IDataObj(
        sTitle: json['title'],
        sStartDate: json['stDate'],
        sEndDate: json['edDate'],
        sTime: json['time'],
        sStatus: json['title'],
        sRawStDate: json['rawStDate'],
        sRawEdDate: json['rawEdDate'],
        bComplete: true,
      );
}
