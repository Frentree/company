import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/login/loginRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

SettingMyPageUpdate(BuildContext context) {
  User _loginUser;
  bool isPwdConfirm = false;
  LoginRepository _loginRepository = LoginRepository();
  File _image;
  String _profileImageURL = "";

  TextEditingController _passwordNowConfirmTextCon = TextEditingController();
  TextEditingController _passwordNewTextCon = TextEditingController();
  TextEditingController _passwordNewConfirmTextCon = TextEditingController();
  TextEditingController _phoneEdit = TextEditingController();

  final Firestore _db = Firestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
        _loginUser = _loginUserInfoProvider.getLoginUser();


        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // 프로필 사진을 업로드할 경로와 파일명을 정의. 사용자의 uid를 이용하여 파일명의 중복 가능성 제거
            StorageReference storageReference =
            _firebaseStorage.ref().child("profile/${_loginUser.mail}");

            void _uploadImageToStorage(ImageSource source) async {
              File image = await ImagePicker.pickImage(source: source);

              if (image == null) return;
              setState(() {
                _image = image;
              });

              // 파일 업로드
              StorageUploadTask storageUploadTask = storageReference.putFile(_image);

              // 파일 업로드 완료까지 대기
              await storageUploadTask.onComplete;

              // 업로드한 사진의 URL 획득
              String downloadURL = await storageReference.getDownloadURL();

              _db.collection("company")
                  .document(_loginUser.companyCode)
                  .collection("user")
                  .document(_loginUser.mail)
                  .updateData({
                "profilePhoto" : downloadURL
              });

              _db.collection("user")
                  .document(_loginUser.mail)
                  .updateData({
                "profilePhoto" : downloadURL
              });

              // 업로드된 사진의 URL을 페이지에 반영
              setState(() {
                _loginUser.profilePhoto = downloadURL;
                _loginUserInfoProvider.setLoginUser(_loginUser);
                _loginUser = _loginUserInfoProvider.getLoginUser();
              });
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      color: blackColor,
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      }
                  ),
                  ExpansionTile(
                    initiallyExpanded: true,
                    leading: Icon(Icons.person_outline),
                    title: Text('내 정보 수정'),
                    children: [
                      Padding(
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
                                            child: FutureBuilder(
                                              future: _firebaseStorage.ref().child("profile/${_loginUser.mail}").getDownloadURL(),
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
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return SimpleDialog(
                                                      title: Text(
                                                        "선택",
                                                        style: customStyle(
                                                            fontColor: mainColor,
                                                            fontSize: 14
                                                        ),
                                                      ),
                                                      children: [
                                                        SimpleDialogOption(
                                                          onPressed: () {
                                                            _uploadImageToStorage(ImageSource.camera);
                                                          },
                                                          child: Text(
                                                            "카메라",
                                                            style: customStyle(
                                                                fontColor: mainColor,
                                                                fontSize: 13
                                                            ),
                                                          ),
                                                        ),
                                                        SimpleDialogOption(
                                                          onPressed: () {
                                                            _uploadImageToStorage(ImageSource.gallery);
                                                          },
                                                          child:Text(
                                                            "갤러리",
                                                            style: customStyle(
                                                                fontColor: mainColor,
                                                                fontSize: 13
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _loginUser.name,
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
                                    "기존 비밀번호",
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
                                      hintText: '기존 비밀번호 입력',
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
                                        mail: _loginUser.mail,
                                        password: _passwordNowConfirmTextCon.text.trim(),
                                        name: _loginUser.name
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
                                            onPressed: () {


                                            }
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
                                              _loginRepository.InfomationUpdateWithFirebaseAuth(
                                                  context: context,
                                                  mail: _loginUser.mail,
                                                  name: _loginUser.name,
                                                  newPassword: _passwordNewTextCon.text.trim(),
                                                  newPasswordConfirm: _passwordNewConfirmTextCon.text.trim()
                                              );
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
                                      hintText: "예) 01012345678",
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
                                    } else if (_phoneEdit.text.trim() == _loginUser.phone) {
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
                                                  _db.collection("company")
                                                      .document(_loginUser.companyCode)
                                                      .collection("user")
                                                      .document(_loginUser.mail).updateData({
                                                    "phone": _phoneEdit.text
                                                  });

                                                  _db.collection("user")
                                                      .document(_loginUser.mail).updateData({
                                                    "phone": _phoneEdit.text
                                                  });
                                                  setState((){
                                                    _loginUser.phone = _phoneEdit.text;
                                                    _loginUserInfoProvider.setLoginUser(_loginUser);
                                                    _phoneEdit.text = "";
                                                  });
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
                      )
                      /*getUpdateMyInfomationCard(
                          context: context,
                          user: _loginUser
                      ),*/
                    ],
                  ),
                ],
              ),
            );

          },
        );
      }
  );

}