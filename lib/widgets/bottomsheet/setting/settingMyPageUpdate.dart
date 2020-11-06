import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/work/workRepository.dart';
import 'package:companyplaylist/screens/setting/myInfomationCard.dart';
import 'package:companyplaylist/screens/work/workDate.dart';
import 'package:companyplaylist/screens/work/workTeam.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

SettingMyPageUpdate(BuildContext context) {
  User _loginUser;

  showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
        _loginUser = _loginUserInfoProvider.getLoginUser();

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    color: blackColor,
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                  ),
                  ExpansionTile(
                    initiallyExpanded: true,
                    leading: Icon(Icons.person_outline),
                    title: Text('내 정보 수정'),
                    children: [
                      getUpdateMyInfomationCard(
                          context: context,
                          user: _loginUser
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
      );
}
