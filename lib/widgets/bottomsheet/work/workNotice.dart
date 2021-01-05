import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/alarmModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/noticeModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/search/searchFormat.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

final word = Words();

WorkNoticeBottomSheet(BuildContext context, String noticeDocumentID,
    String noticeTitle, String noticeContent) async {
  bool result = false;

  TextEditingController _noticeTitle = TextEditingController();
  TextEditingController _noticeContent = TextEditingController();

  FocusNode _noticeFocusNode = FocusNode();

  User _loginUser;

  Map<String, String> _noticeUser = Map();
  NoticeModel _notice;

  if (noticeDocumentID != "") {
    _noticeTitle.text = noticeTitle;
    _noticeContent.text = noticeContent;
  }

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
          _loginUser = _loginUserInfoProvider.getLoginUser();
          _noticeUser.addAll({"mail": _loginUser.mail, "name": _loginUser.name});
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                top: 2.0.h,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: 6.0.h,
                        width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                        decoration: BoxDecoration(
                          color: chipColorGreen,
                          borderRadius: BorderRadius.circular(
                              SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          word.notice(),
                          style: defaultMediumStyle,
                        ),
                      ),
                      cardSpace,
                      Expanded(
                        child: TextFormField(
                          style: defaultRegularStyle,
                          controller: _noticeTitle,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: textFormPadding,
                            border: InputBorder.none,
                            hintText: word.pleaseTitle(),
                            hintStyle: hintStyle,
                          ),
                        ),
                      ),
                      cardSpace,
                      CircleAvatar(
                        radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                        backgroundColor: _noticeTitle.text == "" ? disableUploadBtn : blueColor,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.arrow_upward,
                            color: whiteColor,
                            size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                          ),
                          onPressed: _noticeTitle.text == '' ? () {} : () async {
                            if (_noticeTitle.text != '' &&
                                _noticeContent.text != '') {
                              if (noticeDocumentID == "") {
                                _notice = NoticeModel(
                                  noticeTitle: _noticeTitle.text,
                                  noticeContent: _noticeContent.text,
                                  noticeCreateUser: _noticeUser,
                                  noticeCreateDate: Timestamp.now(),
                                  caseSearch: SearchFormat.setSearchParam(
                                      _noticeTitle.text),
                                  //noticeUpdateDate: Timestamp.fromDate(DateTime.now()),
                                );
                                /*Alarm _alarm = Alarm(

                                );*/
                                await FirebaseRepository().addNotice(
                                    companyCode: _loginUser.companyCode,
                                    notice: _notice,
                                );
                                await FirebaseRepository().saveAlarm(

                                );
                              } else {
                                await FirebaseFirestore.instance
                                    .collection('company')
                                    .doc(_loginUser.companyCode)
                                    .collection("notice")
                                    .doc(noticeDocumentID)
                                    .update({
                                  "noticeTitle": _noticeTitle.text,
                                  "noticeContent": _noticeContent.text,
                                  "caseSearch":
                                      SearchFormat.setSearchParam(
                                          _noticeTitle.text),
                                });
                              }
                              result = true;
                              Navigator.of(context).pop(result);
                              return result;;
                            }
                          },
                        )
                      ),
                    ],
                  ),
                emptySpace,
                Container(
                  height: 6.0.h,
                  width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                      ),
                      cardSpace,
                      Text(
                        word.content(),
                        style: defaultRegularStyle,
                      ),
                    ],
                  ),
                ),
                emptySpace,
                TextFormField(
                  controller: _noticeContent,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  maxLengthEnforced: true,
                  style: defaultRegularStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: textFormPadding,
                    border: OutlineInputBorder(),
                    hintText: word.contentCon(),
                    hintStyle: hintStyle,
                  ),
                ),
                emptySpace,
              ]),
            ),
          );
        },
      );
    },
  );
  return result;
}
