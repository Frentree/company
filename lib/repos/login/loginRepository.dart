//Flutter
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
  CompanyMethod _companyMethod = CompanyMethod();

  bool isFormValidation (bool validationFunction) => _validation.isFormValidation(validationFunction);
  String validationRegExpCheckMessage(String field, String value) => _validation.validationRegExpCheckMessage(field, value);
  String duplicateCheckMessage(String originalValue, String checkValue) => _validation.duplicateCheckMessage(originalValue, checkValue);

  Future<void> signUpWithFirebaseAuth(BuildContext context, String smsCode, String mail, String password, String name, User user) => _signUpMethod.signUpWithFirebaseAuth(context, smsCode, mail, password, name, user);

  Future<void> signInWithFirebaseAuth(BuildContext context, String mail, String password) => _signInMethod.signInWithFirebaseAuth(context, mail, password);

  String createCompanyCode() => _companyMethod.createCompanyCode();
  Future<void> createCompanyCollectionToFirebase(BuildContext context, Company company) => _companyMethod.createCompanyCollectionToFirebase(context, company);
}

