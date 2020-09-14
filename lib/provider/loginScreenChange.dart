import 'package:flutter/material.dart';

class LoginScreenChangeProvider extends ChangeNotifier{
  int _pageIndex = 0;
  String _sendValue = "";

  LoginScreenChangeProvider();

  int getPageIndex(){
    return _pageIndex;
  }

  String getSendValue(){
    return _sendValue;
  }

  setPageIndex(int index){
    _pageIndex = index;
    notifyListeners();
  }

  setPageIndexAndString(int index, String sendValue){
    _pageIndex = index;
    _sendValue = sendValue;
    notifyListeners();
  }
}