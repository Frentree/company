//Flutter
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';

class LoginUserInfoProvider with ChangeNotifier{
  User _loginUser = User();

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
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString("loginUser", json.encode(value));
    setLoginUser(value);
  }

  //핸드폰에 저장된 User 정보 불러오기
  Future<void> loadLoginUserToPhone() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    if(_sharedPreferences.getString("loginUser") != null){
      _loginUser = User.fromMap(await json.decode(_sharedPreferences.getString("loginUser")), null);
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