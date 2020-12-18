/*
* work 공지사항 댓글
* 이윤혁, 2020-10-23 최초작정
*
* @author 이윤혁
* @version 1.0
* 이윤혁, 마지막 수정일 2020-10-23
*
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/models/commentListModel.dart';

class CommentModel {
  String commentid;
  String comment; // 댓글 내용
  Map<String,String> createUser;
  Timestamp createDate;
  Timestamp updateDate;


  CommentModel({
    this.commentid,
    this.comment,
    this.createUser,
    this.createDate,
    this.updateDate
  });

  CommentModel.fromMap(Map snapshot, String id) :
        commentid = id ?? "",
        comment = snapshot["comment"] ?? "",
        createUser = snapshot["createUser"] ?? "",
        createDate = snapshot["createUser"] ?? "",
        updateDate = snapshot["createUser"] ?? "";

  toJson(){
    return {
      "comment": comment,
      "createUser": createUser,
      "createDate": createDate,
      "updateDate": Timestamp.now(),
    };
  }
}

