import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';

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

TextFormField readOlnyTextFormField(TextEditingController textEditingController, String hintText, Function onTap){
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
        )
    ),
    onTap: onTap,
  );
}

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