//Flutter
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/screens/splash.dart';
import 'package:MyCompany/widgets/drawer/menuDrawer.dart';
import 'package:MyCompany/widgets/photo/profilePhoto.dart';
import 'package:MyCompany/models/attendanceModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/attendance/attendanceCheck.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/screens/alarm/alarmMain.dart';
import 'package:MyCompany/screens/setting/settingMain.dart';
import 'package:MyCompany/widgets/bottomsheet/mainBottomSheet.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/widgets/popupMenu/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


//Screen
import 'package:MyCompany/screens/home/homeScheduleMain.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

bool btnClick = false;

class HomeMainPage extends StatefulWidget {
  @override
  HomeMainPageState createState() => HomeMainPageState();
}

class HomeMainPageState extends State<HomeMainPage> {
  DateTime backButtonPressTime;
  int pressCount = 0;

  Future<bool> _onBackPressed() async {
    DateTime now = DateTime.now();
    if(pressCount < 2){
      toastAppClose(context);
      pressCount += 1;
      Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
        pressCount--;
      });
      return Future.value(false);
    }
    else{
      return Future.value(true);
    }
  }

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
  int currentPageIndex = 0;
  String payloadOld = "";
  Attendance _attendance = Attendance();

  // 프로필
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  User _loginUser;
  FirebaseRepository _repository = FirebaseRepository();

  bool click = true;

  //페이지 이동
  void _pageChange(int pageIndex) {
    if (pageIndex == 1) {
      MainBottomSheet(
          context: context,
          companyCode: _loginUser.companyCode,
          mail: _loginUser.mail);
    } else {
      setState(() {
        currentPageIndex = pageIndex;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    currentPageIndex = 0;
    click = false;

    notificationPlugin.setOnNotificationClick(onNotificationClick, onFCMNotificationClick);
  }



  onFCMNotificationClick(String payload) async {
    print("payload ====> $payload");
    print("payloadOld ====> $payloadOld");
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    if(_sharedPreferences.getString("payloadOld") != null){
      payloadOld = _sharedPreferences.getString("payloadOld");
    }

    if(click == false) {
      if(payloadOld == payload || payloadOld == ""){
        payload = "";
      }
      click = !click;
    }

    if(payload.split(",")[0] == "alarm" && click == true){
      setState(() {
        clickTest = true;
        currentPageIndex = 2;
      });

      await _repository.updateReadAlarm(
        companyCode: _loginUser.companyCode,
        mail: _loginUser.mail,
        alarmId: payload.split(",")[1],
      ).whenComplete((){
        click = false;
      });
    }

    else{
      print("실패입니다");
    }
    _sharedPreferences.setString("payloadOld", payload);
  }

  onNotificationClick(String payload) {setState(() {
      currentPageIndex = 0;
    });
  }


  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider =
        Provider.of<LoginUserInfoProvider>(context);
    AttendanceCheck _attendanceCheckProvider =
        Provider.of<AttendanceCheck>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        /*appBar: AppBar(
          backgroundColor: mainColor,

        ),

        endDrawer: Drawer(
          child: MenuDrawer(),
        ),*/
        backgroundColor: mainColor,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 10.0.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 30.0.w : 40.0.w,
                      child: FutureBuilder(
                        future: _attendanceCheckProvider.attendanceCheck(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
                            _attendance = snapshot.data;
                            return Row(
                              children: <Widget>[
                                Container(
                                  width: SizerUtil.deviceType == DeviceType.Tablet ? 15.0.w : 20.0.w,
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    padding: SizerUtil.deviceType == DeviceType.Tablet ? EdgeInsets.only(left: 3.0.w) : EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.power_settings_new_sharp,
                                      color: whiteColor,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                                    ),
                                    onPressed: _attendance.status == 0
                                        ? () async {
                                      await _attendanceCheckProvider.manualOnWork(
                                        context: context,
                                      );
                                    }
                                        :  () async {
                                      await _attendanceCheckProvider.attendanceChange(
                                        context: context,
                                        nowStatus: _attendance.status,
                                      );
                                    }
                                  ),
                                ),
                                Text(
                                  _attendanceCheckProvider.attendanceStatus(_attendance.status),
                                  style: defaultMediumWhiteStyle,
                                )
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 18.75.w : 25.0.w,
                      child: GestureDetector(
                        child: profilePhoto(loginUser: _loginUser),
                        onTap: () {
                          //_loginUserInfoProvider.logoutUesr();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                    right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                    top: 2.0.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
                      topRight: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
                    ),
                    color: whiteColor,
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: [
                            _page[currentPageIndex],
                            StreamBuilder<QuerySnapshot>(
                              stream: _repository.requestAnnualLeaveCount(companyCode: _loginUser.companyCode, loginUserMail: _loginUser.mail),
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return Container();
                                }
                                return Positioned(
                                  right: 0,
                                  bottom: 10,
                                  child: (currentPageIndex == 0 && snapshot.data.docs.length != 0) ? Stack(
                                    children: [
                                      FloatingActionButton(
                                        backgroundColor: mainColor,
                                        child: Icon(
                                          Icons.mail
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            currentPageIndex = 2;
                                            btnClick = true;
                                          });
                                        },
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: new Container(
                                            padding: EdgeInsets.all(1),
                                            constraints: BoxConstraints(
                                              minWidth: 4.0.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: redColor,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              snapshot.data.docs.length.toString(),
                                              style: customStyle(
                                                  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? 10.0.sp : 9.0.sp,
                                                  fontColor: whiteColor,
                                                  fontWeightName: "Medium"
                                              ),
                                              textAlign: TextAlign.center,
                                            )
                                        ),
                                      ),
                                    ],
                                  ) : Container(),
                                );
                              }
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        //네비게이션 바
        bottomNavigationBar: Container(
          child: BottomNavigationBar(
            backgroundColor: whiteColor,
            selectedItemColor: mainColor,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: _pageChange,
            currentIndex: currentPageIndex,
            items: [
              BottomNavigationBarItem(
                icon: (currentPageIndex == 0) ? Icon(
                  Icons.calendar_today,
                  size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                  color: blueColor,
                ) : Icon(
                  Icons.calendar_today,
                  size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                ),
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
                icon: (currentPageIndex == 1) ? Icon(
                  Icons.add_circle_outline_sharp,
                  size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                  color: blueColor,
                ) : Icon(
                  Icons.add_circle_outline_sharp,
                  size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                ),
                label: "Create",
              ),
              BottomNavigationBarItem(
                label: "Push",
                icon: Stack(
                  children: [
                    (currentPageIndex == 2) ? Icon(
                      Icons.notifications_none,
                      size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                      color: blueColor,
                    ) : Icon(
                      Icons.notifications_none,
                      size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                    ),
                    StreamBuilder(
                      stream: _repository.getNoReadAlarm(companyCode: _loginUser.companyCode, mail: _loginUser.mail),
                      builder: (context, snapshot){
                        if(snapshot.data == null){
                          return Center(
                            child: Text(""),
                          );
                        }
                        List<DocumentSnapshot> document = snapshot.data.docs;

                        if(document.length == 0){
                          return Positioned(
                            right: 0,
                            child: new Container(

                            ),
                          );
                        }
                        else {
                          return Positioned(
                            right: 0,
                            child: new Container(
                                padding: EdgeInsets.all(1),
                                constraints: BoxConstraints(
                                  minWidth: 4.0.w,
                                ),
                                decoration: BoxDecoration(
                                  color: redColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  document.length.toString(),
                                  style: customStyle(
                                    fontSize: SizerUtil.deviceType == DeviceType.Tablet ? 10.0.sp : 9.0.sp,
                                    fontColor: whiteColor,
                                    fontWeightName: "Medium"
                                  ),
                                  textAlign: TextAlign.center,
                                )
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                icon: (currentPageIndex == 3) ? Icon(
                  Icons.menu,
                  size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                  color: blueColor,
                ) : Icon(
                  Icons.menu,
                  size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                ),
                label: "Setting",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
