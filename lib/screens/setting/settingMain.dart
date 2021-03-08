import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/universalString.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingInquireAdmin.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingAnnualLeave.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingHelp.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingInquire.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingNotice.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingOrganizationChart.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingPosition.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingTermsOfService.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingUserAddDelete.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingUserManager.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingWifi.dart';
import 'package:MyCompany/widgets/card/settingInfomationCard.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


final word = Words();

class SettingMainPage extends StatefulWidget {
  @override
  SettingMainPageState createState() => SettingMainPageState();
}

class SettingMainPageState extends State<SettingMainPage> {
  List<bool> tabIndex = [false, false, false, false, false];
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
                (grade.contains(9) || grade.contains(8)) ? Container(
                  decoration: tabIndex[0] == false ? BoxDecoration() : BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 0.075.w : 0.1.w,
                          color: dividerColor,
                        ),
                        bottom: BorderSide(
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 0.075.w : 0.1.w,
                          color: dividerColor,
                        ),
                      )
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 9.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                            child: Icon(
                              Icons.apartment_sharp,
                              size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                              color: mainColor,
                            ),
                          ),
                          cardSpace,
                          Container(
                            height: 9.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 71.0.w : 62.0.w,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              word.companyInfomation(), // 회사 정보
                              style: defaultMediumStyle,
                            ),
                          ),
                          Container(
                              height: 9.0.h,
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                              child: IconButton(
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  tabIndex[0] == false ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up_sharp,
                                  size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                                  color: mainColor,
                                ),
                                onPressed: (){;
                                setState(() {
                                  tabIndex[0] = !tabIndex[0];
                                });
                                },
                              )
                          )
                        ],
                      ),
                      tabIndex[0] == false ? Container() : getCompanyInfomationCard(
                        context: context, user: _loginUser,
                        statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(context).context).context).padding.top,
                      )
                    ],
                  ),
                ) : Container(),
                (grade.contains(9) || grade.contains(8)) ? Container(
                  decoration: tabIndex[1] == false ? BoxDecoration() : BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 0.075.w : 0.1.w,
                          color: dividerColor,
                        ),
                        bottom: BorderSide(
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 0.075.w : 0.1.w,
                          color: dividerColor,
                        ),
                      )
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 9.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                            child: Icon(
                              Icons.people_outline,
                              size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                              color: mainColor,
                            ),
                          ),
                          cardSpace,
                          Container(
                            height: 9.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 71.0.w : 62.0.w,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              word.userManager(),
                              style: defaultMediumStyle,
                            ),
                          ),
                          Container(
                              height: 9.0.h,
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                              child: IconButton(
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  tabIndex[1] == false ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up_sharp,
                                  size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                                  color: mainColor,
                                ),
                                onPressed: (){
                                  setState(() {
                                    tabIndex[1] = !tabIndex[1];
                                  });
                                },
                              )
                          )
                        ],
                      ),
                      tabIndex[1] == false ? Container() : Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                    child: Icon(
                                      Icons.account_tree_outlined,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 5.25.w : 7.0.w,
                                      color: mainColor,
                                    ),
                                  ),
                                  cardSpace,
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 73.0.w : 64.0.w,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      word.organizationChart(),
                                      style: defaultRegularStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: (){
                              SettingOrganizationChart(
                                context: context,
                                statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(context).context).context).padding.top
                              );
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                    child: Icon(
                                      Icons.account_box_outlined,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 5.25.w : 7.0.w,
                                      color: mainColor,
                                    ),
                                  ),
                                  cardSpace,
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 73.0.w : 64.0.w,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      word.positionManagerment(),
                                      style: defaultRegularStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: (){
                              SettingPosition(
                                context: context,
                                statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(context).context).context).padding.top
                              );
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                    child: Icon(
                                      Icons.person_add_alt_1_outlined,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 5.25.w : 7.0.w,
                                      color: mainColor,
                                    ),
                                  ),
                                  cardSpace,
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 73.0.w : 64.0.w,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      word.userAddRquestAndDelete(),
                                      style: defaultRegularStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: (){
                              settingUserAddDelete(context: context, statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(context).context).context).padding.top);
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                    child: Icon(
                                      Icons.badge,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 5.25.w : 7.0.w,
                                      color: mainColor,
                                    ),
                                  ),
                                  cardSpace,
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 73.0.w : 64.0.w,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      word.userGradeManager(), // 회사 정보
                                      style: defaultRegularStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: (){
                              SettingUserManager(context: context, statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(context).context).context).padding.top);
                            },
                          ),
                          emptySpace,
                        ],
                      ),
                    ],
                  ),
                ) : Container(),
                (grade.contains(9) || grade.contains(8)) ?
                    Container(
                      decoration: tabIndex[2] == false ? BoxDecoration() : BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 0.075.w : 0.1.w,
                              color: dividerColor,
                            ),
                            bottom: BorderSide(
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 0.075.w : 0.1.w,
                              color: dividerColor,
                            ),
                          )
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 9.0.h,
                                width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                child: Icon(
                                  Icons.power_settings_new,
                                  size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                                  color: mainColor,
                                ),
                              ),
                              cardSpace,
                              Container(
                                height: 9.0.h,
                                width: SizerUtil.deviceType == DeviceType.Tablet ? 71.0.w : 62.0.w,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "출퇴근 인증 기기",
                                  style: defaultMediumStyle,
                                ),
                              ),
                              Container(
                                  height: 9.0.h,
                                  width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                  child: IconButton(
                                    constraints: BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      tabIndex[2] == false ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up_sharp,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                                      color: mainColor,
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        tabIndex[2] = !tabIndex[2];
                                      });
                                    },
                                  )
                              )
                            ],
                          ),
                          tabIndex[2] == false ? Container() : Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 8.0.h,
                                        width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                        child: Icon(
                                          Icons.wifi,
                                          size: SizerUtil.deviceType == DeviceType.Tablet ? 5.25.w : 7.0.w,
                                          color: mainColor,
                                        ),
                                      ),
                                      cardSpace,
                                      Container(
                                        height: 8.0.h,
                                        width: SizerUtil.deviceType == DeviceType.Tablet ? 73.0.w : 64.0.w,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "WIFI 허용 목록 보기",
                                          style: defaultRegularStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: (){
                                  settingWifi(
                                      context: context,
                                      statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(context).context).context).padding.top
                                  );
                                },
                              ),
                              emptySpace,
                            ],
                          ),
                        ],
                      ),
                    ) : Container(),
                Container(
                  decoration: tabIndex[3] == false ? BoxDecoration() : BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 0.075.w : 0.1.w,
                          color: dividerColor,
                        ),
                        bottom: BorderSide(
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 0.075.w : 0.1.w,
                          color: dividerColor,
                        ),
                      )
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 9.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                            child: Icon(
                              Icons.person_outline,
                              size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                              color: mainColor,
                            ),
                          ),
                          cardSpace,
                          Container(
                            height: 9.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 71.0.w : 62.0.w,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              word.myInfomation(), // 내 정보
                              style: defaultMediumStyle,
                            ),
                          ),
                          Container(
                              height: 9.0.h,
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                              child: IconButton(
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  tabIndex[3] == false ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up_sharp,
                                  size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                                  color: mainColor,
                                ),
                                onPressed: (){
                                  setState(() {
                                    tabIndex[3] = !tabIndex[3];
                                  });
                                },
                              )
                          )
                        ],
                      ),
                      tabIndex[3] == false ? Container() : getMyInfomationCard(
                        context: context, user: _loginUser,
                        statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(context).context).context).padding.top,
                      ),
                    ],
                  ),
                ),
