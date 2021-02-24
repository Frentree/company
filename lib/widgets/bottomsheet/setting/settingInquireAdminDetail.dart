import 'dart:async';

import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/inquireAdminModel.dart';
import 'package:MyCompany/models/inquireModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingInquireAdminChat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SettingInquireAdminDetail extends StatefulWidget {
  @override
  _SettingInquireAdminDetailState createState() => _SettingInquireAdminDetailState();
}

class _SettingInquireAdminDetailState extends State<SettingInquireAdminDetail> {

  User _loginUser;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentControll.text = "";
  }

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();

    return Scaffold(
      backgroundColor: whiteColor,
      body: _buildInquireAdminBody(context, _loginUser, setState),
    );
  }
}

Widget _buildInquireAdminBody(BuildContext context, User user, setState) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseRepository().getQnAAdmin(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

      return _buildInquireAdminList(context, snapshot.data.docs, user, setState);
    },
  );
}

final TextEditingController _commentControll = TextEditingController();

Widget _buildInquireAdminList(BuildContext context, List<DocumentSnapshot> snapshot, User user, setState) {

  return Column(
    children: [
      Expanded(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildInquireListItem(context, snapshot[index], user, setState), //_buildListItem(context, snapshot[index], user),
                  childCount: snapshot.length),
            ),
          ],
        ),
      ),
      emptySpace,
    ],
  );
}

Widget _buildInquireListItem(BuildContext context, DocumentSnapshot data, User user, setState) {
  final inquireAdmin = InquireAdminModel.fromSnapshow(data);
  Format _format = Format();
  return InkWell(
    child: Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
      width: double.infinity,
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inquireAdmin.mail,
                  style: defaultSmallStyle,
                ),
                Text(
                  inquireAdmin.lastContent,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: hintStyle,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _format.timeStampToTimes(inquireAdmin.lastDate),
                style: inquireDateBlackStyle,
              ),
              (inquireAdmin.senderCount != 0) ?
              Container(
                  height: 3.0.h,
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: chipColorPurple,
                    radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                    child: Text(
                        inquireAdmin.senderCount.toString()
                    ),
                  )
              ) : Container(),
            ],
          ),
        ],
      ),
    ),
    onTap: (){
      if(inquireAdmin.senderCount != 0) FirebaseRepository().senderQnAReset(mail: inquireAdmin.mail);
      SettingInquireAdminChat(context: context, model: inquireAdmin);
    },
  );
}

