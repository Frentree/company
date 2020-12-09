//Flutter
import 'package:flutter/material.dart';

//Const
import 'package:MyCompany/consts/colorCode.dart';


void showLastFirebaseMessage({BuildContext context, String lastFirebaseMessage}){
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

void showFunctionSuccessMessage({BuildContext context, String successMessage}){
  Scaffold.of(context).showSnackBar(
      SnackBar(
          backgroundColor: blueColor,
          duration: Duration(seconds: 5),
          content: Text(
              successMessage
          )
      )
  );
}

void showFunctionErrorMessage({BuildContext context, String errorMessage}){
  Scaffold.of(context).showSnackBar(
      SnackBar(
          backgroundColor: redColor,
          duration: Duration(seconds: 5),
          content: Text(
            errorMessage
          )
      )
  );
}
