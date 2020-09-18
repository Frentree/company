import 'package:flutter/material.dart';
import 'package:companyplaylist/repos/firebaseMethod.dart';

class Validate {

  List<bool> isBtnActiveList = [];

  Validate(int formCount){
    for(int i = 0; i < formCount; i++){
      isBtnActiveList.add(false);
    }
    print(isBtnActiveList);
  }

  isBtnActive(int formOrder, bool validateFunction){
    if(validateFunction){
      isBtnActiveList[formOrder] = true;
    }

    else {
      isBtnActiveList[formOrder] = false;
    }
  }


  bool isRegExp(String field, String value){
    bool _isValidRegExp = false;

    RegExp emailRegExp = RegExp(r'^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$');
    RegExp passwordRegExp = RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$');
    RegExp phoneRegExp = RegExp(r'^[0-9]{11}$');

    switch (field) {
      case "이메일":
        {
          _isValidRegExp = emailRegExp.hasMatch(value);
        }
        break;

      case "비밀번호":
        {
          _isValidRegExp = passwordRegExp.hasMatch(value);
        }
        break;

      case "전화번호":
        {
          _isValidRegExp = phoneRegExp.hasMatch(value);
        }
        break;

      default:
        {
          _isValidRegExp = true;
        }
        break;
    }

    return _isValidRegExp;
  }

  Future<bool> duplicateCheckFromFirebase(String collectionName, String dataField, String value) async{
    bool _isDuplicate = false;
    FirestoreApi firestoreApi = FirestoreApi(collectionName);
    await firestoreApi.getDataCollection().then((doc){
      for(int i = 0; i < doc.documents.length; i++){
        if(doc.documents.elementAt(i).data[dataField] == value){
          _isDuplicate = true;
          break;
        }
      }
    });

    return _isDuplicate;
  }

  bool duplicateCheck(String originalValue, String checkValue){
    bool _isDuplicate = false;
    if(originalValue == checkValue){
      _isDuplicate = true;
    }

    return _isDuplicate;
  }

  String validRegExpCheckMessage(String field, String value){
    if(value.isNotEmpty){
      if(isRegExp(field, value)){
        return null;
      }
      else {
        if(field == "비밀번호"){
          return "영문+숫자 포함 최소 6자리 이상 입력 해주세요";
        }
        else {
          return field + " 형식이 올바르지 않습니다.";
        }
      }
    }

    else {
      return field + "을(를) 입력해 주세요.";
    }
  }

  String duplicateCheckMessage(String originalValue, String checkValue){
    if(checkValue.isNotEmpty){
      if(duplicateCheck(originalValue, checkValue)){
        return null;
      }
      else {
        return "비밀번호가 다릅니다.";
      }
    }

    else{
      return "비밀번호를 입력해 주세요";
    }
  }
}