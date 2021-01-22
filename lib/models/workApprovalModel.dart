/*
* 결재 관련 Model
* 이윤혁, 2021-01-14 최초작정
*
* @author 이윤혁
* @version 1.0
* 이윤혁, 마지막 수정일 2021-01-18
*
*/
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkApproval {
  final Timestamp createDate; // 결재 요청일
  final Timestamp requestDate; // 행동 날짜
  final Timestamp approvalDate; // 결재 완료일
  final String title; // 결재이름
  final String requestContent; // 결재요청 내용
  final String approvalContent; // 결재완료 내용
  final String approvalType; //결재 종류
  final String approvalUser; //결재자
  final String approvalMail;
  final String user;
  final String userMail;
  final String status; // 결재 상태
  final String location; // 결재 상태
  DocumentReference reference;

  WorkApproval({
    this.createDate,
    this.requestDate,
    this.approvalDate,
    this.title,
    this.requestContent,
    this.approvalContent,
    this.approvalType,
    this.approvalUser,
    this.approvalMail,
    this.user,
    this.userMail,
    this.status,
    this.location,
  });

  WorkApproval.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['createDate'] != null),
        assert(map['requestDate'] != null),
        assert(map['approvalDate'] != null),
        assert(map['title'] != null),
        assert(map['requestContent'] != null),
        assert(map['approvalContent'] != null),
        assert(map['approvalType'] != null),
        assert(map['approvalUser'] != null),
        assert(map['approvalMail'] != null),
        assert(map['user'] != null),
        assert(map['userMail'] != null),
        assert(map['status'] != null),
        assert(map['location'] != null),
        createDate = map['createDate'],
        requestDate = map['requestDate'],
        approvalDate = map['approvalDate'],
        title = map['title'],
        requestContent = map['requestContent'],
        approvalContent = map['approvalContent'],
        approvalType = map['approvalType'],
        approvalUser = map['approvalUser'],
        approvalMail = map['approvalMail'],
        user = map['user'],
        userMail = map['userMail'],
        status = map['status'],
        location = map['location'];

  toJson() {
    return {
      "createDate": createDate,
      "approvalDate": Timestamp.now(),
      "requestDate": requestDate,
      "title": title,
      "requestContent": requestContent,
      "approvalContent": approvalContent,
      "approvalType": approvalType,
      "approvalUser": approvalUser,
      "approvalMail": approvalMail,
      "user": user,
      "userMail": userMail,
      "status": status,
      "location": location,
    };
  }

  WorkApproval.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
