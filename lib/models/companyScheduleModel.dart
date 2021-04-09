import 'package:MyCompany/models/workModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanySchedule extends WorkModel{
  Timestamp endDate;
  Map<dynamic, dynamic> attendees;

  CompanySchedule({
    this.endDate,
    this.attendees,
    String id,
    String createUid,
    String name,
    String type,
    String title, // 글제목
    String contents, // 글내용
    String location,
    Timestamp createDate,
    Timestamp lastModDate,
    Timestamp startDate,
    int timeSlot,
    int level,
    int alarmId,
  }) : super(
    id: id,
    createUid: createUid,
    name: name,
    type: type,
    title: title,
    contents: contents,
    location: location,
    createDate: createDate,
    lastModDate: lastModDate,
    startDate: startDate,
    timeSlot: timeSlot,
    level: level,
    alarmId: alarmId,
  );

  CompanySchedule.fromMap(Map snapshot, String id)
      : endDate= snapshot["endDate"] ?? null,
        attendees = snapshot["attendees"] ?? null,
        super(
        id: id ?? "",
        createUid: snapshot["createUid"] ?? "",
        name: snapshot["name"] ?? "",
        type: snapshot["type"] ?? "",
        title: snapshot["title"] ?? "",
        contents: snapshot["contents"] ?? "",
        location: snapshot["location"] ?? "",
        createDate: snapshot["createDate"] ?? null,
        lastModDate: snapshot["lastModDate"] ?? null,
        startDate: snapshot["startDate"] ?? null,
        startTime: snapshot["startTime"] ?? null,
        timeSlot: snapshot["timeSlot"] ?? 0,
        level: snapshot["level"] ?? 0,
        alarmId: snapshot["alarmId"] ?? 0,
      );

  toJson() {
    return {
      "endDate": endDate,
      "attendees": attendees,
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
}
