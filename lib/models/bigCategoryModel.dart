/*
* work 내근, 외근 일정 관련 카테고리 저장 Model
* 이윤혁, 2020-09-28 최초작정
*
* @author 이윤혁
* @version 1.0
* 이윤혁, 마지막 수정일 2020-09-28
*
*/
import 'package:cloud_firestore/cloud_firestore.dart';

class bigCategoryModel {
  String createUid;
  Timestamp createDate; // 작성 시간
  String bigCategoryTitle; // 카테고리명
  String bigCategoryContent; // 카테고리 내용

  bigCategoryModel({
    this.createUid,
    this.createDate,
    this.bigCategoryTitle,
    this.bigCategoryContent
   });

  bigCategoryModel.fromMap(Map snapshot, String id):
        createUid = id ?? "",
        createDate = snapshot["createDate"] ?? "",
        bigCategoryTitle = snapshot["bigCategoryTitle"] ?? "",
        bigCategoryContent = snapshot["bigCategoryContent"] ?? "";

  toJson() {
    return {
      "createUid": createUid,
      "createDate": createDate,
      "bigCategoryTitle": bigCategoryTitle,
      "bigCategoryContent": bigCategoryContent
    };
  }
}
