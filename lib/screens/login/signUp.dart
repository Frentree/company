//Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
import 'package:companyplaylist/repos/firebasecrud/CrudRepository.dart';
import 'package:companyplaylist/repos/login/loginRepository.dart';
import 'package:companyplaylist/repos/showSnackBarMethod.dart';
import 'package:companyplaylist/repos/login/signUpMethod.dart';

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
  TextEditingController _phoneNumberTextCon;

  //TextForm Key
  final _formKeyName = GlobalKey<FormState>();
  final _formKeyMail = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  final _formKeyPasswordConfirm = GlobalKey<FormState>();
  final _formKeyPhone = GlobalKey<FormState>();

  //유효성 체크
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
  List<bool> isFormValidation = [false, false, false, false, false];

  //인증 코드 저장을 위한 List
  List<String> _smsCode = ["", "", "", "", "", ""];

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
    _phoneNumberTextCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //화면 이동 Provider
    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);
    
    //Firebase 인증 Provider
    FirebaseAuthProvider firebaseAuthProvider = Provider.of<FirebaseAuthProvider>(context);

    //User data model
    _newUser = User(
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
                validityCheckTextFormField(
                  _formKeyName,
                  _nameTextCon,
                  "이름",
                  (value) => _loginRepository.validationRegExpCheckMessage("이름", value),
                  (text) {
                    bool _result = _loginRepository.isFormValidation(_formKeyName.currentState.validate());
                    setState(() {
                      isFormValidation[0] = _result;
                    });
                  }
                ),
                validityCheckTextFormField(
                  _formKeyMail,
                  _mailTextCon,
                  "이메일",
                  (value) => _loginRepository.validationRegExpCheckMessage("이메일", value),
                  (text) {
                    bool _result = _loginRepository.isFormValidation(_formKeyMail.currentState.validate());
                    setState(() {
                      isFormValidation[1] = _result;
                    });
                  }
                ),
                validityCheckTextFormField(
                  _formKeyPassword,
                  _passwordTextCon,
                  "비밀번호",
                  (value) => _loginRepository.validationRegExpCheckMessage("비밀번호", value),
                  (text) {
                    bool _result = _loginRepository.isFormValidation(_formKeyPassword.currentState.validate());
                    setState(() {
                      isFormValidation[2] = _result;
                    });
                  }
                ),
                validityCheckTextFormField(
                  _formKeyPasswordConfirm,
                  _passwordConfirmTextCon,
                  "비밀번호 확인",
                  (value) => _loginRepository.duplicateCheckMessage(_passwordTextCon.text, value),
                  (text) {
                    bool _result = _loginRepository.isFormValidation(_formKeyPasswordConfirm.currentState.validate());
                    setState(() {
                      isFormValidation[3] = _result;
                    });
                  }
                ),
                validityCheckTextFormField(
                   _formKeyPhone,
                   _phoneNumberTextCon,
                   "핸드폰번호(01012341234)",
                   (value) => _loginRepository.validationRegExpCheckMessage("전화번호", value),
                   (text) {
                     bool _result = _loginRepository.isFormValidation(_formKeyPhone.currentState.validate());
                     firebaseAuthProvider.setPhonVerifyResultFalse();
                     setState(() {
                       isFormValidation[4] = _result;
                     });
                   }
                ),
              ]
            ),
          ),

          //공백
          SizedBox(
            height: customHeight(context, 0.02),
          ),
          
          //인증번호 요청 버튼
          Row(
            children: <Widget>[
              Spacer(),
              loginScreenRaisedBtn(
                context,
                blueColor,
                "인증번호 요청",
                whiteColor,
                isFormValidation[4] ? () => firebaseAuthProvider.verifyPhone(_phoneNumberTextCon.text) : null
              ),
              Spacer(),
            ],
          ),

          //공백
          SizedBox(
            height: customHeight(context, 0.01),
          ),

          //인증번호 입력 칸
          (firebaseAuthProvider.getPhoneVerifyResult() && isFormValidation[4]) ? Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "인증번호",
                  style: customStyle(15, "Regular", mainColor),
                ),
                SizedBox(
                  height: customHeight(context, 0.01),
                ),
                Row(
                  children: <Widget>[
                    certificationNumberTextFormField(_smsCode, 0),
                    certificationNumberTextFormField(_smsCode, 1),
                    certificationNumberTextFormField(_smsCode, 2),
                    certificationNumberTextFormField(_smsCode, 3),
                    certificationNumberTextFormField(_smsCode, 4),
                    certificationNumberTextFormField(_smsCode, 5)
                  ].map((c){
                    return Padding(
                      padding: EdgeInsets.only(right: customWidth(context, 0.05)),
                      child: c,
                    );
                  }).toList()
                )
              ],
            ),
          ) : Container(),

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
                  (isFormValidation.contains(false) == false && _smsCode.contains("") == false) ? (){
                    signUp(context, _smsCode.join(), _mailTextCon.text, _passwordTextCon.text, _newUser);
                  }: null
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

