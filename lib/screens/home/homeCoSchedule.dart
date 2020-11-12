//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
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


class HomeScheduleCoPage extends StatefulWidget {
  @override
  HomeScheduleCoPageState createState() => HomeScheduleCoPageState();
}

class HomeScheduleCoPageState extends State<HomeScheduleCoPage> {
  DateTime selectTime = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 00);
  Firestore _db = Firestore.instance;
  User _companyUser;
  CalendarController _calendarController;

  List<bool> isDetail = List<bool>();
  bool isTable = false;

  Format _format = Format();

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

          isTable ? Container(
            child: StreamBuilder(
              stream:_db.collection("company").document(_companyUser.companyCode).collection("user").snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.data == null){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                DateTime weekMonday = selectTime.subtract(Duration(days: selectTime.weekday-1));
                DateTime testTime = DateTime.utc(weekMonday.year, weekMonday.month, weekMonday.day, 12, 00);
                print("testTime ======> $testTime");
                print("selectTime ====> $selectTime");
                List<DateTime> term = [testTime, testTime.add(Duration(days: 1)), testTime.add(Duration(days: 2)), testTime.add(Duration(days: 3)), testTime.add(Duration(days: 4))];
                List<Timestamp> testTerm = [];
                term.forEach((element) {
                  testTerm.add(_format.dateTimeToTimeStamp(element));
                });
                List<DocumentSnapshot> _coUser = snapshot.data.documents ?? [];
                List<String> _coUserUid = [_companyUser.mail];
                Map<String, String> name = {_companyUser.mail : "나"};
                _coUser.forEach((element) {
                  if(element.documentID != _companyUser.mail){
                    _coUserUid.add(element.documentID);
                    name[element.documentID] = element.data["name"];
                  }
                });

                return StreamBuilder(
                  stream:_db.collection("company").document(_companyUser.companyCode).collection("work").orderBy("name").where("startDate", whereIn: testTerm).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.data == null){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var _companyWork = snapshot.data.documents ?? [];

                    List<CompanyWork> convertCompanyWork = [];

                    _companyWork.forEach((doc) => convertCompanyWork.add(CompanyWork.fromMap(doc.data, doc.documentID)));

                    Map<String, List<CompanyWork>> mapB = Map();
                    _coUserUid.forEach((element) {
                      mapB[element] = [];
                    });

                    convertCompanyWork.forEach((element) {
                      print(element.createUid);
                      mapB[element.createUid].add(element);
                      name[element.createUid] = element.name;
                    });
                    print("nowUser ===> ${_companyUser.mail}");
                    print("mapB =====> $mapB");
                    print("name =====> $name");

                    List<TableRow> childRow = [];

                    mapB.forEach((key, value) {
                      print("Key ====> $key");
                      childRow.add(
                          workDetailTableRow(
                              context: context,
                              companyWork: mapB[key],
                              name: name[key]
                          )
                      );
                    });
                    
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: customWidth(context: context, widthSize: 0.08)),
                      child: Container(
                        //color: Colors.purple,
                        height: customHeight(context: context, heightSize: 0.48),
                        child: SingleChildScrollView(
                          child: Table(
                              border: TableBorder.all(width: 0.1),
                              columnWidths: {
                                5: FixedColumnWidth(customWidth(context: context, widthSize: 0.23))
                              },
                              children: childRow
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ) : StreamBuilder(
            stream:_db.collection("company").document(_companyUser.companyCode).collection("user").orderBy("name").snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<DocumentSnapshot> _coUser = snapshot.data.documents ?? [];
              List<String> _coUserUid = [];
              List<String> _name =[];
              _coUser.forEach((element) {
                if(element.documentID != _companyUser.mail){
                  _coUserUid.add(element.documentID);
                  _name.add(element.data["name"]);
                }
                print(_coUserUid);
              });
              return StreamBuilder(
                stream:_db.collection("company").document(_companyUser.companyCode).collection("work").orderBy("name").where("createUid", whereIn: _coUserUid).where("startDate", isEqualTo: _format.dateTimeToTimeStamp(selectTime)).snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.data == null){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var _companyWork = snapshot.data.documents ?? [];

                  List<CompanyWork> convertCompanyWork = [];

                  _companyWork.forEach((doc) => convertCompanyWork.add(CompanyWork.fromMap(doc.data, doc.documentID)));

                  Map<String, List<CompanyWork>> mapB = Map();
                  _coUserUid.forEach((element) {
                    mapB[element] = [];
                  });

                  convertCompanyWork.forEach((element) {
                    mapB[element.createUid].add(element);
                  });

                  List<String> k = [];
                  print(mapB);
                  List<Map<String, List<CompanyWork>>> a = List();
                  mapB.forEach((key, value) {
                    a.add({key: value});
                    k.add(key);
                  });

                  if(_companyWork.length == 0) {
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

                    return Expanded(
                      child: ListView.builder(
                        itemCount: a.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: workCoScheduleCard(
                              context: context,
                              companyWork: a[index],
                              key: k[index],
                              name: _name[index]
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }
}
