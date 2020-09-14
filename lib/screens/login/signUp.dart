import 'package:flutter/material.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/provider/loginScreenChange.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/widgets/button.dart';
import 'package:companyplaylist/widgets/textFromField.dart';
import 'package:companyplaylist/widgets/dialog/phoneVerify.dart';
import 'package:companyplaylist/provider/firebaseLogin.dart';
import 'package:companyplaylist/Src/validate.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/Src/userCrud.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {

  TextEditingController _nameTextCon;
  TextEditingController _mailTextCon;
  TextEditingController _passwordTextCon;
  TextEditingController _passwordConfirmTextCon;
  TextEditingController _phoneNumberTextCon;

  final _formKeyName = GlobalKey<FormState>();
  final _formKeyMail = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  final _formKeyPasswordConfirm = GlobalKey<FormState>();
  final _formKeyPhone = GlobalKey<FormState>();

  Validate _validate = Validate(5);

  UserCrud _userCrud = UserCrud();
  User _user = User();

  FirebaseAuthProvider _firebaseAuthProvider = FirebaseAuthProvider();

  @override
  void initState(){
    super.initState();
    _nameTextCon = TextEditingController();
    _mailTextCon = TextEditingController();
    _passwordTextCon = TextEditingController();
    _passwordConfirmTextCon = TextEditingController();
    _phoneNumberTextCon = TextEditingController();
  }

  @override
  void dispose(){
    _nameTextCon.dispose();
    _mailTextCon.dispose();
    _passwordTextCon.dispose();
    _passwordConfirmTextCon.dispose();
    _phoneNumberTextCon = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

    _user = User(
        id: null,
        mail: _mailTextCon.text,
        name: _nameTextCon.text,
        phone: _phoneNumberTextCon.text
    );

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //상단 글자
          Text(
            "회원가입",
            style: customStyle(18, "Medium", blueColor),
          ),

          //공백
          SizedBox(
            height: customHeight(context, 0.01),
          ),

          //ID/PW 입력 란
          Container(
            child: Column(
              children: <Widget>[
                validityCheckTextFormField(_formKeyName, _nameTextCon, "이름", (value) => _validate.validRegExpCheckMessage("이름", value), (text) => _validate.isBtnActive(0, _formKeyName.currentState.validate())),
                validityCheckTextFormField(_formKeyMail, _mailTextCon, "이메일", (value) => _validate.validRegExpCheckMessage("이메일", value), (text) => _validate.isBtnActive(1, _formKeyMail.currentState.validate())),
                validityCheckTextFormField(_formKeyPassword, _passwordTextCon, "비밀번호", (value) => _validate.validRegExpCheckMessage("비밀번호", value), (text) => _validate.isBtnActive(2, _formKeyPassword.currentState.validate())),
                validityCheckTextFormField(_formKeyPasswordConfirm, _passwordConfirmTextCon, "비밀번호 확인", (value) => _validate.duplicateCheckMessage(_passwordTextCon.text, value), (text) => _validate.isBtnActive(3, _formKeyPasswordConfirm.currentState.validate())),
                validityCheckTextFormField(_formKeyPhone, _phoneNumberTextCon, "핸드폰번호(01012341234)", (value) => _validate.validRegExpCheckMessage("전화번호", value), (text) => _validate.isBtnActive(4, _formKeyPhone.currentState.validate())),
//                Row(
//                  children: <Widget>[
//                    Container(
//
//                      child: validityCheckTextFormField(_formKeyPhone, _phoneNumberTextCon, "핸드폰번호(01012341234)", (value) => _validate.validRegExpCheckMessage("전화번호", value), (text) => _validate.isBtnActive(4, _formKeyPhone.currentState.validate())),
//                    )
//                  ],
//                )
              ],
            ),
          ),

          //공백
          SizedBox(
            height: customHeight(context, 0.07),
          ),

          //공백
          SizedBox(
            height: customHeight(context, 0.07),
          ),

          //회원가입 버튼
          Row(
            children: <Widget>[
              Spacer(),
              loginScreenRaisedBtn(
                  context,
                  blueColor,
                  "회원가입",
                  whiteColor,
                  _validate.isBtnActiveList.contains(false) ? null : () async {
                    //DB에 저장
//                    bool singUpResult = await _firebaseAuthProvider.signUpWithEmail(_mailTextCon.text, _passwordTextCon.text);
//                    print(singUpResult);
//                    _user.id = _firebaseAuthProvider.getUser().uid;
//                    print("UID" + _user.id);
//                    if(singUpResult == true){
//                      _userCrud.addUser(_user,_user.id);
//                      loginScreenChangeProvider.setPageIndexAndString(4, _mailTextCon.text);
//                    }
//
//                    if(singUpResult == false){
//                      String errorMessage = _firebaseAuthProvider.getLastFirebaseMessage();
//                      if(errorMessage == "ERROR_EMAIL_ALREADY_IN_USE"){
//                        showAlertDialog(context, "회원가입 실패!", "이미 사용중인 이메일 입니다.");
//                      }
//                    }
                  }
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

