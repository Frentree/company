import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/screens/work/workDate.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/widgets/bottomsheet/work/copySchedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:MyCompany/models/meetingModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:sizer/sizer.dart';

final word = Words();
meetingMain({BuildContext context, MeetingModel meetingModel, WorkData workData}) async {
  MeetingModel _meetingModel = meetingModel;
  bool result = false;
  bool isChk = false;

  Format _format = Format();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  Map<dynamic, dynamic> attendees;

  User _loginUser;

  DateTime startTime = DateTime.now().minute < 30
      ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 00)
      : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 30);

  FirebaseRepository _repository = FirebaseRepository();

  if (_meetingModel != null) {
    _titleController.text = _meetingModel.title;
    _contentController.text = _meetingModel.contents;
    attendees = _meetingModel.attendees;
    startTime = _format.timeStampToDateTime(_meetingModel.startTime);
  }

  if (workData != null) {
    _titleController.text = workData.title;
    _contentController.text = workData.contents;
    //startTime = _format.timeStampToDateTime(workData.startTime);
  }

  await showModalBottomSheet(
    isScrollControlled: true,
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
              padding: EdgeInsets.only(
                left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                top: 2.0.h,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 6.0.h,
                        width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                        decoration: BoxDecoration(
                          color: chipColorBlue,
                          borderRadius: BorderRadius.circular(
                              SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          word.meetingSchedule(),
                          style: defaultMediumStyle,
                        ),
                      ),
                      cardSpace,
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          style: defaultRegularStyle,
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
                        backgroundColor: _titleController.text == "" ? disableUploadBtn : blueColor,
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.arrow_upward,
                              color: whiteColor,
                              size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                            ),
                            onPressed: _titleController.text == "" ? () {} : () async {
                              _meetingModel = meetingModel != null ? MeetingModel(
                                id: meetingModel.id,
                                createUid: meetingModel.createUid,
                                name: meetingModel.name,
                                type: meetingModel.type,
                                title: _titleController.text,
                                contents: _contentController.text,
                                createDate: meetingModel.createDate,
                                lastModDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                startDate: _format.dateTimeToTimeStamp(DateTime(startTime.year, startTime.month, startTime.day, 21, 00,)),
                                startTime: _format.dateTimeToTimeStamp(startTime),
                                timeSlot: _format.timeSlot(startTime),
                                attendees: attendees,
                              ) : MeetingModel(
                                createUid: _loginUser.mail,
                                name: _loginUser.name,
                                type: "미팅",
                                title: _titleController.text,
                                contents: _contentController.text,
                                createDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                lastModDate:_format.dateTimeToTimeStamp(DateTime.now()),
                                startDate: _format.dateTimeToTimeStamp(DateTime(startTime.year, startTime.month, startTime.day, 21, 00,)),
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
                          }
                        ),
                      ),
                    ],
                  ),
                  emptySpace,
                  Row(
                    children: [
                      Container(
                        height: 6.0.h,
                        width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                            ),
                            cardSpace,
                            Text(
                              word.dateTime(),
                              style: defaultRegularStyle,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Text(
                            _format.dateToString(startTime),
                            style: defaultRegularStyle,
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
                  emptySpace,
                  Row(
                    children: [
                      Container(
                        height: 6.0.h,
                        width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                        child: Row(
                          children: [
                            Icon(
                              Icons.supervisor_account,
                              size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                            ),
                            cardSpace,
                            Text(
                              word.participant(),
                              style: defaultRegularStyle,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: attendees == null ? IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Icon(
                            Icons.person_add_alt_1,
                            size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                          ),
                          onPressed: () async {
                            Map<String, String> temp =
                            await _repository.getColleague(loginUserMail: _loginUser.mail, companyCode: _loginUser.companyCode);
                            setState(() {
                              attendees = temp;
                            }
                            );
                          },
                        ) : Container(
                          height: 4.0.h,
                          alignment: Alignment.center,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: attendees.length,
                            itemBuilder: (context, index) {
                              String key = attendees.keys.elementAt(index);
                              return Row(
                                children: [
                                  Container(
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 13.5.w : 18.0.w,
                                    decoration: containerChipDecoration,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      attendees[key],
                                      style: containerChipStyle,
                                    ),
                                  ),
                                  cardSpace,
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  emptySpace,
                  GestureDetector(
                    onTap: () {
                      isChk = !isChk;
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              height: 6.0.h,
                              child: IconButton(
                                padding: EdgeInsets.all(0.0),
                                icon: isChk == true
                                    ? Icon(Icons.keyboard_arrow_up)
                                    : Icon(Icons.keyboard_arrow_down),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            Text(
                              word.addItem(),
                              style: defaultRegularStyle,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 8),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                  /*Container(
                    child: Row(
                      children: [
                        Container(
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                          height: 6.0.h,
                          child: Checkbox(
                            value: isChk,
                            onChanged: (value) {
                              setState(() {
                                isChk = value;
                              });
                            },
                          ),
                        ),
                        cardSpace,
                        Text(
                          word.addItem(),
                          style: defaultRegularStyle,
                        ),
                      ],
                    ),
                  ),*/
                  Visibility(
                    visible: isChk,
                    child: emptySpace,
                  ),
                  Visibility(
                    visible: isChk,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          maxLines: 5,
                          maxLengthEnforced: true,
                          controller: _contentController,
                          keyboardType: TextInputType.multiline,
                          style: defaultRegularStyle,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: textFormPadding,
                            hintText: word.contentCon(),
                            hintStyle: hintStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  emptySpace,
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
