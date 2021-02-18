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

class InquireModel {
  String sender;
  String mail;
  String name;
  String receiver;
  String content;
  int chk;
  Timestamp createDate;
  DocumentReference reference;

  InquireModel({
    this.sender,
    this.mail,
    this.name,
    this.receiver,
    this.content,
    this.chk,
    this.createDate,
  });

  InquireModel.fromMap(Map<String, dynamic> map, {this.reference})
   : assert(map['sender'] != null),
        assert(map['mail'] != null),
        assert(map['name'] != null),
        assert(map['receiver'] != null),
        assert(map['content'] != null),
        assert(map['chk'] != null),
        assert(map['createDate'] != null),
        sender = map['sender'],
        mail = map['mail'],
        name = map['name'],
        receiver = map['receiver'],
        content = map['content'],
        chk = map['chk'],
        createDate = map['createDate'];

  InquireModel.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);

  toJson() {
    return {
      "sender": sender,
      "mail": mail,
      "name": name,
      "receiver": receiver,
      "content": content,
      "chk": chk,
      "createDate": createDate,
    };
  }
}
