/*
* work 내근, 외근 일정 관련 Model
* 이윤혁, 2020-09-23 최초작정
*
* @author 이윤혁
* @version 1.0
* 이윤혁, 마지막 수정일 2020-09-23
*
*/
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkModel {
  String id;
  String createUid;
  String name;
  String type;
  String title; // 글제목
  String contents; // 글내용
  String location;
  Timestamp createDate;
  Timestamp lastModDate;
  Timestamp startDate;
  Timestamp startTime;
  int timeSlot;
  int level;
  int alarmId;
  DocumentReference reference;

  WorkModel({
    this.id,
    this.createUid,
    this.name,
    this.type,
    this.title,
    this.contents,
    this.location,
    this.createDate,
    this.lastModDate,
    this.startDate,
    this.startTime,
    this.timeSlot,
    this.level,
    this.alarmId,
  });

  WorkModel.fromMap(Map snapshot, String id)
      : id = id ?? "",
        createUid = snapshot["createUid"] ?? "",
        name = snapshot["name"] ?? "",
        type = snapshot["type"] ?? "",
        title = snapshot["title"] ?? "",
        contents = snapshot["contents"] ?? "",
        location = snapshot["location"] ?? "",
        createDate = snapshot["createDate"] ?? null,
        lastModDate = snapshot["lastModDate"] ?? null,
        startDate = snapshot["startDate"] ?? null,
        startTime = snapshot["startTime"] ?? null,
        timeSlot = snapshot["timeSlot"] ?? 0,
        level = snapshot["level"] ?? 0,
        alarmId = snapshot["alarmId"] ?? 0;
      /*: assert(map['id'] != null),
        assert(map['createUid'] != null),
        assert(map['name'] != null),
        assert(map['title'] != null),
        assert(map['type'] != null),
        assert(map['contents'] != null),
        assert(map['location'] != null),
        assert(map['createDate'] != null),
        assert(map['lastModDate'] != null),
        assert(map['startDate'] != null),
        assert(map['startTime'] != null),
        assert(map['timeSlot'] != null),
        assert(map['level'] != null),
        assert(map['alarmId'] != null),
        id = map['id'],
        createUid = map['createUid'],
        name = map['name'],
        title = map['title'],
        type = map['type'],
        contents = map['contents'],
        location = map['location'],
        createDate = map['createDate'],
        lastModDate = map['lastModDate'],
        startDate = map['startDate'],
        startTime = map['startTime'],
        timeSlot = map['timeSlot'],
        level = map['level'],
        alarmId = map['alarmId'];*/

  toJson() {
    return {
      "createUid": createUid,
      "name": name,
      "type": type,
      "title": title,
      "contents": contents,
      "location": location,
      "createDate": createDate,
      "lastModDate": lastModDate,
      "startDate": startDate,
      "startTime": startTime,
      "timeSlot": timeSlot,
      "level": level,
      "alarmId": alarmId,
    };
  }

  WorkModel.fromMap2(Map<String, dynamic> map, {this.reference})
   : assert(map['createUid'] != null),
        assert(map['name'] != null),
        assert(map['title'] != null),
        assert(map['type'] != null),
        assert(map['contents'] != null),
        assert(map['location'] != null),
        assert(map['createDate'] != null),
        assert(map['lastModDate'] != null),
        assert(map['startDate'] != null),
        assert(map['startTime'] != null),
        assert(map['timeSlot'] != null),
        assert(map['level'] != null),
        assert(map['alarmId'] != null),
        id = map['id'],
        createUid = map['createUid'],
        name = map['name'],
        title = map['title'],
        type = map['type'],
        contents = map['contents'],
        location = map['location'],
        createDate = map['createDate'],
        lastModDate = map['lastModDate'],
        startDate = map['startDate'],
        startTime = map['startTime'],
        timeSlot = map['timeSlot'],
        level = map['level'],
        alarmId = map['alarmId'];
  WorkModel.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap2(snapshot.data(), reference: snapshot.reference);
}
