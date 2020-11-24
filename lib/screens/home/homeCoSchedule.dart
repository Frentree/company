//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/widgets/bottomsheet/schedule/coScheduleDetail.dart';
import 'package:companyplaylist/widgets/notImplementedPopup.dart';
import 'package:companyplaylist/widgets/table/workDetailTable.dart';

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
import 'package:companyplaylist/widgets/button/textButton.dart';
import 'package:companyplaylist/widgets/card/workCoScheduleCard.dart';

import '../../models/workModel.dart';

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
              locale: 'ko_KR',
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                formatButtonDecoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                formatButtonTextStyle: customStyle(
                    fontSize: 13,
                    fontWeightName: "Bold",
                    fontColor: whiteColor),
              ),
              calendarStyle: CalendarStyle(
                selectedColor: mainColor,
                selectedStyle: customStyle(
                    fontSize: 18,
                    fontWeightName: "Bold",
                    fontColor: whiteColor),
              ),
            ),
          ),
          Container(
            width: customWidth(context: context, widthSize: 1),
            color: Colors.white,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isTable = !isTable;
                });
              },
              child: Column(
                children: [
                  Text(isTable ? "일간" : "상세"),
                  Icon(isTable
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),

          StreamBuilder(
            stream: _repository.getColleague(loginUserMail: _loginUser.mail, companyCode: _loginUser.companyCode).asStream(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              Map<dynamic, dynamic> colleague = isTable ? {_loginUser.mail : "나"} : {}; //회원 리스트
              colleague.addAll(snapshot.data);

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
                    if(element.data["type"] == "내근" || element.data["type"] == "외근"){
                      companyWorkData[element.data["createUid"]].add(element);
                    }

                    else if(element.data["type"] == "미팅"){
                      companyWorkData[element.data["createUid"]].add(element);
                      if(element.data["attendees"] != null){
                        element.data["attendees"].keys.forEach((key){
                          companyWorkData[key].add(element);
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
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: customWidth(context: context, widthSize: 0.08), vertical: customHeight(context: context, heightSize: 0.01)),
                        child: SingleChildScrollView(
                          child: Table(
                            border: TableBorder.all(width: 0.1,),
                            columnWidths: {
                              5: FixedColumnWidth(customWidth(context: context, widthSize: 0.23))
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
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            width: 1,
                            color: blueColor,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: customHeight(
                                      context: context, heightSize: 0.02)),
                              child: Text(
                                "이 시각 동료 근무 현황 보기",
                                style: customStyle(
                                    fontColor: blackColor,
                                    fontSize: 16,
                                    fontWeightName: "Regular",),
                              )),
                        ),
                      ),
                      onTap: (){
                        NotImplementedFunction(context);
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
                          if(element.data["createUid"] != _loginUser.mail) {
                            companyWorkData[element.data["createUid"]].add(element);
                          }
                          else{
                            if(element.data["type"] == "미팅"){
                              if(element.data["attendees"] != null){
                                element.data["attendees"].keys.forEach((key){
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
