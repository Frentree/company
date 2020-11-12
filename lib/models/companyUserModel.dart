/*
이름 <name>
이메일 <mail>
생일 <birthday>
핸드폰번호 <phone>
프로필 이미지 <image>
생성일 <createDate>
최종수정일 <lastModDate>
동료일정알림 <alrCoSchedule>
승인요청알림 <alrApprovalReq>
출근처리알림 <alrAttendance>
방해금지모드 <alrNoInterrupt>
상태 <status>
레벨 <level>
직급 <position>
팀 <team>
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/models/userModel.dart';

class CompanyUser {
  String id; //Document ID
  User user;
  String name;
  String mail;
  String birthday;
  String phone;
  String image;
  Timestamp createDate;
  Timestamp lastModDate;
  bool alrCoSchedule;
  bool alrApprovalReq;
  bool alrAttendance;
  bool alrNoInterrupt;
  int status;
  int level;
  String position;
  String team;

  CompanyUser({
    this.id,
    this.user,
    this.createDate,
    this.lastModDate,
    this.alrCoSchedule = true,
    this.alrApprovalReq = true,
    this.alrAttendance = true,
    this.alrNoInterrupt = false,
    this.status = 0,
    this.level = 0,
    this.position,
    this.team,
  });

  CompanyUser.fromMap(Map snapshot, String id)
      : id = id ?? "",
        name = snapshot["name"] ?? "",
        mail = snapshot["mail"] ?? "",
        birthday = snapshot["birthday"] ?? "",
        phone = snapshot["phone"] ?? "",
        image = snapshot["image"] ?? "",
        createDate = snapshot["createDate"] ?? "",
        lastModDate = snapshot["lastModDate"] ?? "",
        alrCoSchedule = snapshot["alrCoSchedule"] ?? "",
        alrApprovalReq = snapshot["alrApprovalReq"] ?? "",
        alrAttendance = snapshot["alrAttendance"] ?? "",
        alrNoInterrupt = snapshot["alrNoInterrupt"] ?? "",
        status = snapshot["status"] ?? "",
        level = snapshot["level"] ?? "",
        position = snapshot["position"] ?? "",
        team = snapshot["team"] ?? "";

  toJson() {
    return {
      "name": user.name,
      "mail": user.mail,
      "birthday": user.birthday,
      "phone": user.phone,
      "image": user.image,
      "createDate": createDate,
      "lastModDate": lastModDate,
      "alrCoSchedule": alrCoSchedule,
      "alrApprovalReq": alrApprovalReq,
      "alrAttendance": alrAttendance,
      "alrNoInterrupt": alrNoInterrupt,
      "status": status,
      "level": level,
      "position": position,
      "team": team,
    };
  }
}
