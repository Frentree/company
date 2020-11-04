//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

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

import 'package:companyplaylist/widgets/table/workDetailTable.dart';


class test extends StatefulWidget {
  @override
  testPageState createState() => testPageState();
}

class testPageState extends State<test> {
  DateTime selectTime = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 00);
  Firestore _db = Firestore.instance;
  User _companyUser;
  CalendarController _calendarController;

  List<bool> isDetail = List<bool>();
  bool isTable = false;

  Format _format = Format();

  int tabIndex = 0;

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
                    fontColor: whiteColor
                ),
              ),
              calendarStyle:  CalendarStyle(
                selectedColor: mainColor,
                selectedStyle: customStyle(
                    fontSize: 18,
                    fontWeightName: "Bold",
                    fontColor: whiteColor
                ),
              ),
            ),
          ),
          Container(
              width: customWidth(context: context, widthSize: 1),
              color: Colors.white,
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    isTable = !isTable;
                  });
                },
                child: Column(
                  children: [
                    Text(
                        isTable ? "일간" : "상세"
                    ),
                    Icon(
                        isTable ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down
                    ),
                  ],
                ),
              )
          ),

          StreamBuilder(
            stream:_db.collection("company").document("HYOIE13").collection("user").orderBy("name").snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<DocumentSnapshot> _coUser = snapshot.data.documents ?? [];
              List<String> _coUserUid = ["chlalswl@naver.com"];
              List<String> _coUserName = ["나"];
              _coUser.forEach((element) {
                if(element.documentID != "chlalswl@naver.com"){
                  _coUserUid.add(element.documentID);
                  _coUserName.add(element.data["name"]);
                }
                print(_coUserUid);
                print(_coUserName);
              });
              return StreamBuilder(
                stream: _db.collection("company").document("HYOIE13").collection("work").orderBy("name").where("startDate", isEqualTo: _format.dateTimeToTimeStamp(selectTime)).where("type", isEqualTo: "외근").snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.data == null){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var _companyWork = snapshot.data.documents ?? [];
                  List<CompanyWork> a = [];
                  _companyWork.forEach((doc) => a.add(CompanyWork.fromMap(doc.data, doc.documentID)));
                  Map<String, List<CompanyWork>> mapB = Map();
                  _coUserUid.forEach((element) {
                    mapB[element] = [];
                  });
                  a.forEach((element) {
                    if(mapB.containsKey(element.createUid)){
                      mapB[element.createUid].add(element);
                    }
                  });
                  return Table(
                    w
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}