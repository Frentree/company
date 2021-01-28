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
import 'package:MyCompany/models/userModel.dart';

class CompanyUser {
  String id; //Document ID
  User user;
  String name;
  String mail;
  String birthday;
  String phone;
  String profilePhoto;
  String token;
  Timestamp createDate;
  Timestamp lastModDate;
  String enteredDate;
  int status;
  List<dynamic> level;
  String position;
  String team;
  List<dynamic> userSearch;

  CompanyUser({
    this.id,
    this.user,
    this.token,
    this.createDate,
    this.lastModDate,
    this.enteredDate,
    this.status = 0,
    this.level,
    this.position,
    this.team,
    this.userSearch,
  });

  CompanyUser.fromMap(Map snapshot, String id)
      : id = id ?? "",
        name = snapshot["name"] ?? "",
        mail = snapshot["mail"] ?? "",
        birthday = snapshot["birthday"] ?? "",
        phone = snapshot["phone"] ?? "",
        profilePhoto = snapshot["profilePhoto"] ?? "",
        token = snapshot["token"] ?? "",
        createDate = snapshot["createDate"] ?? null,
        enteredDate = snapshot["enteredDate"] ?? null,
        lastModDate = snapshot["lastModDate"] ?? null,
        status = snapshot["status"] ?? 0,
        level = snapshot["level"] ?? [],
        position = snapshot["position"] ?? "",
        team = snapshot["team"] ?? "",
        userSearch = snapshot["userSearch"] ?? [];

  toJson() {
    return {
      "name": user.name,
      "mail": user.mail,
      "birthday": user.birthday,
      "phone": user.phone,
      "profilePhoto": user.profilePhoto,
      "token": token,
      "createDate": createDate,
      "lastModDate": lastModDate,
      "enteredDate": enteredDate == null ? "" : enteredDate,
      "status": status,
      "level": level,
      "position": position == null ? "" : position,
      "team": team == null ? "" : team,
      "userSearch": user.name.split(""),
    };
  }
}
