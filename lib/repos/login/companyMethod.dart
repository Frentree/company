//Flutter
import 'package:MyCompany/models/approvalModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:flutter/material.dart';
import 'dart:math';

//Provider
import 'package:provider/provider.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';

//Repos
import 'package:MyCompany/repos/firebasecrud/crudRepository.dart';
import 'package:MyCompany/repos/showSnackBarMethod.dart';

//Model
import 'package:MyCompany/models/companyModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';

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
    while (_companyCode.length <= 6) {
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
  Future<void> createCompany({BuildContext context, Company companyModel}) async{
    Format _format = Format();
    FirebaseRepository _repository = FirebaseRepository();

    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context, listen: false);
    User _loginUser = _loginUserInfoProvider.getLoginUser(); //로그인한 사용자 정보 가져오기

    CompanyUser _companyUser = CompanyUser(
      user: _loginUser,
      level: [8, 9],
      createDate: _format.dateTimeToTimeStamp(DateTime.now()),
      lastModDate: _format.dateTimeToTimeStamp(DateTime.now()),
    );

    companyModel.companyCode = await createCompanyCode();
    _loginUser.companyCode = companyModel.companyCode;
    _loginUser.state = 1;

    //회사 컬렉션 생성
    await _repository.saveCompany(companyModel: companyModel);

    await _repository.addGrade(_loginUser.companyCode, "최고관리자", 9);
    await _repository.addGrade(_loginUser.companyCode, "앱 관리자", 8);

    _repository.saveCompanyUser(companyUserModel: _companyUser);
    _repository.updateUser(userModel: _loginUser);

    _loginUserInfoProvider.saveLoginUserToPhone(context: context, value: _loginUser);

    showFunctionSuccessMessage(
        context: context,
        successMessage: "새로운 회사가 생성되었습니다!"
    );
  }

  //회사 가입
  Future<void> joinCompanyUser({BuildContext context, String companyCode}) async {
    Format _format = Format();
    FirebaseRepository _repository = FirebaseRepository();

    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context, listen: false);
    User _loginUser = _loginUserInfoProvider.getLoginUser(); //로그인한 사용자 정보 가져오기

    _loginUser.companyCode = companyCode;
    _loginUser.state = 0;
    _repository.updateUser(userModel: _loginUser);

    Approval approvalModel = Approval(
      name: _loginUser.name,
      mail: _loginUser.mail,
      birthday: _loginUser.birthday,
      phone: _loginUser.phone,
      requestDate: _format.dateTimeToTimeStamp(DateTime.now()),
    );

    _repository.saveApproval(
      companyCode: companyCode,
      approvalModel: approvalModel,
    );

    _loginUserInfoProvider.saveLoginUserToPhone(context: context, value: _loginUser);
  }

  //가입자 승인
  Future<void> userApproval({BuildContext context, String approvalUserMail}) async {
    FirebaseRepository _repository = FirebaseRepository();

    User approvalUser = await _repository.getUser(userMail: approvalUserMail);

    CompanyUser _newCompanyUser = CompanyUser(
      user: approvalUser,
      level: [0],
    );

    approvalUser.state = 1;

    _repository.updateUser(userModel: approvalUser);
    _repository.saveCompanyUser(companyUserModel: _newCompanyUser);
  }

  //가입자 거절
  Future<void> userRejection({BuildContext context, String approvalUserMail}) async {
    FirebaseRepository _repository = FirebaseRepository();

    User approvalUser = await _repository.getUser(userMail: approvalUserMail);

    approvalUser.state = 2;
    approvalUser.companyCode = "";

    _repository.updateUser(userModel: approvalUser);
  }

  Future<void> userLeave({BuildContext context, String leaveUserMail}) async {
    FirebaseRepository _repository = FirebaseRepository();

    User approvalUser = await _repository.getUser(userMail: leaveUserMail);

    approvalUser.state = 4;
    approvalUser.companyCode = "";

    _repository.updateUser(userModel: approvalUser);
  }
}