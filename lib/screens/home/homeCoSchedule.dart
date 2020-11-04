//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/widgets/button/textButton.dart';
import 'package:companyplaylist/widgets/card/workCoScheduleCard.dart';

//Flutter
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

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
              availableCalendarFormats: {
                CalendarFormat.week: "Week",
                CalendarFormat.month: "Month"
              },
              onDaySelected: (day, events, holidays) {
                setState(() {
                  selectTime = day;
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
                  selectedColor: mainColor,
                  selectedStyle: customStyle(
                      fontSize: 18,
                      fontWeightName: "Bold",
                      fontColor: whiteColor
                  )
              ),
            ),
          ),

          Container(
            width: customWidth(
              context: context,
              widthSize: 1
            ),
            padding: EdgeInsets.only(
              left: customWidth(
                context: context,
                widthSize: 0.01
              ),
              right: customWidth(
                context: context,
                widthSize: 0.01
              )
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)
                ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Container(
                  height: customHeight(
                      context: context,
                      heightSize: 0.04
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: tabColor
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      tabBtn(
                        context: context,
                        heightSize: 0.03,
                        widthSize: 0.3,
                        btnText: "이름순",
                        tabIndexVariable: tabIndex,
                        tabOrder: 0,
                        tabAction: (){
                          setState(() {
                            tabIndex = 0;
                          });
                        }
                      ),
                      tabBtn(
                          context: context,
                          heightSize: 0.03,
                          widthSize: 0.32,
                          btnText: "상태순",
                          tabIndexVariable: tabIndex,
                          tabOrder: 1,
                          tabAction: (){
                            setState(() {
                              tabIndex = 1;
                            });
                          }
                      ),
                      tabBtn(
                          context: context,
                          heightSize: 0.03,
                          widthSize: 0.3,
                          btnText: "출퇴근 현황",
                          tabIndexVariable: tabIndex,
                          tabOrder: 2,
                          tabAction: (){
                            setState(() {
                              tabIndex = 2;
                            });
                          }
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          StreamBuilder(
            stream:_db.collection("company").document(_companyUser.companyCode).collection("user").snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<DocumentSnapshot> _coUser = snapshot.data.documents ?? [];
              List<String> _coUserUid = [];
              _coUser.forEach((element) {
                if(element.documentID != _companyUser.mail){
                  _coUserUid.add(element.documentID);
                }
                print(_coUserUid);
              });
              return StreamBuilder(
                stream: tabIndex == 0 ? _db.collection("company").document(_companyUser.companyCode).collection("work").orderBy("name").where("createUid", whereIn: _coUserUid).where("startDate", isEqualTo: _format.dateTimeToTimeStamp(selectTime)).snapshots() :
                    _db.collection("company").document(_companyUser.companyCode).collection("work").orderBy("progress").orderBy("name").where("createUid", whereIn: _coUserUid).where("startDate", isEqualTo: _format.dateTimeToTimeStamp(selectTime)).snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.data == null){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var _companyWork = snapshot.data.documents ?? [];

                  _companyWork.forEach((value){
                    
                  });

                  if(_companyWork.length == 0) {
                    return Card(
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
                    );
                  }

                  else{
                    while(isDetail.length < _companyWork.length){
                      isDetail.add(false);
                    }
                    _companyWork.forEach((value){
                      var b = [];
                      b.add(CompanyWork.fromMap(value.data, value.documentID));
                      print("값 $b");
                    });

                    print(_companyWork);
                    return Expanded(
                      child: ListView.builder(
                        itemCount: _companyWork.length,
                        itemBuilder: (context, index) {
                          CompanyWork _companyData = CompanyWork.fromMap(_companyWork[index].data, _companyWork[index].documentID);
                          switch(_companyData.type) {
                            case '내근':
                              return GestureDetector(
                                child: workCoScheduleCard(
                                    context: context,
                                    companyCode: _companyUser.companyCode,
                                    documentId: _companyWork[index].documentID,
                                    companyWork: _companyData,
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
              );
            },
          )
        ],
      ),
    );
  }
}
