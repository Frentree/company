/*
이름 <name>
이메일 <mail>
생일 <birthday>
핸드폰번호 <phone>
프로필 이미지 <profilePhoto>
생성일 <createDate>
최종수정일 <lastModDate>
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
  String profilePhoto;
  Timestamp createDate;
  Timestamp lastModDate;
  int status;
  int level;
  String position;
  String team;

  CompanyUser({
    this.id,
    this.user,
    this.createDate,
    this.lastModDate,
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
        profilePhoto = snapshot["profilePhoto"] ?? "",
        createDate = snapshot["createDate"] ?? null,
        lastModDate = snapshot["lastModDate"] ?? null,
        status = snapshot["status"] ?? 0,
        level = snapshot["level"] ?? 0,
        position = snapshot["position"] ?? "",
        team = snapshot["team"] ?? "";

  toJson() {
    return {
      "name": user.name,
      "mail": user.mail,
      "birthday": user.birthday,
      "phone": user.phone,
      "profilePhoto": user.profilePhoto,
      "createDate": createDate,
      "lastModDate": lastModDate,
      "status": status,
      "level": level,
      "position": position,
      "team": team,
    };
  }
}
