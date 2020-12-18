//Flutter
import 'package:flutter/material.dart';

class AlarmScreenChangeProvider extends ChangeNotifier{
  //페이지 이름
  String _pageName = "alarm";

  //전달할 값
  String _sendValue = "";

  //AlarmScreenChangeProvider();

  //페이지 이름 가져오기
  String getPageName(){
    return _pageName;
  }

  //전달받은 값 가져오기
  String getSendValue(){
    return _sendValue;
  }

  //페이지 이름 저장
  void setPageName({String pageName}){
    _pageName = pageName;
    notifyListeners();
  }

  //페이지 이름 및 전달할 값 저장
  void setPageIndexAndString({String pageName, String sendValue}){
    _pageName = pageName;
    _sendValue = sendValue;
    notifyListeners();
  }
}