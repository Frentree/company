//Flutter
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:kopo/kopo.dart';

//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';


//Repos
import 'package:MyCompany/repos/login/loginRepository.dart';

//Model
import 'package:MyCompany/models/companyModel.dart';

class CompanyCreatePage extends StatefulWidget {
  @override
  CompanyCreatePageState createState() => CompanyCreatePageState();
}

class CompanyCreatePageState extends State<CompanyCreatePage> {
  //TextEditingController
  TextEditingController _companyNameCon;
  TextEditingController _companyAddressCon;
  TextEditingController _companyDetailAddressCon;

  //TextForm Key
  final _formKeyCompanyName = GlobalKey<FormState>();

  LoginRepository _loginRepository = LoginRepository();

  Company _newCompany = Company();

  @override
  void initState() {
    super.initState();
    _companyNameCon = TextEditingController();
    _companyAddressCon = TextEditingController();
    _companyDetailAddressCon = TextEditingController();
  }

  @override
  void dispose() {
    _companyNameCon.dispose();
    _companyAddressCon.dispose();
    _companyDetailAddressCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _newCompany = Company(
      companyName: _companyNameCon.text,
      companyAddr:
          _companyAddressCon.text + " " + _companyDetailAddressCon.text,
      companySearch: _companyNameCon.text.split(""),
    );
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
              "회사 생성",
              style: customStyle(
                fontWeightName: "Medium",
                fontColor: blueColor,
                fontSize: pageNameFontSize.sp,
              ),
            ),
          ),
          Container(
            height: widgetDistanceH.h,
          ),
          Container(
            child: Column(
              children: [
                Form(
                  key: _formKeyCompanyName,
                  child: TextFormField(
                    controller: _companyNameCon,
                    style: customStyle(
                      fontWeightName: "Regular",
                      fontColor: mainColor,
                      fontSize: textFormFontSize.sp,
                    ),
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
                        fontSize: textFormFontSize.sp,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: textFieldUnderLine,
                        ),
                      ),
                    ),
                    validator: ((value) {
                      return _loginRepository.validationRegExpCheckMessage(
                        field: "이름",
                        value: value,
                      );
                    }),
                  ),
                ),
                Container(
                  height: widgetDistanceH.h,
                ),
                TextFormField(
                  controller: _companyAddressCon,
                  style: customStyle(
                    fontWeightName: "Regular",
                    fontColor: mainColor,
                    fontSize: textFormFontSize.sp,
                  ),
                  readOnly: true,
                  showCursor: false,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: textFormFontPaddingH.h,
                      horizontal: textFormFontPaddingW.w,
                    ),
                    hintText: "회사 주소",
                    hintStyle: customStyle(
                      fontWeightName: "Regular",
                      fontColor: mainColor,
                      fontSize: textFormFontSize.sp,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: textFieldUnderLine,
                      ),
                    ),
                  ),
                  onTap: () async {
                    KopoModel model = await Navigator.push(
                      Scaffold.of(context).context,
                      MaterialPageRoute(builder: (context) => Kopo()),
                    );
                    if (model != null) {
                      setState(
                        () {
                          _companyAddressCon.text = "${model.address}";
                          _companyDetailAddressCon.text =
                              "${model.buildingName}${model.apartment == 'Y' ? '아파트' : ""}";
                        },
                      );
                    }
                  },
                ),
                Container(
                  height: widgetDistanceH.h,
                ),
                TextFormField(
                  controller: _companyDetailAddressCon,
                  style: customStyle(
                    fontWeightName: "Regular",
                    fontColor: mainColor,
                    fontSize: textFormFontSize.sp,
                  ),
                  readOnly: _companyAddressCon.text == "",
                  showCursor: _companyAddressCon.text != "",
                  autofocus: _companyAddressCon.text != "",
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: textFormFontPaddingH.h,
                      horizontal: textFormFontPaddingW.w,
                    ),
                    hintText: "상세 주소",
                    hintStyle: customStyle(
                      fontWeightName: "Regular",
                      fontColor: mainColor,
                      fontSize: textFormFontSize.sp,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: textFieldUnderLine,
                      ),
                    ),
                  ),
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
                  "회사생성",
                  style: customStyle(
                    fontWeightName: "Medium",
                    fontColor: whiteColor,
                    fontSize: buttonFontSize.sp,
                  ),
                ),
                onPressed: _companyAddressCon.text != ""
                    ? () async {
                        _loginRepository.createCompany(
                          context: context,
                          companyModel: _newCompany,
                        );
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
