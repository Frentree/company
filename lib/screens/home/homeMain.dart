//Flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/models/attendanceModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/attendance/attendanceCheck.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/screens/alarm/alarmMain.dart';
import 'package:companyplaylist/screens/approval/approval.dart';
import 'package:companyplaylist/screens/search/searchMain.dart';
import 'package:companyplaylist/screens/setting/settingMain.dart';
import 'package:companyplaylist/widgets/bottomsheet/mainBottomSheet.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Screen
import 'package:companyplaylist/screens/home/homeScheduleMain.dart';
import 'package:provider/provider.dart';

class HomeMainPage extends StatefulWidget {
  @override
  HomeMainPageState createState() => HomeMainPageState();
}

class HomeMainPageState extends State<HomeMainPage> {
  //불러올 페이지 리스트
  List<Widget> _page = [
    HomeScheduleMainPage(),
    SearchMainPage(),
    null,
    AlarmMainPage(),
    SettingMainPage()
  ];

  //현재 페이지 인덱스
  int _currentPateIndex = 0;

  Attendance _attendance = Attendance();

  // 프로필
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  User _loginUser;

  //페이지 이동
  void _pageChange(int pageIndex) {
    if (pageIndex == 2) {
      MainBottomSheet(
          context: context,
          companyCode: _loginUser.companyCode,
          mail: _loginUser.mail);
    } else {
      setState(() {
        print(pageIndex);
        _currentPateIndex = pageIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider =
        Provider.of<LoginUserInfoProvider>(context);
    AttendanceCheck _attendanceCheckProvider =
        Provider.of<AttendanceCheck>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: FutureBuilder(
            future: _attendanceCheckProvider.attendanceCheck(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                _attendance = snapshot.data;
                return Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                        size: customHeight(context: context, heightSize: 0.04),
                        color: Colors.white,
                      ),
                      onPressed: _attendance.status == 0
                          ? () async {
                              await _attendanceCheckProvider.manualOnWork(
                                context: context,
                              );
                            }
                          : _attendance.status != 3
                              ? () async {
                                  await _attendanceCheckProvider.manualOffWork(
                                    context: context,
                                  );
                                }
                              : null,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        _attendanceCheckProvider
                            .attendanceStatus(_attendance.status),
                      ),
                    )
                  ],
                );
              }
            }),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            width: customWidth(context: context, widthSize: 0.2),
            child: GestureDetector(
              child: Container(
                height: customHeight(context: context, heightSize: 0.05),
                width: customWidth(context: context, widthSize: 0.1),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: whiteColor,
                    border: Border.all(color: whiteColor, width: 2)),
                child: FutureBuilder(
                  future: FirebaseRepository()
                      .photoProfile(_loginUser.companyCode, _loginUser.mail),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Icon(Icons.person_outline);
                    }
                    return Image.network(snapshot.data['profilePhoto']);
                  },
                ),
              ),
              onTap: () {
                _loginUserInfoProvider.logoutUesr();
              },
            ),
          ),
        ],
      ),
      body: Container(
        height: heightRatio(
          context: context,
          heightRatio: 0.85,
        ),
        width: customWidth(context: context, widthSize: 1),
        padding: EdgeInsets.only(
            left: customWidth(
              context: context,
              widthSize: 0.02,
            ),
            right: customWidth(
              context: context,
              widthSize: 0.02,
            )),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: whiteColor),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Expanded(
              flex: 11,
              child: _page[_currentPateIndex],
            ),
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
              title: Text("Schedule")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: customHeight(
                  context: context,
                  heightSize: 0.04,
                ),
              ),
              title: Text("Search")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_outline,
                size: customHeight(
                  context: context,
                  heightSize: 0.06,
                ),
                color: blueColor,
              ),
              title: Text("Create")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications_none,
                size: customHeight(
                  context: context,
                  heightSize: 0.04,
                ),
              ),
              title: Text("Push")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.menu,
                size: customHeight(
                  context: context,
                  heightSize: 0.04,
                ),
              ),
              title: Text("Setting")),
        ],
      ),
    );
  }
}
