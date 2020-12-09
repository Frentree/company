//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/meetingModel.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/widgets/card/meetingScheduleCard.dart';

//Flutter
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/repos/tableCalendar/table_calendar.dart';

//Model
import 'package:companyplaylist/models/workModel.dart';
import 'package:companyplaylist/models/userModel.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';

//Util
import 'package:companyplaylist/utils/date/dateFormat.dart';

//Widget
import 'package:companyplaylist/widgets/card/workScheduleCard.dart';

class HomeSchedulePage extends StatefulWidget {
  @override
  HomeSchedulePageState createState() => HomeSchedulePageState();
}

class HomeSchedulePageState extends State<HomeSchedulePage> {
  Widget _buildEventMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date) ? bottomColor : mainColor,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  DateTime selectTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 21, 00);
  FirebaseRepository _repository = FirebaseRepository();
  User _loginUser;
  CalendarController _calendarController;

  Format _format = Format();

  List<bool> isDetail = List<bool>();
  Map<DateTime, List<dynamic>> _events;

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
          StreamBuilder(
            stream: _repository.getCompanyWork(
              companyCode: _loginUser.companyCode,
            ),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              _events = {};
              if (snapshot.hasData) {
                snapshot.data.documents.forEach((element) {
                  var elementData = element.data();
                  if (elementData["createUid"] == _loginUser.mail ||
                      elementData["attendees"] != null &&
                          elementData["attendees"].keys
                              .contains(_loginUser.mail)) {
                    DateTime _startDate =
                        _format.timeStampToDateTime(elementData["startDate"]);
                    if (_events[_startDate] == null) {
                      _events.addAll({_startDate: []});
                    }
                    _events[_startDate].add(element);
                  }
                });
              }
              return Container(
                color: Colors.white,
                child: TableCalendar(
                  events: _events,
                  calendarController: _calendarController,
                  initialCalendarFormat: CalendarFormat.week,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  availableCalendarFormats: {
                    CalendarFormat.week: "주간",
                    CalendarFormat.month: "월간"
                  },
                  onDaySelected: (day, events, holidays) {
                    setState(() {
                      selectTime = day;
                      _calendarController
                          .setCalendarFormat(CalendarFormat.week);
                    });
                  },
                  locale: 'ko_KR',
                  calendarStyle: CalendarStyle(
                    selectedColor: mainColor,
                    selectedStyle: customStyle(
                      fontSize: 18,
                      fontWeightName: "Bold",
                      fontColor: whiteColor,
                    ),
                  ),
                  builders: CalendarBuilders(
                    markersBuilder: (context, date, events, holidays) {
                      List<Widget> children = [];
                      if (events.isNotEmpty) {
                        children.add(Positioned(
                          right: 1,
                          bottom: 1,
                          child: _buildEventMarker(date, events),
                        ));
                      }
                      return children;
                    },
                    //selectedDayBuilder: ()
                  ),
                ),
              );
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
                if (elementData["createUid"] == _loginUser.mail ||
                    (elementData["attendees"] != null &&
                    elementData["attendees"].keys
                            .contains(_loginUser.mail))) {
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            width: 1,
                            color: boarderColor,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: customHeight(
                                      context: context, heightSize: 0.02)),
                              child: Text(
                                "일정이 없습니다.",
                                style: customStyle(
                                    fontColor: blackColor,
                                    fontSize: 16,
                                    fontWeightName: "Medium"),
                              )),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                while (isDetail.length != _companyWork.length) {
                  isDetail =
                      List.generate(_companyWork.length, (index) => false);
                }
                if (isDetail.length > _companyWork.length) {
                  if (isDetail.contains(true)) {
                    isDetail.remove(true);
                  } else
                    isDetail = [];
                }
                print(isDetail);
                return Expanded(
                  child: ListView.builder(
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
    );
  }
}
