import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/repos/login/loginRepository.dart';
import 'package:companyplaylist/widgets/bottomsheet/setting/settingMyPageUpdate.dart';
import 'package:companyplaylist/widgets/form/textFormField.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Widget getMyInfomationCard({BuildContext context, User user}){
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageReference storageReference =
  _firebaseStorage.ref().child("profile/${user.mail}");
  return Padding(
    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              color: whiteColor,
              alignment: Alignment.center,
              width: customWidth(
                  context: context,
                  widthSize: 0.1
              ),
              child: GestureDetector(
                child: Container(
                  height: customHeight(
                      context: context,
                      heightSize: 0.05
                  ),
                  width: customWidth(
                      context: context,
                      widthSize: 0.1
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: whiteColor,
                      border: Border.all(color: whiteColor, width: 2)
                  ),
                  child: FutureBuilder(
                    future: _firebaseStorage.ref().child("profile/${user.mail}").getDownloadURL(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Icon(
                            Icons.person_outline
                        );
                      }
                      return Image.network(
                          snapshot.data
                      );
                    },
                  ),
                  /*Text(
                                    "사진",
                                    style: TextStyle(
                                        color: Colors.black
                                    ),
                                  ),*/
                ),
                onTap: (){
                },
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Text(
                user.name,
                style: customStyle(
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),

            Text(
              "개발팀",
              style: customStyle(
                fontSize: 14,
                fontColor: grayColor,
                fontWeightName: 'Medium',
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 15)),
            Text(
              "사원",
              style: customStyle(
                fontSize: 14,
                fontColor: grayColor,
                fontWeightName: 'Medium',
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 15)),
            ActionChip(
              backgroundColor: blueColor,
              label: Text(
                "수정",
                style: customStyle(
                  fontSize: 14,
                  fontColor: whiteColor,
                  fontWeightName: 'Medium',
                ),
              ),
              onPressed: () {
                SettingMyPageUpdate(context);
              },
            ),

          ],
        ),
        SizedBox(
          height: customHeight(
              context: context,
              heightSize: 0.01
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "입사일",
                style: customStyle(
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
            Expanded(
              child: Text(
                "2018.11.01",
                style: customStyle(
                  fontSize: 14,
                  fontColor: grayColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: customHeight(
              context: context,
              heightSize: 0.01
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "이메일",
                style: customStyle(
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
            Expanded(
              child: Text(
                user.mail,
                style: customStyle(
                  fontSize: 14,
                  fontColor: grayColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: customHeight(
              context: context,
              heightSize: 0.01
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "전화번호",
                style: customStyle(
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
            Expanded(
              child: Text(
                user.phone,
                style: customStyle(
                  fontSize: 14,
                  fontColor: grayColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: customHeight(
              context: context,
              heightSize: 0.01
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "계정탈퇴",
                style: customStyle(
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
            Expanded(
              child: Text(
                "",
                style: customStyle(
                  fontSize: 14,
                  fontColor: grayColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget getUpdateMyInfomationCard({BuildContext context, User user}){
  LoginRepository _loginRepository = LoginRepository();

  bool isPwdConfirm = false;

  TextEditingController _passwordNowConfirmTextCon = TextEditingController();
  TextEditingController _passwordNewTextCon = TextEditingController();
  TextEditingController _passwordNewConfirmTextCon = TextEditingController();
  TextEditingController _phoneEdit = TextEditingController();

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        color: whiteColor,
                        alignment: Alignment.center,
                        width: customWidth(
                            context: context,
                            widthSize: 0.1
                        ),
                        height: customHeight(
                            context: context,
                            heightSize: 0.08
                        ),
                        child: GestureDetector(
                          child: Container(
                            height: customHeight(
                                context: context,
                                heightSize: 0.05
                            ),
                            width: customWidth(
                                context: context,
                                widthSize: 0.1
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: whiteColor,
                                border: Border.all(color: whiteColor, width: 2)
                            ),
                            child: Image.network(
                                "https://i.pinimg.com/originals/d9/82/f4/d982f4ec7d06f6910539472634e1f9b1.png"
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Container(
                          height: customHeight(
                              context: context,
                              heightSize: 0.05
                          ),
                          child: FloatingActionButton(
                            backgroundColor: Colors.orange,
                            child: Icon(
                                Icons.attach_file
                            ),
                            onPressed: () {

                            },

                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    user.name,
                    style: customStyle(
                      fontSize: 16,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                ActionChip(
                  backgroundColor: whiteColor,
                  label: Text(
                    "변경",
                    style: customStyle(
                      fontSize: 14,
                      fontColor: whiteColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(
              height: customHeight(
                  context: context,
                  heightSize: 0.01
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "현재 비밀번호",
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),

                Expanded(
                  child: TextField(
                    controller: _passwordNowConfirmTextCon,
                    obscureText: true,

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '비밀번호 입력',
                    ),
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                  /*validityCheckTextFormField(
                    key: _formKeyPasswordConfirm,
                    textEditingController: _passwordConfirmTextCon,
                    hintText: "*****************'",
                    validityCheckAction: (value) => _loginRepository.validationRegExpCheckMessage(field: "비밀번호", value: value),
                    onChangeAction: (text) {
                      bool _result = _loginRepository.isFormValidation(validationFunction: _formKeyPasswordConfirm.currentState.validate());

                    }

                ),*/
                ),

                ActionChip(
                  backgroundColor: blueColor,
                  label: Text(
                    "확인",
                    style: customStyle(
                      fontSize: 14,
                      fontColor: whiteColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                  onPressed: () async {
                    bool isChk = await _loginRepository.InfomationConfirmWithFirebaseAuth(
                        context: context,
                        mail: user.mail,
                        password: _passwordNowConfirmTextCon.text.trim(),
                        name: user.name
                    );
                    setState(()  {
                      if(isChk) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: Text(
                                "인증 확인",
                                style: customStyle(
                                    fontColor: blueColor,
                                    fontSize: 13,
                                    fontWeightName: 'Bold'
                                ),
                              ),
                              content: Text(
                                "인증이 완료되었습니다.\n변경될 비밀번호를 입력해주세요.",
                                style: customStyle(
                                    fontColor: mainColor, fontSize: 13, fontWeightName: 'Regular'),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "확인",
                                    style: customStyle(
                                        fontColor: blueColor, fontSize: 15, fontWeightName: 'Bold'),
                                  ),
                                  onPressed: () {
                                    isPwdConfirm =  isChk;
                                    _passwordNowConfirmTextCon.selection;
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: Text(
                                "인증 실패",
                                style: customStyle(
                                    fontColor: redColor,
                                    fontSize: 13,
                                    fontWeightName: 'Bold'
                                ),
                              ),
                              content: Text(
                                "인증이 실패 하였습니다.",
                                style: customStyle(
                                    fontColor: mainColor, fontSize: 13, fontWeightName: 'Regular'),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "확인",
                                    style: customStyle(
                                        fontColor: blueColor, fontSize: 15, fontWeightName: 'Bold'),
                                  ),
                                  onPressed: () {
                                    isPwdConfirm =  isChk;
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    });
                  },
                ),
              ],
            ),
            Visibility(
                visible: isPwdConfirm,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "새 비밀번호",
                            style: customStyle(
                              fontSize: 14,
                              fontColor: mainColor,
                              fontWeightName: 'Medium',
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _passwordNewTextCon,
                            obscureText: true,

                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '*****************',
                            ),
                            style: customStyle(
                              fontSize: 14,
                              fontColor: mainColor,
                              fontWeightName: 'Medium',
                            ),
                          ),
                        ),
                        ActionChip(
                            backgroundColor: whiteColor,
                            label: Text(
                              "변경",
                              style: customStyle(
                                fontSize: 14,
                                fontColor: whiteColor,
                                fontWeightName: 'Medium',
                              ),
                            ),
                            onPressed: () {}
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "새 비밀번호 확인",
                            style: customStyle(
                              fontSize: 14,
                              fontColor: mainColor,
                              fontWeightName: 'Medium',
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _passwordNewConfirmTextCon,
                            obscureText: true,

                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '*****************',
                            ),
                            style: customStyle(
                              fontSize: 14,
                              fontColor: mainColor,
                              fontWeightName: 'Medium',
                            ),
                          ),
                        ),
                        ActionChip(
                            backgroundColor: blueColor,
                            label: Text(
                              "변경",
                              style: customStyle(
                                fontSize: 14,
                                fontColor: whiteColor,
                                fontWeightName: 'Medium',
                              ),
                            ),
                            onPressed: () {
                              String pwdMsg = _loginRepository.validationRegExpCheckMessage(
                                  field: "비밀번호", value: _passwordNowConfirmTextCon.text.trim());
                              print(pwdMsg);
                              if (_passwordNowConfirmTextCon.text.trim() == "") {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      title: Text(
                                        "비밀번호 변경 실패",
                                        style: customStyle(
                                            fontColor: redColor,
                                            fontSize: 13,
                                            fontWeightName: 'Bold'
                                        ),
                                      ),
                                      content: Text(
                                        "변경될 비밀번호를 입력해주세요",
                                        style: customStyle(
                                            fontColor: mainColor, fontSize: 13, fontWeightName: 'Regular'),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            "확인",
                                            style: customStyle(
                                                fontColor: blueColor, fontSize: 15, fontWeightName: 'Bold'),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (pwdMsg != null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      title: Text(
                                        "비밀번호 변경 실패",
                                        style: customStyle(
                                            fontColor: redColor,
                                            fontSize: 13,
                                            fontWeightName: 'Bold'
                                        ),
                                      ),
                                      content: Text(
                                        "영문 + 숫자 포함 최소 6자리 이상 입력 해주세요",
                                        style: customStyle(
                                            fontColor: mainColor, fontSize: 13, fontWeightName: 'Regular'),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            "확인",
                                            style: customStyle(
                                                fontColor: blueColor, fontSize: 15, fontWeightName: 'Bold'),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      title: Text(
                                        "비밀번호 변경",
                                        style: customStyle(
                                            fontColor: redColor,
                                            fontSize: 13,
                                            fontWeightName: 'Bold'
                                        ),
                                      ),
                                      content: Text(
                                        "비밀번호를 변경하시겠습니까?",
                                        style: customStyle(
                                            fontColor: mainColor,
                                            fontSize: 13,
                                            fontWeightName: 'Regular'),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            "예",
                                            style: customStyle(
                                                fontColor: blueColor,
                                                fontSize: 15,
                                                fontWeightName: 'Bold'),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(
                                            "아니오",
                                            style: customStyle(
                                                fontColor: blueColor,
                                                fontSize: 15,
                                                fontWeightName: 'Bold'),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                        ),
                      ],
                    ),
                  ],
                )
            ),

            Row(
              children: [
                Expanded(
                  child: Text(
                    "전화번호",
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneEdit,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: user.phone,
                    ),
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                ActionChip(
                  backgroundColor: blueColor,
                  label: Text(
                    "변경",
                    style: customStyle(
                      fontSize: 14,
                      fontColor: whiteColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                  onPressed: () {
                    RegExp phoneRegExp = RegExp(r'^[0-9]{11}$');
                    if (_phoneEdit.text.trim() == "") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: Text(
                              "전화번호 변경 실패",
                              style: customStyle(
                                  fontColor: redColor,
                                  fontSize: 13,
                                  fontWeightName: 'Bold'
                              ),
                            ),
                            content: Text(
                              "전화번호를 아무것도 입력하지 않았습니다.",
                              style: customStyle(
                                  fontColor: mainColor, fontSize: 13, fontWeightName: 'Regular'),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  "확인",
                                  style: customStyle(
                                      fontColor: blueColor, fontSize: 15, fontWeightName: 'Bold'),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else if (_phoneEdit.text.trim() == user.phone) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: Text(
                              "전화번호 변경 실패",
                              style: customStyle(
                                  fontColor: redColor,
                                  fontSize: 13,
                                  fontWeightName: 'Bold'
                              ),
                            ),
                            content: Text(
                              "기존 전화번호와 동일합니다.",
                              style: customStyle(
                                  fontColor: mainColor, fontSize: 13, fontWeightName: 'Regular'),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  "확인",
                                  style: customStyle(
                                      fontColor: blueColor, fontSize: 15, fontWeightName: 'Bold'),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else if (!phoneRegExp.hasMatch(_phoneEdit.text.trim())) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: Text(
                              "변경 실패",
                              style: customStyle(
                                  fontColor: redColor,
                                  fontSize: 13,
                                  fontWeightName: 'Bold'
                              ),
                            ),
                            content: Text(
                              "유효하지 않은 전화번호 형식입니다.",
                              style: customStyle(
                                  fontColor: mainColor, fontSize: 13, fontWeightName: 'Regular'),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  "확인",
                                  style: customStyle(
                                      fontColor: blueColor, fontSize: 15, fontWeightName: 'Bold'),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: Text(
                              "전화번호 변경",
                              style: customStyle(
                                  fontColor: redColor,
                                  fontSize: 13,
                                  fontWeightName: 'Bold'
                              ),
                            ),
                            content: Text(
                              "${_phoneEdit.text}\n이 번호로 변경 하시겟습니까?",
                              style: customStyle(
                                  fontColor: mainColor,
                                  fontSize: 13,
                                  fontWeightName: 'Regular'),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  "예",
                                  style: customStyle(
                                      fontColor: blueColor,
                                      fontSize: 15,
                                      fontWeightName: 'Bold'),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  "아니오",
                                  style: customStyle(
                                      fontColor: blueColor,
                                      fontSize: 15,
                                      fontWeightName: 'Bold'),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: customHeight(
                  context: context,
                  heightSize: 0.01
              ),
            ),
          ],
        ),
      );
    },
  );
}