//Flutter
import 'package:flutter/material.dart';

InkWell textBtn(String btnText, TextStyle btnTextStyle, btnAction){
  return InkWell(
      child: Text(
        btnText,
        style: btnTextStyle,
      ),
      onTap: btnAction
  );
}