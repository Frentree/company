//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/meetingModel.dart';
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
  DateTime selectTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21, 00);
  Firestore _db = Firestore.instance;
  User _companyUser;
  CalendarController _calendarController;

  Format _format = Format();

  List<bool> isDetail = List<bool>();

  Map<DateTime, List<dynamic>> _events ={
    DateTime(2020, 11, 5) : ["ㅁㅁㅁ"]
  };

  Map<DateTime, List<dynamic>> _holidays ={
    DateTime(2020, 11, 6) : ["ㅁㅁㅁ"]
  };

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  @override
  void initState(){
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose(){
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _companyUser = _loginUserInfoProvider.getLoginUser();

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TableCalendar(
              events: _events,
              holidays: _holidays,
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
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
              locale: 'ko_KR',
              headerStyle: HeaderStyle(
                formatButtonDecoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                formatButtonTextStyle: customStyle(
                    fontSize: 13,
                    fontWeightName: "Bold",
                    fontColor: whiteColor
                ),
              ),
              calendarStyle:  CalendarStyle(
                  markersColor: redColor,
                  selectedColor: mainColor,
                  selectedStyle: customStyle(
                      fontSize: 18,
                      fontWeightName: "Bold",
                      fontColor: whiteColor
                  )
              ),

            ),
          ),
          StreamBuilder(
            stream: _db.collection("company").document(_companyUser.companyCode).collection("work").where("startDate", isEqualTo: _format.dateTimeToTimeStamp(selectTime)).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var _companyWork = [];

              snapshot.data.documents.forEach((element){
                if(element.data["createUid"] == _companyUser.mail || element.data["attendees"].keys.contains(_companyUser.mail)){
                  _companyWork.add(element);
                }
              });

              if(_companyWork.length == 0) {
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
                              padding: EdgeInsets.symmetric(vertical: customHeight(context: context, heightSize: 0.02)),
                              child: Text(
                                "일정이 없습니다.",
                                style: customStyle(
                                    fontColor: blackColor,
                                    fontSize: 16,
                                    fontWeightName: "Medium"
                                ),
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              else{
                while(isDetail.length < _companyWork.length){
                  isDetail.add(false);
                }
                if(isDetail.length > _companyWork.length){
                  isDetail.remove(true);
                }
                print(isDetail);
                return Expanded(
                  child: ListView.builder(
                    itemCount: _companyWork.length,
                    itemBuilder: (context, index) {
                      dynamic _companyData;
                      if(_companyWork[index].data["type"] == "내근" || _companyWork[index].data["type"] == "외근")
                        {
                          _companyData = WorkModel.fromMap(_companyWork[index].data, _companyWork[index].documentID);
                        }
                      else if(_companyWork[index].data["type"] == "미팅"){
                        print("미팅");
                        _companyData = MeetingModel.fromMap(_companyWork[index].data, _companyWork[index].documentID);
                      }


                      switch(_companyData.type) {
                        case '내근':
                        case '외근':
                          return GestureDetector(
                            child: workScheduleCard(
                              context: context,
                              companyCode: _companyUser.companyCode,
                              workModel: _companyData,
                              isDetail: isDetail[index],
                            ),
                            onTap: () {
                              setState(() {
                                isDetail[index] = !isDetail[index];
                                for(int i = 0; i < isDetail.length; i++){
                                  if(i != index) {
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
                              loginUserMail: _companyUser.mail,
                              companyCode: _companyUser.companyCode,
                              meetingModel: _companyData,
                              isDetail: isDetail[index],
                            ),
                            onTap: () {
                              setState(() {
                                isDetail[index] = !isDetail[index];
                                for(int i = 0; i < isDetail.length; i++){
                                  if(i != index) {
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
