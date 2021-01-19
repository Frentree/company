//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/widgets/bottomsheet/schedule/coScheduleDetail.dart';
import 'package:MyCompany/widgets/notImplementedPopup.dart';
import 'package:MyCompany/widgets/table/workDetailTable.dart';
import 'package:MyCompany/i18n/word.dart';

//Flutter
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/repos/tableCalendar/table_calendar.dart';

//Model
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/models/userModel.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';

//Util
import 'package:MyCompany/utils/date/dateFormat.dart';

//Widget
import 'package:MyCompany/widgets/button/textButton.dart';
import 'package:MyCompany/widgets/card/workCoScheduleCard.dart';


import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

import 'package:MyCompany/widgets/bottomsheet/work/attendance.dart';

final word = Words();

class HomeScheduleCoPage extends StatefulWidget {
  @override
  HomeScheduleCoPageState createState() => HomeScheduleCoPageState();
}

class HomeScheduleCoPageState extends State<HomeScheduleCoPage> {
  DateTime selectTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 21, 00);
  FirebaseRepository _repository = FirebaseRepository();
  User _loginUser;
  CalendarController _calendarController;

  List<bool> isDetail = List<bool>();
  bool isTable = false;

  Format _format = Format();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider =
        Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TableCalendar(
              calendarController: _calendarController,
              initialCalendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableCalendarFormats: {
                CalendarFormat.week: "Week",
              },
              onDaySelected: (day, events, holidays) {
                setState(() {
                  selectTime = day;
                });
              },
              //locale: 'ko_KR',
              headerStyle: HeaderStyle(
                titleTextStyle: defaultMediumStyle,
                headerPadding: EdgeInsets.symmetric(vertical: 2.0.h),
                formatButtonVisible: false,
              ),
              calendarStyle: CalendarStyle(
                selectedColor: mainColor,
                selectedStyle: customStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
                  fontWeightName: "Bold",
                  fontColor: whiteColor,
                ),
                todayStyle: customStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
                  fontWeightName: "Bold",
                  fontColor: whiteColor,
                ),
                weekdayStyle: customStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? 8.25.sp : 11.0.sp,
                  fontColor: mainColor,
                  fontWeightName: "Regular",
                ),
                saturdayStyle: customStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? 8.25.sp : 11.0.sp,
                  fontColor: blueColor,
                  fontWeightName: "Regular",
                ),
                weekendStyle: customStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? 8.25.sp : 11.0.sp,
                  fontColor: redColor,
                  fontWeightName: "Regular",
                ),
                outsideStyle: customStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
                  fontColor: Colors.black26,
                  fontWeightName: "Regular",
                ),
                outsideSaturdayStyle: customStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
                  fontColor: Colors.blue[200],
                  fontWeightName: "Regular",
                ),
                outsideWeekendStyle: customStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
                  fontColor: Colors.red[200],
                  fontWeightName: "Regular",
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            color: whiteColor,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isTable = !isTable;
                });
              },
              child: Column(
                children: [
                  Text(
                    isTable ? word.daily() : word.details(),
                    style: customStyle(
                      fontSize: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.sp : 10.0.sp,
                      fontColor: mainColor,
                      fontWeightName: "Medium",
                    ),
                  ),
                  Icon(isTable
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                    size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                  ),
                ],
              ),
            ),
          ),
          emptySpace,
          StreamBuilder(
            stream: _repository.getColleagueInfo(companyCode: _loginUser.companyCode),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              Map<dynamic, dynamic> colleague = isTable ? {_loginUser.mail : word.my()} : {}; //회원 리스트
              snapshot.data.documents.forEach((element){
                var elementData = element.data();
                if(elementData["mail"] != _loginUser.mail){
                  colleague.addAll({elementData["mail"]: elementData["name"]});
                }
              });

              return isTable ? StreamBuilder(
                stream: _repository.getSelectedWeekCompanyWork(companyCode: _loginUser.companyCode, selectedWeek: _format.oneWeekDay(selectTime)),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  Map<String, List<dynamic>> companyWorkData = {};//회원 별 데이터

                  colleague.keys.forEach((element) {
                    companyWorkData[element] = []; //회원 별 데이터에 키값 저장
                  });

                  snapshot.data.documents.forEach((element){
                    var elementData = element.data();
                    if(elementData["type"] == "내근" || elementData["type"] == "외근"){
                      companyWorkData[elementData["createUid"]].add(element);
                    }

                    else if(elementData["type"] == "미팅"){
                      companyWorkData[elementData["createUid"]].add(element);
                      if(elementData["attendees"] != null){
                        elementData["attendees"].keys.forEach((key){
                          if(companyWorkData.containsKey(key)){
                            companyWorkData[key].add(element);
                          }
                        });
                      }
                    }

                  });

                  List<TableRow> childRow = [];

                  companyWorkData.forEach((key, value) {
                    childRow.add(
                      workDetailTableRow(
                        context: context,
                        companyWork: value,
                        loginUserMail: key,
                        name: colleague[key],
                      )
                    );
                  });

                  return Expanded(
                    child: Container(
                      color: whiteColor,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w, vertical: 1.0.h),
                        child: SingleChildScrollView(
                          child: Table(
                            border: TableBorder.all(width: 0.1,),
                            columnWidths: {
                              5: FixedColumnWidth(SizerUtil.deviceType == DeviceType.Tablet ? 23.0.w : 21.0.w)
                            },
                            children: childRow,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ) : Expanded(
                child: Column(
                  children: [
                    InkWell(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.Tablet ? buttonRadiusTW.w : buttonRadiusMW.w),
                          side: BorderSide(
                            width: 1,
                            color: blueColor,
                          ),
                        ),
                        child: Padding(
                          padding: cardPadding,
                          child: Container(
                            height: scheduleCardDefaultSizeH.h,
                            alignment: Alignment.center,
                            child: Text(
                              word.colleagueTimeSchedule(),
                              style: cardTitleStyle,
                            ),
                          ),
                        ),
                      ),
                      onTap: (){
                        attendance(context: context, statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(Scaffold.of(context).context).context).context).padding.top);
                      },
                    ),
                    StreamBuilder(
                      stream: _repository.getSelectedDateCompanyWork(companyCode: _loginUser.companyCode, selectedDate: _format.dateTimeToTimeStamp(selectTime)),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if (snapshot.data == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        Map<String, List<dynamic>> companyWorkData = {};//회원 별 데이터

                        colleague.keys.forEach((element) {
                          companyWorkData[element] = []; //회원 별 데이터에 키값 저장
                        });

                        snapshot.data.documents.forEach((element){
                          var elementData = element.data();
                          if(elementData["createUid"] != _loginUser.mail) {
                            companyWorkData[elementData["createUid"]].add(element);
                          }
                          else{
                            if(elementData["type"] == "미팅"){
                              if(elementData["attendees"] != null){
                                elementData["attendees"].keys.forEach((key){
                                  if(companyWorkData.keys.contains(key)){
                                    companyWorkData[key].add(element);
                                  }
                                });
                              }
                            }
                          }
                        });
                        return Expanded(
                          child: ListView.builder(
                            itemCount: companyWorkData.keys.length,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                child: workCoScheduleCard(
                                  context: context,
                                  name: colleague[companyWorkData.keys.elementAt(index)],
                                  workData: companyWorkData[companyWorkData.keys.elementAt(index)],
                                ),
                                onTap: companyWorkData[companyWorkData.keys.elementAt(index)].length != 0 ? (){
                                  coScheduleDetail(
                                    context: context,
                                    name: colleague[companyWorkData.keys.elementAt(index)],
                                    loginUserMail: colleague.keys.elementAt(index),
                                    scheduleData: companyWorkData[companyWorkData.keys.elementAt(index)],
                                  );
                                } : null
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
