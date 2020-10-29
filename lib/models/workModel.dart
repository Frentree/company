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

class CompanyWork {
  String createUid;
  Timestamp createDate;
  Timestamp startDate;
  String name;
  String workTitle;       // 글제목
  String workContents;    // 글내용
  int level;              // 권한
  List<Map<String,String>> share;     // 공유할 사람
  String type;            // 내외근 일정 입력
  int progress;        // 진행 상태( 1. 완료, 2. 진행중, 3.진행전, 4.보류, 5. 지연 )
  String location;
  String timeTest;
//  String endDate;
//  String bigCategory;     // 상위 프로젝트
//  String normalCategory;  // 하위 프로젝트
//  int workNo;             // 글넘버
//  String lastModifier;    // 마지막 수정자
//  String workReq;
//  String workRequester;
//  String ReqStatus;
//  List<String> exception; // 공유안 할 사람
//  List<Map<String,String>> coWorker;     // 일정을 같이 하는 사람

  CompanyWork({
    this.createUid,
    this.createDate,
    this.startDate,
    this.workTitle,
    this.name,
    this.workContents,
    this.level,
    this.share,
    this.type,
    this.progress,
    this.location,
    this.timeTest,
  });

  CompanyWork.fromMap(Map snapshot, String id) :
        createUid = snapshot["createUid"] ?? "",
        createDate = snapshot["createDate"] ?? "",
        startDate = snapshot["startDate"] ?? "",
        workTitle = snapshot["workTitle"] ?? "",
        name = snapshot["name"] ?? "",
        workContents = snapshot["workContents"] ?? "",
        level = snapshot["level"] ?? "",
        share = snapshot["share"] ?? "",
        type = snapshot["type"] ?? "",
        progress = snapshot["progress"] ?? "",
        location = snapshot["location"] ?? "",
        timeTest = snapshot["timeTest"] ?? "";
  toJson(){
    return {
      "createUid": createUid,
      "createDate": createDate,
      "startDate": startDate,
      "workTitle": workTitle,
      "name": name,
      "workContents": workContents,
      "level": level,
      "share": share,
      "type": type,
      "progress": progress,
      "location": location,
      "timeTest": timeTest,
    };
  }
}

