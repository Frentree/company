import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();
double count = 15.0;

class AnnualLeavePage extends StatefulWidget {
  @override
  _AnnualLeavePageState createState() => _AnnualLeavePageState();
}

class _AnnualLeavePageState extends State<AnnualLeavePage> {
  @override
  User _loginUser;
  String yearDate = DateTime.now().year.toString();
  int changeDate = 0;

  Widget build(BuildContext context) {
    count = 15.0;
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_sharp),
                  onPressed: () {
                    setState(() {
                      changeDate -= 1;
                      yearDate = (DateTime.now().year + changeDate).toString();
                    });
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(yearDate + " 년", style: defaultMediumStyle),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios_sharp),
                  onPressed: () {
                    setState(() {
                      changeDate += 1;
                      yearDate = (DateTime.now().year + changeDate).toString();
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: cardPadding,
            child: Container(
              height: cardTitleSizeH.h,
              child: Row(children: [
                cardSpace,
                cardSpace,
                cardSpace,
                Container(
                  width: SizerUtil.deviceType == DeviceType.Tablet ? 22.0.w : 20.0.w,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        "사용일",
                        style: cardBlueStyle,
                      ),
                    ],
                  ),
                ),
                cardSpace,
                cardSpace,
                Container(
                  width: SizerUtil.deviceType == DeviceType.Tablet ? 21.0.w : 19.0.w,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        "종류",
                        style: cardBlueStyle,
                      ),
                    ],
                  ),
                ),
                cardSpace,
                Container(
                  width: SizerUtil.deviceType == DeviceType.Tablet ? 15.0.w : 13.0.w,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        "차감일",
                        style: cardBlueStyle,
                      ),
                    ],
                  ),
                ),
                cardSpace,
                Container(
                  width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                  alignment: Alignment.center,
                  child: Text(
                    "남은일",
                    style: cardBlueStyle,
                  ),
                ),
                /*Container(
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 11.0.w : 9.0.w,
                      alignment: Alignment.center,
                      child: Text(
                        "옵션",
                        style: cardBlueStyle,
                      ),
                    ),*/
              ]),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseRepository().selectAnnualLeave(mail: _loginUser.mail, companyCode: _loginUser.companyCode, date: yearDate),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();

                return _buildList(context, snapshot.data.docs, _loginUser.companyCode);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, String companyCode) {
  /*return ListView(
    children: snapshot.map((data) => _buildListItem(context, data, companyCode)).toList(),
  );*/
  return CustomScrollView(
    slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) => _buildListItem(context, snapshot[index], companyCode), childCount: snapshot.length),
      ),
    ],
  );
  /*return ListView.builder(
    itemCount: snapshot.length,
    itemBuilder: (context, index) {
      return _buildListItem(context, snapshot[index], companyCode);
    },
  );*/
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data, String companyCode) {
  final work = WorkModel.fromSnapshow(data);
  count = (work.type == "연차") ? count - 1.0 : count - 0.5;
  return Container(
    padding: cardPadding,
    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: grayColor))),
    child: _buildUserList(context, work, companyCode, count),
  );
}

Widget _buildUserList(BuildContext context, WorkModel work, String companyCode, double count) {
  Format _format = Format();
  return Row(
    children: [
      Container(
        width: SizerUtil.deviceType == DeviceType.Tablet ? 26.0.w : 24.0.w,
        alignment: Alignment.center,
        child: Text(_format.yearMonthDay(work.startTime), style: defaultMediumStyle),
      ),
      cardSpace,
      cardSpace,
      cardSpace,
      Container(
        width: SizerUtil.deviceType == DeviceType.Tablet ? 22.0.w : 20.0.w,
        alignment: Alignment.topLeft,
        child: Text(work.type.toString(), style: defaultMediumStyle),
      ),
      cardSpace,
      Container(
        width: SizerUtil.deviceType == DeviceType.Tablet ? 16.0.w : 14.0.w,
        alignment: Alignment.topLeft,
        child: Text((work.type == "연차" ? "-1" : "-0.5") + "일", style: defaultMediumStyle),
      ),
      cardSpace,
      Text(count.toString() + " 일", style: defaultMediumStyle),
    ],
  );
}
