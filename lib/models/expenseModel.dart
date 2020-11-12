/*
이름 <name>
이메일 <mail>
회사코드 <companyCode>
생성일시 <createDate>
경비항목 <contentType>
지출일시 <buyDate>
지출금액 <cost>
세부내역 메모 <memo>
영수증 첨부 이미지 유알엘 <imageUrl>
기안상태 <status>
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String name;
  String mail;
  String companyCode;
  Timestamp createDate;
  String contentType;
  DateTime buyDate;
  int cost;
  String memo;
  String imageUrl;
  int status;

  ExpenseModel({
    this.name,
    this.mail,
    this.companyCode,
    this.createDate,
    this.contentType,
    this.buyDate,
    this.cost,
    this.memo,
    this.imageUrl,
    this.status = 0
  });

  ExpenseModel.fromMap(Map snapshot, String id)
      : name = snapshot["name"],
        mail = snapshot["mail"],
        companyCode = snapshot["companyCode"],
        createDate = snapshot["createDate"],
        contentType = snapshot["contentType"],
        buyDate = snapshot["buyDate"],
        cost = snapshot["cost"],
        memo = snapshot["memo"],
        imageUrl = snapshot["imageUrl"],
        status = snapshot["status"];

  toJson() => {
      "name": name,
      "mail": mail,
      "companyCode": companyCode,
      "createDate": createDate,
      "contentType": contentType,
      "buyDate": buyDate,
      "cost": cost,
      "memo": memo,
      "imageUrl": imageUrl,
      "status": status,
    };

  Map toMap() {
    var map = Map<String, dynamic>();
    map['name'] = this.name;
    map['mail'] = this.mail;
    map['companyCode'] = this.companyCode;
    map['createDate'] = this.createDate;
    map['contentType'] = this.contentType;
    map['buyDate'] = this.buyDate;
    map['cost'] = this.cost;
    map['memo'] = this.memo;
    map['imageUrl'] = this.imageUrl;
    map['status'] = this.status;
    return map;
  }
}