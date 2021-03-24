import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseMethod.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/screens/alarm/alarmNoticeDetails.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/dialog/annualDialogList.dart';
import 'package:MyCompany/widgets/dialog/companyUserDialogList.dart';
import 'package:MyCompany/widgets/dialog/organizationChartDialogList.dart';
import 'package:MyCompany/widgets/notImplementedPopup.dart';
import 'package:MyCompany/widgets/popupMenu/expensePopupMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();

class SettingCompanyUserDetailPage extends StatefulWidget {
  @override
  _SettingCompanyUserDetailPageState createState() => _SettingCompanyUserDetailPageState();
}

class _SettingCompanyUserDetailPageState extends State<SettingCompanyUserDetailPage> {
  @override
  Widget build(BuildContext context) {
    User _loginUser;
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();
    
    return Scaffold(
      backgroundColor: whiteColor,
      body: _buildBody(context, _loginUser),
    );
  }

 
}

Widget _buildBody(BuildContext context, User user) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseRepository().getCompanyUsers(
      companyCode: user.companyCode
    ),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.docs, user.companyCode);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, String companyCode) {
  return CustomScrollView(
    slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate(
                (context, index) => _buildListItem(context, snapshot[index], companyCode),
            childCount: snapshot.length),
      ),
    ],
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data, String companyCode) {
  final companyUser = CompanyUser.fromSnapshow(data);

  return Container(
    padding: cardPadding,
    height: 15.0.h,
    decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: grayColor
            )
        )
    ),
    child: _buildUserList(context, companyUser, companyCode),
  );
}

Widget _buildUserList(BuildContext context, CompanyUser companyUser, String companyCode) {
  Format _format = Format();

  return Row(
    children: [
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "이름 : " + companyUser.name,
              style: cardMainStyle,
            ),
            treeSpace,
            Text(
              "팀 : " + companyUser.team,
              style: cardMainStyle,
            ),
            treeSpace,
            Text(
              "전화 : " + companyUser.phone,
              style: cardMainStyle,
            ),
          ],
        ),
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "직급 : " + companyUser.position,
              style: cardMainStyle,
            ),
            treeSpace,
            Text(
              "입사일 : " + companyUser.enteredDate,
              style: cardMainStyle,
            ),
            treeSpace,
            Text(
              "생일 : " + _format.yearMonthDay(companyUser.birthday),
              style: cardMainStyle,
            ),
          ],
        ),
      ),
      PopupMenuButton(
        icon: Icon(
          Icons.arrow_forward_ios,
          size: 15,
        ),
        onSelected: (val) {
          switch(val) {
            case 2 : updateUserInfomation(
              companyCode: companyCode,
              context: context,
              user: companyUser
            );
            break;
          }
        },
        itemBuilder: (context) => [
          /*PopupMenuItem(
            height: 7.0.h,
            value: 1,
            child: Row(
              children: [
                Container(
                  child: Icon(
                    Icons.remove_red_eye_outlined,
                    size: 20,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w)),
                Text(
                  "보기",
                  style: cardMainStyle,
                )
              ],
            ),
          ),*/
          PopupMenuItem(
            height: 7.0.h,
            value: 2,
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  size: 20,
                ),
                Padding(padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w)),
                Text(
                  Words.word.update(),
                  style: cardMainStyle,
                )
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

