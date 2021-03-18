import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/universalString.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingCompanyUser.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingExpenseAnnual.dart';
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
import 'package:flutter_grid_button/flutter_grid_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SettingMainCopyPage extends StatefulWidget {
  @override
  SettingMainCopyPageState createState() => SettingMainCopyPageState();
}

class SettingMainCopyPageState extends State<SettingMainCopyPage> {
  User _loginUser;


  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider =
    Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();
    return Scaffold(
        backgroundColor: whiteColor,
        body: GridButton(
          borderWidth: 0,
          onPressed: (value) {
          },
          items: [
            [
              GridButtonItem(
                title: "회사정보",
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.apartment_sharp,
                        color: mainColor
                      ),
                      Text(
                        Words.word.companyInfomation(),
                        style: defaultMediumStyle,
                      ),
                    ],
                  ),
                ),
                flex: 1,
                value: "1",
              ),
              GridButtonItem(
                title: "사용자 관리",
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          Icons.people_outline,
                          color: mainColor
                      ),
                      Text(
                        Words.word.userManager(),
                        style: defaultMediumStyle,
                      ),
                    ],
                  ),
                ),
                flex: 1,
                value: "2",
              ),
              GridButtonItem(
                title: "출퇴근 인증 기기",
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          Icons.important_devices,
                          color: mainColor
                      ),
                      Text(
                        "인증 기기",
                        style: defaultMediumStyle,
                      ),
                    ],
                  ),
                ),
                flex: 1,
                value: "3",
              ),
            ],
            [
              GridButtonItem(
                title: "고객지원",
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          Icons.info_outline,
                          color: mainColor
                      ),
                      Text(
                        Words.word.serviceCenter(),
                        style: defaultMediumStyle,
                      ),
                    ],
                  ),
                ),
                flex: 1,
                value: "4",
              ),
              GridButtonItem(
                title: "연차/경비",
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          Icons.work_outline,
                          color: mainColor
                      ),
                      Text(
                        "연차/경비",
                        style: defaultMediumStyle,
                      ),
                    ],
                  ),
                ),
                flex: 1,
                value: "5",
              ),
              GridButtonItem(
                title: "앱버전",
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          Icons.perm_device_info,
                          color: mainColor
                      ),
                      Text(
                        Words.word.appVersion(),
                        style: defaultMediumStyle,
                      ),
                      Text(
                        APP_VERSION,
                        style: hintStyle,
                      ),
                    ],
                  ),
                ),
                flex: 1,
                value: "6",
              ),
            ],
            [
              GridButtonItem(
                title: "로그아웃",
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          Icons.logout,
                          color: mainColor
                      ),
                      Text(
                        Words.word.logout(),
                        style: defaultMediumStyle,
                      ),
                    ],
                  ),
                ),
                flex: 1,
                value: "7",
              ),
              GridButtonItem(
                title: "",
              ),
              GridButtonItem(
                title: "",
              ),
            ],
            [],
            [],
          ],
        )
    );
  }
}
