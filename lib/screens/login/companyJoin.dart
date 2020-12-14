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
              style: customStyle(
                fontWeightName: "Medium",
                fontColor: blueColor,
                fontSize: defaultSize.sp,
              ),
            ),
          ),
          Container(
            height: widgetDistanceH.h,
          ),
          Container(
            child: Column(
              children: [
                TextFormField(
                  controller: _companyNameCon,
                  style: customStyle(
                    fontWeightName: "Regular",
                    fontColor: mainColor,
                    fontSize: defaultSize.sp,
                  ),
                  readOnly: true,
                  showCursor: false,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: textFormFontPaddingH.h,
                      horizontal: textFormFontPaddingW.w,
                    ),
                    hintText: "회사명",
                    hintStyle: customStyle(
                      fontWeightName: "Regular",
                      fontColor: mainColor,
                      fontSize: defaultSize.sp,
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
          Container(
            height: widgetButtonDistanceH.h,
          ),
          Center(
            child: Container(
              height: buttonSizeH.h,
              width: buttonSizeW.w,
              child: RaisedButton(
                color: blueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonRadiusW.w),
                ),
                elevation: 0.0,
                child: Text(
                  "회사 가입",
                  style: pageNameStyle,
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
