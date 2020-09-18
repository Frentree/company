/*
폰트 종류, 크기 넣는 파일
 */

//Flutter
import 'package:flutter/material.dart';

//폰트 이름
String fontStyle = 'NotoSansKR';

//폰트 굵기
Map<String, FontWeight> fontWeight = {
  'Thin': FontWeight.w100,
  'Light': FontWeight.w300,
  'Regular': FontWeight.w400,
  'Medium': FontWeight.w500,
  'Bold': FontWeight.w700,
  'Black': FontWeight.w900
};

//커스텀 폰트 스타일
TextStyle customStyle(double fontSize, String fontWeightName, Color fontColor){
  return TextStyle(
    fontFamily: fontStyle,
    fontSize: fontSize,
    fontWeight: fontWeight[fontWeightName],
    color: fontColor,
  );
}