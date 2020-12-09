import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/attendanceModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/screens/alarm/alarmNotice.dart';
import 'package:companyplaylist/screens/setting/myInfomationCard.dart';
import 'package:companyplaylist/screens/setting/myWork.dart';
import 'package:companyplaylist/widgets/bottomsheet/setting/settingUserAddDelete.dart';
import 'package:companyplaylist/widgets/bottomsheet/setting/settingUserManager.dart';
import 'package:companyplaylist/widgets/button/textButton.dart';
import 'package:companyplaylist/widgets/notImplementedPopup.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingMainPage extends StatefulWidget {
  @override
  SettingMainPageState createState() => SettingMainPageState();
}

class SettingMainPageState extends State<SettingMainPage> {
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
    LoginUserInfoProvider _loginUserInfoProvider =
        Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();

    return Scaffold(
        body: FutureBuilder(
      future: FirebaseRepository()
          .userGrade(_loginUser.companyCode, _loginUser.mail),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        List<dynamic> grade = snapshot.data['level'];
        return ListView(
          children: <Widget>[
            (grade.contains(9) || grade.contains(8))
                ? ExpansionTile(
                    // 2. 리스트 항목 추가하면 끝!
                    leading: Icon(Icons.person_outline),
                    title: Text(
                      '회사 정보',
                      style: customStyle(fontColor: Colors.green),
                    ),
                    children: [],
                  )
                : SizedBox(),
            (grade.contains(9) || grade.contains(8))
                ? ExpansionTile(
                    // 2. 리스트 항목 추가하면 끝!
                    leading: Icon(Icons.people_outline),
                    title: Text(
                      '사용자 관리',
                      style: customStyle(fontColor: Colors.green),
                    ),
                    childrenPadding: EdgeInsets.only(left: 20),
                    children: [
                      ListTile(
                        leading: Icon(Icons.account_tree_outlined),
                        title: Text('조직도'),
                        dense: true,
                        onTap: () {
                          NotImplementedFunction(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person_add_alt_1_outlined),
                        title: Text('사용자 추가 요청/삭제'),
                        dense: true,
                        onTap: () {
                          settingUserAddDelete(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.badge),
                        title: Text('사용자 권한 관리'),
                        dense: true,
                        onTap: () {
                          SettingUserManager(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.list_alt_sharp),
                        title: Text('사용자별 근채/연차/급여 조회'),
                        dense: true,
                        onTap: () {
                          NotImplementedFunction(context);
                        },
                      ),
                    ],
                  )
                : SizedBox(),
            ExpansionTile(
              // 2. 리스트 항목 추가하면 끝!
              leading: Icon(Icons.person_outline),
              title: Text('내 정보'),
              children: [
                getMyInfomationCard(context: context, user: _loginUser),
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
                    onTap: () {
                      NotImplementedFunction(context);
                      //movePage(context, "myWork", "0");
                    },
                  ),
                  ListTile(
                    title: Text("연차 사용 내역 조회"),
                    dense: true,
                    onTap: () {
                      NotImplementedFunction(context);
                      //movePage(context, "myWork", "1");
                    },
                  ),
                  ListTile(
                    title: Text("급여 내역 조회"),
                    dense: true,
                    onTap: () {
                      NotImplementedFunction(context);
                      //movePage(context, "myWork", "2");
                    },
                  )
                ]),
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
                  onTap: () {
                    NotImplementedFunction(context);
                  },
                ),
                ListTile(
                  title: Text('1:1 문의하기'),
                  dense: true,
                  onTap: () {
                    NotImplementedFunction(context);
                  },
                ),
                ListTile(
                  title: Text('공지사항'),
                  dense: true,
                  onTap: () {
                    NotImplementedFunction(context);
                  },
                ),
                ListTile(
                  title: Text('서비스 이용약관'),
                  dense: true,
                  onTap: () {
                    NotImplementedFunction(context);
                  },
                ),
                ListTile(
                  title: Text('개인정보 취급방침'),
                  dense: true,
                  onTap: () {
                    NotImplementedFunction(context);
                  },
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
                    style: customStyle(fontSize: 12, fontColor: grayColor),
                  ),
                ],
              ),
              trailing: Text('최신'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('로그 아웃'),
              onTap: () {
                _loginUserInfoProvider.logoutUesr();
              },
            ),
          ],
        );
      },
    ));
  }
}

void movePage(BuildContext context, page, tab) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MyWork(),
    ),
  );
}
