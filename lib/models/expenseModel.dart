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

import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  Format _format = Format();

  String name;
  String mail;
  String companyCode;
  Timestamp createDate;
  String contentType;
  Timestamp buyDate;
  int cost;
  int index;
  String imageUrl;
  String status;
  String detailNote;
  Timestamp searchDate;
  bool isSelected;
  bool isApproved;
  String docId;

  ExpenseModel(
      {this.name,
      this.mail,
      this.companyCode,
      this.createDate,
      this.contentType,
      this.buyDate,
      this.cost,
      this.index,
      this.imageUrl,
      this.status = "미",
      this.detailNote,
      this.searchDate,
      this.isSelected = false,
      this.isApproved = false,
      this.docId});

  ExpenseModel.fromMap(int Index, Map snapshot, String id)
      : name = snapshot["name"],
        mail = snapshot["mail"],
        companyCode = snapshot["companyCode"],
        createDate = snapshot["createDate"],
        contentType = snapshot["contentType"],
        buyDate = snapshot["buyDate"],
        cost = snapshot["cost"],
        imageUrl = snapshot["imageUrl"],
        status = snapshot["status"],
        detailNote = snapshot["detailNote"],
        searchDate = snapshot["searchDate"],
        index = Index,
        docId = snapshot["docId"],
        //isSelected = snapshot["isSelected"],
        isApproved = snapshot["isApproved"];

  toJson() => {
        "name": name,
        "mail": mail,
        "companyCode": companyCode,
        "createDate": createDate,
        "contentType": contentType,
        "buyDate": buyDate,
        "cost": cost,
        "index": index,
        "imageUrl": imageUrl,
        "status": status,
        "detailNote": detailNote,
        "searchDate": searchDate,
        "isSelected": isSelected,
        "isApproved": isApproved,
        "docId": docId,
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
    map['index'] = this.index;
    map['imageUrl'] = this.imageUrl;
    map['status'] = this.status;
    map['detailNote'] = this.detailNote;
    map['searchDate'] = this.searchDate;
    map['isSelected'] = this.isSelected;
    map['isApproved'] = this.isApproved;
    map['docId'] = this.docId;
    return map;
  }
}
