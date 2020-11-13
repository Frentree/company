
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';
import 'package:companyplaylist/screens/alarm/alarmNoticeComment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

import 'package:provider/provider.dart';

class ManageCommute extends StatefulWidget{
  @override
  ManageCommutePageState createState() => ManageCommutePageState();
}

class ManageCommutePageState extends State<ManageCommute>{
  int i = 0;
  Stream<QuerySnapshot> currentStream;
  CrudRepository _crudRepository;
  LoginUserInfoProvider _loginUserInfoProvider;

  User _loginUser;

  @override
  Widget build(BuildContext context) {
    log('ManageCommutePageState');
    _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();

    _crudRepository =
        CrudRepository.noticeAttendance(companyCode: _loginUser.companyCode);
    currentStream = _crudRepository.fetchNoticeAsStream();
    return StreamBuilder(
      stream: currentStream,
      builder: (context, snapshot){
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<DocumentSnapshot> documents =
            snapshot.data.documents;
        log('streamBuild');
        Row(
          children: <Widget>[
            ActionChip(label: Text("as"), onPressed: (){})
          ],
        );
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return null;
          },
          // workScheduleCard(context)
        );
      },
    );
  }
  
}