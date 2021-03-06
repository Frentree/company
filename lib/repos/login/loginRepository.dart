//Flutter
import 'package:MyCompany/models/approvalModel.dart';
import 'package:MyCompany/repos/setting/infomationUpdateMethod.dart';
import 'package:flutter/material.dart';

//Repos
import 'package:MyCompany/repos/login/validationMethod.dart';
import 'package:MyCompany/repos/login/signUpMethod.dart';
import 'package:MyCompany/repos/login/signInMethod.dart';
import 'package:MyCompany/repos/login/companyMethod.dart';

//Model
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/companyModel.dart';

class LoginRepository {
  ValidationMethod _validation = ValidationMethod();
  SignUpMethod _signUpMethod = SignUpMethod();
  SignInMethod _signInMethod = SignInMethod();
  myInfomationMethod _myInfoMethod = myInfomationMethod();
  CompanyMethod _companyMethod = CompanyMethod();

  bool isFormValidation({bool validationFunction}) =>
      _validation.isFormValidation(validationFunction: validationFunction);

  String validationRegExpCheckMessage({String field, String value}) =>
      _validation.validationRegExpCheckMessage(field: field, value: value);

  String duplicateCheckMessage({String originalValue, String checkValue}) =>
      _validation.duplicateCheckMessage(
          originalValue: originalValue, checkValue: checkValue);

  Future<void> signUpWithFirebaseAuth(
      {BuildContext context, /*String smsCode,*/ String password, User user}) =>
      _signUpMethod.signUpWithFirebaseAuth(
          context: context, /*smsCode: smsCode,*/ password: password, user: user);

  // 계정삭제 패스워드 확인
  Future<void> dropAccountWithFirebaseAuth(
      {BuildContext context, String companyCode, String mail, String password, String name}) =>
      _myInfoMethod.dropAccountWithFirebaseAuth(
          context: context, companyCode: companyCode, mail: mail, password: password, name: name);

  // 계정삭제
  Future<void> dropAccountAuth(
      {BuildContext context, String companyCode, String mail}) =>
      _myInfoMethod.dropAccountAuth(context, companyCode, mail);

  // 패스워드 확인
  Future<bool> InfomationConfirmWithFirebaseAuth(
      {BuildContext context, String mail, String password, String name}) =>
      _myInfoMethod.InfomationConfirmWithFirebaseAuth(
          context: context, mail: mail, password: password, name: name);

  // 패스워드 변경
  Future<bool> InfomationUpdateWithFirebaseAuth(
      {BuildContext context,
        String mail,
        String newPassword,
        String newPasswordConfirm,
        String name}) =>
      _myInfoMethod.InfomationUpdateWithFirebaseAuth(
          context: context,
          mail: mail,
          newPassword: newPassword,
          newPasswordConfirm: newPasswordConfirm,
          name: name);

  Future<void> signInWithFirebaseAuth(
      {BuildContext context, String mail, String password}) =>
      _signInMethod.signInWithFirebaseAuth(
          context: context, mail: mail, password: password);

  Future<void> createCompany({BuildContext context, Company companyModel}) =>
      _companyMethod.createCompany(
          context: context, companyModel: companyModel);

  Future<void> joinCompanyUser({BuildContext context, String companyCode}) =>
      _companyMethod.joinCompanyUser(
          context: context, companyCode: companyCode);

  Future<void> userApproval({BuildContext context, String approvalUserMail, String position, String teamName, String enteredDate}) =>
      _companyMethod.userApproval(
          context: context, approvalUserMail: approvalUserMail, position: position, team: teamName, enteredDate: enteredDate);

  Future<void> userRejection({BuildContext context, String approvalUserMail}) =>
      _companyMethod.userRejection(
          context: context, approvalUserMail: approvalUserMail);

  Future<void> userLeave({BuildContext context, String leaveUserMail}) => _companyMethod.userLeave(
    context: context, leaveUserMail: leaveUserMail,
  );
}
