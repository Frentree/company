import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/function/meeting/meetingFunction.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/meetingModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/fcm/pushFCM.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/screens/work/workDate.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/bottomsheet/meeting/meetingParticipant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MeetingMainDetail extends StatefulWidget {
  @override
  _MeetingMainDetailState createState() => _MeetingMainDetailState();
}

DateTime selectedDate = DateTime.now();
DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
DateTime selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
DateTime startTime = selectedDay == today ? DateTime.now().minute < 30 ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 00) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 30) : selectedDate.minute < 30 ? DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 09, 00) : DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 09, 30);
DateTime endTime = selectedDay == today ? DateTime.now().minute < 30 ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 00) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 30) : selectedDate.minute < 30 ? DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 11, 00) : DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 11, 30);


class _MeetingMainDetailState extends State<MeetingMainDetail> {
  @override
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  Map<dynamic,dynamic> companyUser;
  MeetingModel _model;

  int _repeatDateChoise = 0;

  Format _format = Format();
  Fcm fcm = Fcm();

  bool isButtonChk = false;
  bool isSwitchChk = false;
  bool isContentChk = false;

  User _loginUser;

  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider =
      Provider.of<LoginUserInfoProvider>(context);

    _loginUser = _loginUserInfoProvider.getLoginUser();
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
        right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
        top: 4.0.h,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 18,
                icon: Icon(Icons.arrow_back_ios_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Center(
                  child: Container(
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
                      Words.word.meetingSchedule(),
                      style: defaultMediumStyle,
                    ),
                  ),
                )
              ),
              IconButton(
                iconSize: 20,
                icon: Icon(Icons.check),
                onPressed: () async {
                  _model = MeetingModel(
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
                    attendees: companyUser,
                    alarmId: DateTime.now().hashCode,
                  );

                  await MeetingFunction(
                    model: _model,
                    startTime: startTime,
                    endTime: endTime,
                    repeatDate: _repeatDateChoise,
                    uesr: _loginUser,
                  ).addMeeting();

                  await Navigator.pop(context);
                },
              ),
            ],
          ),
          Row(
            children: [
              Text("제목 ",
                style: customStyle(
                    fontColor: mainColor,
                    fontSize: 15,
                    fontWeightName: 'Bold'
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
                    hintText: Words.word.pleaseTitle(),
                    hintStyle: hintStyle,
                  ),
                ),
              ),
            ],
          ),
          emptySpace,
          Row(
            children: [
              Text("일정",
                style: customStyle(
                  fontColor: mainColor,
                  fontSize: 15,
                  fontWeightName: 'Bold'
                ),
              ),
              Expanded(
                child: SizedBox()
              ),
              Text("종일"),
              Switch(
                value: isSwitchChk,
                onChanged: (value) {
                  setState(() {
                    isSwitchChk = value;
                    if(isSwitchChk) {
                      startTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 00);
                      endTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 00);
                    }
                  });
                },
                activeTrackColor: mainColor,
                activeColor: Colors.indigo,
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 20,),
              Text(
                "시작",
                style: defaultRegularStyle,
              ),
              SizedBox(width: 30,),
              InkWell(
                child: Text(
                  _format.dateToString(startTime),
                  style: defaultRegularStyle,
                ),
                onTap: () async {
                  if(!isSwitchChk) {
                    DateTime _dateTime = await workDatePage(
                        context: context,
                        startTime: startTime
                    );
                    setState(() {
                      startTime = _dateTime;
                    });
                  }
                },
              ),
            ],
          ),
          emptySpace,
          Row(
            children: [
              SizedBox(width: 20,),
              Text(
                "종료",
                style: defaultRegularStyle,
              ),
              SizedBox(width: 30,),
              InkWell(
                child: Text(
                  _format.dateToString(endTime),
                  style: defaultRegularStyle,
                ),
                onTap: () async {
                  if(!isSwitchChk) {
                    DateTime _dateTime = await workDatePage(
                        context: context,
                        startTime: endTime
                    );
                    setState(() {
                      endTime = _dateTime;
                    });
                  }
                },
              ),
            ],
          ),
          emptySpace,
          Row(
            children: [
              Text("주기",
                style: customStyle(
                    fontColor: mainColor,
                    fontSize: 15,
                    fontWeightName: 'Bold'
                ),
              ),
              cardSpace,
              Tooltip(
                message: "해당 주기마다 등록되는 갯 수가 정해져있습니다.\n최대 20개의 일정이 등록 되니 참고바랍니다.",
                child: Icon(
                  Icons.announcement_outlined,
                  color: redColor,
                  size: 18,
                ),
              ),
              Expanded(
                child: PopupMenuButton(
                  child: RaisedButton(

                    disabledColor: Colors.white,
                    child: Text(
                        _buildChosenItem(_repeatDateChoise),
                        style: defaultRegularStyle
                    ),
                  ),
                  onSelected: (val) {
                    _repeatDateChoise = val;
                    setState((){});
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      height: 7.0.h,
                      value: 0,
                      child: Row(
                        children: [
                          cardSpace,
                          Text(
                            "선택 안함",
                            style: defaultRegularStyle,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      height: 7.0.h,
                      value: 1,
                      child: Row(
                        children: [
                          //Icon(Icons.delete),
                          cardSpace,
                          Text(
                            "일주일",
                            style: defaultRegularStyle,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      height: 7.0.h,
                      value: 2,
                      child: Row(
                        children: [
                          //Icon(Icons.edit),
                          cardSpace,
                          Text(
                            "한  달",
                            style: defaultRegularStyle,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      height: 7.0.h,
                      value: 3,
                      child: Row(
                        children: [
                          //Icon(Icons.edit),
                          cardSpace,
                          Text(
                            "일  년",
                            style: defaultRegularStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          emptySpace,
          Row(
            children: [
              Text(
                Words.word.participant(),
                style: customStyle(
                    fontColor: mainColor,
                    fontSize: 15,
                    fontWeightName: 'Bold'
                ),
              ),
              cardSpace,
              Expanded(
                child: Container(
                  height: 6.0.h,
                  child: InkWell(
                    child: Row(
                      children: [
                        Expanded(
                          child: companyUser == null ? Container() :
                          Container(
                            height: 4.0.h,
                            alignment: Alignment.center,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: companyUser.length,
                              itemBuilder: (context, index) {
                                String key = companyUser.keys.elementAt(index);
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
                                        companyUser[key],
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
                        Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 18,
                        )
                      ],
                    ),
                    onTap: () async {
                      companyUser = await MeetingParticipant(
                        context: context,
                        companyUser: companyUser,
                        loginUser: _loginUser,
                      );
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          emptySpace,
          GestureDetector(
            onTap: () {
              isContentChk = !isContentChk;
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
                        icon: isContentChk == true
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
          Visibility(
            visible: isContentChk,
            child: emptySpace,
          ),
          Visibility(
            visible: isContentChk,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Words.word.content(),
                  style: customStyle(
                      fontColor: mainColor,
                      fontSize: 15,
                      fontWeightName: 'Bold'
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
    );
  }
}


String _buildChosenItem(int chosenItem) {
  String _chosenItem = chosenItem.toString();
  switch (_chosenItem) {
    case '0':
      return "선택 안함";
    case '1':
      return "일주일";
    case '2':
      return "한  달";
    case '3':
      return "일  년";
  }
}