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
          style: customStyle(18, "Medium", blueColor),
        ),

        //공백
        SizedBox(
          height: customHeight(context, 0.05),
        ),

        textFormField(_companyNameCon, "회사명"),
        
        readOlnyTextFormField(
          _companyCodeCon,
          "회사 코드",
          suffixWidget: Padding(
            padding: const EdgeInsets.all(5.0),
            child: RaisedButton(
              child: Text(
                "코드 생성"
              ),
              onPressed: _companyNameCon.text != "" ? (){
                String _result = _loginRepository.createCompanyCode();
                setState(() {
                  _companyCodeCon.text = _result;
                });
              } : null
            )
          )
        ),

        SizedBox(
          height: customHeight(context, 0.3),
        ),

        loginScreenRaisedBtn(
          context,
          blueColor,
          "생성하기",
          whiteColor,
          (_companyNameCon.text != "" && _companyCodeCon.text != "") ? (){
            _loginRepository.createCompanyCollectionToFirebase(context, _newCompany);
          } : null
        )
      ],
    );
  }
}