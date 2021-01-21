//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/meetingModel.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/widgets/card/meetingScheduleCard.dart';
import 'package:MyCompany/i18n/word.dart';

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

import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

final word = Words();

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

  List<bool> isDetail = List<bool>();
  bool isBirthdayDetail = false;

  Map<int, bool> test = {};
  Map<DateTime, List<dynamic>> _events;
  Map<DateTime, List<dynamic>> _holidays;

  ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    notificationPlugin.setOnNotificationClick(onNotificationClick);

  }


  onNotificationClick(String payload){
    print('Payload $payload');
    int index = 0;
    int i = 0;
    test.forEach((key, value) {
      if(key != int.parse(payload)){
        i++;
      }
      else
        index = i;
    });
    print("test $test");
    setState(() {
      test[int.parse(payload)] = true;
    });
    _scrollController.scrollTo(index: index, duration: Duration(seconds: 1));
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
                    DateTime _startDate = _format.timeStampToDateTime(elementData["startDate"]);
                    if (_events[_startDate] == null) {
                      _events.addAll({_startDate: []});
                    }
                    _events[_startDate].add(element);
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
                      initialCalendarFormat: CalendarFormat.week,
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
                          child: CircularProgressIndicator(),
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
                        test = {};
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
                                      style: cardTitleStyle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        if (test.length != _companyWork.length) {
                          test = {};
                          _companyWork.forEach((element) {
                            test.addAll({element.data()["alarmId"] : false});
                          });
                          isDetail = List.generate(_companyWork.length, (index) => false);
                        }

                        if((test.length == _companyWork.length) && isDetail.contains(true)){
                          int i = isDetail.indexOf(true);
                          if(test[_companyWork[i].data()["alarmId"]] != true){
                            test = {};
                            _companyWork.forEach((element) {
                              test.addAll({element.data()["alarmId"] : false});
                            });
                          }
                        }

                        if (test.length > _companyWork.length) {
                          if (test.containsValue(true)) {
                            test.removeWhere((key, value) => value == true);
                            isDetail.remove(true);
                          } else{
                            test = {};
                            isDetail = [];
                          }

                        }
                        print("isDetail $isDetail");
                        return Expanded(
                          child: ScrollablePositionedList.builder(
                            itemScrollController: _scrollController,
                            itemCount: _companyWork.length,
                            itemBuilder: (context, index) {
                              dynamic _companyData;
                              if (_companyWork[index].data()["type"] == "내근" ||
                                  _companyWork[index].data()["type"] == "외근") {
                                _companyData = WorkModel.fromMap(
                                    _companyWork[index].data(),
                                    _companyWork[index].documentID);
                              } else if (_companyWork[index].data()["type"] == "미팅") {
                                _companyData = MeetingModel.fromMap(
                                    _companyWork[index].data(),
                                    _companyWork[index].documentID);
                              }

                              switch (_companyData.type) {
                                case '내근':
                                case '외근':
                                  return GestureDetector(
                                    child: workScheduleCard(
                                      context: context,
                                      companyCode: _loginUser.companyCode,
                                      workModel: _companyData,
                                      isDetail: test[_companyWork[index].data()["alarmId"]],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isDetail[index] = !isDetail[index];
                                        test[_companyWork[index].data()["alarmId"]] = !test[_companyWork[index].data()["alarmId"]];
                                        for (int i = 0; i < test.length; i++) {
                                          if (i != index) {
                                            test[_companyWork[i].data()["alarmId"]] = false;
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
                                      isDetail: test[_companyWork[index].data()["alarmId"]],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isDetail[index] = !isDetail[index];
                                        test[_companyWork[index].data()["alarmId"]] = !test[_companyWork[index].data()["alarmId"]];
                                        for (int i = 0; i < test.length; i++) {
                                          if (i != index) {
                                            test[_companyWork[i].data()["alarmId"]] = false;
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
