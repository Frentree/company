//Flutter
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';

//Repos
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';
import 'package:companyplaylist/repos/showSnackBarMethod.dart';

//Model
import 'package:companyplaylist/models/companyModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/models/companyUserModel.dart';

class CompanyMethod{
  //회사코드 랜덤 생성
  String createRandomCompanyCode(){
    Random _random = Random();
    List<int> _skipCharacter = [
      0x3A,
      0x3B,
      0x3C,
      0x3D,
      0x3E,
      0x3F,
      0x40
    ]; // 제외할 문자 [:, ;, <, =, >, ?, @]

    int minRandomValue = 0x30; //0
    int maxRandomValue = 0x5A; //Z
    List<int> _companyCode = []; //회사 코드

    //6자리 까지 반복
    while (_companyCode.length <= 5) {
      //랜덤값 생성
      int tempValue = minRandomValue + _random.nextInt(maxRandomValue - minRandomValue);

      //생성된 랜덤값이 제외 문자에 속해있으면 무시
      if(_skipCharacter.contains(tempValue)){
        continue;
      }

      //생성된 랜덤값이 제외 문자에 속해있지 않으면 리스트에 추가
      _companyCode.add(tempValue);
    }

    //생성된 리스트 값을 스트링으로 리턴
    return String.fromCharCodes(_companyCode.cast<int>());
  }

  //회사코드 중복 체크
  Future<bool> duplicateCompanyCodeCheck({String newCompanyCode}) async {
    List<Company> _company; //회사 정보 리스트
    bool _isDuplicate = true; //중복값 체크 (중복 : false, 중복안됨 : true)


    CrudRepository _crudRepository = CrudRepository(); //CRUD 메소드 사용


    //회사 정보 리스트에 추가
    _company =  await _crudRepository.fetchCompanyInfo();


    _company.forEach((company) {
      if(company.companyCode == newCompanyCode){
        _isDuplicate = false;
      }
    });

    return _isDuplicate;
  }

  //회사코드 생성
  Future<String> createCompanyCode() async {
    String companyCode; //회사 코드
    bool _isDuplicate = false; //중복값 체크(중복 : false, 중복안됨 : true)

    while(_isDuplicate == false){
      companyCode = createRandomCompanyCode();
      _isDuplicate = await duplicateCompanyCodeCheck(newCompanyCode: companyCode);
    }

    return companyCode;
  }

  //회사 컬렉션 생성
  Future<void> createCompanyCollectionToFirebase({BuildContext context, Company company}) async{
    CrudRepository _crudRepository = CrudRepository();
    CrudRepository _companyUserRepository = CrudRepository.companyUser(companyCode: company.companyCode);
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context, listen: false);

    User _user = _loginUserInfoProvider.getLoginUser(); //로그인한 사용자 정보 가져오기
    CompanyUser _companyUser = CompanyUser(user: _user);

    _crudRepository.setCompanyInfoDataToFirebase(
      dataModel: company,
      documentId: company.companyCode
    ); //회사 컬렉션 생성

    _user.companyCode = company.companyCode;
    _user.companyName = company.companyName;

    _loginUserInfoProvider.saveLoginUserToPhone(value: _user);

    _companyUserRepository.setCompanyUserDataToFirebase(
      dataModel: _companyUser,
      documentId: _user.mail
    );

    _crudRepository.updateUserDataToFirebase(
      dataModel: _user,
      documentId: _user.mail
    );

    showFunctionSuccessMessage(
      context: context,
      successMessage: "새로운 회사가 생성되었습니다!"
    );
  }

  //회사 가입
  Future<void> joinCompanyUser({BuildContext context, String companyCode}) async {
    CrudRepository _crudRepository = CrudRepository();
    Company _company = Company();
    CrudRepository _companyUserRepository = CrudRepository.companyUser(companyCode: companyCode);
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context, listen: false);

    _company = await _crudRepository.getCompanyInfoDataToFirebaseById(documentId: companyCode);

    User _user = _loginUserInfoProvider.getLoginUser();

    CompanyUser _companyUser = CompanyUser(user: _user);

    bool _isCompanyCodeExist = false; //회사코드 존재 여부(존재: false, 존재안함: true)

    _isCompanyCodeExist = await duplicateCompanyCodeCheck(newCompanyCode: companyCode);

    if(_isCompanyCodeExist == false){
      _user.companyCode = _company.companyCode;
      _user.companyName = _company.companyName;

      _loginUserInfoProvider.saveLoginUserToPhone(value: _user);

      _companyUserRepository.setCompanyUserDataToFirebase(
        dataModel: _companyUser,
        documentId: _user.mail
      );

      _crudRepository.updateUserDataToFirebase(
        dataModel: _user,
        documentId: _user.mail
      );

      showFunctionSuccessMessage(
        context: context,
        successMessage: "${_company.companyName} 에 가입되었습니다!"
      );
    }

    else{
      showFunctionErrorMessage(
        context: context,
        errorMessage: "회사 코드가 존재하지 않습니다"
      );
    }
  }
}