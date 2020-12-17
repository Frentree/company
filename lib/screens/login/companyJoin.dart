//Flutter
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/screens/login/companySearch.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
//Repos
import 'package:MyCompany/repos/login/loginRepository.dart';

//Model
import 'package:MyCompany/models/companyModel.dart';

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
            height: pageNameSizeH.h,
            alignment: Alignment.centerLeft,
            child: Text(
              "회사 가입",
              style: pageNameStyle,
            ),
          ),
          emptySpace,
          Container(
            child: Column(
              children: [
                TextFormField(
                  controller: _companyNameCon,
                  style: defaultRegularStyle,
                  readOnly: true,
                  showCursor: false,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: textFormPadding,
                    hintText: "회사명",
                    hintStyle: hintStyle,
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
                          builder: (context) => CompanySearchPage(_newCompany)
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
          emptySpace,
          emptySpace,
          Center(
            child: Container(
              height: buttonSizeH.h,
              width: SizerUtil.deviceType == DeviceType.Tablet ? buttonSizeTW.w : buttonSizeMW.w,
              child: RaisedButton(
                color: blueColor,
                shape: raisedButtonShape,
                elevation: 0.0,
                child: Text(
                  "회사 가입",
                  style: buttonWhiteStyle,
                ),
                onPressed: _companyNameCon.text != "" ? () async {
                  _loginRepository.joinCompanyUser(
                    context: context,
                    companyCode: _newCompany.companyCode,
                  );
                } : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
