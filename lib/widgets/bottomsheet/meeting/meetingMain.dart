import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/screens/work/workDate.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:MyCompany/models/meetingModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';

import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

final word = Words();
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
        topRight: Radius.circular(3.0.w),
        topLeft: Radius.circular(3.0.w),
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
                  top: 2.0.h,
                  left: 5.0.w,
                  right: 5.0.w,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30.0.w,
                        child: Chip(
                          padding: EdgeInsets.zero,
                          backgroundColor: chipColorBlue,
                          label: Text(
                            word.meetingSchedule(),
                            style: customStyle(
                              fontSize: 11.0.sp,
                              fontColor: mainColor,
                              fontWeightName: "Regular",
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 3.0.w),
                      ),
                      Container(
                        width: 40.0.w,
                        child: TextField(
                          controller: _titleController,
                          style: customStyle(
                            fontSize: 13.0.sp,
                            fontColor: mainColor,
                            fontWeightName: "Regular",
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: word.pleaseTitle(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 3.0.w),
                      ),
                      Container(
                        width: 10.0.w,
                        child: CircleAvatar(
                          radius: 5.0.w,
                          backgroundColor: _titleController.text == ""
                              ? disableUploadBtn
                              : blueColor,
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.arrow_upward,
                                color: whiteColor,
                                size: 6.0.w,
                              ),
                              onPressed: _titleController.text == ""
                                  ? () {
                                     /* print("업로드 안됨");*/
                                    }
                                  : () async {
                                _meetingModel = meetingModel != null ? MeetingModel(
                                  id: meetingModel.id,
                                  createUid: meetingModel.createUid,
                                  name: meetingModel.name,
                                  type: meetingModel.type,
                                  title: _titleController.text,
                                  contents: _contentController.text,
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
                                  contents: _contentController.text,
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
                  Padding(padding: EdgeInsets.only(top: 2.0.h,)),
                  Row(
                    children: [
                      Container(
                        width: 30.0.w,
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 6.0.w,
                            ),
                            Padding(padding: EdgeInsets.only(left: 3.0.w),),
                            Text(
                              word.dateTime(),
                              style: customStyle(
                                fontSize: 12.0.sp,
                                fontColor: mainColor,
                                fontWeightName: 'Regular',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 55.0.w,
                        child: InkWell(
                          child: Text(
                            _format.dateToString(startTime),
                            style: customStyle(
                              fontSize: 12.0.sp,
                              fontColor: mainColor,
                              fontWeightName: 'Regular',
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
                  Padding(padding: EdgeInsets.only(top: 2.0.h,)),
                  Row(
                    children: [
                      Container(
                        width: 30.0.w,
                        child: Row(
                          children: [
                            Icon(
                              Icons.supervisor_account,
                              size: 6.0.w,
                            ),
                            Padding(padding: EdgeInsets.only(left: 3.0.w),),
                            Text(
                              word.participant(),
                              style: customStyle(
                                fontSize: 12.0.sp,
                                fontColor: mainColor,
                                fontWeightName: 'Regular',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: 55.0.w,
                          height: 5.0.h,
                          child: attendees == null
                              ? IconButton(
                            padding: EdgeInsets.zero,
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
                                      padding: EdgeInsets.all(1.0.w),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: textFieldUnderLine),
                                            borderRadius:
                                                BorderRadius.circular(2.0.w)),
                                        width: 10.0.w,
                                        height:3.0.h,
                                        alignment: Alignment.center,
                                        child: Text(
                                          attendees[key],
                                          style: customStyle(
                                              fontSize: 10.0.sp,
                                              fontWeightName: "Regular",
                                              fontColor: mainColor),
                                        ),
                                      ),
                                    );
                                  })),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 2.0.h,)),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 7.0.w,
                          height: 3.0.h,
                          child: Checkbox(
                            value: isChk,
                            onChanged: (value) {
                              setState(() {
                                isChk = value;
                              });
                            },
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 3.0.w),),
                        Text(
                          word.addItem(),
                          style: customStyle(
                            fontSize: 12.0.sp,
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
                          width: 30.0.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.list,
                                size: 6.0.w,
                              ),
                              Padding(padding: EdgeInsets.only(left: 3.0.w),),
                              Text(
                                word.content(),
                                style: customStyle(
                                  fontSize: 12.0.sp,
                                  fontColor: mainColor,
                                  fontWeightName: 'Regular',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 55.0.w,
                          child: TextField(
                            maxLines: null,
                            controller: _contentController,
                            keyboardType: TextInputType.multiline,
                            style: customStyle(
                              fontSize: 12.0.sp,
                              fontColor: mainColor,
                              fontWeightName: 'Regular',
                            ),
                            decoration: InputDecoration(
                              hintText: word.contentCon(),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 4.0.h)),
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
