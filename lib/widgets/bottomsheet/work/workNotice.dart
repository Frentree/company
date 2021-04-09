import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/alarmModel.dart';
import 'package:MyCompany/models/companyScheduleModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/repos/fcm/pushFCM.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/models/noticeModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/search/searchFormat.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

final word = Words();

WorkNoticeBottomSheet(BuildContext context, String noticeDocumentID,
    String noticeTitle, String noticeContent) async {
  bool result = false;

  bool _detailClicked = false;

  TextEditingController _noticeTitle = TextEditingController();
  TextEditingController _noticeContent = TextEditingController();

  FocusNode _noticeFocusNode = FocusNode();

  Format _format = Format();
  Fcm fcm = Fcm();

  User _loginUser;

  Map<String, String> _noticeUser = Map();
  NoticeModel _notice;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

/*
  DateTime startTime = DateTime.now().minute < 30 ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 00) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, 30);
*/
  List<DateTime> dateRange = [DateTime.now(), null];

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
                                var doc = await FirebaseFirestore.instance.collection("company").doc(_loginUser.companyCode).collection("user").doc(_loginUser.mail).get();
                                CompanyUser loginUserInfo = CompanyUser.fromMap(doc.data(), doc.id);

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

                                    await FirebaseRepository().addNotice(
                                      companyCode: _loginUser.companyCode,
                                      notice: _notice,
                                    ).whenComplete(() async {
                                      Alarm _alarmModel = Alarm(
                                        alarmId: _notice.noticeCreateDate.hashCode,
                                        createName: _loginUser.name,
                                        createMail: _loginUser.mail,
                                        collectionName: "notice",
                                        alarmContents: loginUserInfo.team + " " + _loginUser.name + " " + loginUserInfo.position + "님이 새로운 " + "공지" + "를 등록 했습니다.",
                                        read: false,
                                        alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                      );

                                      if(_titleController.text != ""){
                                        if(dateRange[1] == null){
                                          dateRange[1] = dateRange[0];
                                        }

                                        CompanySchedule _companySchedule = CompanySchedule(
                                          createUid: _loginUser.mail,
                                          name: _loginUser.name,
                                          type: "회사",
                                          title: _titleController.text,
                                          contents: _noticeContent.text,
                                          location: _locationController.text,
                                          createDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                          lastModDate: _format.dateTimeToTimeStamp(DateTime.now()),
                                          startDate: _format.dateTimeToTimeStamp(DateTime(
                                            dateRange[0].year,
                                            dateRange[0].month,
                                            dateRange[0].day,
                                            21,
                                            00,
                                          )),
                                          timeSlot: _format.timeSlot(dateRange[0]),
                                          level: 0,
                                          alarmId: DateTime.now().hashCode,
                                          endDate: _format.dateTimeToTimeStamp(DateTime(
                                            dateRange[1].year,
                                            dateRange[1].month,
                                            dateRange[1].day,
                                            21,
                                            00,
                                          )),
                                        );
                                        Map<String, String> temp = await FirebaseRepository().getColleague(loginUserMail: _loginUser.mail, companyCode: _loginUser.companyCode);

                                        _companySchedule.attendees = temp;

                                        await FirebaseRepository().saveCompanySchedule(
                                          companySchedule: _companySchedule,
                                          companyCode: _loginUser.companyCode,
                                        );
                                      }

                                      //동료들 토큰 가져오기
                                      List<String> tokens = await FirebaseRepository().getTokens(companyCode: _loginUser.companyCode, mail: _loginUser.mail);

                                      await FirebaseRepository().saveAlarm(
                                        alarmModel: _alarmModel,
                                        companyCode: _loginUser.companyCode,
                                        mail: _loginUser.mail,
                                      ).whenComplete(() async{
                                        //동료들에게 알림 보내기
                                        fcm.sendFCMtoSelectedDevice(
                                            alarmId: _alarmModel.alarmId.toString(),
                                            tokenList: tokens,
                                            name: _loginUser.name,
                                            team: loginUserInfo.team,
                                            position: loginUserInfo.position,
                                            collection: "notice"
                                        );
                                      });


                                    });
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
                    InkWell(
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                            color: _titleController.text == "" ? grayColor : blackColor,
                          ),
                          cardSpace,
                          Text(
                            _titleController.text == "" ? "일정 등록 (미등록)" : "일정 등록 (등록)",
                            style: defaultRegularStyle,
                          ),
                        ],
                      ),
                      onTap: (){
                        setState((){
                          _detailClicked = !_detailClicked;
                        });
                      },
                    ),
                    Visibility(
                      visible: _detailClicked,
                      child: emptySpace,
                    ),
                    Visibility(
                      visible: _detailClicked,
                      child: Column(
                        children: [
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
                                      "날짜",
                                      style: defaultRegularStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Text(
                                    "${_format.dateToString(dateRange[0]).substring(5, 10)}" + (dateRange[1] == null ? "" : " ~ " + _format.dateToString(dateRange[1]).substring(5, 10)),
                                    style: defaultRegularStyle,
                                  ),
                                  onTap: () async {
                                    DateTime firstDate = dateRange[0] != null ? dateRange[0] : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                                    List<DateTime> pickedDateTime = await DateRangePicker.showDatePicker(
                                      context: context,
                                      initialFirstDate: firstDate,
                                      initialLastDate: dateRange[1] == null ? DateTime(firstDate.year, firstDate.month, firstDate.day, 23, 59) : dateRange[1],
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(DateTime.now().year+2),
                                    );
                                    if (pickedDateTime != null && pickedDateTime.length >= 1) {
                                      setState(() {
                                        int i = 0;
                                        pickedDateTime.forEach((element) {
                                          dateRange[i] = element;
                                          i++;
                                        });

                                        if(pickedDateTime.length != 2){
                                          dateRange[1] = DateTime(dateRange[0].year, dateRange[0].month, dateRange[0].day, 23, 59);
                                        }
                                      });

                                      print(_format.dateToString(dateRange[0]));
                                      print(_format.dateToString(dateRange[1]));
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height: 6.0.h,
                                width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.list,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                    ),
                                    cardSpace,
                                    Text(
                                      "일정 제목",
                                      style: defaultRegularStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _titleController,
                                  style: defaultRegularStyle,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: textFormPadding,
                                    border: InputBorder.none,
                                    hintText: word.pleaseTitle() + "(필수 입력)",
                                    hintStyle: hintStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height: 6.0.h,
                                width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                    ),
                                    cardSpace,
                                    Text(
                                      "장소",
                                      style: defaultRegularStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _locationController,
                                  style: defaultRegularStyle,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: textFormPadding,
                                    border: InputBorder.none,
                                    hintText: "장소를 입력하세요",
                                    hintStyle: hintStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    emptySpace,
                  ]
              ),
            ),
          );
        },
      );
    },
  );
  return result;
}
