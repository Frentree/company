//Flutter
import 'package:flutter/material.dart';
import 'dart:math';

//Repos
import 'package:companyplaylist/repos/firebaseMethod.dart';
import 'package:companyplaylist/repos/firebasecrud/CrudRepository.dart';
import 'package:companyplaylist/repos/showSnackBarMethod.dart';

//Model
import 'package:companyplaylist/models/companyModel.dart';

import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';


class CompanyMethod{


  String createCompanyCode(){
    Random _random = Random();
    List<int> _skipCharacter = [
      0x3A,
      0x3B,
      0x3C,
      0x3D,
      0x3E,
      0x3F,
      0x40
    ]; // [:, ;, <, =, >, ?, @]

    int minRandomValue = 0x30;
    int maxRandomValue = 0x5A;
    List<int> _companyCode = [];

    while (_companyCode.length <= 6) {
      int tempValue = minRandomValue + _random.nextInt(maxRandomValue - minRandomValue);

      if(_skipCharacter.contains(tempValue)){
        continue;
      }
      _companyCode.add(tempValue);
    }

    return String.fromCharCodes(_companyCode.cast<int>());
  }

  Future<String> duplicateCompanyCodeCheck(String newCompanyCode) async {
    FirestoreApi _firestoreApi = FirestoreApi.onePath("company");



  }

  Future<void> createCompanyCollectionToFirebase(BuildContext context, Company company) async{
    CrudRepository _companyCrud = CrudRepository();
    CrudRepository _companyUser = CrudRepository.companyUser(company.companyCode);

    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context, listen: false);
    _companyCrud.setCompanyInfoDataToFirebase(company, company.companyCode);
    _companyUser.addCompanyUserDataToFirebase(_loginUserInfoProvider.getloginUser());
    showFunctionSuccessMessage(context, "새로운 회사가 생성되었습니다!");
  }


}