/*
승인 요청자 이름 <name>
승인 요청자 이메일 <mail>
승인 요청자 생일 <birthday>
승인 요청자 핸드폰번호 <phone>
승인 요청 날짜<requestDate>
승인 상태 <state> 0 : 미승인/ 1: 승인 / 2: 반려 / 3: 퇴사
승인 또는 반려 날짜 <approvalDate>
퇴사 날짜<resignationDate>
가입승인자 메일 <signUpApprover>
퇴사승인자 <resignationApprover>
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Approval {
  String id; //Document ID
  String name;
  String mail;
  Timestamp birthday;
  String phone;
  Timestamp requestDate;
  int state;
  Timestamp approvalDate;
  Timestamp resignationDate;
  String signUpApprover;
  String resignationApprover;

  Approval({
    this.id,
    this.name,
    this.mail,
    this.birthday,
    this.phone,
    this.requestDate,
    this.state = 0,
    this.approvalDate,
    this.resignationDate,
    this.signUpApprover,
    this.resignationApprover,
  });

  Approval.fromMap(Map snapshot, String id)
      : id = id ?? "",
        name = snapshot["name"] ?? "",
        mail = snapshot["mail"] ?? "",
        birthday = snapshot["birthday"] ?? null,
        phone = snapshot["phone"] ?? "",
        requestDate = snapshot["requestDate"] ?? null,
        state = snapshot["state"] ?? 0,
        approvalDate = snapshot["approvalDate"] ?? null,
        resignationDate = snapshot["resignationDate"] ?? null,
        signUpApprover = snapshot["signUpApprover"] ?? "",
        resignationApprover = snapshot["resignationApprover"] ?? "";

  toJson() {
    return {
      "name": name,
      "mail": mail,
      "birthday": birthday,
      "phone": phone,
      "requestDate": requestDate,
      "state": state,
      "approvalDate": approvalDate,
      "resignationDate": resignationDate,
      "signUpApprover": signUpApprover,
      "resignationApprover": resignationApprover,
    };
  }
}
