/*
* work 내용 작성에 관련된 Firebase
* 이윤혁, 2020-09-24 최초작정
*
* @author 이윤혁
* @version 1.0
* 이윤혁, 마지막 수정일 2020-09-24
*
* */

//Flutter
import 'package:companyplaylist/models/bigCategoryModel.dart';
import 'package:companyplaylist/models/workModel.dart';
import 'package:flutter/material.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';

//Repos
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';


class WorkScheduleMethod{

  /* 일정 저장 메소드 */
  Future<void> workScheduleFirebaseAuth(
      {BuildContext context,
      String createUid,
      String workTitle,
      String startDate,
      String endDate,
      String workContent,
      List<Map<String, String>> share,
      String bigCategory,
      String type}) async {
    FirebaseAuthProvider _firebaseAuthProvider =
        Provider.of<FirebaseAuthProvider>(context, listen: false);
/*
    // 타이틀 미입력
    if(workTitle.trim() == "") {
      return;
    }
    
    // 시작및 종료시간 미선택
    if(startDate == "" && endDate == "") {
      return;
    }
    
    // 빅 카테고리 미선택
    if(bigCategory == "project"){
      return;
    }
    
    // 내용 미입력
    if(workContent.trim() == ""){
      return;
    }
    */

    CompanyWork work = CompanyWork(
      createUid: createUid,
      workTitle: workTitle,
      startDate: startDate,
      endDate: endDate,
      workContents: workContent,
      type: type,
      share: share,
      bigCategory: bigCategory,
    );

    CrudRepository _crudRepository = CrudRepository();
    
    // 데이터 베이스 추가
    _crudRepository.addCompanyWorkDataToFirebase(
      dataModel: work
    );

    Navigator.pop(context);
  }

  /* 프로젝트 정보 */
  Future<List<WorkCategory>> workCategoryFirebaseAuth({BuildContext context}) async {
    CrudRepository _crudRepository = CrudRepository();
    Future<List<WorkCategory>> categoryList = _crudRepository.fetchWorkCategory();

    WorkCategory _workCategory = WorkCategory();

    String s;

    categoryList.then((value) =>
    value.forEach((element) { print(element.bigCategoryTitle);}));


    return _crudRepository.fetchWorkCategory();
  }
}
