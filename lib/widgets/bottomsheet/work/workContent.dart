import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/widgets/bottomsheet/work/workDate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

workContent(BuildContext context, int type) {
  TextEditingController _titleController = TextEditingController();

  User _loginUser;

  String date = "날짜";

  // 내근 or 외근 일 경우 실행
  if (type == 1 || type == 2) {
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        context: context,
        builder: (BuildContext context) {
          LoginUserInfoProvider _loginUserInfoProvider =
              Provider.of<LoginUserInfoProvider>(context);
          _loginUser = _loginUserInfoProvider.getLoginUser();

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Chip(
                              backgroundColor: chipColorBlue,
                              label: Text(
                                type == 1 ? "내근 일정" : "외근 일정",
                                style: customStyle(
                                  fontSize: 14,
                                  fontColor: mainColor,
                                  fontWeightName: 'Regular',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Expanded(
                            flex: 5,
                            child: TextField(
                              controller: _titleController,
                              autofocus: true,
                              decoration:
                                  InputDecoration(hintText: '제목을 입력하세요'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Expanded(
                            flex: 1,
                            child: CircleAvatar(
                                radius: 20,
                                backgroundColor: _titleController.text == ''
                                    ? Colors.black12
                                    : _titleController.text == ''
                                        ? Colors.black12
                                        : Colors.blue,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_upward),
                                  onPressed: () {
                                    if (_titleController.text != '' &&
                                        _titleController.text != '') {
                                    } else if (_titleController.text == '') {
                                      // 제목 미입력

                                    } else {
                                      // 내용 미입력

                                    }
                                  },
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
