/*
어플에 가입한 사용자 정보를 저장하는 DB 모델

이름 <name>
이메일 <mail>
생일 <birthday>
핸드폰번호 <phone>
회사이름 <companyName>
회사코드 <companyCode>
프로필 이미지 <image>
앱 테마 옵션 <screenTheme>
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id; //Document ID
  String name;
  String mail;
  String birthday;
  String phone;
  String companyName;
  String companyCode;
  String profilePhoto;
  int screenTheme;

  User({
    this.id,
    this.name,
    this.mail,
    this.birthday,
    this.phone,
    this.companyName,
    this.companyCode,
    this.profilePhoto,
    this.screenTheme,
  });

  User.fromMap(Map snapshot, String id)
      : id = id ?? "",
        name = snapshot["name"] ?? "",
        mail = snapshot["mail"] ?? "",
        birthday = snapshot["birthday"] ?? "",
        phone = snapshot["phone"] ?? "",
        companyName = snapshot["companyName"] ?? "",
        companyCode = snapshot["companyCode"] ?? "",
        profilePhoto = snapshot["profilePhoto"] ?? "",
        screenTheme = snapshot["screenTheme"];

  toJson() {
    return {
      "name": name,
      "mail": mail,
      "birthday": birthday,
      "phone": phone,
      "companyName": companyName,
      "companyCode": companyCode,
      "profilePhoto": profilePhoto,
      "screenTheme": screenTheme,
    };
  }
}
