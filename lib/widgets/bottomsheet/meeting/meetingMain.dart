import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/screens/work/workDate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:MyCompany/models/meetingModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';

meetingMain({BuildContext context, MeetingModel meetingModel}) async {
  MeetingModel _meetingModel = meetingModel;
  bool result = false;
  bool isChk = false;

  Format _format = Format();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  Map<dynamic, dynamic> attendees;

  User _loginUser;

  DateTime startTime = DateTime.now().minute < 30
      ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          DateTime.now().hour, 00)
      : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          DateTime.now().hour, 30);

  FirebaseRepository _repository = FirebaseRepository();

  if (_meetingModel != null) {
    _titleController.text = _meetingModel.title;
    _contentController.text = _meetingModel.contents;
    attendees = _meetingModel.attendees;
    startTime = _format.timeStampToDateTime(_meetingModel.startTime);
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
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                            "미팅 일정",
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
                            hintText: '미팅 제목을 입력하세요',
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
                                _meetingModel = meetingModel != null ? MeetingModel(
                                  id: meetingModel.id,
                                  createUid: meetingModel.createUid,
                                  name: meetingModel.name,
                                  type: meetingModel.type,
                                  title: _titleController.text,
                                  createDate: meetingModel.createDate,
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
                                  startTime: _format.dateTimeToTimeStamp(startTime),
                                  timeSlot: _format.timeSlot(startTime),
                                  attendees: attendees,
                                ) : MeetingModel(
                                  createUid: _loginUser.mail,
                                  name: _loginUser.name,
                                  type: "미팅",
                                  title: _titleController.text,
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
                                  startTime: _format.dateTimeToTimeStamp(startTime),
                                  timeSlot: _format.timeSlot(startTime),
                                  attendees: attendees
                                );

                                      if (meetingModel == null) {
                                        await _repository.saveMeeting(
                                          meetingModel: _meetingModel,
                                          companyCode: _loginUser.companyCode,
                                        );
                                      } else {
                                        await _repository.updateMeeting(
                                          meetingModel: _meetingModel,
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
                              "일시",
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
                  Row(
                    children: [
                      Container(
                        width: customWidth(context: context, widthSize: 0.25),
                        child: Row(
                          children: [
                            Icon(
                              Icons.supervisor_account,
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              "참가자",
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
                          height: 35,
                          width: customWidth(context: context, widthSize: 0.6),
                          child: attendees == null
                              ? IconButton(
                                  icon: Icon(Icons.person_add_alt_1),
                                  onPressed: () async {
                                    Map<String, String> temp =
                                        await _repository.getColleague(
                                            loginUserMail: _loginUser.mail,
                                            companyCode:
                                                _loginUser.companyCode);
                                    setState(() {
                                      attendees = temp;
                                    });
                                  },
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: attendees.length,
                                  itemBuilder: (context, index) {
                                    String key =
                                        attendees.keys.elementAt(index);
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: textFieldUnderLine),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        width: customWidth(
                                            context: context, widthSize: 0.1),
                                        height: customHeight(
                                            context: context, heightSize: 0.03),
                                        alignment: Alignment.center,
                                        child: Text(
                                          attendees[key],
                                          style: customStyle(
                                              fontSize: 12,
                                              fontWeightName: "Regular",
                                              fontColor: mainColor),
                                        ),
                                      ),
                                    );
                                  })),
                    ],
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
