//import 'package:flutter/material.dart';
//import 'package:companyplaylist/consts/colorCode.dart';
//import 'package:companyplaylist/consts/widgetSize.dart';
//import 'package:companyplaylist/consts/font.dart';
//import 'package:companyplaylist/widgets/button.dart';
//import 'package:companyplaylist/widgets/textFromField.dart';
//import 'package:companyplaylist/repos/companyCodeCheck.dart';
//import 'package:companyplaylist/provider/loginScreenChange.dart';
//import 'package:provider/provider.dart';
//
//class CompanyMainPage extends StatefulWidget {
//  @override
//  CompanyMainPageState createState() =>CompanyMainPageState();
//}
//
//class CompanyMainPageState extends State<CompanyMainPage> {
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
//    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);
//
//    return Column(
//      children: <Widget>[
//        //상단 글자
//        Text(
//          "회원 가입을 축하드립니다.",
//          style: customStyle(18, "Medium", blueColor),
//        ),
//
//        //공백
//        SizedBox(
//          height: customHeight(context, 0.05),
//        ),
//
//        //코드 입력란
//        loginScreenRaisedBtn(context, mainColor, "회사만들기", whiteColor, () => loginScreenChangeProvider.setPageIndex(3)),
//
//        SizedBox(
//          height: customHeight(context, 0.03),
//        ),
//
//        loginScreenRaisedBtn(context, mainColor, "기존 회사 가입", whiteColor, null),
//      ],
//    );
//  }
//}