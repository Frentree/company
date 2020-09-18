//Flutter
import 'package:flutter/material.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';

class LoginUserInfoProvider with ChangeNotifier{
  User _loginUser = User();

  User getloginUser() {
    return _loginUser;
  }

  User setLoginUser(User value){
    _loginUser = value;
    notifyListeners();
  }
}