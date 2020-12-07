//Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Widget
import 'package:flutter/rendering.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';


//Repos
import 'package:companyplaylist/repos/login/loginRepository.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';

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
  bool isPhoneVerify = false;

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
    _birthdayTextCon = MaskedTextController(mask: '0000.00.00');
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
    FocusScope.of(context).unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Firebase 인증 Provider
    FirebaseAuthProvider _firebaseAuthProvider =
        Provider.of<FirebaseAuthProvider>(context);

    //User data model
    _newUser = User(
      mail: _mailTextCon.text.replaceAll(" ", ""),
      name: _nameTextCon.text.replaceAll(" ", ""),
      birthday: _birthdayTextCon.text.replaceAll(".", ""),
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
                height: heightRatio(
                  context: context,
                  heightRatio: 0.06,
                ),
                child: font(
                  text: "회원가입",
                  textStyle: customStyle(
                    fontWeightName: "Medium",
                    fontColor: blueColor,
                  ),
                ),
              ),
              Container(
                height: heightRatio(context: context, heightRatio: 0.03),
              ),
              Container(
                height: heightRatio(
                  context: context,
                  heightRatio: 0.96,
                ),
                child: Column(
                  children: [
                    Form(
                      key: _formKeyName,
                      child: TextFormField(
                        controller: _nameTextCon,
                        decoration: InputDecoration(
                          hintText: "이름",
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
                    Form(
                      key: _formKeyMail,
                      child: TextFormField(
                        controller: _mailTextCon,
                        decoration: InputDecoration(
                          hintText: "이메일",
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
                    Form(
                      key: _formKeyPassword,
                      child: TextFormField(
                        controller: _passwordTextCon,
                        decoration: InputDecoration(
                          hintText: "비밀번호",
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
                    Form(
                      key: _formKeyPasswordConfirm,
                      child: TextFormField(
                        controller: _passwordConfirmTextCon,
                        decoration: InputDecoration(
                          hintText: "비밀번호 확인",
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
                    Form(
                      key: _formKeyBirthday,
                      child: TextFormField(
                        controller: _birthdayTextCon,
                        decoration: InputDecoration(
                          hintText: "생년월일",
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
                            field: "생일",
                            value: value,
                          );
                        }),
                        onChanged: ((text){
                          bool _result = _loginRepository.isFormValidation(
                            validationFunction: _formKeyBirthday.currentState.validate(),
                          );
                          setState(() {
                            isFormValidation[4] = _result;
                          });
                        }),
                      ),
                    ),
                    Form(
                      key: _formKeyPhone,
                      child: TextFormField(
                        controller: _phoneNumberTextCon,
                        decoration: InputDecoration(
                          hintText: "핸드폰번호(010-2226-9930/인증번호 : 123456)",
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
                    ),

                    Container(
                      height: heightRatio(context: context, heightRatio: 0.025),
                    ),

                    Visibility(
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
                          text: "회원가입",
                          textStyle: customStyle(
                            fontWeightName: "Medium",
                            fontColor: whiteColor,
                          ),
                        ),
                        onPressed: !(isFormValidation.contains(false) || _smsCode.contains("")) ? () async {
                          await _loginRepository.signUpWithFirebaseAuth(
                            context: context,
                            smsCode: _smsCode.join(),
                            password: _passwordTextCon.text,
                            user: _newUser,
                          );
                          Navigator.pushNamed(context, "/Login");
                        } : null,
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
