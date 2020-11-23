//Flutter
import 'package:companyplaylist/models/attendanceModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/attendance/attendanceCheck.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/screens/alarm/alarmMain.dart';
import 'package:companyplaylist/screens/search/searchMain.dart';
import 'package:companyplaylist/screens/setting/settingMain.dart';
import 'package:companyplaylist/widgets/bottomsheet/mainBottomSheet.dart';
import 'package:companyplaylist/widgets/notImplementedPopup.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Screen
import 'package:companyplaylist/screens/home/homeScheduleMain.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomeMainPage extends StatefulWidget {
  @override
  HomeMainPageState createState() => HomeMainPageState();
}

class HomeMainPageState extends State<HomeMainPage> {
  //불러올 페이지 리스트
  List<Widget> _page = [HomeScheduleMainPage(),SearchMainPage(),null, AlarmMainPage(), SettingMainPage()];

  //현재 페이지 인덱스
  int _currentPateIndex = 0;

  Attendance _attendance = Attendance();

  // 프로필
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  User _loginUser;

  //페이지 이동
  void _pageChange(int pageIndex){
    if(pageIndex == 2){

      //WorkMainPage(context);
      MainBottomSheet(context);
    }
    else{
      setState(() {
        print(pageIndex);
        _currentPateIndex = pageIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();

    AttendanceCheck _attendanceProvider = Provider.of<AttendanceCheck>(context);
    _attendance = _attendanceProvider.getAttendanceData();

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.power_settings_new,
                  size: customHeight(
                      context: context,
                      heightSize: 0.04
                  ),
                  color: Colors.white,
                ),
                onPressed: (){
                  NotImplementedFunction(context);
                /*onPressed: _attendance.status == 1 ? () async {
                  String result = await _attendanceProvider.manualOffWork(
                    context: context,
                  );

                  if(result == "OK"){
                    Fluttertoast.showToast(
                        msg: "퇴근이 정상적으로 처리되었습니다.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity:  ToastGravity.BOTTOM,
                        backgroundColor: blackColor
                    );
                  }
                } : () async {
                  String result = await _attendanceProvider.manualOnWork(
                      context: context
                  );

                  if(result == "OK"){
                    Fluttertoast.showToast(
                        msg: "출근이 정상적으로 처리되었습니다.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity:  ToastGravity.BOTTOM,
                        backgroundColor: blackColor
                    );
                  }*/
                }
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                  "근무중"
              ),
            )
          ],
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            width: customWidth(
                context: context,
                widthSize: 0.2
            ),
            child: GestureDetector(
              child: Container(
                height: customHeight(
                    context: context,
                    heightSize: 0.05
                ),
                width: customWidth(
                    context: context,
                    widthSize: 0.1
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: whiteColor,
                    border: Border.all(color: whiteColor, width: 2)
                ),
                child: FutureBuilder(
                  future: _firebaseStorage.ref().child("profile/${_loginUser.mail}").getDownloadURL(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Icon(
                          Icons.person_outline
                      );
                    }
                    return Image.network(
                        snapshot.data
                    );
                  },
                ),
              ),
              onTap: (){
                _loginUserInfoProvider.logoutUesr();
              },
            ),
          ),
        ],
      ),
      body: Container(
        width: customWidth(
            context: context,
            widthSize: 1
        ),
        padding: EdgeInsets.only(
            left: customWidth(
              context: context,
              widthSize: 0.02,
            ),
            right: customWidth(
              context: context,
              widthSize: 0.02,
            )
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
            ),
            color: whiteColor
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Expanded(
              flex: 11,
              child: _page[_currentPateIndex],
            ),

            //배너
            /*Expanded(
              flex: 2,
              child: Container(
                color: bottomColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: customHeight(context: context, heightSize: 0.03)),
                      child: Text(
                        "슬기로운 회사 생활",
                        style: customStyle(
                          fontSize: 16,
                          fontWeightName: "Regular",
                          fontColor: whiteColor,
                        ),
                      ),
                    ),
                    Image.asset("images/bannerImage.jpg")
                  ],
                ),
              ),
            )*/
          ],
        ),
      ),

      //네비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: whiteColor,
        selectedItemColor: mainColor,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _pageChange,
        currentIndex: _currentPateIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today,
                size: customHeight(
                  context: context,
                  heightSize: 0.04,
                ),
              ),
              title: Text(
                  "Schedule"
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: customHeight(
                  context: context,
                  heightSize: 0.04,
                ),
              ),
              title: Text(
                  "Search"
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_outline,
                size: customHeight(
                  context: context,
                  heightSize: 0.06,
                ),
                color: blueColor,
              ),
              title: Text(
                  "Create"
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications_none,
                size: customHeight(
                  context: context,
                  heightSize: 0.04,
                ),
              ),
              title: Text(
                  "Push"
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.menu,
                size: customHeight(
                  context: context,
                  heightSize: 0.04,
                ),
              ),
              title: Text(
                  "Setting"
              )
          ),
        ],
      ),
    );
  }
}