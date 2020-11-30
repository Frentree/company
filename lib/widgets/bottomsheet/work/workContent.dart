import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/screens/work/workDate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/models/workModel.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/utils/date/dateFormat.dart';

workContent({BuildContext context, int type, WorkModel workModel}) async {
  WorkModel _workModel = workModel;
  bool result = false;
  bool isChk = false;

  Format _format = Format();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  User _loginUser;

  DateTime startTime = DateTime.now().minute < 30 ? DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,00) : DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,30);

  FirebaseRepository _repository = FirebaseRepository();

  if (_workModel != null) {
    _titleController.text = _workModel.title;
    _locationController.text = _workModel.location;
    _contentController.text = _workModel.contents;
    startTime = _format.timeStampToDateTime(_workModel.startTime);
  }

  await showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      LoginUserInfoProvider _loginUserInfoProvider =
      Provider.of<LoginUserInfoProvider>(context);
      _loginUser = _loginUserInfoProvider.getLoginUser();

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: customWidth(context: context, widthSize: 0.25),
                        child: Chip(
                          backgroundColor: chipColorBlue,
                          label: Text(
                            type == 1 ? "내근 일정" : "외근 일정",
                            style: customStyle(
                              fontSize: 14,
                              fontColor: mainColor,
                              fontWeightName: "Regular",
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                      ),
                      Container(
                        width: customWidth(context: context, widthSize: 0.5),
                        child: TextField(
                          controller: _titleController,
                          style: customStyle(
                            fontSize: 14,
                            fontColor: mainColor,
                            fontWeightName: "Regular",
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '제목을 입력하세요',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                      ),
                      Container(
                        width: customWidth(context: context, widthSize: 0.1),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: _titleController.text == ""
                              ? disableUploadBtn
                              : blueColor,
                          child: IconButton(
                              icon: Icon(
                                Icons.arrow_upward,
                                color: whiteColor,
                              ),
                              onPressed: _titleController.text == ""
                                  ? () {
                                print("업로드 안됨");
                              }
                                  : () async {
                                _workModel = workModel != null ? WorkModel(
                                  id: workModel.id,
                                  createUid: workModel.createUid,
                                  name: workModel.name,
                                  type: workModel.type,
                                  title: _titleController.text,
                                  contents: _contentController.text,
                                  location: _locationController.text,
                                  createDate: workModel.createDate,
                                  lastModDate:
                                  _format.dateTimeToTimeStamp(
                                      DateTime.now()),
                                  startDate: _format.dateTimeToTimeStamp(
                                      DateTime(
                                          startTime.year,
                                          startTime.month,
                                          startTime.day,
                                          21,
                                          00,)),
                                  startTime: _format
                                      .dateTimeToTimeStamp(startTime),
                                  timeSlot: _format.timeSlot(startTime),
                                  level: 0,
                                ) : WorkModel(
                                  createUid: _loginUser.mail,
                                  name: _loginUser.name,
                                  type: type == 1 ? "내근" : "외근",
                                  title: _titleController.text,
                                  contents: _contentController.text,
                                  location: _locationController.text,
                                  createDate: _format.dateTimeToTimeStamp(
                                      DateTime.now()),
                                  lastModDate:
                                  _format.dateTimeToTimeStamp(
                                      DateTime.now()),
                                  startDate: _format.dateTimeToTimeStamp(
                                      DateTime(
                                        startTime.year,
                                        startTime.month,
                                        startTime.day,
                                        21,
                                        00,)),
                                  startTime: _format
                                      .dateTimeToTimeStamp(startTime),
                                  timeSlot: _format.timeSlot(startTime),
                                  level: 0,
                                );

                                if (workModel == null) {
                                  await _repository.saveWork(
                                    workModel: _workModel,
                                    companyCode: _loginUser.companyCode,
                                  );
                                }

                                else {
                                  await _repository.updateWork(
                                    workModel: _workModel,
                                    companyCode: _loginUser.companyCode,
                                  );
                                }
                                result = true;
                                Navigator.of(context).pop(result);
                                return result;
                              }),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    children: [
                      Container(
                        width: customWidth(context: context, widthSize: 0.25),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              type == 1 ? "내근 일시" : "외근 일시",
                              style: customStyle(
                                fontSize: 14,
                                fontColor: mainColor,
                                fontWeightName: 'Regular',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: customWidth(context: context, widthSize: 0.6),
                        child: InkWell(
                          child: Text(
                            _format.dateToString(startTime),
                            style: customStyle(
                              fontSize: 13,
                              fontColor: mainColor,
                              fontWeightName: 'Bold',
                            ),
                          ),
                          onTap: () async {
                            DateTime _dateTime = await workDatePage(
                              context: context,
                              startTime: startTime
                            );
                            setState(() {
                              startTime = _dateTime;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Visibility(
                    visible: (type == 2),
                    child: Row(
                      children: [
                        Container(
                          width: customWidth(context: context, widthSize: 0.25),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                              ),
                              Padding(padding: EdgeInsets.only(left: 10)),
                              Text(
                                "외근 장소",
                                style: customStyle(
                                  fontSize: 14,
                                  fontColor: mainColor,
                                  fontWeightName: 'Regular',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            width:
                            customWidth(context: context, widthSize: 0.6),
                            child: TextField(
                              controller: _locationController,
                              style: customStyle(
                                fontSize: 14,
                                fontColor: mainColor,
                                fontWeightName: 'Regular',
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '외근지를 입력하세요',
                              ),
                            )),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: (type == 2),
                    child: Padding(padding: EdgeInsets.only(top: 10)),
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 25,
                          height: 30,
                          child: Checkbox(
                            value: isChk,
                            onChanged: (value) {
                              setState(() {
                                isChk = value;
                              });
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          "추가 항목 입력",
                          style: customStyle(
                            fontSize: 14,
                            fontColor: mainColor,
                            fontWeightName: 'Regular',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isChk,
                    child: Row(
                      children: [
                        Container(
                          width: customWidth(context: context, widthSize: 0.25),
                          child: Row(
                            children: [
                              Icon(
                                Icons.list,
                              ),
                              Padding(padding: EdgeInsets.only(left: 10)),
                              Text(
                                "상세 내용",
                                style: customStyle(
                                  fontSize: 14,
                                  fontColor: mainColor,
                                  fontWeightName: 'Regular',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: customWidth(context: context, widthSize: 0.6),
                          child: TextField(
                            maxLines: null,
                            controller: _contentController,
                            keyboardType: TextInputType.multiline,
                            style: customStyle(
                              fontSize: 13,
                              fontColor: mainColor,
                              fontWeightName: 'Bold',
                            ),
                            decoration: InputDecoration(
                              hintText: "상세 내용을 입력하세요",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 20)),
                ],
              ),
            ),
          );
        },
      );
    },
  );
  return result;
}
