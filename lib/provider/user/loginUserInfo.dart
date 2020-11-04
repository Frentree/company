//Flutter
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/attendance/attendanceMethod.dart';

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

  Future<void> saveLoginUserToPhone({BuildContext context, User value}) async {
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString("loginUser", json.encode(value));
    setLoginUser(value);

    if(value.companyCode != null){
      print("회사코드");
      AttendanceMethod _attendanceProvider = Provider.of<AttendanceMethod>(context, listen: false);
      await _attendanceProvider.attendanceCheck();
    }
  }

  Future<void> loadLoginUserToPhone() async {
    print("로그인 유저 정보를 가져옵니다");
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await SharedPreferences.getInstance();
    if(_sharedPreferences.getString("loginUser") != null){
      _loginUser = User.fromMap(await json.decode(_sharedPreferences.getString("loginUser")), null);
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