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
import 'package:companyplaylist/models/commentListModel.dart';

class NoticeCommentModel {
  String commentID; //Firebase Default ID
  String comment; // 댓글 내용
  List<CommentListModel> commentList;
  Map<String,String> createUser;
  Timestamp createDate;
  Timestamp updateDate;

  NoticeCommentModel({
    this.commentID,
    this.comment,
    this.commentList,
    this.createUser,
    this.createDate,
    this.updateDate,
  });

  NoticeCommentModel.fromMap(Map snapshot, String id) :
        commentID = snapshot["commentID"] ?? "",
        comment = snapshot["comment"] ?? "",
        commentList = snapshot["commentList"] ?? "",
        createUser = snapshot["createUser"] ?? "",
        createDate = snapshot["createDate"] ?? "",
        updateDate = snapshot["updateDate"] ?? "";
  toJson(){
    return {
      "commentID": commentID,
      "comment": comment,
      "commentList": commentList,
      "createUser": createUser,
      "createDate": createDate,
      "updateDate": updateDate,
    };
  }
}

