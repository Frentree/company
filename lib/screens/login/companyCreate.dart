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

class CompanyCreatePage extends StatefulWidget{
  @override
  CompanyCreatePageState createState() => CompanyCreatePageState();
}

class CompanyCreatePageState extends State<CompanyCreatePage> {
  //TextEditingController
  TextEditingController _companyNameCon;
  TextEditingController _companyCodeCon;

  LoginRepository _loginRepository = LoginRepository();

  Company _newCompany = Company();

  @override
  void initState(){
    super.initState();
    _companyNameCon = TextEditingController();
    _companyCodeCon = TextEditingController();
  }

  @override
  void dispose(){
    _companyNameCon.dispose();
    _companyCodeCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _newCompany = Company(
      id: null,
      companyName: _companyNameCon.text,
      companyCode: _companyCodeCon.text
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "회사 생성",
          style: customStyle(
            fontSize: 18,
            fontWeightName: "Medium",
            fontColor: blueColor
          ),
        ),

        //공백
        SizedBox(
          height: customHeight(
            context: context,
            heightSize: 0.05
          ),
        ),

        textFormField(
          textEditingController: _companyNameCon,
          hintText: "회사명",
        ),

        textFormField(
          textEditingController: _companyCodeCon,
          hintText: "회사 코드",
          showCursor: false,
          readOnly: true,
          suffixWidget: Padding(
            padding: const EdgeInsets.all(5.0),
            child: RaisedButton(
              child: Text(
                "코드 생성"
              ),
              onPressed: _companyNameCon.text != "" ? () async {
                String _result = await _loginRepository.createCompanyCode();
                setState(() {
                  _companyCodeCon.text = _result;
                });
              } : null
            )
          )
        ),

        SizedBox(
          height: customHeight(
            context: context,
            heightSize: 0.3
          ),
        ),

        loginScreenRaisedBtn(
          context: context,
          btnColor: blueColor,
          btnText:  "생성하기",
          btnTextColor: whiteColor,
          btnAction: (_companyNameCon.text != "" && _companyCodeCon.text != "") ? () => {
            _loginRepository.createCompanyCollectionToFirebase(
              context: context,
              company: _newCompany
            )
          } : null
        )
      ],
    );
  }
}