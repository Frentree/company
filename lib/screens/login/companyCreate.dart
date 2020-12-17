//Flutter
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:kopo/kopo.dart';

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
              style: pageNameStyle,
            ),
          ),
          emptySpace,
          Container(
            child: Column(
              children: [
                Form(
                  key: _formKeyCompanyName,
                  child: TextFormField(
                    controller: _companyNameCon,
                    style: defaultRegularStyle,
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
                    validator: ((value) {
                      return _loginRepository.validationRegExpCheckMessage(
                        field: "이름",
                        value: value,
                      );
                    }),
                  ),
                ),
                emptySpace,
                TextFormField(
                  controller: _companyAddressCon,
                  style: defaultRegularStyle,
                  readOnly: true,
                  showCursor: false,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: textFormPadding,
                    hintText: "회사 주소",
                    hintStyle: hintStyle,
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
                emptySpace,
                TextFormField(
                  controller: _companyDetailAddressCon,
                  style: defaultRegularStyle,
                  readOnly: _companyAddressCon.text == "",
                  showCursor: _companyAddressCon.text != "",
                  autofocus: _companyAddressCon.text != "",
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: textFormPadding,
                    hintText: "상세 주소",
                    hintStyle: hintStyle,
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
                  "회사생성",
                  style: buttonWhiteStyle,
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
