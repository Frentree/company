import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/screens/setting/myWork.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingOrganizationChart.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingPosition.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingUserAddDelete.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingUserManager.dart';
import 'package:MyCompany/widgets/card/settingInfomationCard.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/widgets/notImplementedPopup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';

final word = Words();

class SettingMainPage extends StatefulWidget {
  @override
  SettingMainPageState createState() => SettingMainPageState();
}

class SettingMainPageState extends State<SettingMainPage> {
  int tabIndex = 0;
  User _loginUser;
  bool co_worker_alert = true;
  bool approval_alert = false;
  bool commute_alert = true;
  bool notice_alert = false;
  bool doNotDisturb_alert = true;

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider =
        Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();
    return Scaffold(
        backgroundColor: whiteColor,
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
                        leading: Icon(
                          Icons.person_outline,
                          size: iconSizeW.w,
                        ),
                        title: Text(
                          word.companyInfomation(), // 회사 정보
                          style: customStyle(
                            fontColor: Colors.green,
                            fontSize: homePageDefaultFontSize,
                          ),
                        ),
                        children: [
                          getCompanyInfomationCard(
                              context: context, user: _loginUser)
                        ],
                      )
                    : SizedBox(),
                (grade.contains(9) || grade.contains(8))
                    ? ExpansionTile(
                        // 2. 리스트 항목 추가하면 끝!
                        leading: Icon(
                          Icons.people_outline,
                          size: iconSizeW.w,
                        ),
                        title: Text(
                          word.userManager(),
                          style: customStyle(
                            fontColor: Colors.green,
                            fontSize: homePageDefaultFontSize,
                          ),
                        ),
                        childrenPadding: EdgeInsets.only(left: 5.0.w),
                        children: [
                          // 조직도
                          ListTile(
                            leading: Icon(
                              Icons.account_tree_outlined,
                              size: 7.0.w,
                            ),
                            title: Text(
                              word.organizationChart(),
                              style: customStyle(
                                fontSize: 12.0.sp,
                              ),
                            ),
                            dense: true,
                            onTap: () {
                              SettingOrganizationChart(context);
                            },
                          ),
                          // 직급관리
                          ListTile(
                            leading: Icon(
                              Icons.account_box_outlined,
                              size: 7.0.w,
                            ),
                            title: Text(
                              word.positionManagerment(),
                              style: customStyle(
                                fontSize: 12.0.sp,
                              ),
                            ),
                            dense: true,
                            onTap: () {
                              SettingPosition(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.person_add_alt_1_outlined,
                              size: 7.0.w,
                            ),
                            title: Text(
                              word.userAddRquestAndDelete(),
                              style: customStyle(
                                fontSize: 12.0.sp,
                              ),
                            ),
                            dense: true,
                            onTap: () {
                              settingUserAddDelete(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.badge,
                              size: 7.0.w,
                            ),
                            title: Text(
                              word.userGradeManager(),
                              style: customStyle(
                                fontSize: 12.0.sp,
                              ),
                            ),
                            dense: true,
                            onTap: () {
                              SettingUserManager(context);
                            },
                          ),

                          /// 기능 미구현으로 인한 숨김 처리
                          /*ListTile(
                      leading: Icon(Icons.list_alt_sharp),
                      title: Text('사용자별 근채/연차/급여 조회'),
                      dense: true,
                      onTap: () {
                        NotImplementedFunction(context);
                      },
                    ),*/
                        ],
                      )
                    : SizedBox(),
                ExpansionTile(
                  // 2. 리스트 항목 추가하면 끝!
                  leading: Icon(
                    Icons.person_outline,
                    size: iconSizeW.w,
                  ),
                  title: Text(
                    word.myInfomation(),
                    style: customStyle(
                      fontSize: homePageDefaultFontSize,
                    ),
                  ),
                  children: [
                    getMyInfomationCard(context: context, user: _loginUser),
                  ],
                ),

                /// 기능 미구현으로 인한 숨김 처리
                /*ExpansionTile(
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
                    ]),*/

                /// 기능 미구현으로 인한 숨김 처리
                /*ExpansionTile(
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
                ),*/

                /// 기능 미구현으로 인한 숨김 처리
                /*ExpansionTile(
                  leading: Icon(Icons.desktop_mac),
                  title: Text('화면'),
                ),*/

                /// 기능 미구현으로 인한 숨김 처리
                /*ExpansionTile(
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
                ),*/
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    size: iconSizeW.w,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        word.serviceCenter(),
                        style: customStyle(
                          fontSize: homePageDefaultFontSize,
                        ),
                      ),
                      Text(
                        'pe.jeon87@frentree.com',
                        style: customStyle(
                            fontSize: 12.0.sp, fontColor: grayColor),
                      ),
                    ],
                  ),
                ),

                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    size: iconSizeW.w,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        word.appVersion(),
                        style: customStyle(
                          fontSize: homePageDefaultFontSize,
                        ),
                      ),
                      Text(
                        '0.01',
                        style: customStyle(
                            fontSize: 12.0.sp, fontColor: grayColor),
                      ),
                    ],
                  ),
                  trailing: Text(word.newVersion()),
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    size: iconSizeW.w,
                  ),
                  title: Text(
                    word.logout(),
                    style: customStyle(
                      fontSize: homePageDefaultFontSize,
                    ),
                  ),
                  onTap: () {
                    _loginUserInfoProvider.logoutUesr();
                  },
                ),
              ],
            );
          },
        ));
  }

  void movePage(BuildContext context, page, tab) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyWork(),
      ),
    );
  }
}
