/*
* 사용자 권한 Model
* 이윤혁, 2020-11-24 최초작정
*
* @author 이윤혁
* @version 1.0
* 이윤혁, 마지막 수정일 2020-11-24
*
*/
import 'package:cloud_firestore/cloud_firestore.dart';

class GradeModel {
  int gradeID;
  String gradeName; // 작성 시간
  List<Map<String,String>> gradeUser; // 카테고리명
  Timestamp gradeCreate; // 카테고리 내용

  GradeModel({
    this.gradeID,
    this.gradeName,
    this.gradeUser,
    this.gradeCreate
   });

  GradeModel.fromMap(Map snapshot, String id):
        gradeID = snapshot["gradeID"] ?? "",
        gradeName = snapshot["gradeName"] ?? "",
        gradeUser = snapshot["gradeUser"] ?? null,
        gradeCreate = snapshot["gradeCreate"] ?? "";

  toJson() {
    return {
      "createUid": gradeID,
      "createDate": gradeName,
      "bigCategoryTitle": gradeCreate,
    };
  }
}
