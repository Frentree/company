/*
이메일 <mail>
날짜<date>
출근시간 <attendTime>
퇴근시간 <endTime>
인증기기 <certificationDevice>
네트워크 정보 <networkInfo>
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  String id; //Document ID
  String mail;
  String date;
  Timestamp attendTime;
  Timestamp endTime;
  int certificationDevice;
  String networkInfo;

  Attendance({
    this.id,
    this.mail,
    this.date,
    this.attendTime,
    this.endTime,
    this.certificationDevice,
    this.networkInfo,
  });

  Attendance.fromMap(Map snapshot, String id) :
        id = id ?? "",
        mail = snapshot["mail"] ?? "",
        date = snapshot["date"] ?? "",
        attendTime = snapshot["attendTime"] ?? "",
        endTime = snapshot["endTime"] ?? "",
        certificationDevice = snapshot["certificationDevice"] ?? "",
        networkInfo = snapshot["networkInfo"] ?? "";

  toJson(){
    return {
      "mail": mail,
      "date": date,
      "attendTime": attendTime,
      "endTime": endTime,
      "certificationDevice": certificationDevice,
      "networkInfo": networkInfo,
    };
  }
}