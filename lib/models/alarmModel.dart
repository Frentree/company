/*
알람 모델

작성자 이름 <createName>
작성자 이메일 <createMail>
항목 <dbName>
읽음여부 <read>
알림온시간 <alarmDate>
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class Alarm {
  String id; //Document ID
  String createName;
  String createMail;
  String dbName;
  bool read;
  Timestamp alarmDate;

  Alarm({
    this.id,
    this.createName,
    this.createMail,
    this.dbName,
    this.read = false,
    this.alarmDate,
  });

  Alarm.fromMap(Map snapshot, String id)
      : id = id ?? "",
        createName = snapshot["createName"] ?? "",
        createMail = snapshot["createMail"] ?? "",
        dbName = snapshot["dbName"] ?? "",
        read = snapshot["read"] ?? false,
        alarmDate = snapshot["alarmDate"] ?? Timestamp.now();

  toJson() {
    return {
      "createName": createName,
      "createMail": createMail,
      "dbName": dbName,
      "read": read,
      "alarmDate": alarmDate,
    };
  }
}
