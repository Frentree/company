/*
이름 <name>
이메일 <mail>
핸드폰번호 <phone>
회사코드 <companyCode>
회사이름 <companyName>
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id; //Document ID
  String name;
  String mail;
  Timestamp birthday;
  String phone;
  String companyName;
  String companyCode;
  String image;
  int screenTheme;

  String profilePhoto;

  User({
    this.id,
    this.name,
    this.mail,
    this.birthday,
    this.phone,`
    this.companyName,
    this.companyCode,
    this.image,
    this.screenTheme,

    this.profilePhoto,
  });

  User.fromMap(Map snapshot, String id) :
        id = id ?? "",
        name = snapshot["name"] ?? "",
        mail = snapshot["mail"] ?? "",
        birthday = snapshot["birthday"],
        phone = snapshot["phone"] ?? "",
        companyName = snapshot["companyName"] ?? "",
        companyCode = snapshot["companyCode"] ?? "",
        image = snapshot["image"] ?? "",
        screenTheme = snapshot["screenTheme"],
        profilePhoto = snapshot["profilePhoto"] ?? "";

  toJson(){
    return {
      "name": name,
      "mail": mail,
      "birthday": birthday,
      "phone": phone,
      "companyName": companyName,
      "companyCode": companyCode,
      "image": image,
      "screenTheme": screenTheme,
      "profilePhoto": profilePhoto,
    };
  }
}