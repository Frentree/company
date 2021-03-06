/*
회의 관련 데이터 모델

이메일 <createUid>
이름 <name>
업무타입 <type>
제목 <title>
참석자 <attendees>
생성일 <createDate>
최종수정일 <lastModDate>
회의날짜 <startDate>
회의시간 <startTime>
시간대 <timeSlot>
 */

import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingModel {
  String id; //Document ID
  String createUid;
  String name;
  String type;
  String title;
  String contents;
  Map<dynamic, dynamic> attendees;
  Timestamp createDate;
  Timestamp lastModDate;
  Timestamp startDate;
  Timestamp startTime;
  int timeSlot;
  int alarmId;



  int level;
  String location;

  MeetingModel({
    this.id,
    this.createUid,
    this.name,
    this.type,
    this.title,
    this.contents,
    this.attendees,
    this.createDate,
    this.lastModDate,
    this.startDate,
    this.startTime,
    this.timeSlot,
    this.alarmId,
  });

  MeetingModel.fromMap(Map snapshot, String id)
      : id = id ?? "",
        createUid = snapshot["createUid"] ?? "",
        name = snapshot["name"] ?? "",
        type = snapshot["type"] ?? "",
        title = snapshot["title"] ?? "",
        contents = snapshot["contents"] ?? "",
        attendees = snapshot["attendees"] ?? null,
        createDate = snapshot["createDate"] ?? null,
        lastModDate = snapshot["lastModDate"] ?? null,
        startDate = snapshot["startDate"] ?? null,
        startTime = snapshot["startTime"] ?? null,
        timeSlot = snapshot["timeSlot"] ?? 0,
        alarmId = snapshot["alarmId"] ?? 0,

        location = snapshot["location"],
        level = snapshot["level"];

  toJson() {
    return {
      "createUid": createUid,
      "name": name,
      "type": type,
      "title": title,
      "contents": contents,
      "attendees": attendees,
      "createDate": createDate,
      "lastModDate": lastModDate,
      "startDate": startDate,
      "startTime": startTime,
      "timeSlot": timeSlot,
      "alarmId": alarmId,

      "location": "",
      "level": 2,
    };
  }
}
