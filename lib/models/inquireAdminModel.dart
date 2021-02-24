/*
* work 내근, 외근 일정 관련 Model
* 이윤혁, 2020-09-23 최초작정
*
* @author 이윤혁
* @version 1.0
* 이윤혁, 마지막 수정일 2020-09-23
*
*/
import 'package:cloud_firestore/cloud_firestore.dart';

class InquireAdminModel {
  int senderCount;
  String mail;
  String name;
  String lastContent;
  Timestamp lastDate;
  DocumentReference reference;

  InquireAdminModel({
    this.senderCount,
    this.mail,
    this.name,
    this.lastContent,
    this.lastDate,
  });

  InquireAdminModel.fromMap(Map<String, dynamic> map, {this.reference})
   : assert(map['senderCount'] != null),
        assert(map['mail'] != null),
        assert(map['name'] != null),
        assert(map['lastContent'] != null),
        assert(map['lastDate'] != null),
        senderCount = map['senderCount'],
        mail = map['mail'],
        name = map['name'],
        lastContent = map['lastContent'],
        lastDate = map['lastDate'];

  InquireAdminModel.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);

  toJson() {
    return {
      "senderCount": senderCount,
      "mail": mail,
      "name": name,
      "lastContent": lastContent,
      "lastDate": lastDate,
    };
  }
}
