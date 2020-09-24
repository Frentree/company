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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/models/workModel.dart';
import 'package:flutter/material.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';
import 'package:companyplaylist/provider/screen/loginScreenChange.dart';

//Repos
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';


class WorkScheduleMethod{

  /* 일정 저장 메소드 */
  Future<void> workScheduleFirebaseAuth({BuildContext context, String workTitle, String startDate, String endDate, String workContent, String share}) async {
    FirebaseAuthProvider _firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context, listen: false);

    CompanyWork work = CompanyWork(
      workTitle: workTitle,
      startDate: startDate,
      endDate: endDate,
      workContents: workContent,
      type: "내근",
      share: ["이윤혁", "최민지", "전준현"],
    );

    CrudRepository _crudRepository = CrudRepository();

    _crudRepository.addCompanyWorkDataToFirebase(
      dataModel: work
    );

  }
}
