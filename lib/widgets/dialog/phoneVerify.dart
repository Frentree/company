import 'package:flutter/material.dart';
import 'package:companyplaylist/provider/firebaseLogin.dart';
import 'package:provider/provider.dart';

void phoneVerify(BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context){
      FirebaseAuthProvider firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context);

      return AlertDialog(
        title: Text(
          "전화번호 인증"
        ),
      );
    }
  );
}