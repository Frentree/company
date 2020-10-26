/*
* work 공지사항 댓글
* 이윤혁, 2020-10-21 최초작정
*
* @author 이윤혁
* @version 1.0
* 이윤혁, 마지막 수정일 2020-10-21
*
*/
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentListModel {
  String comments; // 대댓글 내용
  Map<String, String> commentsUser;
  Timestamp createDate;
  Timestamp updateDate;

  CommentListModel({
    this.comments,
    this.commentsUser,
    this.createDate,
    this.updateDate
  });

  CommentListModel.fromMap(Map snapshot, String id) :
        comments = snapshot["comments"] ?? "",
        commentsUser = snapshot["commentsUser"] ?? "",
        createDate = snapshot["createDate"] ?? "",
        updateDate = snapshot["updateDate"] ?? "";

  toJson(){
    return {
      "comments": comments,
      "commentsUser": commentsUser,
      "createDate": createDate,
    };
  }
}

