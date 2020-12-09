//Flutter
import 'package:companyplaylist/models/approvalModel.dart';
import 'package:companyplaylist/repos/setting/infomationUpdateMethod.dart';
import 'package:flutter/material.dart';

//Repos
import 'package:companyplaylist/repos/login/validationMethod.dart';
import 'package:companyplaylist/repos/login/signUpMethod.dart';
import 'package:companyplaylist/repos/login/signInMethod.dart';
import 'package:companyplaylist/repos/login/companyMethod.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/models/companyModel.dart';

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
          {BuildContext context, String smsCode, String password, User user}) =>
      _signUpMethod.signUpWithFirebaseAuth(
          context: context, smsCode: smsCode, password: password, user: user);

  // 패스워드 확인
  Future<bool> InfomationConfirmWithFirebaseAuth(
          {BuildContext context, String mail, String password, String name}) =>
      _myInfoMethod.InfomationConfirmWithFirebaseAuth(
          context: context, mail: mail, password: password, name: name);

  // 패스워드 변경
  Future<void> InfomationUpdateWithFirebaseAuth(
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

  Future<void> userApproval({BuildContext context, String approvalUserMail}) =>
      _companyMethod.userApproval(
          context: context, approvalUserMail: approvalUserMail);

  Future<void> userRejection({BuildContext context, String approvalUserMail}) =>
      _companyMethod.userRejection(
          context: context, approvalUserMail: approvalUserMail);

  Future<void> userLeave({BuildContext context, String leaveUserMail}) => _companyMethod.userLeave(
    context: context, leaveUserMail: leaveUserMail,
  );
}
