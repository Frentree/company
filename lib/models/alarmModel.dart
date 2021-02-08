/*
알람 모델

작성자 이름 <createName>
작성자 이메일 <createMail>
컬렉션 이름 <collectionName>
읽음여부 <read>
알림온시간 <alarmDate>
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class Alarm {
  String id; //Document ID
  int alarmId;
  String createName;
  String createMail;
  String collectionName;
  String alarmContents;
  bool read;
  Timestamp alarmDate;

  Alarm({
    this.id,
    this.alarmId,
    this.createName,
    this.createMail,
    this.collectionName,
    this.alarmContents,
    this.read = false,
    this.alarmDate,
  });

  Alarm.fromMap(Map snapshot, String id)
      : id = id ?? "",
        alarmId = snapshot["alarmId"] ?? 0,
        createName = snapshot["createName"] ?? "",
        createMail = snapshot["createMail"] ?? "",
        collectionName = snapshot["collectionName"] ?? "",
        alarmContents = snapshot["alarmContents"] ?? "",
        read = snapshot["read"] ?? false,
        alarmDate = snapshot["alarmDate"] ?? Timestamp.now();

  toJson() {
    return {
      "alarmId": alarmId,
      "createName": createName,
      "createMail": createMail,
      "collectionName": collectionName,
      "alarmContents": alarmContents,
      "read": read,
      "alarmDate": alarmDate,
    };
  }
}
