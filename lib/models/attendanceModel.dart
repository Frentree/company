/*
이메일 <mail>
DB 생성 날짜<createDate>
출근시간 <attendTime>
퇴근시간 <endTime>
상태 <state>
지각여부 <late>
인증기기 <certificationDevice>
네트워크 정보 <networkInfo>
수동출근이유 <manualOnWorkReason>
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  String id; //Document ID 필드
  String mail;
  Timestamp createDate;
  Timestamp attendTime;
  Timestamp endTime;
  String state;
  String late;
  int certificationDevice;
  String networkInfo;
  String manualOnWorkReason;

  Attendance({
    this.id,
    this.mail,
    this.createDate,
    this.attendTime,
    this.endTime,
    this.state,
    this.late,
    this.certificationDevice,
    this.networkInfo,
    this.manualOnWorkReason,
  });

  Attendance.fromMap(Map snapshot, String id) :
        id = id ?? "",
        mail = snapshot["mail"] ?? "",
        createDate = snapshot["createDate"] ?? null,
        attendTime = snapshot["attendTime"] ?? null,
        endTime = snapshot["endTime"] ?? null,
        state = snapshot["state"] ?? "",
        late = snapshot["late"] ?? "",
        certificationDevice = snapshot["certificationDevice"] ?? 0,
        networkInfo = snapshot["networkInfo"] ?? "",
        manualOnWorkReason = snapshot["manualOnWorkReason"];

  toJson(){
    return {
      "mail": mail,
      "createDate": createDate,
      "attendTime": attendTime,
      "endTime": endTime,
      "state": state,
      "late": late,
      "certificationDevice": certificationDevice,
      "networkInfo": networkInfo,
      "manualOnWorkReason": manualOnWorkReason,
    };
  }
}