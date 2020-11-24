//Flutter
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:flutter/services.dart';

TextFormField textFormField(
    {TextEditingController textEditingController,
    String hintText,
    bool showCursor = true,
    bool readOnly = false,
    Function onTap,
    Widget suffixWidget}) {
  return TextFormField(
    textAlignVertical: TextAlignVertical.center,
    showCursor: showCursor,
    readOnly: readOnly,
    controller: textEditingController,
    decoration: InputDecoration(
        hintText: hintText,
        hintStyle: customStyle(
          fontSize: 15,
          fontWeightName: "Regular",
          fontColor: mainColor,
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: textFieldUnderLine,
        )),
        suffixIcon: suffixWidget),
    onTap: onTap,
  );
}

TextFormField textFormFieldWithOutlinedBorder(
    {TextEditingController textEditingController,
      String hintText,
      bool showCursor = true,
      bool readOnly = false,
      Function onTap,
      Widget suffixWidget}) {
  return TextFormField(
    textAlignVertical: TextAlignVertical.center,
    showCursor: showCursor,
    readOnly: readOnly,
    controller: textEditingController,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintText: hintText,
        hintStyle: customStyle(
          fontSize: 15,
          fontWeightName: "Regular",
          fontColor: mainColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: inputBoarderColor,
            width: 1.0,
          ),
        ),
        suffixIcon: suffixWidget),
    onTap: onTap,
  );
}

//유효성 검사 및 뒤에 아이콘이 추가된 TextFormField
Form validityCheckTextFormField(
    {GlobalKey<FormState> key,
    TextEditingController textEditingController,
    String hintText,
    Function validityCheckAction,
    Function onChangeAction,
    Widget suffixWidget}) {
  return Form(
    key: key,
    child: TextFormField(
      textAlignVertical: TextAlignVertical.center,
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: customStyle(
            fontSize: 15,
            fontWeightName: "Regular",
            fontColor: mainColor,
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: textFieldUnderLine,
          )),
          suffixIcon:
              Padding(padding: const EdgeInsets.all(5.0), child: suffixWidget)),
      validator: validityCheckAction,
      onChanged: onChangeAction,
    ),
  );
}

//회원가입 페이지 인증번호 입력 폼
Container certificationNumberTextFormField(
    {List<String> codeList, int codeListOrder}) {
  return Container(
    height: 40,
    width: 40,
    child: Center(
      child: TextFormField(
        textAlign: TextAlign.center,
        style: customStyle(
          fontSize: 18,
          fontWeightName: "Regular",
          fontColor: mainColor,
        ),
        inputFormatters: [LengthLimitingTextInputFormatter(1)],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: grayColor, width: 10),
          ),
        ),
        onChanged: (value) {
          codeList[codeListOrder] = value;
        },
      ),
    ),
  );
}
