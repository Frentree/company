//Flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/models/attendanceModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/attendance/attendanceCheck.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/screens/alarm/alarmMain.dart';
import 'package:MyCompany/screens/approval/approval.dart';
import 'package:MyCompany/screens/search/searchMain.dart';
import 'package:MyCompany/screens/setting/settingMain.dart';
import 'package:MyCompany/widgets/bottomsheet/mainBottomSheet.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/screens/alarm/alarmMain.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/widgetSize.dart';

//Screen
import 'package:MyCompany/screens/home/homeScheduleMain.dart';
import 'package:provider/provider.dart';

import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

class HomeMainPage extends StatefulWidget {
  @override
  HomeMainPageState createState() => HomeMainPageState();
}

class HomeMainPageState extends State<HomeMainPage> {
  //불러올 페이지 리스트
  List<Widget> _page = [
    HomeScheduleMainPage(),

    /// 기능 미구현으로 인한 숨김 처리
    //SearchMainPage(),
    null,
    AlarmMainPage(),
    SettingMainPage()
  ];

  //현재 페이지 인덱스
  int _currentPageIndex = 0;

  Attendance _attendance = Attendance();

  // 프로필
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  User _loginUser;

  //페이지 이동
  void _pageChange(int pageIndex) {
    if (pageIndex == 1) {
      MainBottomSheet(
          context: context,
          companyCode: _loginUser.companyCode,
          mail: _loginUser.mail);
    } else {
      setState(() {
        print(pageIndex);
        _currentPageIndex = pageIndex;
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
                        size: iconSizeW.w,
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
                      padding: EdgeInsets.only(left: 2.0.w),
                      child: Text(
                        _attendanceCheckProvider
                            .attendanceStatus(_attendance.status),
                        style: customStyle(
                          fontSize: homePageDefaultFontSize.sp,
                          fontColor: Colors.white,
                        ),
                      ),
                    )
                  ],
                );
              }
            }),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            width: 20.0.w,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                color: whiteColor,
                width: 10.0.w,
                height: 7.0.h,
                child: FutureBuilder(
                  future: FirebaseRepository().photoProfile(_loginUser.companyCode, _loginUser.mail),
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
        height: 85.0.h,
        width: 100.0.w,
        padding: EdgeInsets.only(
          left: 2.0.w,
          right: 2.0.w,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(pageRadiusW.w),
                topRight: Radius.circular(pageRadiusW.w)),
            color: whiteColor),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
            ),
            Expanded(
              child: _page[_currentPageIndex],
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
        currentIndex: _currentPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: (_currentPageIndex == 0)
                ? Icon(
                    Icons.calendar_today,
                    size: iconSizeW.w,
                    color: blueColor,
                  )
                : Icon(Icons.calendar_today, size: iconSizeW.w),
            label: "Schedule",
          ),

          /// 기능 미구현으로 인한 숨김 처리
          /*BottomNavigationBarItem(
          icon: (_currentPateIndex == 0)
                  ? Icon(
                      Icons.search,
                      size: customHeight(
                        context: context,
                        heightSize: 0.06,
                      ),
                color: blueColor,
                    )
                  : Icon(
                      Icons.search,
                      size: customHeight(
                        context: context,
                        heightSize: 0.04,
                      ),
                    ),
              =
              title: Text("Search")),*/
          BottomNavigationBarItem(
            icon: (_currentPageIndex == 1)
                ? Icon(
                    Icons.add_circle_outline,
                    size: iconSizeW.w,
                    color: blueColor,
                  )
                : Icon(
                    Icons.add_circle_outline,
                    size: iconSizeW.w,
                  ),
            label: "Create",
          ),
          BottomNavigationBarItem(
            icon: (_currentPageIndex == 2)
                ? Icon(
                    Icons.notifications_none,
                    size: iconSizeW.w,
                    color: blueColor,
                  )
                : Icon(
                    Icons.notifications_none,
                    size: iconSizeW.w,
                  ),
            label: "Push",
          ),
          BottomNavigationBarItem(
            icon: (_currentPageIndex == 3)
                ? Icon(
                    Icons.menu,
                    size: iconSizeW.w,
                    color: blueColor,
                  )
                : Icon(
                    Icons.menu,
                    size: iconSizeW.w,
                  ),
            label: "Setting",
          ),
        ],
      ),
    );
  }
}
