/*
이름 <wifiName>
등록자메일 <registrantMail>
등록자이름 <registrantName>
등록일자 <registrationDate>
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class WifiList {
  String id; //Document ID
  String wifiName;
  String registrantMail;
  String registrantName;
  Timestamp registrationDate;

  WifiList({
    this.id,
    this.wifiName,
    this.registrantMail,
    this.registrantName,
    this.registrationDate,
  });

  WifiList.fromMap(Map snapshot, String id)
      : id = id ?? "",
        wifiName = snapshot["wifiName"] ?? "",
        registrantMail = snapshot["registrantMail"] ?? "",
        registrantName = snapshot["registrantName"] ?? "",
        registrationDate = snapshot["registrationDate"] ?? Timestamp.now();


  toJson() {
    return {
      "wifiName": wifiName,
      "registrantMail": registrantMail,
      "registrantName": registrantName,
      "registrationDate": registrationDate,
    };
  }
}
