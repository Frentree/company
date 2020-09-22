/*
이름 <name>
이메일 <mail>
핸드폰번호 <phone>
회사코드 <companyCode>
회사이름 <companyName>
프로필사진 <profilePhoto>
상태 <status>
레벨 <level>
직급 <position>
팀 <team>
생성일 <createDate>
최종수정일 <lastModDate>
동료출퇴근알림 <alrCoAttendance>
동료일정알림 <alrCoSchedule>
승인요청알림 <alrApprovalReq>
출근처리알림 <alrAttendance>
방해금지모드 <alrNoInterrupt>
와이파이인증 <authWifi>
GPS인증 <authGPS>
비콘인증 <authBeacon>
글씨크기 <screenFontSize>
테마 <screenTheme>
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/models/userModel.dart';

class CompanyUser{
  String id; //Document ID
  User user;
  String name;
  String mail;
  String phone;
  String companyName;
  String companyCode;
  String profilePhoto;
  int status;
  int level;
  String position;
  String team;
  Timestamp createDate;
  Timestamp lastModDate;
  bool alrCoAttendance;
  bool alrCoSchedule;
  bool alrApprovalReq;
  bool alrAttendance;
  bool alrNoInterrupt;
  bool authWifi;
  bool authGPS;
  bool authBeacon;
  int screenFontSize;
  int scrrenTheme;


  CompanyUser({
    this.id,
    this.user,
    this.profilePhoto,
    this.status = 0,
    this.level = 0,
    this.position,
    this.team,
    this.createDate,
    this.lastModDate,
    this.alrCoAttendance = false,
    this.alrCoSchedule = false,
    this.alrApprovalReq = true,
    this.alrAttendance = true,
    this.alrNoInterrupt = false,
    this.authWifi = true,
    this.authGPS = false,
    this.authBeacon = false,
    this.screenFontSize = 10,
    this.scrrenTheme = 1
  });

  CompanyUser.fromMap(Map snapshot, String id) :
        id = id ?? "",
        name = snapshot["name"] ?? "",
        mail = snapshot["mail"] ?? "",
        phone = snapshot["phone"] ?? "",
        companyName = snapshot["companyName"] ?? "",
        companyCode = snapshot["companyCode"] ?? "",
        profilePhoto = snapshot["profilePhoto"] ?? "",
        level = snapshot["level"] ?? "",
        position = snapshot["position"] ?? "",
        team = snapshot["team"] ?? "",
        createDate = snapshot["createDate"] ?? "",
        lastModDate = snapshot["lastModDate"] ?? "",
        status = snapshot["status"] ?? "",
        alrCoAttendance = snapshot["alrCoAttendance"] ?? "",
        alrCoSchedule = snapshot["alrCoSchedule"] ?? "",
        alrApprovalReq = snapshot["alrApprovalReq"] ?? "",
        alrAttendance = snapshot["alrAttendance"] ?? "",
        alrNoInterrupt = snapshot["alrNoInterrupt"] ?? "",
        authWifi = snapshot["authWifi"] ?? "",
        authGPS = snapshot["authGPS"] ?? "",
        authBeacon = snapshot["authBeacon"] ?? "",
        screenFontSize = snapshot["screenFontSize"] ?? "",
        scrrenTheme = snapshot["scrrenTheme"] ?? "";

  toJson(){
    return {
      "name": user.name,
      "mail": user.mail,
      "phone": user.phone,
      "companyName": user.companyName,
      "companyCode": user.companyCode,
      "profilePhoto": profilePhoto,
      "status": status,
      "level": level,
      "position": position,
      "team": team,
      "createDate": createDate,
      "lastModDate": lastModDate,
      "alrCoAttendance": alrCoAttendance,
      "alrCoSchedule": alrCoSchedule,
      "alrApprovalReq": alrApprovalReq,
      "alrAttendance": alrAttendance,
      "alrNoInterrupt": alrNoInterrupt,
      "authWifi": authWifi,
      "authGPS": authGPS,
      "authBeacon": authBeacon,
      "screenFontSize": screenFontSize,
      "scrrenTheme": scrrenTheme
    };
  }
}