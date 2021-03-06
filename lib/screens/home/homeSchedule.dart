//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/companyScheduleModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/meetingModel.dart';
import 'package:MyCompany/repos/fcm/pushFCM.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/widgets/card/companyScheduleCard.dart';
import 'package:MyCompany/widgets/card/meetingScheduleCard.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//Flutter
import 'package:flutter/material.dart';
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
import 'package:MyCompany/widgets/card/workScheduleCard.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';


final word = Words();
DateTime selectedDate = DateTime.now();

class HomeSchedulePage extends StatefulWidget {
  @override
  HomeSchedulePageState createState() => HomeSchedulePageState();
}

class HomeSchedulePageState extends State<HomeSchedulePage> {
  Widget _buildEventMarker(DateTime date, List events) {
    return AnimatedContainer(
      width: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 3.5.w,
      height: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 3.5.w,
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _calendarController.isSelected(date) ? bottomColor : mainColor,
      ),
      child: Text(
        '${events.length}',
        style: TextStyle().copyWith(
          color: Colors.white,
          fontSize: SizerUtil.deviceType == DeviceType.Tablet ? 8.0.sp : 9.0.sp,
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.cake,
      size: 20.0,
      color: Colors.pinkAccent,
    );
  }

  DateTime selectTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 21, 00);
  FirebaseRepository _repository = FirebaseRepository();
  User _loginUser;
  CalendarController _calendarController;

  Format _format = Format();

  FirebaseMessaging _fcm = FirebaseMessaging();

  List<bool> isDetail = [];
  bool isBirthdayDetail = false;

