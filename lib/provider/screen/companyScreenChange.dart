//Flutter
import 'package:flutter/material.dart';

class CompanyScreenChangeProvider extends ChangeNotifier{
  //페이지 이름
  String _pageName = "userTypeSelect";

  //전달할 값
  String _sendValue = "";

  //LoginScreenChangeProvider();

  //페이지 이름 가져오기
  String getPageName(){
    return _pageName;
  }

  //전달받은 값 가져오기
  String getSendValue(){
    return _sendValue;
  }

  //페이지 이름 저장
  void setPageName(String name){
    _pageName = name;
    notifyListeners();
  }

  //페이지 이름 및 전달할 값 저장
  void setPageIndexAndString(String name, String sendValue){
    _pageName = name;
    _sendValue = sendValue;
    notifyListeners();
  }
}