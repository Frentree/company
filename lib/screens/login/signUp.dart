//Flutter
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

//Const
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
//Widget
import 'package:flutter/rendering.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:MyCompany/provider/firebase/firebaseAuth.dart';


//Repos
import 'package:MyCompany/repos/login/loginRepository.dart';

//Model
import 'package:MyCompany/models/userModel.dart';

final word = Words();

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  //TextForm Controller
  TextEditingController _nameTextCon;
  TextEditingController _mailTextCon;
  TextEditingController _passwordTextCon;
  TextEditingController _passwordConfirmTextCon;
  TextEditingController _birthdayTextCon;
  TextEditingController _phoneNumberTextCon;
  List<TextEditingController> _certificationNumberTexCon;


  //TextForm Key
  final _formKeyName = GlobalKey<FormState>();
  final _formKeyMail = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  final _formKeyPasswordConfirm = GlobalKey<FormState>();
  final _formKeyBirthday = GlobalKey<FormState>();
  final _formKeyPhone = GlobalKey<FormState>();

  LoginRepository _loginRepository = LoginRepository();

  //User Model
  User _newUser = User();

  //
  bool isPhoneVerify = true/*false*/;

  //폼 유효성 여부 확인을 위한 List
  List<bool> isFormValidation = [false, false, false, false, false, false];

  //인증 코드 저장을 위한 List
  List<String> _smsCode = ["", "", "", "", "", ""];

  @override
  void initState() {
    super.initState();
    _nameTextCon = TextEditingController();
    _mailTextCon = TextEditingController();
    _passwordTextCon = TextEditingController();
    _passwordConfirmTextCon = TextEditingController();
    _birthdayTextCon = MaskedTextController(mask: '0000/00/00');
    _phoneNumberTextCon = MaskedTextController(mask: '000-0000-0000');
    _certificationNumberTexCon = [TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(), TextEditingController()];
  }

  @override
  void dispose() {
    _nameTextCon.dispose();
    _mailTextCon.dispose();
    _passwordTextCon.dispose();
    _passwordConfirmTextCon.dispose();
    _birthdayTextCon.dispose();
    _phoneNumberTextCon.dispose();
    _certificationNumberTexCon.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Firebase 인증 Provider
    FirebaseAuthProvider _firebaseAuthProvider =
        Provider.of<FirebaseAuthProvider>(context);
    Format _format = Format();
    //User data model
    _newUser = User(
      mail: _mailTextCon.text.replaceAll(" ", ""),
      name: _nameTextCon.text.replaceAll(" ", ""),
      phone: _phoneNumberTextCon.text,
    );

    return Scaffold(
      backgroundColor: whiteColor,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowGlow();
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 5.0.h,
                alignment: Alignment.centerLeft,
                child: Text(
                  word.signUp(),
                  style: pageNameStyle,
                ),
              ),
              emptySpace,
              Container(
                child: Column(
                  children: [
                    Form(
                      key: _formKeyName,
                      child: TextFormField(
                        controller: _nameTextCon,
                        style: defaultRegularStyle,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: textFormPadding,
                          hintText: word.name(),
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
                        onChanged: ((text){
                          bool _result = _loginRepository.isFormValidation(
                            validationFunction: _formKeyName.currentState.validate(),
                          );
                          setState(() {
                            isFormValidation[0] = _result;
                          });
                        }),
                      ),
                    ),
                    emptySpace,
                    Form(
                      key: _formKeyMail,
                      child: TextFormField(
                        controller: _mailTextCon,
                        style: defaultRegularStyle,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: textFormPadding,
                          hintText: word.email(),
                          hintStyle: hintStyle,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: textFieldUnderLine,
                            ),
                          ),
                        ),
                        validator: ((value) {
                          return _loginRepository.validationRegExpCheckMessage(
                            field: "이메일",
                            value: value,
                          );
                        }),
                        onChanged: ((text){
                          bool _result = _loginRepository.isFormValidation(
                            validationFunction: _formKeyMail.currentState.validate(),
                          );
                          setState(() {
                            isFormValidation[1] = _result;
                          });
                        }),
                      ),
                    ),
                    emptySpace,
                    Form(
                      key: _formKeyPassword,
                      child: TextFormField(
                        controller: _passwordTextCon,
                        style: defaultRegularStyle,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: textFormPadding,
                          hintText: word.password(),
                          hintStyle: hintStyle,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: textFieldUnderLine,
                            ),
                          ),
                        ),
                        validator: ((value) {
                          return _loginRepository.validationRegExpCheckMessage(
                            field: "비밀번호",
                            value: value,
                          );
                        }),
                        onChanged: ((text){
                          bool _result = _loginRepository.isFormValidation(
                            validationFunction: _formKeyPassword.currentState.validate(),
                          );
                          setState(() {
                            isFormValidation[2] = _result;
                          });
                        }),
                      ),
                    ),
                    emptySpace,
                    Form(
                      key: _formKeyPasswordConfirm,
                      child: TextFormField(
                        controller: _passwordConfirmTextCon,
                        style: defaultRegularStyle,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: textFormPadding,
                          hintText: word.passwordConfirm(),
                          hintStyle: hintStyle,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: textFieldUnderLine,
                            ),
                          ),
                        ),
                        validator: ((value) {
                          return _loginRepository.duplicateCheckMessage(
                            originalValue: _passwordTextCon.text,
                            checkValue: value,
                          );
                        }),
                        onChanged: ((text){
                          bool _result = _loginRepository.isFormValidation(
                            validationFunction: _formKeyPasswordConfirm.currentState.validate(),
                          );
                          setState(() {
                            isFormValidation[3] = _result;
                          });
                        }),
                      ),
                    ),
                    emptySpace,
                    Form(
                      key: _formKeyBirthday,
                      child: TextFormField(
                        controller: _birthdayTextCon,
                        style: defaultRegularStyle,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: textFormPadding,
                          hintText: word.birthDay(),
                          hintStyle: hintStyle,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: textFieldUnderLine,
                            ),
                          ),
                        ),
                        validator: ((value) {
                          return _loginRepository.validationRegExpCheckMessage(
                            field: "생일",
                            value: value,
                          );
                        }),
                        onChanged: ((text){
                          bool _result = _loginRepository.isFormValidation(
                            validationFunction:  _formKeyBirthday.currentState.validate(),
                          );
                          setState(() {
                            isFormValidation[4] = _result;
                          });

                        }),

                        /*onChanged: ((text){
                          bool _result = _loginRepository.isFormValidation(
                            validationFunction: _formKeyBirthday.currentState.validate(),
                          );
                          setState(() {
                            //isFormValidation[4] = _result;
                          });
                        }),*/


                      ),
                    ),
                    emptySpace,
                    Form(
                      key: _formKeyPhone,
                      child: TextFormField(
                        controller: _phoneNumberTextCon,
                        style: defaultRegularStyle,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: textFormPadding,
                          hintText: word.phone(),
                          hintStyle: hintStyle,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: textFieldUnderLine,
                            ),
                          ),
                        ),
                        validator: ((value) {
                          return _loginRepository.validationRegExpCheckMessage(
                            field: "전화번호",
                            value: value,
                          );
                        }),
                        onChanged: ((text){
                          bool _result = _loginRepository.isFormValidation(
                            validationFunction: _formKeyPhone.currentState.validate(),
                          );
                          setState(() {
                            isFormValidation[5] = _result;
                          });
                        }),
                      ),
                    ),
                    emptySpace,
                    /*Container(
                      height: heightRatio(
                        context: context,
                        heightRatio: 0.06,
                      ),
                      width: widthRatio(
                        context: context,
                        widthRatio: 1,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: widthRatio(
                          context: context,
                          widthRatio: 0.2,
                        ),
                      ),
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
                          text: "인증번호 요청",
                          textStyle: customStyle(
                            fontWeightName: "Medium",
                            fontColor: whiteColor,
                          ),
                        ),
                        onPressed: isFormValidation[5] ? () async {
                          bool _result = await _firebaseAuthProvider.verifyPhone(
                            phoneNumber: _phoneNumberTextCon.text,
                          );
                          setState(() {
                            isPhoneVerify = _result;
                          });
                        } : null,
                      ),
                    ),*/

                    /*Visibility(
                      visible: isPhoneVerify,
                      child: Container(
                        height: heightRatio(context: context, heightRatio: 0.125),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: heightRatio(
                                  context: context, heightRatio: 0.05),
                              width:
                                  widthRatio(context: context, widthRatio: 0.15),
                              child: font(
                                text: "인증번호",
                                textStyle: customStyle(
                                  fontWeightName: "Regular",
                                  fontColor: mainColor,
                                ),
                              ),
                            ),
                            Container(
                              height: heightRatio(
                                  context: context, heightRatio: 0.025),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: heightRatio(
                                      context: context, heightRatio: 0.05),
                                  width: widthRatio(
                                      context: context, widthRatio: 0.1),
                                  child: TextFormField(
                                    controller: _certificationNumberTexCon[0],
                                    textAlign: TextAlign.center,
                                    style: customStyle(
                                      fontWeightName: "Regular",
                                      fontColor: mainColor,
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1)
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: grayColor, width: 10),
                                      ),
                                    ),
                                    onChanged: ((text){
                                      _smsCode[0] = text;
                                    }),
                                  ),
                                ),
                                Container(
                                  height: heightRatio(
                                      context: context, heightRatio: 0.05),
                                  width: widthRatio(
                                      context: context, widthRatio: 0.1),
                                  child: TextFormField(
                                    controller: _certificationNumberTexCon[1],
                                    textAlign: TextAlign.center,
                                    style: customStyle(
                                      fontWeightName: "Regular",
                                      fontColor: mainColor,
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1)
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: grayColor, width: 10),
                                      ),
                                    ),
                                    onChanged: ((text){
                                      _smsCode[1] = text;
                                    }),
                                  ),
                                ),
                                Container(
                                  height: heightRatio(
                                      context: context, heightRatio: 0.05),
                                  width: widthRatio(
                                      context: context, widthRatio: 0.1),
                                  child: TextFormField(
                                    controller: _certificationNumberTexCon[2],
                                    textAlign: TextAlign.center,
                                    style: customStyle(
                                      fontWeightName: "Regular",
                                      fontColor: mainColor,
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1)
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: grayColor, width: 10),
                                      ),
                                    ),
                                    onChanged: ((text){
                                      _smsCode[2] = text;
                                    }),
                                  ),
                                ),
                                Container(
                                  height: heightRatio(
                                      context: context, heightRatio: 0.05),
                                  width: widthRatio(
                                      context: context, widthRatio: 0.1),
                                  child: TextFormField(
                                    controller: _certificationNumberTexCon[3],
                                    textAlign: TextAlign.center,
                                    style: customStyle(
                                      fontWeightName: "Regular",
                                      fontColor: mainColor,
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1)
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: grayColor, width: 10),
                                      ),
                                    ),
                                    onChanged: ((text){
                                      _smsCode[3] = text;
                                    }),
                                  ),
                                ),
                                Container(
                                  height: heightRatio(
                                      context: context, heightRatio: 0.05),
                                  width: widthRatio(
                                      context: context, widthRatio: 0.1),
                                  child: TextFormField(
                                    controller: _certificationNumberTexCon[4],
                                    textAlign: TextAlign.center,
                                    style: customStyle(
                                      fontWeightName: "Regular",
                                      fontColor: mainColor,
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1)
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: grayColor, width: 10),
                                      ),
                                    ),
                                    onChanged: ((text){
                                      _smsCode[4] = text;
                                    }),
                                  ),
                                ),
                                Container(
                                  height: heightRatio(
                                      context: context, heightRatio: 0.05),
                                  width: widthRatio(
                                      context: context, widthRatio: 0.1),
                                  child: TextFormField(
                                    controller: _certificationNumberTexCon[5],
                                    textAlign: TextAlign.center,
                                    style: customStyle(
                                      fontWeightName: "Regular",
                                      fontColor: mainColor,
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1)
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: grayColor, width: 10),
                                      ),
                                    ),
                                    onChanged: ((text){
                                      _smsCode[5] = text;
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),*/
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
                            "회원가입",
                            style: buttonWhiteStyle,
                          ),
                          onPressed: !(isFormValidation.contains(false) /*|| _smsCode.contains("")*/) ? () async {
                            FocusScope.of(context).unfocus();
                            _newUser.birthday = _birthdayTextCon.text == "" ? null : _birthdayTextCon.text.replaceAll(".", "")/*_format.dateTimeToTimeStamp(DateTime.parse(_birthdayTextCon.text.replaceAll(".", "")))*/;
                            await _loginRepository.signUpWithFirebaseAuth(
                              context: context,
                              /*smsCode: _smsCode.join(),*/
                              password: _passwordTextCon.text,
                              user: _newUser,
                            );
                            Navigator.pushNamed(context, "/Login");
                          } : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
