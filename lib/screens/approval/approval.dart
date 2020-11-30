//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/approvalModel.dart';
import 'package:companyplaylist/models/meetingModel.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/repos/login/loginRepository.dart';
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

class ApprovalPage extends StatefulWidget {
  @override
  ApprovalPageState createState() => ApprovalPageState();
}

class ApprovalPageState extends State<ApprovalPage> {
  LoginRepository _loginRepository = LoginRepository();
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
                  if (element.data["createUid"] == _loginUser.mail ||
                      element.data["attendees"] != null &&
                          element.data["attendees"].keys
                              .contains(_loginUser.mail)) {
                    DateTime _startDate =
                        _format.timeStampToDateTime(element.data["startDate"]);
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
            stream: _repository.getApproval(
                companyCode: _loginUser.companyCode,
                managerMail: _loginUser.mail),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var _approvalData = [];
              snapshot.data.documents.forEach((element) {
                _approvalData.add(element);
              });
              if (_approvalData.length == 0) {
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
                                "승인할 내용이 없습니다.",
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
                return Expanded(
                  child: ListView.builder(
                    itemCount: _approvalData.length,
                    itemBuilder: (context, index) {
                      Approval _APData;
                      _APData = Approval.fromMap(
                          _approvalData[index].data,
                          _approvalData[index].documentID);
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            width: 1,
                            color: boarderColor,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: widthRatio(
                              context: context,
                              widthRatio: 0.02,
                            ),
                            vertical: heightRatio(
                              context: context,
                              heightRatio: 0.01,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: heightRatio(
                                    context: context, heightRatio: 0.03),
                                child: font(
                                  text: _APData.name,
                                  textStyle: customStyle(
                                    fontColor: mainColor,
                                    fontWeightName: "Medium",
                                  ),
                                ),
                              ),
                              Container(
                                height: heightRatio(
                                    context: context, heightRatio: 0.03),
                                child: font(
                                  text: _APData.mail,
                                  textStyle: customStyle(
                                    fontColor: grayColor,
                                    fontWeightName: "Regular",
                                  ),
                                ),
                              ),
                              Container(
                                height: heightRatio(
                                    context: context, heightRatio: 0.03),
                                child: font(
                                  text: _APData.phone,
                                  textStyle: customStyle(
                                    fontColor: grayColor,
                                    fontWeightName: "Regular",
                                  ),
                                ),
                              ),
                              Container(
                                height: heightRatio(
                                    context: context, heightRatio: 0.03),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RaisedButton(
                                      child: Text("승인"),
                                      onPressed: () async {
                                        _APData.state = 1;
                                       await _repository.updateApproval(
                                          companyCode: _loginUser.companyCode,
                                          managerMail: _loginUser.mail,
                                          approvalModel: _APData,
                                        );
                                       await _loginRepository.userApproval(approvalUserMail:  _APData.mail, context: context);
                                      },
                                    ),
                                    RaisedButton(
                                      child: Text("거절"),
                                      onPressed: () async {
                                        _APData.state = 2;
                                        await _repository.updateApproval(
                                          companyCode: _loginUser.companyCode,
                                          managerMail: _loginUser.mail,
                                          approvalModel: _APData,
                                        );
                                        await _loginRepository.userRejection(approvalUserMail: _APData.mail, context: context);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
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
