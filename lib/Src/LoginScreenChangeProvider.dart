import 'package:flutter/material.dart';

class LoginScreenChangeProvider extends ChangeNotifier{
  int _pageIndex = 0;

  LoginScreenChangeProvider();

  int getPageIndex(){
    print("index  $_pageIndex");
    return _pageIndex;
  }

  setPageIndex(int index){
    _pageIndex = index;
    print("넣었다");
    notifyListeners();
  }
}