import 'package:flutter/material.dart';

double customWidth(BuildContext context, double widthSize){
  double _customWidth = MediaQuery.of(context).size.width*widthSize;
  return _customWidth;
}

double customHeight(BuildContext context, double HeightSize){
  double _customHeight = MediaQuery.of(context).size.height*HeightSize;
  return _customHeight;
}