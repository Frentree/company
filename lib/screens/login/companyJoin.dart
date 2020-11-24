//Flutter
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Widget
import 'package:companyplaylist/widgets/button/raisedButton.dart';
import 'package:companyplaylist/widgets/form/textFormField.dart';

//Repos
import 'package:companyplaylist/repos/login/loginRepository.dart';

//Model
import 'package:companyplaylist/models/companyModel.dart';

class CompanyJoinPage extends StatefulWidget{
  @override
  CompanyJoinPageState createState() => CompanyJoinPageState();
}

class CompanyJoinPageState extends State<CompanyJoinPage> {
  //TextEditingController
  TextEditingController _companyCodeCon;

  LoginRepository _loginRepository = LoginRepository();

  Company _newCompany = Company();

  @override
  void initState(){
    super.initState();
    _companyCodeCon = TextEditingController();
  }

  @override
  void dispose(){
    _companyCodeCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "초대 코드",
          style: customStyle(
            fontSize: 18,
            fontWeightName: "Medium",
            fontColor: blueColor,
          ),
        ),

        //공백
        SizedBox(
          height: customHeight(
            context: context,
            heightSize: 0.05,
          ),
        ),

        textFormField(
          textEditingController: _companyCodeCon,
          hintText: "초대코드를 입력해주세요",
        ),

        SizedBox(
          height: customHeight(
            context: context,
            heightSize: 0.1,
          ),
        ),

        Text(
          "초대코드는 관리자에게 받을 수 있습니다.",
          style: customStyle(
            fontSize: 14,
            fontWeightName: "Regular",
            fontColor: grayColor
          ),
        ),

        SizedBox(
          height: customHeight(
            context: context,
            heightSize: 0.3,
          ),
        ),

        loginScreenRaisedBtn(
          context: context,
          btnColor: blueColor,
          btnText:  "합류하기",
          btnTextColor: whiteColor,
          btnAction: (_companyCodeCon.text != "") ? () => {
            _loginRepository.joinCompanyUser(
              context: context,
              companyCode: _companyCodeCon.text
            )
          } : null
        )
      ],
    );
  }
}