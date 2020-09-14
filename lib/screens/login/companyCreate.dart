import 'package:flutter/material.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/provider/loginScreenChange.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/widgets/button.dart';
import 'package:companyplaylist/widgets/textFromField.dart';


class CreateCompanyPage extends StatefulWidget{
  @override
  CreateCompanyPageState createState() => CreateCompanyPageState();
}

class CreateCompanyPageState extends State<CreateCompanyPage>{

  TextEditingController _companyNameTextCon;
  TextEditingController _bossNameTextCon;
  TextEditingController _companyCodeTextCon;

  @override
  void initState(){
    super.initState();
    _companyNameTextCon = TextEditingController();
    _bossNameTextCon = TextEditingController();
    _companyCodeTextCon = TextEditingController();
  }

  @override
  void dispose(){
    _companyNameTextCon.dispose();
    _bossNameTextCon.dispose();
    _companyCodeTextCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //상단 글자
        Text(
          "회사생성",
          style: customStyle(18, "Medium", blueColor),
        ),

        //공백
        SizedBox(
          height: customHeight(context, 0.01),
        ),

        //ID/PW 입력 란
        Container(
          child: Column(
            children: <Widget>[
              textFormField(_companyNameTextCon, "회사명"),
              textFormField(_bossNameTextCon, "대표자 성함"),
//              readOlnyTextFormField(_companyCodeTextCon, "회사코드", () async {
//                _companyCodeTextCon.text = await companyCodeCheck();
//              })
            ],
          ),
        ),

        //공백
        SizedBox(
          height: customHeight(context, 0.07),
        ),

        textBtn("직장만들기", customStyle(15, "Regular", mainColor), null),

        //공백
        SizedBox(
          height: customHeight(context, 0.07),
        ),

        //회원가입 버튼
        Row(
          children: <Widget>[
            Spacer(),
            loginScreenRaisedBtn(context, blueColor, "회사등록", whiteColor, () => loginScreenChangeProvider.setPageIndex(2)),
            Spacer(),
          ],
        ),
      ],
    );
  }
}