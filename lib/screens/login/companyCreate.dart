//Flutter
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
    );
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
              text: "회사 생성",
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
                Form(
                  key: _formKeyCompanyName,
                  child: TextFormField(
                    controller: _companyNameCon,
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
                    validator: ((value) {
                      return _loginRepository.validationRegExpCheckMessage(
                        field: "이름",
                        value: value,
                      );
                    }),
                  ),
                ),
                TextFormField(
                  controller: _companyAddressCon,
                  readOnly: true,
                  showCursor: false,
                  decoration: InputDecoration(
                    hintText: "회사 주소",
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
                TextFormField(
                  controller: _companyDetailAddressCon,
                  readOnly: _companyAddressCon.text == "",
                  showCursor: _companyAddressCon.text != "",
                  autofocus: _companyAddressCon.text != "",
                  decoration: InputDecoration(
                    hintText: "상세 주소",
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
                text: "회사 생성",
                textStyle: customStyle(
                  fontWeightName: "Medium",
                  fontColor: whiteColor,
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
