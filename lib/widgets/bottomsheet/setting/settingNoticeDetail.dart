import 'dart:async';

import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/appNoticeModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingNoticeDetail extends StatefulWidget {
  @override
  _SettingNoticeDetailState createState() => _SettingNoticeDetailState();
}

class _SettingNoticeDetailState extends State<SettingNoticeDetail> {
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


    Timer(
      Duration(milliseconds: 100),
          () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
    );
    return Scaffold(
      backgroundColor: whiteColor,
      body: _buildInquireBody(context, _loginUser, setState),
    );
  }
}

Widget _buildInquireBody(BuildContext context, User user, setState) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseRepository().getNotice(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

      return _buildInquireList(context, snapshot.data.docs, user, setState);
    },
  );
}

final TextEditingController _commentControll = TextEditingController();
final ScrollController _scrollController = ScrollController();

Widget _buildInquireList(BuildContext context, List<DocumentSnapshot> snapshot, User user, setState) {
  return Column(
    children: [
      Expanded(
        child: CustomScrollView(
          controller: _scrollController,
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
  final appNotice = AppNoticeModel.fromSnapshow(data);

  Format _format = Format();
  return ExpansionTile(
    expandedAlignment: Alignment.topLeft,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appNotice.title,
        ),
        Text(
          _format.yearMonthDay(appNotice.createDate).toString(),
          style: defaultRegularStyleGray,
        ),
      ],
    ),
    children: [
      Text(
        appNotice.content,
      ),
    ],
  );
}

