import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/noticeModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

WorkNoticeBottomSheet(BuildContext context) async {
  TextEditingController _noticeTitle = TextEditingController();
  TextEditingController _noticeContent = TextEditingController();

  FocusNode noticeNode = FocusNode();

  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  User _loginUser = User.fromMap(
      await json.decode(_sharedPreferences.getString("loginUser")), null);

  Map<String, String> _noticeUser = Map();

  _noticeUser.addAll({"mail": _loginUser.mail, "name": _loginUser.name});

  CrudRepository _crudRepository =
      CrudRepository.noticeAttendance(companyCode: _loginUser.companyCode);
  NoticeModel _notice;

  await showModalBottomSheet(
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: 30,
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(children: <Widget>[
                  IntrinsicHeight(
                    child: Row(
                      children: <Widget>[
                        Chip(
                          backgroundColor: chipColorGreen,
                          label: Text(
                            "공지사항",
                            style: customStyle(
                              fontSize: 14,
                              fontColor: mainColor,
                              fontWeightName: 'Regular',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                        ),
                        Container(
                          width: 200,
                          child: TextFormField(
                            autofocus: true,
                            controller: _noticeTitle,
                            onFieldSubmitted: (value) =>
                                noticeNode.requestFocus(),
                            decoration: InputDecoration(hintText: '제목을 입력하세요'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                        ),
                        CircleAvatar(
                            radius: 20,
                            backgroundColor: _noticeTitle.text == ''
                                ? Colors.black12
                                : _noticeContent.text == ''
                                    ? Colors.black12
                                    : Colors.blue,
                            child: IconButton(
                              icon: Icon(Icons.arrow_upward),
                              onPressed: () {
                                if (_noticeTitle.text != '' &&
                                    _noticeContent.text != '') {
                                  _notice = NoticeModel(
                                    noticeTitle: _noticeTitle.text,
                                    noticeContent: _noticeContent.text,
                                    noticeCreateUser: _noticeUser,
                                    noticeCreateDate:
                                        Timestamp.fromDate(DateTime.now()),
                                    //noticeUpdateDate: Timestamp.fromDate(DateTime.now()),
                                  );
                                  _crudRepository.addNoticeDataToFirebase(
                                      dataModel: _notice);
                                  Navigator.pop(context);
                                } else if (_noticeTitle.text == '') {
                                  // 제목 미입력

                                } else {
                                  // 내용 미입력

                                }
                              },
                            )
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 25),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      InkWell(
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.chat_bubble_outline,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                              ),
                              Text(
                                "내용",
                                style: customStyle(
                                  fontSize: 14,
                                  fontColor: mainColor,
                                  fontWeightName: 'Regular',
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                        },
                      ),
                      SizedBox(
                        height: customHeight(
                            context: context,
                            heightSize: 0.01
                        ),
                      ),
                      TextFormField(
                        focusNode: noticeNode,
                        controller: _noticeContent,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        maxLengthEnforced: true,
                        style: customStyle(
                          fontSize: 13,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "내용을 입력하세요",
                        ),
                      ),
                      SizedBox(
                        height:
                            customHeight(context: context, heightSize: 0.02),
                      ),
                    ],
                  )
                ]),
              ),
            );
          },
        );
      });
}
