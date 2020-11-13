import 'dart:io';

import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/attendanceModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/screens/alarm/alarmNotice.dart';
import 'package:companyplaylist/screens/setting/myInfomationCard.dart';
import 'package:companyplaylist/screens/setting/myWork.dart';
import 'package:companyplaylist/widgets/button/textButton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingMainPage extends StatefulWidget{
  @override
  SettingMainPageState createState() => SettingMainPageState();
}

class SettingMainPageState extends State<SettingMainPage>{
  int tabIndex = 0;
  User _loginUser;
  Attendance _attendance = Attendance();
  bool co_worker_alert = true;
  bool approval_alert = false;
  bool commute_alert = true;
  bool notice_alert = false;
  bool doNotDisturb_alert = true;

  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();

    return Scaffold(
      body: ListView(
            children: <Widget>[
              ExpansionTile(                           // 2. 리스트 항목 추가하면 끝!
                leading: Icon(Icons.person_outline),
                title: Text('내 정보'),
                children: [
                  getMyInfomationCard(
                      context: context,
                      user: _loginUser
                  ),
                ],
              ),
              ExpansionTile(
                  leading: Icon(Icons.event_note_outlined),
                  childrenPadding: EdgeInsets.only(left: 30),
                  title: Text('내 근태/연차/급여 조회'),
                  children: <Widget>[
                    ListTile(
                      title: Text("근태 조회"),
                      dense: true,
                      onTap: (){
                        movePage(context, "myWork", "0");
                      },
                    ),
                    ListTile(
                      title: Text("연차 사용 내역 조회"),
                      dense: true,
                      onTap: (){
                        movePage(context, "myWork", "1");
                      },
                    ),
                    ListTile(
                      title: Text("급여 내역 조회"),
                      dense: true,
                      onTap: (){
                        movePage(context, "myWork", "2");
                      },
                    )
                  ]

              ),
              ExpansionTile(
                leading: Icon(Icons.notifications_none_outlined),
                childrenPadding: EdgeInsets.only(left: 30),
                title: Text('알림 설정'),
                children: <Widget>[
                  ListTile(
                    title: Text('동료 일정 등록 시 알림 수신'),
                    dense: true,
                    trailing: Switch(
                      value: co_worker_alert,
                    ),
                  ),
                  ListTile(
                    title: Text('승인 결과 알림'),
                    dense: true,
                    trailing: Switch(
                      value: approval_alert,
                    ),
                  ),
                  ListTile(
                    title: Text('출퇴근 처리 전 미리 알림'),
                    dense: true,
                    trailing: Switch(
                      value: commute_alert,
                    ),
                  ),
                  ListTile(
                    title: Text('공지사항'),
                    dense: true,
                    trailing: Switch(
                      value: notice_alert,
                    ),
                  ),
                  ListTile(
                    title: Text('방해 금지 모드'),
                    dense: true,
                    trailing: Switch(
                      value: doNotDisturb_alert,
                    ),
                  )
                ],
              ),
              ExpansionTile(
                leading: Icon(Icons.desktop_mac),
                title: Text('화면'),
              ),
              ExpansionTile(
                leading: Icon(Icons.help_outline_sharp),
                title: Text('고객지원'),
                children: <Widget>[
                  ListTile(
                    title: Text('도움말'),
                    dense: true,
                  ),
                  ListTile(
                    title: Text('1:1 문의하기'),
                    dense: true,
                  ),
                  ListTile(
                    title: Text('공지사항'),
                    dense: true,
                  ),
                  ListTile(
                    title: Text('서비스 이용약관'),
                    dense: true,
                  ),
                  ListTile(
                    title: Text('개인정보 취급방침'),
                    dense: true,
                  )
                ],
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('앱버전'),
                    Text(
                      '0.01',
                      style: customStyle(
                        fontSize: 12,
                        fontColor: greyColor
                      ),
                    ),
                  ],
                ),
                trailing: Text('최신'),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('로그 아웃'),
              ),
            ],
          )
    );
  }
}

void movePage(BuildContext context, page, tab){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MyWork(),
    ),
  );
}