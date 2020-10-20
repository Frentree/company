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
  String createUid;       // Firebase ID 상속
  String createDate;
  String startDate;
  String endDate;
  String bigCategory;     // 상위 프로젝트
  String normalCategory;  // 하위 프로젝트
  int workNo;             // 글넘버
  String workTitle;       // 글제목
  String lastModifier;    // 마지막 수정자
  String workContents;    // 글내용
  int level;              // 권한
  List<Map<String,String>> share;     // 공유할 사람
  List<String> exception; // 공유안 할 사람
  String type;            // 내외근 일정 입력
  String progress;        // 진행 상태( 1. 진행전, 2. 진행중, 3.완료, 4.보류, 5. 지연 )
  String workReq;
  String workRequester;
  String ReqStatus;
  List<Map<String,String>> coWorker;     // 일정을 같이 하는 사람

  CompanyWork({
    this.createUid,
    this.createDate,
    this.startDate,
    this.endDate,
    this.bigCategory,
    this.normalCategory,
    this.workNo,
    this.workTitle,
    this.lastModifier,
    this.workContents,
    this.level,
    this.share,
    this.exception,
    this.type,
    this.progress,
    this.workReq,
    this.workRequester,
    this.coWorker,
  });

  CompanyWork.fromMap(Map snapshot, String id) :
        createUid = snapshot["createUid"] ?? "",
        createDate = snapshot["createDate"] ?? "",
        startDate = snapshot["startDate"] ?? "",
        endDate = snapshot["endDate"] ?? "",
        bigCategory = snapshot["bigCategory"] ?? "",
        normalCategory = snapshot["normalCategory"] ?? "",
        workNo = snapshot["workNo"] ?? "",
        workTitle = snapshot["workTitle"] ?? "",
        lastModifier = snapshot["lastModifier"] ?? "",
        workContents = snapshot["workContents"] ?? "",
        level = snapshot["level"] ?? "",
        share = snapshot["share"] ?? "",
        exception = snapshot["exception"] ?? "",
        type = snapshot["type"] ?? "",
        progress = snapshot["progress"] ?? "",
        workReq = snapshot["workReq"] ?? "",
        workRequester = snapshot["workRequester"] ?? "",
        coWorker = snapshot["coWorker"] ?? "";
  toJson(){
    return {
      "createUid": createUid,
      "createDate": createDate,
      "startDate": startDate,
      "endDate": endDate,
      "bigCategory": bigCategory,
      "normalCategory": normalCategory,
      "workNo": workNo,
      "workTitle": workTitle,
      "lastModifier": lastModifier,
      "workContents": workContents,
      "level": level,
      "share": share,
      "exception": exception,
      "type": type,
      "progress": progress,
      "workReq": workReq,
      "workRequester": workRequester,
      "coWorker": coWorker,
    };
  }
}

