/*
* work 내용 작성에 관련된 Firebase
* 이윤혁, 2020-09-24 최초작정
*
* @author 이윤혁
* @version 1.0
* 이윤혁, 마지막 수정일 2020-09-24
*
* *//*


//Flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/models/bigCategoryModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/models/workModel.dart';
import 'package:flutter/material.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';

//Repos
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';


class WorkScheduleMethod{

  */
/* 일정 저장 메소드 *//*

  Future<void> workScheduleFirebaseAuth(
      {BuildContext context,
        String createUid,
        String name,
        String workTitle,
        String workContents,
        Timestamp startDate,
        Timestamp startTime,
        Timestamp createDate,
        List<Map<String, String>> share,
        int progress,
        String location,
        String timeTest,
        String type,
        User user,
      }) async {
    FirebaseAuthProvider _firebaseAuthProvider =
    Provider.of<FirebaseAuthProvider>(context, listen: false);

    // 타이틀 미입력
    if(workTitle.trim() == "") {
      return;
    }

    // 시작및 종료시간 미선택
    if(startDate == "") {
      return;
    }
    */
/*
    // 내용 미입력
    if(workContents.trim() == ""){
      return;
    }
*//*

    CompanyWork work = CompanyWork(
      createUid: createUid,
      name: name,
      workTitle: workTitle,
      createDate: createDate,
      startDate: startDate,
      startTime: startTime,
      workContents: workContents,
      type: type,
      share: share,
      level: 0,
      progress: progress,
      location: location,
      timeTest: timeTest,
    );

    CrudRepository _crudRepository = CrudRepository.companyWork(companyCode: user.companyCode);

    // 데이터 베이스 추가
    _crudRepository.addCompanyWorkDataToFirebase(
        dataModel: work
    );

    Navigator.pop(context);
  }

  */
/* 프로젝트 정보 *//*

  Future<List<bigCategoryModel>> workCategoryFirebaseAuth({BuildContext context}) async {
    CrudRepository _crudRepository = CrudRepository();
    Future<List<bigCategoryModel>> categoryList = _crudRepository.fetchWorkCategory();

    bigCategoryModel _workCategory = bigCategoryModel();

    String s;

    categoryList.then((value) =>
        value.forEach((element) { print(element.bigCategoryTitle);}));


    return _crudRepository.fetchWorkCategory();
  }
}*/
