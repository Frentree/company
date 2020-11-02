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
      backgroundColor: whiteColor,
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
            child: Column(
              children: [
                Text("상세"),
                Icon(
                    Icons.keyboard_arrow_down
                ),
              ],
            ),
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
              List<String> _coUserUid = [];
              List<String> _coUserName = [];
              _coUser.forEach((element) {
                if(element.documentID != "chlalswl@naver.com"){
                  _coUserUid.add(element.documentID);
                  _coUserName.add(element.data["name"]);
                }
                print(_coUserName);
              });
              return Column(
                children: [
                  StreamBuilder(
                    stream: _db.collection("company").document("HYOIE13").collection("work").orderBy("name").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(snapshot.data == null){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var _companyWork = snapshot.data.documents ?? [];
                      List<CompanyWork> a = [];
                      var b = Map<String, List<CompanyWork>>();
                      _companyWork.forEach((doc) => a.add(CompanyWork.fromMap(doc.data, doc.documentID)));

                      _companyWork.forEach((doc){
                        for(int i = 0; i < _coUserName.length; i++)
                        if(doc.data["name"] == _coUserName[2]){
                          List<CompanyWork> c = [];
                          c.add(CompanyWork.fromMap(doc.data, doc.documentID));
                          b[_coUserName[2]] = c;
                          print("C값 ${b[_coUserName[2]][0].name}");
                          b[_coUserName[2]].add(CompanyWork.fromMap(doc.data, doc.documentID));
                        }
                      });

                      for(int i = 0; i < _coUserName.length; i++){

                      }

                      print(b);

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: customWidth(context: context, widthSize: 0.08)),
                        child: Table(
                          border: TableBorder(
                            left: BorderSide(
                              width: 0.2,
                            ),
                            right: BorderSide(
                              width: 0.2,
                            ),
                            bottom: BorderSide(
                              width: 0.2
                            ),
                            horizontalInside: BorderSide(
                              width: 0.2
                            ),
                            verticalInside: BorderSide(
                              width: 0.2
                            ),
                            top: BorderSide(
                              width: 0.2
                            )
                          ),
                          columnWidths: {
                            5: FixedColumnWidth(customWidth(context: context, widthSize: 0.23))
                          },
                          children: [
                            TableRow(
                              children:[
                                Container(
                                  height: customHeight(context: context, heightSize: 0.1),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: customHeight(context: context, heightSize: 0.01), horizontal: customWidth(context: context, widthSize: 0.01)),

                                    child: Container(
                                      color: Colors.yellow,
                                      child: GestureDetector(
                                        onTap: (){
                                          print("테스트입니다");
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        /*Container(
                                          height: customHeight(context: context, heightSize: 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: blueColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "미팅",
                                              style: customStyle(
                                                  fontColor: whiteColor
                                              ),
                                            ),
                                          ),
                                        ),*/
                                        SizedBox(height: customHeight(context: context, heightSize: 0.01),),
                                        /*Container(
                                          height: customHeight(context: context, heightSize: 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: blueColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "외근",
                                              style: customStyle(
                                                  fontColor: whiteColor
                                              ),
                                            ),
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        /*Container(
                                          height: customHeight(context: context, heightSize: 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: blueColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "미팅",
                                              style: customStyle(
                                                  fontColor: whiteColor
                                              ),
                                            ),
                                          ),
                                        ),*/
                                        SizedBox(height: customHeight(context: context, heightSize: 0.01),),
                                        /*Container(
                                          height: customHeight(context: context, heightSize: 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: blueColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "외근",
                                              style: customStyle(
                                                  fontColor: whiteColor
                                              ),
                                            ),
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        /*Container(
                                          height: customHeight(context: context, heightSize: 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: blueColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "미팅",
                                              style: customStyle(
                                                  fontColor: whiteColor
                                              ),
                                            ),
                                          ),
                                        ),*/
                                        SizedBox(height: customHeight(context: context, heightSize: 0.01),),
                                        /*Container(
                                          height: customHeight(context: context, heightSize: 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: blueColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "외근",
                                              style: customStyle(
                                                  fontColor: whiteColor
                                              ),
                                            ),
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        /*Container(
                                          height: customHeight(context: context, heightSize: 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: blueColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "미팅",
                                              style: customStyle(
                                                  fontColor: whiteColor
                                              ),
                                            ),
                                          ),
                                        ),*/
                                        SizedBox(height: customHeight(context: context, heightSize: 0.01),),
                                        /*Container(
                                          height: customHeight(context: context, heightSize: 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: blueColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "외근",
                                              style: customStyle(
                                                  fontColor: whiteColor
                                              ),
                                            ),
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: customHeight(context: context, heightSize: 0.08),
                                  child: Center(
                                    child: Text("나"),
                                  ),
                                ),
                              ]
                            ),
                            TableRow(
                                children:[
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: customHeight(context: context, heightSize: 0.03),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: blueColor
                                            ),
                                            child: GestureDetector(
                                              onTap: (){
                                                print("hihi");
                                              },
                                              child: Center(
                                                child: Text(
                                                  "미팅",
                                                  style: customStyle(
                                                      fontColor: whiteColor
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: customHeight(context: context, heightSize: 0.01),),
                                          /*Container(
                                            height: customHeight(context: context, heightSize: 0.03),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: blueColor
                                            ),
                                            child: Center(
                                              child: Text(
                                                "외근",
                                                style: customStyle(
                                                    fontColor: whiteColor
                                                ),
                                              ),
                                            ),
                                          ),*/
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          /*Container(
                                          height: customHeight(context: context, heightSize: 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: blueColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "미팅",
                                              style: customStyle(
                                                  fontColor: whiteColor
                                              ),
                                            ),
                                          ),
                                        ),*/
                                          SizedBox(height: customHeight(context: context, heightSize: 0.01),),
                                          /*Container(
                                          height: customHeight(context: context, heightSize: 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: blueColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "외근",
                                              style: customStyle(
                                                  fontColor: whiteColor
                                              ),
                                            ),
                                          ),
                                        ),*/
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          /*Container(
                                          height: customHeight(context: context, heightSize: 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: blueColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "미팅",
                                              style: customStyle(
                                                  fontColor: whiteColor
                                              ),
                                            ),
                                          ),
                                        ),*/
                                          SizedBox(height: customHeight(context: context, heightSize: 0.01),),
                                          /*Container(
                                          height: customHeight(context: context, heightSize: 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: blueColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "외근",
                                              style: customStyle(
                                                  fontColor: whiteColor
                                              ),
                                            ),
                                          ),
                                        ),*/
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height:customHeight(context: context,heightSize: 0.08),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Center(
                                        child: Container(
                                            height: customHeight(context: context, heightSize: 0.03),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Colors.purple
                                            ),
                                            child: Center(
                                              child: Text(
                                                "연차",
                                                style: customStyle(
                                                    fontColor: whiteColor
                                                ),
                                              ),
                                            ),
                                          ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          /*Container(
                                          height: customHeight(context: context, heightSize: 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: blueColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "미팅",
                                              style: customStyle(
                                                  fontColor: whiteColor
                                              ),
                                            ),
                                          ),
                                        ),*/
                                          SizedBox(height: customHeight(context: context, heightSize: 0.01),),
                                          /*Container(
                                          height: customHeight(context: context, heightSize: 0.03),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: blueColor
                                          ),
                                          child: Center(
                                            child: Text(
                                              "외근",
                                              style: customStyle(
                                                  fontColor: whiteColor
                                              ),
                                            ),
                                          ),
                                        ),*/
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: customHeight(context: context, heightSize: 0.08),
                                    child: Center(
                                      child: Text("김대성"),
                                    ),
                                  ),
                                ]
                            ),
                          ],
                        ),
                      );

                    },
                  ),
                  /*StreamBuilder(
                    stream: _db.collection("company").document("HYOIE13").collection("work").orderBy("name").where("createUid", whereIn: _coUserUid).where("startDate", isEqualTo: _format.dateTimeToTimeStamp(selectTime)).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(snapshot.data == null){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var _companyWork = snapshot.data.documents ?? [];


                    },
                  ),*/
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
