//Flutter
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';


void showLastFirebaseMessage(BuildContext context, String lastFirebaseMessage){
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: redColor,
      duration: Duration(seconds: 5),
      content: Text(
        lastFirebaseMessage
      )
    )
  );
}