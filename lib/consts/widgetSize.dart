/*

위젯 사이즈 넣는 파일
버튼 위젯, 바텀시트 위젯 등등 공통으로 정의할 위젯 사이즈 적용

 */

//Flutter
import 'package:flutter/material.dart';

//넓이 커스텀 사이즈
double customWidth({BuildContext context, double widthSize}){
  double _customWidth = MediaQuery.of(context).size.width*widthSize;
  return _customWidth;
}

//높이 커스텀 사이즈
double customHeight({BuildContext context, double heightSize}){
  double _customHeight = MediaQuery.of(context).size.height*heightSize;
  return _customHeight;
}

//넓이 비율
double widthRatio({BuildContext context, double widthRatio}){
  double _widthRatio = MediaQuery.of(context).size.width*widthRatio;
  return _widthRatio;
}

//높이 비율
double heightRatio({BuildContext context, double heightRatio}){
  double _heightRatio = (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top)*heightRatio;
  return _heightRatio;
}