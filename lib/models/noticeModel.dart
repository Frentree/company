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
  String noticeContent;
  Timestamp noticeCreateDate;
  Timestamp noticeUpdateDate;
  Map<String,String> noticeCreateUser;
  List<String> caseSearch;


  NoticeModel({
    this.noticeUid,
    this.noticeTitle,
    this.noticeContent,
    this.noticeCreateDate,
    this.noticeUpdateDate,
    this.noticeCreateUser,
    this.caseSearch,
   });

  NoticeModel.fromMap(Map snapshot, String id):
        noticeUid = id ?? "",
        noticeTitle = snapshot["noticeTitle"] ?? "",
        noticeContent = snapshot["noticeContent"] ?? "",
        noticeCreateDate = snapshot["noticeCon"] ?? "",
        noticeUpdateDate = snapshot["noticeUpdateDate"] ?? "null",
        noticeCreateUser = snapshot["noticeCreateUser"] ?? "",
        caseSearch = snapshot["caseSearch"] ?? "null";

  toJson() {
    return {
      "noticeUid": noticeUid,
      "noticeTitle": noticeTitle,
      "noticeContent": noticeContent,
      "noticeCreateDate": noticeCreateDate,
      /*"noticeUpdateDate": noticeUpdateDate,*/
      "noticeCreateUser": noticeCreateUser,
      "caseSearch": caseSearch,
    };
  }
}
