import 'dart:io';

import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/login/loginRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';



final word = Words();

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
            Reference storageReference = _firebaseStorage.ref().child("profile/${_loginUser.mail}");

            void _uploadImageToStorage(ImageSource source) async {
              File image = await ImagePicker.pickImage(source: source);

              if (image == null) return;
              setState(() {
                _image = image;
              });

              // 파일 업로드
              UploadTask storageUploadTask = storageReference.putFile(image);

              // 파일 업로드 완료까지 대기
              /// if 문으로 변경
              //await storageUploadTask.onComplete;

              // 업로드한 사진의 URL 획득
              String downloadURL = await storageReference.getDownloadURL();

              FirebaseRepository().updatePhotoProfile(companyCode: _loginUser.companyCode, mail: _loginUser.mail, url: downloadURL);

              // 업로드된 사진의 URL을 페이지에 반영
              setState(() {
                _loginUser.profilePhoto = downloadURL;
                _loginUserInfoProvider.setLoginUser(_loginUser);
                _loginUser = _loginUserInfoProvider.getLoginUser();
              });
            }

            return Container(
              height: 90.0.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(pageRadiusW.w),
                  topRight: Radius.circular(pageRadiusW.w),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 10.0.w,
                    child: Center(
                      child: IconButton(
                          color: blackColor,
                          icon: Icon(Icons.close,size: iconSizeW.w,),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                  ExpansionTile(
                    backgroundColor: whiteColor,
                    initiallyExpanded: true,
                    leading: Icon(Icons.person_outline, size: iconSizeW.w,),
                    title: Text(word.myInfomationUpdate()),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w, bottom: 2.0.h),
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
                                        width: 10.0.w,
                                        height: 8.0.h,
                                        child: GestureDetector(
                                          child: FutureBuilder(
                                            future: Firestore.instance
                                                .collection("company")
                                                .document(_loginUser.companyCode)
                                                .collection("user")
                                                .document(_loginUser.mail)
                                                .get(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Icon(Icons.person_outline);
                                              }

                                              return Image.network(snapshot.data['profilePhoto']);
                                            },
                                          ),
                                          onTap: () {},
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 3.0.w),
                                        child: Container(
                                          height: 5.0.h,
                                          child: FloatingActionButton(
                                            backgroundColor: Colors.orange,
                                            child: Icon(Icons.attach_file, size: 6.0.w,),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return SimpleDialog(
                                                      title: Text(
                                                        word.select(),
                                                        style: customStyle(fontColor: mainColor, fontSize: 13.0.sp),
                                                      ),
                                                      children: [
                                                        SimpleDialogOption(
                                                          onPressed: () {
                                                            _uploadImageToStorage(ImageSource.camera);
                                                          },
                                                          child: Text(
                                                            word.camera(),
                                                            style: customStyle(fontColor: mainColor, fontSize: 13.0.sp),
                                                          ),
                                                        ),
                                                        SimpleDialogOption(
                                                          onPressed: () {
                                                            _uploadImageToStorage(ImageSource.gallery);
                                                          },
                                                          child: Text(
                                                            word.gallery(),
                                                            style: customStyle(fontColor: mainColor, fontSize: 13.0.sp),
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
                                      fontSize: 15.0.sp,
                                      fontColor: mainColor,
                                      fontWeightName: 'Medium',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.0.h,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    word.currentPassword(),
                                    style: customStyle(
                                      fontSize: 11.0.sp,
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
                                      hintText: word.currentPassword() + " " + word.input(),
                                    ),
                                    style: customStyle(
                                      fontSize: 11.0.sp,
                                      fontColor: mainColor,
                                      fontWeightName: 'Medium',
                                    ),
                                  ),
                                ),
                                ActionChip(
                                  padding: EdgeInsets.zero,
                                  backgroundColor: blueColor,
                                  label: Text(
                                    word.confirm(),
                                    style: customStyle(
                                      fontSize: 11.0.sp,
                                      fontColor: whiteColor,
                                      fontWeightName: 'Medium',
                                    ),
                                  ),
                                  onPressed: () async {
                                    bool isChk = await _loginRepository.InfomationConfirmWithFirebaseAuth(
                                        context: context,
                                        mail: _loginUser.mail,
                                        password: _passwordNowConfirmTextCon.text.trim(),
                                        name: _loginUser.name);
                                    if (isChk) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          // return object of type Dialog
                                          return AlertDialog(
                                            title: Text(
                                              word.authentication() + " " + word.confirm(),
                                              style: customStyle(fontColor: blueColor, fontSize: 13.0.sp, fontWeightName: 'Bold'),
                                            ),
                                            content: Text(
                                              word.authenticationSuccessCon(),
                                              style: customStyle(fontColor: mainColor, fontSize: 13.0.sp, fontWeightName: 'Regular'),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  word.confirm(),
                                                  style: customStyle(fontColor: blueColor, fontSize: 15.0.sp, fontWeightName: 'Bold'),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    isPwdConfirm = isChk;
                                                    _passwordNowConfirmTextCon.selection;
                                                  });
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
                                              word.authentication() + " " + word.failed(),
                                              style: customStyle(fontColor: redColor, fontSize: 13.0.sp, fontWeightName: 'Bold'),
                                            ),
                                            content: Text(
                                              word.authenticationFailCon(),
                                              style: customStyle(fontColor: mainColor, fontSize: 13.0.sp, fontWeightName: 'Regular'),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  word.confirm(),
                                                  style: customStyle(fontColor: blueColor, fontSize: 15.0.sp, fontWeightName: 'Bold'),
                                                ),
                                                onPressed: () {
                                                  isPwdConfirm = isChk;
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
                            Visibility(
                                visible: isPwdConfirm,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            word.newPassword(),
                                            style: customStyle(
                                              fontSize: 11.0.sp,
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
                                              fontSize: 11.0.sp,
                                              fontColor: mainColor,
                                              fontWeightName: 'Medium',
                                            ),
                                          ),
                                        ),
                                        Chip(
                                          backgroundColor: whiteColor,
                                          label: Text("확인"),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            word.newPasswordConfirm(),
                                            style: customStyle(
                                              fontSize: 11.0.sp,
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
                                              fontSize: 11.0.sp,
                                              fontColor: mainColor,
                                              fontWeightName: 'Medium',
                                            ),
                                          ),
                                        ),
                                        ActionChip(
                                            backgroundColor: blueColor,
                                            label: Text(
                                              word.update(),
                                              style: customStyle(
                                                fontSize: 11.0.sp,
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
                                                  newPasswordConfirm: _passwordNewConfirmTextCon.text.trim());
                                              _loginUserInfoProvider.logoutUesr();
                                            }),
                                      ],
                                    ),
                                  ],
                                )),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    word.phone(),
                                    style: customStyle(
                                      fontSize: 11.0.sp,
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
                                      hintText: "${word.ex()}) 01012345678",
                                    ),
                                    style: customStyle(
                                      fontSize: 11.0.sp,
                                      fontColor: mainColor,
                                      fontWeightName: 'Medium',
                                    ),
                                  ),
                                ),
                                ActionChip(
                                  backgroundColor: blueColor,
                                  label: Text(
                                    word.update(),
                                    style: customStyle(
                                      fontSize: 11.0.sp,
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
                                              word.phoneChangeFiled(),
                                              style: customStyle(fontColor: redColor, fontSize: 13.0.sp, fontWeightName: 'Bold'),
                                            ),
                                            content: Text(
                                              word.phoneChangeFiledNoneCon(),
                                              style: customStyle(fontColor: mainColor, fontSize: 13.0.sp, fontWeightName: 'Regular'),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  word.confirm(),
                                                  style: customStyle(fontColor: blueColor, fontSize: 15.0.sp, fontWeightName: 'Bold'),
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
                                              word.phoneChangeFiled(),
                                              style: customStyle(fontColor: redColor, fontSize: 13.0.sp, fontWeightName: 'Bold'),
                                            ),
                                            content: Text(
                                              word.phoneChangeFiledSameCon(),
                                              style: customStyle(fontColor: mainColor, fontSize: 13.0.sp, fontWeightName: 'Regular'),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  word.confirm(),
                                                  style: customStyle(fontColor: blueColor, fontSize: 15.0.sp, fontWeightName: 'Bold'),
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
                                              word.phoneChangeFiled(),
                                              style: customStyle(fontColor: redColor, fontSize: 13.0.sp, fontWeightName: 'Bold'),
                                            ),
                                            content: Text(
                                              word.phoneChangeFiledTyepCon(),
                                              style: customStyle(fontColor: mainColor, fontSize: 13.0.sp, fontWeightName: 'Regular'),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  word.confirm(),
                                                  style: customStyle(fontColor: blueColor, fontSize: 15.0.sp, fontWeightName: 'Bold'),
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
                                              word.phoneChange(),
                                              style: customStyle(fontColor: redColor, fontSize: 13.0.sp, fontWeightName: 'Bold'),
                                            ),
                                            content: Text(
                                              "${_phoneEdit.text}\n${word.phoneChangeCon()}",
                                              style: customStyle(fontColor: mainColor, fontSize: 13.0.sp, fontWeightName: 'Regular'),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  word.yes(),
                                                  style: customStyle(fontColor: blueColor, fontSize: 15.0.sp, fontWeightName: 'Bold'),
                                                ),
                                                onPressed: () {
                                                  FirebaseRepository().updatePhone(
                                                      companyCode: _loginUser.companyCode, mail: _loginUser.mail, phone: _phoneEdit.text);
                                                  setState(() {
                                                    _loginUser.phone = _phoneEdit.text;
                                                    _loginUserInfoProvider.setLoginUser(_loginUser);
                                                    _phoneEdit.text = "";
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(
                                                  word.no(),
                                                  style: customStyle(fontColor: blueColor, fontSize: 15.0.sp, fontWeightName: 'Bold'),
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
                              height: 1.0.h
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
      });
}

SettingCompanyPageUpdate(BuildContext context, String imageUrl) {
  User _loginUser;
  LoginRepository _loginRepository = LoginRepository();
  File _image;
  String _profileImageURL = imageUrl;

  TextEditingController _companyNameTextCon = TextEditingController();
  TextEditingController _companyNoTextCon = TextEditingController();
  TextEditingController _companyAddrTextCon = TextEditingController();
  TextEditingController _companyPhoneTextCon = TextEditingController();
  TextEditingController _companyWebTextCon = TextEditingController();

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
            Reference storageReference = _firebaseStorage.ref().child("company/${_loginUser.companyCode}");

            void _uploadImageToStorage(ImageSource source) async {
              File image = await ImagePicker.pickImage(source: source);

              if (image == null) return;
              setState(() {
                _image = image;
              });

              // 파일 업로드
              UploadTask storageUploadTask = storageReference.putFile(image);

              String imageUrl = await storageReference.getDownloadURL();

              setState((){
                // 업로드한 사진의 URL 획득
                _profileImageURL = imageUrl;
              });
            }

            return Container(
              height: 90.0.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(pageRadiusW.w),
                  topRight: Radius.circular(pageRadiusW.w),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      color: blackColor,
                      icon: Icon(Icons.close,size: iconSizeW.w,),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        leading: Icon(Icons.person_outline, size: iconSizeW.w,),
                        title: Text(word.companyInfomation() + " " + word.update()),
                        children: [
                          StreamBuilder(
                            stream: FirebaseRepository().getCompanyInfos(companyCode: _loginUser.companyCode),
                            builder: (context, snapshot) {

                              if (!snapshot.hasData) return SizedBox();
                              return Padding(
                                padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w, bottom: 2.0.h),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              Container(
                                                color: mainColor,
                                                width: 20.0.w,
                                                child: Center(
                                                  child: Container(
                                                    color: whiteColor,
                                                    alignment: Alignment.center,
                                                    width: 20.0.w,
                                                    child: Image.network(_profileImageURL),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 60.0.w,
                                                alignment: Alignment.topRight,
                                                child: SizedBox(
                                                  width: 10.0.w,
                                                  height: 6.0.h,
                                                  child: FloatingActionButton(
                                                    backgroundColor: Colors.orange,
                                                    child: Icon(Icons.attach_file),
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return SimpleDialog(
                                                              title: Text(
                                                                word.select(),
                                                                style: customStyle(fontColor: mainColor, fontSize: 14.0.sp),
                                                              ),
                                                              children: [
                                                                SimpleDialogOption(
                                                                  onPressed: () {
                                                                    _uploadImageToStorage(ImageSource.camera);
                                                                  },
                                                                  child: Text(
                                                                    word.camera(),
                                                                    style: customStyle(fontColor: mainColor, fontSize: 13.0.sp),
                                                                  ),
                                                                ),
                                                                SimpleDialogOption(
                                                                  onPressed: () {
                                                                    _uploadImageToStorage(ImageSource.gallery);
                                                                  },
                                                                  child: Text(
                                                                    word.gallery(),
                                                                    style: customStyle(fontColor: mainColor, fontSize: 13.0.sp),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        ActionChip(
                                          backgroundColor: whiteColor,
                                          label: Text(
                                            word.update(),
                                            style: customStyle(
                                              fontSize: 14.0.sp,
                                              fontColor: whiteColor,
                                              fontWeightName: 'Medium',
                                            ),
                                          ),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1.0.h
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            word.companyName(),
                                            style: customStyle(
                                              fontSize: 14.0.sp,
                                              fontColor: mainColor,
                                              fontWeightName: 'Medium',
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: _companyNameTextCon,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: snapshot.data["companyName"].toString(),
                                            ),
                                            style: customStyle(
                                              fontSize: 14.0.sp,
                                              fontColor: mainColor,
                                              fontWeightName: 'Medium',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            word.businessNumber(),
                                            style: customStyle(
                                              fontSize: 14.0.sp,
                                              fontColor: mainColor,
                                              fontWeightName: 'Medium',
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: _companyNoTextCon,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: snapshot.data["companyNo"] != "" ? snapshot.data["companyNo"] : word.businessNumberCon(),
                                            ),
                                            style: customStyle(
                                              fontSize: 14.0.sp,
                                              fontColor: mainColor,
                                              fontWeightName: 'Medium',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            word.address(),
                                            style: customStyle(
                                              fontSize: 14.0.sp,
                                              fontColor: mainColor,
                                              fontWeightName: 'Medium',
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: _companyAddrTextCon,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: snapshot.data["companyAddr"],
                                            ),
                                            style: customStyle(
                                              fontSize: 14.0.sp,
                                              fontColor: mainColor,
                                              fontWeightName: 'Medium',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            word.phone(),
                                            style: customStyle(
                                              fontSize: 14.0.sp,
                                              fontColor: mainColor,
                                              fontWeightName: 'Medium',
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: _companyPhoneTextCon,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: snapshot.data["companyPhone"],
                                            ),
                                            style: customStyle(
                                              fontSize: 14.0.sp,
                                              fontColor: mainColor,
                                              fontWeightName: 'Medium',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            word.webAddress(),
                                            style: customStyle(
                                              fontSize: 14.0.sp,
                                              fontColor: mainColor,
                                              fontWeightName: 'Medium',
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: _companyWebTextCon,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: snapshot.data["companyWeb"] != "" ? snapshot.data["companyWeb"] :  "${word.ex()}) www.company.com",
                                            ),
                                            style: customStyle(
                                              fontSize: 14.0.sp,
                                              fontColor: mainColor,
                                              fontWeightName: 'Medium',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: customHeight(context: context, heightSize: 0.01),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        ActionChip(
                                            backgroundColor: blueColor,
                                            label: Text(
                                              word.update(),
                                              style: customStyle(
                                                fontSize: 14.0.sp,
                                                fontColor: whiteColor,
                                                fontWeightName: 'Medium',
                                              ),
                                            ),
                                            onPressed: () {
                                              FirebaseRepository().updateCompany(
                                                companyCode: _loginUser.companyCode,
                                                companyName: _companyNameTextCon.text.trim() != "" ? _companyNameTextCon.text : snapshot.data["companyName"],
                                                companyNo: _companyNoTextCon.text.trim() != "" ? _companyNoTextCon.text : snapshot.data["companyNo"],
                                                companyAddr: _companyAddrTextCon.text.trim() != "" ? _companyAddrTextCon.text : snapshot.data["companyAddr"],
                                                companyPhone: _companyPhoneTextCon.text.trim() != "" ? _companyPhoneTextCon.text : snapshot.data["companyPhone"],
                                                companyWeb: _companyWebTextCon.text.trim() != "" ? _companyWebTextCon.text : snapshot.data["companyWeb"],
                                                url: _profileImageURL.trim() != "" ? _profileImageURL : snapshot.data["companyPhoto"],
                                              );
                                              Navigator.pop(context);
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                          /*getUpdateMyInfomationCard(
                              context: context,
                              user: _loginUser
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      });
}
