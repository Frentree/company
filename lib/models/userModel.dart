/*
어플에 가입한 사용자 정보를 저장하는 DB 모델

이름 <name>
이메일 <mail>
생일 <birthday>
핸드폰번호 <phone>
회사이름 <companyName>
회사코드 <companyCode>
프로필 이미지 <profilePhoto>
생성일 <createDate>
최종수정일 <lastModDate>
동료일정알림 <alrCoSchedule>
승인요청알림 <alrApprovalReq>
출근처리알림 <alrAttendance>
방해금지모드 <alrNoInterrupt>
앱 테마 옵션 <screenTheme>
승인 상태 <state> 0 : 미승인/ 1: 승인
계좌번호 <account>
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id; //Document ID
  String name;
  String mail;
  String birthday;
  /*Timestamp birthday;*/
  String phone;
  String companyCode;
  String profilePhoto;
  Timestamp createDate;
  Timestamp lastModDate;
  bool alrCoSchedule;
  bool alrApprovalReq;
  bool alrAttendance;
  bool alrNoInterrupt;
  int screenTheme;
  int state;
  String account;

  User({
    this.id,
    this.name,
    this.mail,
    this.birthday,
    this.phone,
    this.companyCode,
    this.profilePhoto,
    this.createDate,
    this.lastModDate,
    this.alrCoSchedule = true,
    this.alrApprovalReq = true,
    this.alrAttendance = true,
    this.alrNoInterrupt = false,
    this.screenTheme = 1,
    this.state = 0,
    this.account,
  });

  User.fromMap(Map snapshot, String id)
      : id = id ?? "",
        name = snapshot["name"] ?? "",
        mail = snapshot["mail"] ?? "",
        birthday = snapshot["birthday"] ?? "",
        /*birthday = snapshot["birthday"] ?? null,*/
        phone = snapshot["phone"] ?? "",
        companyCode = snapshot["companyCode"] ?? "",
        profilePhoto = snapshot["profilePhoto"] ?? "",
        createDate = snapshot["createDate"] ?? Timestamp.now(),
        lastModDate = snapshot["lastModDate"] ?? Timestamp.now(),
        alrCoSchedule = snapshot["alrCoSchedule"] ?? true,
        alrApprovalReq = snapshot["alrApprovalReq"] ?? true,
        alrAttendance = snapshot["alrAttendance"] ?? true,
        alrNoInterrupt = snapshot["alrNoInterrupt"] ?? false,
        screenTheme = snapshot["screenTheme"] ?? 1,
        state = snapshot["state"] ?? 0,
        account = snapshot["account"] ?? "";

  toJson() {
    return {
      "name": name,
      "mail": mail,
      "birthday": birthday,
      "phone": phone,
      "companyCode": companyCode,
      "profilePhoto": profilePhoto,
      "createDate": createDate,
      "lastModDate": lastModDate,
      "alrCoSchedule": alrCoSchedule,
      "alrApprovalReq": alrApprovalReq,
      "alrAttendance": alrAttendance,
      "alrNoInterrupt": alrNoInterrupt,
      "screenTheme": screenTheme,
      "state": state,
      "account": account,
    };
  }
}