/*
                Container(
                  decoration: tabIndex[4] == false ? BoxDecoration() : BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 0.075.w : 0.1.w,
                          color: dividerColor,
                        ),
                        bottom: BorderSide(
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 0.075.w : 0.1.w,
                          color: dividerColor,
                        ),
                      )
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 9.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                            child: Icon(
                              Icons.event_note_outlined,
                              size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                              color: mainColor,
                            ),
                          ),
                          cardSpace,
                          Container(
                            height: 9.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 71.0.w : 62.0.w,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "내 근태/연차/급여 조회", // 내 정보
                              style: defaultMediumStyle,
                            ),
                          ),
                          Container(
                              height: 9.0.h,
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                              child: IconButton(
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  tabIndex[4] == false ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up_sharp,
                                  size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                                  color: mainColor,
                                ),
                                onPressed: (){
                                  setState(() {
                                    tabIndex[4] = !tabIndex[4];
                                  });
                                },
                              )
                          )
                        ],
                      ),
                      tabIndex[4] == false ? Container() : Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                    child: Icon(
                                      Icons.timelapse_outlined,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 5.25.w : 7.0.w,
                                      color: mainColor,
                                    ),
                                  ),
                                  cardSpace,
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 73.0.w : 64.0.w,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "연차 사용 내역 조회",
                                      style: defaultRegularStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: (){
                              SettingAnnualLeave(
                                  context: context,
                                  statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(context).context).context).padding.top
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),*/

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

                Container(
                  decoration: tabIndex[4] == false ? BoxDecoration() : BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 0.075.w : 0.1.w,
                          color: dividerColor,
                        ),
                        bottom: BorderSide(
                          width: SizerUtil.deviceType == DeviceType.Tablet ? 0.075.w : 0.1.w,
                          color: dividerColor,
                        ),
                      )
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 9.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                            child: Icon(
                              Icons.info_outline,
                              size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                              color: mainColor,
                            ),
                          ),
                          cardSpace,
                          Container(
                            height: 9.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 71.0.w : 62.0.w,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              Words.word.serviceCenter(), // 고객지원
                              style: defaultMediumStyle,
                            ),
                          ),
                          Container(
                              height: 9.0.h,
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                              child: IconButton(
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  tabIndex[4] == false ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up_sharp,
                                  size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                                  color: mainColor,
                                ),
                                onPressed: (){
                                  setState(() {
                                    tabIndex[4] = !tabIndex[4];
                                  });
                                },
                              )
                          )
                        ],
                      ),
                      tabIndex[4] == false ? Container() : Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                    child: Icon(
                                      Icons.help,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 5.25.w : 7.0.w,
                                      color: mainColor,
                                    ),
                                  ),
                                  cardSpace,
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 73.0.w : 64.0.w,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Words.word.Help(),
                                      style: defaultRegularStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: (){
                              SettingHelp(
                                  context: context,
                                  statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(context).context).context).padding.top
                              );
                            },
                          ),
                          (_loginUser.companyCode == "0S9YLBX") ? GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                    child: Icon(
                                      Icons.question_answer_outlined,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 5.25.w : 7.0.w,
                                      color: mainColor,
                                    ),
                                  ),
                                  cardSpace,
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 73.0.w : 64.0.w,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Words.word.InquireResponse(),
                                      style: defaultRegularStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: (){
                              SettingInquireAdmin(
                                  context: context,
                                  statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(context).context).context).padding.top
                              );
                            },
                          ) :
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                    child: Icon(
                                      Icons.question_answer_outlined,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 5.25.w : 7.0.w,
                                      color: mainColor,
                                    ),
                                  ),
                                  cardSpace,
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 73.0.w : 64.0.w,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Words.word.Inquire(),
                                      style: defaultRegularStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: (){
                              SettingInquire(
                                  context: context,
                                  statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(context).context).context).padding.top
                              );
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                    child: Icon(
                                      Icons.add_alert_rounded,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 5.25.w : 7.0.w,
                                      color: mainColor,
                                    ),
                                  ),
                                  cardSpace,
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 73.0.w : 64.0.w,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Words.word.notice(),
                                      style: defaultRegularStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: (){
                              SettingNotice(context: context, statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(context).context).context).padding.top);
                            },
                          ),
                          /*GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                    child: Icon(
                                      Icons.medical_services_outlined,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 5.25.w : 7.0.w,
                                      color: mainColor,
                                    ),
                                  ),
                                  cardSpace,
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 73.0.w : 64.0.w,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Words.word.TermsOfService(), // 서비스 이용약관
                                      style: defaultRegularStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: (){
                              SettingTermsOfService(context: context, statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(context).context).context).padding.top);
                            },
                          ),*/
                          /*GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                    child: Icon(
                                      Icons.badge,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 5.25.w : 7.0.w,
                                      color: mainColor,
                                    ),
                                  ),
                                  cardSpace,
                                  Container(
                                    height: 8.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 73.0.w : 64.0.w,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Words.word.personalInfomation(), // 개인정보 취급방식
                                      style: defaultRegularStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: (){
                              SettingUserManager(context: context, statusBarHeight: MediaQuery.of(Scaffold.of(Scaffold.of(context).context).context).padding.top);
                            },
                          ),*/
                          emptySpace,
                        ],
                      ),
                    ],
                  ),
                ),
                /*Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 9.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                            child: Icon(
                              Icons.info_outline,
                              size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                              color: mainColor,
                            ),
                          ),
                          cardSpace,
                          Container(
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 78.5.w : 72.0.w,
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  word.serviceCenter(), // 회사 정보
                                  style: defaultMediumStyle,
                                ),
                                Text(
                                  "frentreedev@frentree.com", // 회사 정보
                                  style: hintStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),*/
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 9.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                            child: Icon(
                              Icons.perm_device_info,
                              size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                              color: mainColor,
                            ),
                          ),
                          cardSpace,
                          Container(
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 71.5.w : 62.0.w,
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  word.appVersion(), // 회사 정보
                                  style: defaultMediumStyle,
                                ),
                                Text(
                                  APP_VERSION, // 회사 정보
                                  style: hintStyle,
                                ),
                              ],
                            ),
                          ),
                          Container(
                              height: 9.0.h,
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                word.newVersion(),
                                style: defaultRegularStyle,
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 9.0.h,
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                              child: Icon(
                                Icons.logout,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                                color: mainColor,
                              ),
                            ),
                            cardSpace,
                            Container(
                                height: 9.0.h,
                                width: SizerUtil.deviceType == DeviceType.Tablet ? 78.5.w : 72.0.w,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  word.logout(),
                                  style: defaultMediumStyle,
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  onTap: (){
                    _loginUserInfoProvider.logoutUser();
                  },
                ),
              ],
            );
          },
        )
    );
  }
}
