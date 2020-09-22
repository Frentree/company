////Flutter
//import 'package:flutter/material.dart';
//
//
//import 'package:companyplaylist/widgets/alarm/alertDialog.dart';
//import 'package:companyplaylist/repos/firebaseMethod.dart';
//
//companyCodeCheck(BuildContext context, String code) async {
//
//  bool isCompanyCode = false;
//  String companyName;
//
//  FirestoreApi firestoreApi = FirestoreApi("companyCode");
//
//  await firestoreApi.getDataCollection().then((doc){
//    for(int i = 0; i < doc.documents.length; i++) {
//      if(doc.documents.elementAt(i).data["companyCode"] == code){
//        companyName = doc.documents.elementAt(i).data["companyName"];
//        isCompanyCode = true;
//        break;
//      }
//      else{
//        isCompanyCode = false;
//      }
//    }
//  });
//  print(isCompanyCode);
//
//  if(isCompanyCode == true){
//    showAlertDialog(context, companyName, "$companyName 회사에 가입하시겠습니까?");
//  }
//  else{
//    showAlertDialog(context, "!", "회사 코드가 올바르지 않습니다.");
//  }
//}