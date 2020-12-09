//Flutter
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Model
import 'package:MyCompany/models/userModel.dart';

class LoginUserInfoProvider with ChangeNotifier{
  User _loginUser;

  //User 정보 가져오기
  User getLoginUser() {
    return _loginUser;
  }

  //User 정보 저장하기
  void setLoginUser(User value){
    _loginUser = value;
    notifyListeners();
  }

  //핸드폰에 User 정보 저장하기
  Future<void> saveLoginUserToPhone({BuildContext context, User value}) async {
    Format _format = Format();
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();

    dynamic encodeData = value.toJson();

    encodeData["createDate"] = _format.timeStampToDateTime(encodeData["createDate"]).toIso8601String();
    encodeData["lastModDate"] = _format.timeStampToDateTime(encodeData["lastModDate"]).toIso8601String();

    _sharedPreferences.setString("loginUser", jsonEncode(encodeData));
    setLoginUser(value);
  }

  //핸드폰에 저장된 User 정보 불러오기
  Future<void> loadLoginUserToPhone() async {
    Format _format = Format();
    FirebaseRepository _repository = FirebaseRepository();
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    if(_sharedPreferences.getString("loginUser") != null){
      dynamic decodeData = jsonDecode(_sharedPreferences.getString("loginUser"));
      decodeData["createDate"] = _format.dateTimeToTimeStamp(DateTime.parse(decodeData["createDate"]));
      decodeData["lastModDate"] = _format.dateTimeToTimeStamp(DateTime.parse(decodeData["lastModDate"]));

      _loginUser = User.fromMap(decodeData, null);

      User user = await _repository.getUser(userMail: _loginUser.mail);
      if(user != _loginUser){
        _loginUser = user;
      }
      notifyListeners();
    }

    else{
      return null;
    }
  }

  //로그아웃
  Future<void> logoutUesr() async {
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.remove("loginUser");
    setLoginUser(null);
  }
}