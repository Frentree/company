//Flutter
import 'package:companyplaylist/utils/date/dateFormat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Widget
import 'package:companyplaylist/widgets/button/raisedButton.dart';
import 'package:companyplaylist/widgets/form/textFormField.dart';
import 'package:flutter/rendering.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/firebase/firebaseAuth.dart';
import 'package:companyplaylist/provider/screen/loginScreenChange.dart';

//Repos
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';
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

  //TextForm Key
  final _formKeyName = GlobalKey<FormState>();
  final _formKeyMail = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  final _formKeyPasswordConfirm = GlobalKey<FormState>();
  final _formKeyBirthday = GlobalKey<FormState>();
  final _formKeyPhone = GlobalKey<FormState>();

  LoginRepository _loginRepository = LoginRepository();

  //UserDataCrudToFirebase
  CrudRepository _userCrud = CrudRepository();

  //User Model
  User _newUser = User();

  //인증ID
  String verificationId;

  //
  bool isPhoneVerify = false;

  //폼 유효성 여부 확인을 위한 List
  List<bool> isFormValidation = [false, false, false, false, false, false];

  //인증 코드 저장을 위한 List
  List<String> _smsCode = ["", "", "", "", "", ""];

  Format _format = Format();

  @override
  void initState() {
    super.initState();
    _nameTextCon = TextEditingController();
    _mailTextCon = TextEditingController();
    _passwordTextCon = TextEditingController();
    _passwordConfirmTextCon = TextEditingController();
    _birthdayTextCon = MaskedTextController(mask: '0000.00.00');
    _phoneNumberTextCon = MaskedTextController(mask: '000-0000-0000');
  }

  @override
  void dispose() {
    _nameTextCon.dispose();
    _mailTextCon.dispose();
    _passwordTextCon.dispose();
    _passwordConfirmTextCon.dispose();
    _birthdayTextCon.dispose();
    _phoneNumberTextCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Firebase 인증 Provider
    FirebaseAuthProvider _firebaseAuthProvider =
        Provider.of<FirebaseAuthProvider>(context);

    //화면 이동을 위한 Provider
    LoginScreenChangeProvider _loginScreenChangeProvider =
        Provider.of<LoginScreenChangeProvider>(context);

    //User data model
    _newUser = User(
      mail: _mailTextCon.text,
      name: _nameTextCon.text,
      //birthday: _format.dateTimeToTimeStamp(DateTime.parse(_birthdayTextCon.text.replaceAll(".", ""))),
      phone: _phoneNumberTextCon.text,
    );

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //상단 글자
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "회원가입",
                style: customStyle(
                  fontSize: 18,
                  fontWeightName: "Medium",
                  fontColor: blueColor,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _loginScreenChangeProvider.setPageName(pageName: "login");
                },
              )
            ],
          ),

          //공백
          SizedBox(
            height: customHeight(
              context: context,
              heightSize: 0.01,
            ),
          ),

          //ID/PW 입력 란
          Container(
            child: Column(children: <Widget>[
              validityCheckTextFormField(
                key: _formKeyName,
                textEditingController: _nameTextCon,
                hintText: "이름",
                validityCheckAction: (value) => _loginRepository
                    .validationRegExpCheckMessage(field: "이름", value: value),
                onChangeAction: (text) {
                  bool _result = _loginRepository.isFormValidation(
                    validationFunction: _formKeyName.currentState.validate(),
                  );
                  setState(
                    () {
                      isFormValidation[0] = _result;
                    },
                  );
                },
              ),
              validityCheckTextFormField(
                key: _formKeyMail,
                textEditingController: _mailTextCon,
                hintText: "이메일",
                validityCheckAction: (value) => _loginRepository
                    .validationRegExpCheckMessage(field: "이메일", value: value),
                onChangeAction: (text) {
                  bool _result = _loginRepository.isFormValidation(
                    validationFunction: _formKeyMail.currentState.validate(),
                  );
                  setState(
                    () {
                      isFormValidation[1] = _result;
                    },
                  );
                },
              ),
              validityCheckTextFormField(
                key: _formKeyPassword,
                textEditingController: _passwordTextCon,
                hintText: "비밀번호",
                validityCheckAction: (value) => _loginRepository
                    .validationRegExpCheckMessage(field: "비밀번호", value: value),
                onChangeAction: (text) {
                  bool _result = _loginRepository.isFormValidation(
                    validationFunction:
                        _formKeyPassword.currentState.validate(),
                  );
                  setState(
                    () {
                      isFormValidation[2] = _result;
                    },
                  );
                },
              ),
              validityCheckTextFormField(
                key: _formKeyPasswordConfirm,
                textEditingController: _passwordConfirmTextCon,
                hintText: "비밀번호 확인",
                validityCheckAction: (value) =>
                    _loginRepository.duplicateCheckMessage(
                        originalValue: _passwordTextCon.text,
                        checkValue: value),
                onChangeAction: (text) {
                  bool _result = _loginRepository.isFormValidation(
                    validationFunction:
                        _formKeyPasswordConfirm.currentState.validate(),
                  );
                  setState(
                    () {
                      isFormValidation[3] = _result;
                    },
                  );
                },
              ),
              validityCheckTextFormField(
                key: _formKeyBirthday,
                textEditingController: _birthdayTextCon,
                hintText: "생일(YYYY.MM.DD)",
                validityCheckAction: (value) => _loginRepository
                    .validationRegExpCheckMessage(field: "생일", value: value),
                onChangeAction: (text) {
                  bool _result = _loginRepository.isFormValidation(
                    validationFunction:
                        _formKeyBirthday.currentState.validate(),
                  );
                  setState(
                    () {
                      isFormValidation[4] = _result;
                    },
                  );
                },
              ),
              validityCheckTextFormField(
                key: _formKeyPhone,
                textEditingController: _phoneNumberTextCon,
                hintText: "핸드폰번호(01022269930/123456)",
                validityCheckAction: (value) => _loginRepository
                    .validationRegExpCheckMessage(field: "전화번호", value: value),
                onChangeAction: (text) {
                  bool _result = _loginRepository.isFormValidation(
                    validationFunction: _formKeyPhone.currentState.validate(),
                  );
                  _firebaseAuthProvider.setPhonVerifyResultFalse();
                  setState(
                    () {
                      isFormValidation[5] = _result;
                    },
                  );
                },
              ),
            ]),
          ),

          //공백
          SizedBox(
            height: customHeight(
              context: context,
              heightSize: 0.02,
            ),
          ),

          //인증번호 요청 버튼
          Row(
            children: <Widget>[
              Spacer(),
              loginScreenRaisedBtn(
                  context: context,
                  btnColor: blueColor,
                  btnText: "인증번호 요청",
                  btnTextColor: whiteColor,
                  btnAction: isFormValidation[5]
                      ? () => _firebaseAuthProvider.verifyPhone(
                          phoneNumber: _phoneNumberTextCon.text)
                      : null),
              Spacer(),
            ],
          ),

          //공백
          SizedBox(
            height: customHeight(
              context: context,
              heightSize: 0.01,
            ),
          ),

          //인증번호 입력 칸
          (_firebaseAuthProvider.getPhoneVerifyResult() && isFormValidation[5])
              ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "인증번호",
                        style: customStyle(
                            fontSize: 15,
                            fontWeightName: "Regular",
                            fontColor: mainColor),
                      ),
                      SizedBox(
                        height: customHeight(
                          context: context,
                          heightSize: 0.01,
                        ),
                      ),
                      Row(
                          children: <Widget>[
                        certificationNumberTextFormField(
                            codeList: _smsCode, codeListOrder: 0),
                        certificationNumberTextFormField(
                            codeList: _smsCode, codeListOrder: 1),
                        certificationNumberTextFormField(
                            codeList: _smsCode, codeListOrder: 2),
                        certificationNumberTextFormField(
                            codeList: _smsCode, codeListOrder: 3),
                        certificationNumberTextFormField(
                            codeList: _smsCode, codeListOrder: 4),
                        certificationNumberTextFormField(
                            codeList: _smsCode, codeListOrder: 5),
                      ].map((c) {
                        return Padding(
                          padding: EdgeInsets.only(
                              right: customWidth(
                                  context: context, widthSize: 0.05)),
                          child: c,
                        );
                      }).toList())
                    ],
                  ),
                )
              : Container(),

          //공백
          SizedBox(
            height: customHeight(
              context: context,
              heightSize: 0.07,
            ),
          ),

          //회원가입 버튼
          Row(
            children: <Widget>[
              Spacer(),
              loginScreenRaisedBtn(
                  context: context,
                  btnColor: blueColor,
                  btnText: "회원가입",
                  btnTextColor: whiteColor,
                  btnAction: (isFormValidation.contains(false) == false &&
                          _smsCode.contains("") == false)
                      ? () => {
                            _newUser = User(
                              mail: _mailTextCon.text,
                              name: _nameTextCon.text,
                              birthday: _birthdayTextCon.text,
                              phone: _phoneNumberTextCon.text,
                            ),
                            _loginRepository.signUpWithFirebaseAuth(
                              context: context,
                              smsCode: _smsCode.join(),
                              mail: _mailTextCon.text,
                              password: _passwordTextCon.text,
                              name: _nameTextCon.text,
                              user: _newUser,
                            ),
                          }
                      : null),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
