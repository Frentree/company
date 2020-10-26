//Flutter
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';

class LoginUserInfoProvider with ChangeNotifier{
  User _loginUser;

  User getLoginUser() {
    return _loginUser;
  }

  void setLoginUser(User value){
    _loginUser = value;
    notifyListeners();
  }

  Future<void> saveLoginUserToPhone({User value}) async {
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString("loginUser", json.encode(value));
    setLoginUser(value);
  }

  Future<void> loadLoginUserToPhone() async {
    print("실행");
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await SharedPreferences.getInstance();
    if(_sharedPreferences.getString("loginUser") != null){
      _loginUser = User.fromMap(await json.decode(_sharedPreferences.getString("loginUser")), null);
      notifyListeners();
    }
    else{
      return null;
    }
  }

  void logoutUesr() async {
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.remove("loginUser");
    setLoginUser(null);
  }
}