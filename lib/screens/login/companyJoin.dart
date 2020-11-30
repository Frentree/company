//Flutter
import 'package:companyplaylist/screens/login/companySearch.dart';
import 'package:flutter/material.dart';
import 'package:kopo/kopo.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Repos
import 'package:companyplaylist/repos/login/loginRepository.dart';

//Model
import 'package:companyplaylist/models/companyModel.dart';

class CompanyJoinPage extends StatefulWidget {
  @override
  CompanyJoinPageState createState() => CompanyJoinPageState();
}

class CompanyJoinPageState extends State<CompanyJoinPage> {
  //TextEditingController
  TextEditingController _companyNameCon;

  LoginRepository _loginRepository = LoginRepository();

  Company _newCompany;

  @override
  void initState() {
    super.initState();
    _companyNameCon = TextEditingController();
  }

  @override
  void dispose() {
    _companyNameCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: heightRatio(
              context: context,
              heightRatio: 0.06,
            ),
            child: font(
              text: "회사 가입",
              textStyle: customStyle(
                fontWeightName: "Medium",
                fontColor: blueColor,
              ),
            ),
          ),
          Container(
            height: heightRatio(
              context: context,
              heightRatio: 0.03,
            ),
          ),
          Container(
            height: heightRatio(
              context: context,
              heightRatio: 0.36,
            ),
            child: Column(
              children: [
                TextFormField(
                  controller: _companyNameCon,
                  readOnly: true,
                  showCursor: false,
                  decoration: InputDecoration(
                    hintText: "회사명",
                    hintStyle: customStyle(
                      fontWeightName: "Regular",
                      fontColor: mainColor,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: textFieldUnderLine,
                      ),
                    ),
                  ),
                  onTap: () async {
                    Company company = await Navigator.push(
                      Scaffold.of(context).context,
                      MaterialPageRoute(
                          builder: (context) => CompanySearchPage(_companyNameCon.text)
                      ),
                    );
                    if(company != null){
                      setState(() {
                        _companyNameCon.text = company.companyName;
                        _newCompany = company;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            height: heightRatio(
              context: context,
              heightRatio: 0.025,
            ),
          ),
          Container(
            height: heightRatio(
              context: context,
              heightRatio: 0.06,
            ),
            width: widthRatio(context: context, widthRatio: 1),
            padding: EdgeInsets.symmetric(
                horizontal: widthRatio(context: context, widthRatio: 0.2)),
            child: RaisedButton(
              color: blueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: whiteColor,
                ),
              ),
              elevation: 0.0,
              child: font(
                text: "회사 가입",
                textStyle: customStyle(
                  fontWeightName: "Medium",
                  fontColor: whiteColor,
                ),
              ),
              onPressed: _companyNameCon.text != "" ? () async {
                _loginRepository.joinCompanyUser(
                  context: context,
                  companyCode: _newCompany.companyCode,
                );
              } : null,
            ),
          ),
          Container(
            height: heightRatio(
              context: context,
              heightRatio: 0.025,
            ),
          ),
        ],
      ),
    );
  }
}
