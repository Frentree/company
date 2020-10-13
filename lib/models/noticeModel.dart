/*
* 공지사항 Model
* 이윤혁, 2020-10-13 최초작정
*
* @author 이윤혁
* @version 1.0
* 이윤혁, 마지막 수정일 2020-10-13
*
*/
import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  String noticeUid;
  String noticeTitle;
  String noticeCon;
  String noticeCreateDate;
  String noticeUpdateDate;
  Map<String,String> noticeCreateUser;


  NoticeModel({
    this.noticeUid,
    this.noticeTitle,
    this.noticeCon,
    this.noticeCreateDate,
    this.noticeUpdateDate,
    this.noticeCreateUser,
   });

  NoticeModel.fromMap(Map snapshot, String id):
        noticeUid = id ?? "",
        noticeTitle = snapshot["noticeTitle"] ?? "",
        noticeCon = snapshot["noticeCon"] ?? "",
        noticeCreateDate = snapshot["noticeCon"] ?? "",
        noticeUpdateDate = snapshot["noticeUpdateDate"] ?? "",
        noticeCreateUser = snapshot["noticeCreateUser"] ?? "";

  toJson() {
    return {
      "noticeUid": noticeUid,
      "noticeTitle": noticeTitle,
      "noticeCon": noticeCon,
      "noticeCreateDate": noticeCreateDate,
      "noticeUpdateDate": noticeUpdateDate,
      "noticeCreateUser": noticeCreateUser
    };
  }
}
