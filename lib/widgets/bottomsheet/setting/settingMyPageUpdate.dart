import 'dart:io';

import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/widgets/photo/profilePhoto.dart';
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

SettingMyPageUpdate({BuildContext context, double statusBarHeight}) {
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(pageRadiusW.w),
          topLeft: Radius.circular(pageRadiusW.w),
        ),
      ),
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

            return GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height - 10.0.h - statusBarHeight,
                  padding: EdgeInsets.only(
                    left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                    right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                    top: 2.0.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
                      topRight: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
                    ),
                    color: whiteColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 6.0.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 6.0.h,
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                              child: IconButton(
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.keyboard_arrow_left_sharp,
                                  size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                                  color: mainColor,
                                ),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    word.myInfomationUpdate(),
                                    style: defaultMediumStyle,
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                      emptySpace,
                      Expanded(
                        child: StreamBuilder(
                          stream: FirebaseRepository().getCompanyInfos(companyCode: _loginUser.companyCode),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return SizedBox();
                            return Padding(
                              padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w, bottom: 2.0.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          color: whiteColor,
                                          alignment: Alignment.center,
                                          child: profilePhoto(loginUser: _loginUser)
                                        ),
                                        onTap: (){
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SimpleDialog(
                                                title: Text(
                                                  word.select(),
                                                  style: defaultMediumStyle,
                                                ),
                                                children: [
                                                  SimpleDialogOption(
                                                    onPressed: () {
                                                      _uploadImageToStorage(ImageSource.camera);
                                                    },
                                                    child: Text(
                                                      word.camera(),
                                                      style: defaultRegularStyle,
                                                    ),
                                                  ),
                                                  SimpleDialogOption(
                                                    onPressed: () {
                                                      _uploadImageToStorage(ImageSource.gallery);
                                                    },
                                                    child: Text(
                                                      word.gallery(),
                                                      style: defaultRegularStyle,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      cardSpace,
                                      cardSpace,
                                      cardSpace,
                                      Container(
                                        width: SizerUtil.deviceType == DeviceType.Tablet ? 9.75.w : 13.0.w,
                                        child: Text(
                                          _loginUser.name,
                                          style: defaultRegularStyle,
                                        ),
                                      ),
                                    ],
                                  ),

                                  emptySpace,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: SizerUtil.deviceType == DeviceType.Tablet ? 32.0.w : 29.0.w,
                                        child: Text(
                                          word.currentPassword(),
                                          style: defaultRegularStyle,
                                        ),
                                      ),
                                      cardSpace,
                                      Expanded(
                                        child: Container(
                                          child: TextFormField(
                                            controller: _passwordNowConfirmTextCon,
                                            obscureText: true,
                                            style: defaultRegularStyle,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: textFormPadding,
                                              hintText: word.currentPassword() + " " + word.input(),
                                              hintStyle: defaultRegularStyle,
                                              border: InputBorder.none,
                                            ),
                                          )
                                        ),
                                      ),
                                      cardSpace,
                                      GestureDetector(
                                        child: Container(
                                          height: 4.0.h,
                                          decoration: BoxDecoration(
                                            color: blueColor,
                                            borderRadius: BorderRadius.circular(
                                                SizerUtil.deviceType == DeviceType.Tablet ? containerChipRadiusTW.w : containerChipRadiusMW.w
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            word.confirm(),
                                            style: defaultMediumWhiteStyle,
                                          ),
                                        ),
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();
                                          bool isChk = await _loginRepository.InfomationConfirmWithFirebaseAuth(
                                              context: context,
                                              mail: _loginUser.mail,
                                              password: _passwordNowConfirmTextCon.text.trim(),
                                              name: _loginUser.name);
                                          if (isChk) {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog
                                                return AlertDialog(
                                                  title: Text(
                                                    word.authentication() + " " + word.confirm(),
                                                    style: defaultMediumStyle,
                                                  ),
                                                  content: Text(
                                                    word.authenticationSuccessCon(),
                                                    style: defaultRegularStyle,
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text(
                                                        word.confirm(),
                                                        style: buttonBlueStyle,
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
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: isPwdConfirm,
                                    child: Column(
                                      children: [
                                        emptySpace,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: SizerUtil.deviceType == DeviceType.Tablet ? 32.0.w : 29.0.w,
                                              child: Text(
                                                word.newPassword(),
                                                style: defaultRegularStyle,
                                              ),
                                            ),
                                            cardSpace,
                                            Expanded(
                                              child: Container(
                                                  child: TextFormField(
                                                    controller: _passwordNewTextCon,
                                                    obscureText: true,
                                                    style: defaultRegularStyle,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding: textFormPadding,
                                                      hintText: '********',
                                                      hintStyle: defaultRegularStyle,
                                                      border: InputBorder.none,
                                                    ),
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                        emptySpace,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: SizerUtil.deviceType == DeviceType.Tablet ? 32.0.w : 29.0.w,
                                              child: Text(
                                                word.newPasswordConfirm(),
                                                style: defaultRegularStyle,
                                              ),
                                            ),
                                            cardSpace,
                                            Expanded(
                                              child: Container(
                                                  child: TextFormField(
                                                    controller: _passwordNewConfirmTextCon,
                                                    obscureText: true,
                                                    style: defaultRegularStyle,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding: textFormPadding,
                                                      hintText: '********',
                                                      hintStyle: defaultRegularStyle,
                                                      border: InputBorder.none,
                                                    ),
                                                  )
                                              ),
                                            ),
                                            cardSpace,
                                            GestureDetector(
                                              child: Container(
                                                height: 4.0.h,
                                                decoration: BoxDecoration(
                                                  color: blueColor,
                                                  borderRadius: BorderRadius.circular(
                                                      SizerUtil.deviceType == DeviceType.Tablet ? containerChipRadiusTW.w : containerChipRadiusMW.w
                                                  ),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  word.update(),
                                                  style: defaultMediumWhiteStyle,
                                                ),
                                              ),
                                              onTap: () async {
                                               await _loginRepository.InfomationUpdateWithFirebaseAuth(
                                                    context: context,
                                                    mail: _loginUser.mail,
                                                    name: _loginUser.name,
                                                    newPassword: _passwordNewTextCon.text.trim(),
                                                    newPasswordConfirm: _passwordNewConfirmTextCon.text.trim());
                                                _loginUserInfoProvider.logoutUesr();
                                              }
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  emptySpace,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: SizerUtil.deviceType == DeviceType.Tablet ? 32.0.w : 29.0.w,
                                        child: Text(
                                          word.phone(),
                                          style: defaultRegularStyle,
                                        ),
                                      ),
                                      cardSpace,
                                      Expanded(
                                        child: Container(
                                          child: TextFormField(
                                            controller: _phoneEdit,
                                            style: defaultRegularStyle,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: textFormPadding,
                                              hintText: "${word.ex()}) 01012345678",
                                              hintStyle: defaultRegularStyle,
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          height: 4.0.h,
                                          width: SizerUtil.deviceType == DeviceType.Tablet ? 13.5.w : 18.0.w,
                                          decoration: BoxDecoration(
                                            color: blueColor,
                                            borderRadius: BorderRadius.circular(
                                                SizerUtil.deviceType == DeviceType.Tablet ? containerChipRadiusTW.w : containerChipRadiusMW.w
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            word.update(),
                                            style: defaultMediumWhiteStyle,
                                          ),
                                        ),
                                        onTap: (){
                                          RegExp phoneRegExp = RegExp(r'^[0-9]{11}$');
                                          if (_phoneEdit.text.trim() == "") {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog
                                                return AlertDialog(
                                                  title: Text(
                                                    word.phoneChangeFiled(),
                                                    style: defaultMediumStyle,
                                                  ),
                                                  content: Text(
                                                    word.phoneChangeFiledNoneCon(),
                                                    style: defaultRegularStyle,
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text(
                                                        word.confirm(),
                                                        style: buttonBlueStyle,
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
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog
                                                return AlertDialog(
                                                  title: Text(
                                                    word.phoneChangeFiled(),
                                                    style: defaultMediumStyle,
                                                  ),
                                                  content: Text(
                                                    word.phoneChangeFiledSameCon(),
                                                    style: defaultRegularStyle,
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text(
                                                        word.confirm(),
                                                        style: buttonBlueStyle,
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
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog
                                                return AlertDialog(
                                                  title: Text(
                                                    word.phoneChangeFiled(),
                                                    style: defaultMediumStyle,
                                                  ),
                                                  content: Text(
                                                    word.phoneChangeFiledTyepCon(),
                                                    style: defaultRegularStyle,
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text(
                                                        word.confirm(),
                                                        style: buttonBlueStyle,
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
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog
                                                return AlertDialog(
                                                  title: Text(
                                                    word.phoneChange(),
                                                    style: defaultMediumStyle,
                                                  ),
                                                  content: Text(
                                                    "${_phoneEdit.text}\n${word.phoneChangeCon()}",
                                                    style: defaultRegularStyle,
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text(
                                                        word.yes(),
                                                        style: buttonBlueStyle,
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
                                                        style: buttonBlueStyle,
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
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                ]),
                ),
              ),
            );
          },
        );
      });
}

SettingCompanyPageUpdate({BuildContext context, String imageUrl, double statusBarHeight}) {
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(pageRadiusW.w),
          topLeft: Radius.circular(pageRadiusW.w),
        ),
      ),
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

            return GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height - 10.0.h - statusBarHeight,
                  padding: EdgeInsets.only(
                    left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                    right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                    top: 2.0.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
                      topRight: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
                    ),
                    color: whiteColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 6.0.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 6.0.h,
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                              child: IconButton(
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.keyboard_arrow_left_sharp,
                                  size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                                  color: mainColor,
                                ),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    word.companyInfomation() + " " + word.update(),
                                    style: defaultMediumStyle,
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                      emptySpace,
                      Expanded(
                        child: StreamBuilder(
                          stream: FirebaseRepository().getCompanyInfos(companyCode: _loginUser.companyCode),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return SizedBox();
                            return Padding(
                              padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w, bottom: 2.0.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                        color: whiteColor,
                                        width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                                        height: SizerUtil.deviceType == DeviceType.Tablet ? 11.25.w : 15.0.w,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Image.network(_profileImageURL),
                                        )
                                    ),
                                    onTap: (){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SimpleDialog(
                                              title: Text(
                                                word.select(),
                                                style: defaultMediumStyle,
                                              ),
                                              children: [
                                                SimpleDialogOption(
                                                  onPressed: () {
                                                    _uploadImageToStorage(ImageSource.camera);
                                                  },
                                                  child: Text(
                                                    word.camera(),
                                                    style: defaultRegularStyle,
                                                  ),
                                                ),
                                                SimpleDialogOption(
                                                  onPressed: () {
                                                    _uploadImageToStorage(ImageSource.gallery);
                                                  },
                                                  child: Text(
                                                    word.gallery(),
                                                    style: defaultRegularStyle,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                      );
                                    },
                                  ),
                                  emptySpace,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                                        child: Text(
                                          word.companyName(),
                                          style: defaultRegularStyle,
                                        ),
                                      ),
                                      Container(
                                        width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                                        child: TextFormField(
                                          controller: _companyNameTextCon,
                                          style: defaultRegularStyle,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: textFormPadding,
                                            hintText: snapshot.data["companyName"],
                                            hintStyle: defaultRegularStyle,
                                            border: InputBorder.none,
                                          ),
                                        )
                                      ),
                                    ],
                                  ),
                                  emptySpace,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                                        child: Text(
                                          word.address(),
                                          style: defaultRegularStyle,
                                        ),
                                      ),
                                      Container(
                                          width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                                          child: TextFormField(
                                            controller: _companyAddrTextCon,
                                            style: defaultRegularStyle,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: textFormPadding,
                                              hintText: snapshot.data["companyAddr"],
                                              hintStyle: defaultRegularStyle,
                                              border: InputBorder.none,
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                  emptySpace,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                                        child: Text(
                                          word.phone(),
                                          style: defaultRegularStyle,
                                        ),
                                      ),
                                      Container(
                                          width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                                          child: TextFormField(
                                            controller: _companyPhoneTextCon,
                                            style: defaultRegularStyle,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: textFormPadding,
                                              hintText: snapshot.data["companyPhone"],
                                              hintStyle: defaultRegularStyle,
                                              border: InputBorder.none,
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                  emptySpace,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                                        child: Text(
                                          word.webAddress(),
                                          style: defaultRegularStyle,
                                        ),
                                      ),
                                      Container(
                                          width: SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 35.0.w,
                                          child: TextFormField(
                                            controller: _companyWebTextCon,
                                            style: defaultRegularStyle,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: textFormPadding,
                                              hintText: snapshot.data["companyWeb"] != "" ? snapshot.data["companyWeb"] :  "${word.ex()}) www.company.com",
                                              hintStyle: defaultRegularStyle,
                                              border: InputBorder.none,
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                  emptySpace,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          height: 4.0.h,
                                          width: SizerUtil.deviceType == DeviceType.Tablet ? 13.5.w : 18.0.w,
                                          decoration: BoxDecoration(
                                            color: blueColor,
                                            borderRadius: BorderRadius.circular(
                                                SizerUtil.deviceType == DeviceType.Tablet ? containerChipRadiusTW.w : containerChipRadiusMW.w
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            word.update(),
                                            style: defaultMediumWhiteStyle,
                                          ),
                                        ),
                                        onTap: (){
                                          FirebaseRepository().updateCompany(
                                            companyCode: _loginUser.companyCode,
                                            companyName: _companyNameTextCon.text.trim() != "" ? _companyNameTextCon.text : snapshot.data["companyName"],
                                            companyAddr: _companyAddrTextCon.text.trim() != "" ? _companyAddrTextCon.text : snapshot.data["companyAddr"],
                                            companyPhone: _companyPhoneTextCon.text.trim() != "" ? _companyPhoneTextCon.text : snapshot.data["companyPhone"],
                                            companyWeb: _companyWebTextCon.text.trim() != "" ? _companyWebTextCon.text : snapshot.data["companyWeb"],
                                            url: _profileImageURL.trim() != "" ? _profileImageURL : snapshot.data["companyPhoto"],
                                          );
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
   );
}
