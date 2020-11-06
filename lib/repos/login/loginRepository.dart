//Flutter
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

class LoginRepository{
  ValidationMethod _validation = ValidationMethod();
  SignUpMethod _signUpMethod = SignUpMethod();
  SignInMethod _signInMethod = SignInMethod();
  InfomationUpdateMethod _infoMethod = InfomationUpdateMethod();
  CompanyMethod _companyMethod = CompanyMethod();

  bool isFormValidation ({bool validationFunction}) => _validation.isFormValidation(validationFunction: validationFunction);
  String validationRegExpCheckMessage({String field, String value}) => _validation.validationRegExpCheckMessage(field: field, value: value);
  String duplicateCheckMessage({String originalValue, String checkValue}) => _validation.duplicateCheckMessage(originalValue: originalValue, checkValue: checkValue);

  Future<void> signUpWithFirebaseAuth({BuildContext context, String smsCode, String mail, String password, String name, User user}) => _signUpMethod.signUpWithFirebaseAuth(context: context, smsCode: smsCode, mail: mail, password: password, name: name, user: user);

  Future<void> InfomationUpdateWithFirebaseAuth({BuildContext context, String mail, String password, String name}) => _infoMethod.InfomationUpdateWithFirebaseAuth(context: context, mail: mail, password: password, name: name);

  Future<void> signInWithFirebaseAuth({BuildContext context, String mail, String password}) => _signInMethod.signInWithFirebaseAuth(context: context, mail: mail, password: password);

  String createRandomCompanyCode() => _companyMethod. createRandomCompanyCode();
  Future<String> createCompanyCode() => _companyMethod.createCompanyCode();
  Future<void> createCompanyCollectionToFirebase({BuildContext context, Company company}) => _companyMethod.createCompanyCollectionToFirebase(context: context, company: company);
  Future<void> joinCompanyUser({BuildContext context, String companyCode}) => _companyMethod.joinCompanyUser(context: context, companyCode: companyCode);
}


