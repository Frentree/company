import 'dart:convert';

import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/noticeModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

WorkNoticeBottomSheet(BuildContext context) async {
  TextEditingController _noticeTitle = TextEditingController();
  TextEditingController _noticeContent = TextEditingController();

  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  User _loginUser = User.fromMap(await json.decode(_sharedPreferences.getString("loginUser")), null);

  Map<String,String> _noticeUser = Map();

  _noticeUser.addAll({
    "mail" : _loginUser.mail,
    "name" : _loginUser.name
  });

  CrudRepository _crudRepository = CrudRepository.noticeAttendance(companyCode: _loginUser.companyCode);
  NoticeModel _notice;

  bool _isContent = false;

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
              child: Container(
                padding:
                    EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
                height: 300,
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
                            decoration:
                                InputDecoration(hintText: '제목을 입력하세요'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                        ),
                        CircleAvatar(
                            radius: 20,
                            backgroundColor: _noticeTitle.text == '' ? Colors.black12 : _noticeContent.text == ''
                                ? Colors.black12
                                : Colors.blue,
                            child: IconButton(
                              icon: Icon(Icons.arrow_upward),
                              onPressed: (){
                                _notice = NoticeModel(
                                  noticeTitle: _noticeTitle.text,
                                  noticeCon: _noticeContent.text,
                                  noticeCreateUser: _noticeUser,
                                  noticeCreateDate: DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(DateTime.now()),
                                  noticeUpdateDate: DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(DateTime.now()),
                                );
                                _crudRepository.addNoticeDataToFirebase(
                                  dataModel: _notice
                                );
                              },
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 25),
                  ),
                  Row(
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
                          print("aa");
                          setState(() {
                            _isContent = true;
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Visibility(
                        visible: _isContent == true,
                        child: Container(
                          width: customWidth(
                            context: context,
                            widthSize: 0.7
                          ),
                          height: customHeight(
                            context: context,
                            heightSize: 0.06,
                          ),
                          child: TextFormField(
                            autofocus: true,
                            controller: _noticeContent,
                            style: customStyle(
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "제목을 입력하세요",
                            ),
                          ),
                        ),
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
