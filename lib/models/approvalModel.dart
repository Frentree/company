/*
이름 <name>
이메일 <mail>
생일 <birthday>
핸드폰번호 <phone>
승인 상태 <state> 0 : 미승인/ 1: 승인 / 2: 반려
승인 또는 반려 날짜 <approvalDate>
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/models/userModel.dart';

class Approval {
  String id; //Document ID
  String name;
  String mail;
  String birthday;
  String phone;
  int state;
  Timestamp approvalDate;

  Approval({
    this.id,
    this.name,
    this.mail,
    this.birthday,
    this.phone,
    this.state = 0,
    this.approvalDate,
  });

  Approval.fromMap(Map snapshot, String id)
      : id = id ?? "",
        name = snapshot["name"] ?? "",
        mail = snapshot["mail"] ?? "",
        birthday = snapshot["birthday"] ?? "",
        phone = snapshot["phone"] ?? "",
        state = snapshot["state"] ?? 0,
        approvalDate = snapshot["approvalDate"] ?? null;

  toJson() {
    return {
      "name": name,
      "mail": mail,
      "birthday": birthday,
      "phone": phone,
      "state": state,
      "approvalDate": approvalDate,
    };
  }
}
