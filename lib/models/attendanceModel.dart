/*
이름 <name>
이메일 <mail>
DB 생성 날짜<createDate>
출근시간 <attendTime>
퇴근시간 <endTime>
상태 <status>
인증기기 <certificationDevice>
네트워크 정보 <networkInfo>
수동출근이유 <manualOnWorkReason>
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  String id; //Document ID 필드
  String name;
  String mail;
  Timestamp createDate;
  Timestamp attendTime;
  Timestamp endTime;
  int status;
  int certificationDevice;
  String networkInfo;
  int manualOnWorkReason;

  Attendance({
    this.id,
    this.mail,
    this.name,
    this.createDate,
    this.attendTime,
    this.endTime,
    this.status,
    this.certificationDevice,
    this.networkInfo,
    this.manualOnWorkReason,
  });

  Attendance.fromMap(Map snapshot, String id)
      : id = id ?? "",
        mail = snapshot["mail"] ?? "",
        name = snapshot["name"] ?? "",
        createDate = snapshot["createDate"] ?? null,
        attendTime = snapshot["attendTime"] ?? null,
        endTime = snapshot["endTime"] ?? null,
        status = snapshot["status"] ?? 0,
        certificationDevice = snapshot["certificationDevice"] ?? 0,
        networkInfo = snapshot["networkInfo"] ?? "",
        manualOnWorkReason = snapshot["manualOnWorkReason"] ?? null;

  toJson() {
    return {
      "mail": mail,
      "name": name,
      "createDate": createDate,
      "attendTime": attendTime,
      "endTime": endTime,
      "status": status,
      "certificationDevice": certificationDevice,
      "networkInfo": networkInfo,
      "manualOnWorkReason": manualOnWorkReason,
    };
  }
}