  Map<DateTime, List<dynamic>> _events;
  Map<DateTime, List<dynamic>> _holidays;

  ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    selectedDate = selectTime;
    _calendarController = CalendarController();
    _fcm.configure(
      // 앱이 실행중일 경우
      onMessage: Fcm.myBackgroundMessageHandler,
      onBackgroundMessage: Fcm.myBackgroundMessageHandler,
    );
  }

  @override
  void dispose() {
    selectedDate = DateTime.now();
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
          StreamBuilder(
            stream: _repository.getCompanyWork(
              companyCode: _loginUser.companyCode,
            ),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              _events = {};
              if (snapshot.hasData) {
                snapshot.data.documents.forEach((element) {
                  var elementData = element.data();
                  if (elementData["createUid"] == _loginUser.mail || elementData["attendees"] != null && elementData["attendees"].keys.contains(_loginUser.mail)) {
                    if(elementData["endDate"] != null){
                      DateTime c = _format.timeStampToDateTime(elementData["startDate"]);
                      while(c.isBefore(_format.timeStampToDateTime(elementData["endDate"]))){
                        if (_events[c] == null) {
                          _events.addAll({c: []});
                        }
                        _events[c].add(element);
                        c = c.add(Duration(days: 1));
                      }
                      if (_events[_format.timeStampToDateTime(elementData["endDate"])] == null) {
                        _events.addAll({_format.timeStampToDateTime(elementData["endDate"]): []});
                      }
                      _events[_format.timeStampToDateTime(elementData["endDate"])].add(element);
                    }
                    else{
                      DateTime _startDate = _format.timeStampToDateTime(elementData["startDate"]);

                      if (_events[_startDate] == null) {
                        _events.addAll({_startDate: []});
                      }
                      _events[_startDate].add(element);
                    }
                  }
                });
              }

              return FutureBuilder(
                  future: _repository.getBirthday(companyCode: _loginUser.companyCode),
                  builder: (context, snapshot) {
                    _holidays = {};
                    _holidays = snapshot.data;
                    return Container(
                      color: Colors.white,
                      child: TableCalendar(
                        events: _events,
                        holidays: _holidays,
                        calendarController: _calendarController,
                        initialCalendarFormat: CalendarFormat.month,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        availableCalendarFormats: {
                          CalendarFormat.week: word.weekly(),
                          CalendarFormat.month: word.monthly()
                        },
                        onDaySelected: (day, events, holidays) {
                          setState(() {
                            selectTime = day;
                            _calendarController
                                .setCalendarFormat(CalendarFormat.week);
                            selectedDate = day;
                          });
                        },
                        headerStyle: HeaderStyle(
                          titleTextStyle: defaultMediumStyle,
                          headerPadding: EdgeInsets.symmetric(vertical: 2.0.h),
                        ),
                        calendarStyle: CalendarStyle(
                          holidayStyle: customStyle(
                            fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
                            fontWeightName: "Bold",
                            fontColor: Colors.pinkAccent,
                          ),
                          selectedColor: mainColor,
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
                          selectedStyle: customStyle(
                            fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
                            fontWeightName: "Bold",
                            fontColor: whiteColor,
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
                          eventDayStyle: customStyle(
                            fontSize: SizerUtil.deviceType == DeviceType.Tablet ? 8.25.sp : 11.0.sp,
                            fontColor: mainColor,
                            fontWeightName: "Regular",
                          ),
                        ),

                        builders: CalendarBuilders(
                          markersBuilder: (context, date, events, holidays) {
                            List<Widget> children = [];
                            if (events.isNotEmpty) {
                              children.add(Positioned(
                                left: SizerUtil.deviceType == DeviceType.Tablet ? 8.0.w : 7.0.w,
                                top: SizerUtil.deviceType == DeviceType.Tablet ? 5.5.h : 4.5.h,
                                child: _buildEventMarker(date, events),
                              ));
                            }
                            if (holidays.isNotEmpty) {
                              children.add(
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: _buildHolidaysMarker(),
                                ),
                              );
                            }
                            return children;
                          },
                        ),
                      ),
                    );
                  }
              );
            },
          ),
          emptySpace,
          Expanded(
            child: Container(
              child: Column(
                children: [
                  FutureBuilder(
                    future: _repository.getBirthday(companyCode: _loginUser.companyCode),
                    builder: (context, snapshot) {
                      _holidays = {};
                      _holidays = snapshot.data;

                      if (snapshot.data == null) {
                        return Center(
                          /*child: CircularProgressIndicator(),*/
                        );
                      }

                      return (_holidays.containsKey(DateTime(selectTime.year, selectTime.month, selectTime.day, 0, 0))) ? GestureDetector(
                        onTap: (){
                          if(_calendarController.calendarFormat == CalendarFormat.week){
                            setState(() {
                              isBirthdayDetail = !isBirthdayDetail;
                            });
                          }
                        },
                        child: Container(
                          child: Card(
                            elevation: 0,
                            shape: cardShape,
                            child: Padding(
                              padding: cardPadding,
                              child: Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        "오늘의 생일자 " + _holidays[DateTime(selectTime.year, selectTime.month, selectTime.day, 0, 0)].length.toString() + "명",
                                        style: cardTitleStyle,
                                      ),
                                      Container(
                                        height: 3.0.h,
                                        alignment: Alignment.center,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _holidays[DateTime(selectTime.year, selectTime.month, selectTime.day, 0, 0)].length,
                                          itemBuilder: (context, index){
                                            CompanyUser _companyUser = _holidays[DateTime(selectTime.year, selectTime.month, selectTime.day, 0, 0)][index];
                                            return Row(
                                              children: [
                                                Container(
                                                  child: Center(
                                                    child: Text(
                                                        _companyUser.team + " " + _companyUser.name + " " + _companyUser.position
                                                    ),
                                                  ),
                                                ),
                                                cardSpace,
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ),
                      ) : Container();
                    },
                  ),
                  StreamBuilder(
                    stream: _repository.getSelectedDateCompanyWork(
                        companyCode: _loginUser.companyCode,
                        selectedDate: _format.dateTimeToTimeStamp(selectTime)),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      var _companyWork = [];
                      snapshot.data.documents.forEach((element) {
                        var elementData = element.data();
                        if (elementData["createUid"] == _loginUser.mail || (elementData["attendees"] != null && elementData["attendees"].keys.contains(_loginUser.mail))) {
                          _companyWork.add(element);
                        }
                      });
                      if (_companyWork.length == 0) {
                        isDetail = [];
                        return Expanded(
                          child: ListView(
                            children: [
                              Card(
                                elevation: 0,
                                shape: cardShape,
                                child: Padding(
                                  padding: cardPadding,
                                  child: Container(
                                    height: scheduleCardDefaultSizeH.h,
                                    alignment: Alignment.center,
                                    child: Text(
                                      word.noSchedule(),
                                      style: containerMediumStyle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        while(isDetail.length != _companyWork.length){
                          isDetail = List.generate(_companyWork.length, (index) => false);
                        }
                        /*if (test.length != _companyWork.length) {
                          test = {};
                          _companyWork.forEach((element) {
                            test.addAll({element.data()["alarmId"] : false});
                          });

                        }*/
                        /*if((test.length == _companyWork.length) && isDetail.contains(true)){
                          int i = isDetail.indexOf(true);
                          if(test[_companyWork[i].data()["alarmId"]] != true){
                            test = {};
                            _companyWork.forEach((element) {
                              test.addAll({element.data()["alarmId"] : false});
                            });
                          }
                        }
*/
                        if (isDetail.length > _companyWork.length) {
                          if (isDetail.contains(true)) {
                            /*test.removeWhere((key, value) => value == true);*/
                            isDetail.remove(true);
                          } else{
                            /*test = {};*/
                            isDetail = [];
                          }

                        }
                        return Expanded(
                          child: ScrollablePositionedList.builder(
                            itemScrollController: _scrollController,
                            itemCount: _companyWork.length,
                            itemBuilder: (context, index) {
                              dynamic _companyData;
                              if (_companyWork[index].data()["type"] == "내근" ||
                                  _companyWork[index].data()["type"] == "외근" ||
                                  _companyWork[index].data()["type"] == "연차" ||
                                  _companyWork[index].data()["type"] == "반차" ||
                                  _companyWork[index].data()["type"] == "요청") {
                                _companyData = WorkModel.fromMap(
                                    _companyWork[index].data(),
                                    _companyWork[index].documentID);
                              } else if (_companyWork[index].data()["type"] == "미팅") {
                                _companyData = MeetingModel.fromMap(
                                    _companyWork[index].data(),
                                    _companyWork[index].documentID);
                              }

                              else if (_companyWork[index].data()["type"] == "회사") {
                                _companyData = CompanySchedule.fromMap(
                                    _companyWork[index].data(),
                                    _companyWork[index].documentID);
                              }
                              switch (_companyData.type) {
                                case '내근':
                                case '외근':
                                case '요청':
                                  return GestureDetector(
                                    child: workScheduleCard(
                                      context: context,
                                      companyCode: _loginUser.companyCode,
                                      workModel: _companyData,
                                      isDetail: /*test[_companyWork[index].data()["alarmId"]],*/isDetail[index],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isDetail[index] = !isDetail[index];
                                        /*test[_companyWork[index].data()["alarmId"]] = !test[_companyWork[index].data()["alarmId"]];*/
                                        for (int i = 0; i < isDetail.length; i++) {
                                          if (i != index) {
                                            /*test[_companyWork[i].data()["alarmId"]] = false;*/
                                            isDetail[i] = false;
                                          }
                                        }
                                      });
                                    },
                                  );
                                  break;
                                case '연차':
                                case '반차':
                                  return GestureDetector(
                                    child: workScheduleCard(
                                      context: context,
                                      companyCode: _loginUser.companyCode,
                                      workModel: _companyData,
                                      isDetail: isDetail[index],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isDetail[index] = !isDetail[index];
                                        for (int i = 0; i < isDetail.length; i++) {
                                          if (i != index) {
                                            isDetail[i] = false;
                                          }
                                        }
                                      });
                                    },
                                  );
                                  break;
                                case '미팅':
                                  return GestureDetector(
                                    child: meetingScheduleCard(
                                      context: context,
                                      loginUserMail: _loginUser.mail,
                                      companyCode: _loginUser.companyCode,
                                      meetingModel: _companyData,
                                      isDetail: /*test[_companyWork[index].data()["alarmId"]],*/isDetail[index],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isDetail[index] = !isDetail[index];
                                        /*test[_companyWork[index].data()["alarmId"]] = !test[_companyWork[index].data()["alarmId"]];*/
                                        for (int i = 0; i < isDetail.length; i++) {
                                          if (i != index) {
                                            /*test[_companyWork[i].data()["alarmId"]] = false;*/
                                            isDetail[i] = false;
                                          }
                                        }
                                      });
                                    },
                                  );
                                case '회사':
                                  return GestureDetector(
                                    child: companyScheduleCard(
                                      context: context,
                                      loginUserMail: _loginUser.mail,
                                      companyCode: _loginUser.companyCode,
                                      companyScheduleModel: _companyData,
                                      isDetail: /*test[_companyWork[index].data()["alarmId"]],*/isDetail[index],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isDetail[index] = !isDetail[index];
                                        /*test[_companyWork[index].data()["alarmId"]] = !test[_companyWork[index].data()["alarmId"]];*/
                                        for (int i = 0; i < isDetail.length; i++) {
                                          if (i != index) {
                                            /*test[_companyWork[i].data()["alarmId"]] = false;*/
                                            isDetail[i] = false;
                                          }
                                        }
                                      });
                                    },
                                  );
                                  break;
                                default:
                                  return Container();
                              }
                            },

                          ),

                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
