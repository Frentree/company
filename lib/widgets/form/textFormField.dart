//Flutter
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:flutter/services.dart';

//기본 TextFormField
TextFormField textFormField(TextEditingController textEditingController, String hintText){
  return TextFormField(
    controller: textEditingController,
    decoration: InputDecoration(
        hintText: hintText,
        hintStyle: customStyle(15, "Regular", mainColor),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: textFieldUnderLine,
            )
        )
    ),
  );
}

//뒤에 아이콘이 추가된 TextFormField
TextFormField textFormFieldWithSuffixIcon(TextEditingController textEditingController, String hintText, {Widget suffixWidget}){
  return TextFormField(
    textAlignVertical: TextAlignVertical.center,
    controller: textEditingController,
    decoration: InputDecoration(
        hintText: hintText,
        hintStyle: customStyle(15, "Regular", mainColor),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: textFieldUnderLine,
            )
        ),
        suffixIcon: Padding(
            padding: const EdgeInsets.all(5.0),
            child: suffixWidget
        )
    ),
  );
}

//읽기 전용 TextFormField
TextFormField readOlnyTextFormField(TextEditingController textEditingController, String hintText, {Function onTap, Widget suffixWidget}){
  return TextFormField(
    showCursor: false,
    readOnly: true,
    controller: textEditingController,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: customStyle(15, "Regular", mainColor),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: textFieldUnderLine,
        )
      ),
      suffixIcon: suffixWidget
    ),
    onTap: onTap,
  );
}

//유효성 검사가 추가된 TextFormField
Form validityCheckTextFormField(GlobalKey<FormState> key, TextEditingController textEditingController, String hintText, Function validityCheckAction, Function onChangeAction) {
  return Form(
    key: key,
    child: TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: customStyle(15, "Regular", mainColor),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: textFieldUnderLine,
            )
        ),
      ),
      validator: validityCheckAction,
      onChanged: onChangeAction,
    ),
  );
}

//유효성 검사 및 뒤에 아이콘이 추가된 TextFormField
Form validityCheckTextFormFieldWithSuffixIcon(GlobalKey<FormState> key, TextEditingController textEditingController, String hintText, Function validityCheckAction, Function onChangeAction, Widget suffixWidget) {
  return Form(
    key: key,
    child: TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: customStyle(15, "Regular", mainColor),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: textFieldUnderLine,
              )
          ),
          suffixIcon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: suffixWidget
          )
      ),
      validator: validityCheckAction,
      onChanged: onChangeAction,
    ),
  );
}

//회원가입 페이지 인증번호 입력 폼
Container certificationNumberTextFormField(List<String> codeList, int codeListOrder){
  return Container(
    height: 40,
    width: 40,
    child: Center(
      child: TextFormField(
        textAlign: TextAlign.center,
        style: customStyle(18, "Regular", mainColor),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1)
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: greyColor,
              width: 10
            ),
          ),
        ),
        onChanged: (value){
          codeList[codeListOrder] = value;
        },
      ),
    ),
  );
}