import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/widgets/bottomsheet/dateSetBottomSheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

ExpenseMain(BuildContext context) {
  TextEditingController _titleController = TextEditingController();

  User _loginUser;
  bool _detailClicked = false;

  String date = "날짜";
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
                                "경비 청구",
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
                                    if (_titleController.text != '') {
                                    } else if (_titleController.text == '') {
                                      // 제목 미입력

                                    } else {
                                      // 내용 미입력

                                    }
                                  },
                                )),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 25),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                                child: Row(
                              children: [
                                Icon(Icons.calendar_today),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Text(
                                  "지출일자",
                                  style: customStyle(
                                      fontSize: 14,
                                      fontWeightName: "regular",
                                      fontColor: mainColor),
                                )
                              ],
                            )),
                            onTap: () async {
                              String setDate =
                                  await dateSetBottomSheet(context);
                              if (setDate != '') {
                                setState(() {
                                  date = setDate;
                                });
                              }
                            },
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 25),
                      ),
                      Row(
                        children: [
                          Icon(Icons.art_track),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Text(
                            "지출 금액",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: "regular",
                                fontColor: mainColor),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 25),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 22.0,
                            width: 22.0,
                            child: IconButton(
                              padding: EdgeInsets.all(0.0),
                              icon: _detailClicked == true
                                  ? Icon(Icons.keyboard_arrow_up)
                                  : Icon(Icons.keyboard_arrow_down),
                              onPressed: () {
                                _detailClicked = !_detailClicked;
                                debugPrint(_detailClicked.toString());
                                setState(() {
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                          ),
                          Text(
                            "세부 내역(옵션)",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: "regular",
                                fontColor: mainColor),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 25),
                      ),
                    ]),
              ),
            );
          },
        );
      });
}
