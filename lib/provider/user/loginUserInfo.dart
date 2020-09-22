//Flutter
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';

class LoginUserInfoProvider with ChangeNotifier{
  User _loginUser;

  LoginUserInfoProvider(){
    loadLoginUserToPhone();
  }

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
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await SharedPreferences.getInstance();
    _loginUser = User.fromMap(json.decode(_sharedPreferences.getString("loginUser")), null);
    notifyListeners();
  }
}