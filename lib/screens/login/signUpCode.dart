//import 'package:flutter/material.dart';
//import 'package:companyplaylist/consts/colorCode.dart';
//import 'package:companyplaylist/consts/widgetSize.dart';
//import 'package:companyplaylist/consts/font.dart';
//import 'package:companyplaylist/widgets/button.dart';
//import 'package:companyplaylist/widgets/textFromField.dart';
//import 'package:companyplaylist/repos/companyCodeCheck.dart';
//
//class SignUpCodePage extends StatefulWidget {
//  @override
//  SignUpCodePageState createState() => SignUpCodePageState();
//}
//
//class SignUpCodePageState extends State<SignUpCodePage> {
//  TextEditingController _codeTextCon;
//
//  @override
//  void initState() {
//    super.initState();
//    _codeTextCon = TextEditingController();
//  }
//
//  @override
//  void dispose(){
//    _codeTextCon.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: <Widget>[
//        //상단 글자
//        Text(
//          "환영합니다.",
//          style: customStyle(18, "Medium", blueColor),
//        ),
//
//        //공백
//        SizedBox(
//          height: customHeight(context, 0.05),
//        ),
//
//        //코드 입력란
//        Container(
//          child: textFormField(_codeTextCon, "회사코드"),
//        ),
//
//        //공백
//        SizedBox(
//          height: customHeight(context, 0.4),
//        ),
//
//        //요청하기 버튼
//        loginScreenRaisedBtn(context, blueColor, "요청하기", whiteColor, () => companyCodeCheck(context, _codeTextCon.text)),
//      ],
//    );
//  }
//}