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

class AppNoticeModel {
  String mail;
  String name;
  String title;
  String content;
  Timestamp createDate;
  DocumentReference reference;

  AppNoticeModel({
    this.mail,
    this.name,
    this.title,
    this.content,
    this.createDate,
  });

  AppNoticeModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['mail'] != null),
        assert(map['name'] != null),
        assert(map['title'] != null),
        assert(map['content'] != null),
        assert(map['createDate'] != null),
        mail = map['mail'],
        name = map['name'],
        title = map['title'],
        content = map['content'],
        createDate = map['createDate'];

  AppNoticeModel.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);

  toJson() {
    return {
      "mail": mail,
      "name": name,
      "title": title,
      "content": content,
      "createDate": createDate,
    };
  }
}
