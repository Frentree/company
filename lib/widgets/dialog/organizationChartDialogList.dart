import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

final word = Words();
// 팀 미완성
Future<void> getErrorDialog({BuildContext context, String text}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          height: 50,
          color: mainColor,
          child: Center(
            child: Text(
              word.alarm(),
              style: customStyle(
                  fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
            ),
          ),
        ),
        titlePadding: EdgeInsets.all(0.0),
        content: Container(
          height: customHeight(context: context, heightSize: 0.2),
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(text),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: mainColor,
                            child: Text(
                              word.confirm(),
                              style: customStyle(
                                  fontColor: whiteColor,
                                  fontSize: 15,
                                  fontWeightName: 'Bold'),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// 유저 팀명 수정 다이얼로그
Future<void> getTeamUpadateDialog(
    {BuildContext context,
    String teamName,
    String documentID,
    String companyCode}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      TextEditingController _teamNameEditController = TextEditingController();
      return AlertDialog(
        title: Text(
          word.departmentUpdate(),
          style: defaultMediumStyle,
        ),
        content: Container(
          width: SizerUtil.deviceType == DeviceType.Tablet ? 40.0.w : 30.0.w,
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _teamNameEditController,
                  style: defaultRegularStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: textFormPadding,
                    icon: Icon(
                      Icons.account_circle,
                      size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                    ),
                    labelText: teamName,
                    labelStyle: defaultRegularStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              word.update(),
              style: buttonBlueStyle,
            ),
            onPressed: () {
              FirebaseRepository().modifyOrganizationChartName(
                  companyCode: companyCode,
                  documentID: documentID,
                  teamName: _teamNameEditController.text);
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(
              word.cencel(),
              style: buttonBlueStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// 팀 삭제 다이얼로그
Future<void> getTeamDeleteDialog(
    {BuildContext context,
    String documentID,
    String companyCode,
    String teamName}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          word.departmentDelete(),
          style: defaultMediumStyle,
        ),
        content: Container(
          width: SizerUtil.deviceType == DeviceType.Tablet ? 40.0.w : 30.0.w,
          child: Text(
            word.deleteTeamCon(),
            style: defaultRegularStyle,
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              word.yes(),
              style: buttonBlueStyle,
            ),
            onPressed: () {
              FirebaseRepository().deleteUserOrganizationChart(
                  documentID: documentID,
                  companyCode: companyCode,
                  teamName: teamName);
              /*FirebaseRepository().deleteTeam(documentID, companyCode);*/

              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(
              word.no(),
              style: buttonBlueStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

final List<Map<String, dynamic>> teamList = List();
// 팀 유저 추가 다이얼로그
Future<void> addTeamUserDialog(
    {BuildContext context,
    String documentID,
    String companyCode,
    String teamName}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          word.addUser(),
          style: defaultMediumStyle,
        ),
        content: SingleChildScrollView(
          child: Container(
            height: 50.0.h,
            width: SizerUtil.deviceType == DeviceType.Tablet ? 40.0.w : 30.0.w,
            child: StreamBuilder(
              stream: FirebaseRepository().getGreadeUserAdd(companyCode),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                return _getUserTeamListAdd(
                    context, snapshot.data.documents, teamName, companyCode);
              },
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              word.yes(),
              style: buttonBlueStyle,
            ),
            onPressed: () async {
              await FirebaseRepository()
                  .addTeamUser(companyCode: companyCode, user: teamList);
              teamList.clear();
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(
              word.no(),
              style: buttonBlueStyle,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

// 팀 추가 안된 사용자 불러오기
Widget _getUserTeamListAdd(BuildContext context,
    List<DocumentSnapshot> snapshot, String teamName, String companyCode) {
  return ListView.builder(
    itemCount: snapshot.length,
    itemBuilder: (context, index) {
      bool isChk = (teamName == snapshot[index]["team"]);
      if (!isChk)
        return StatefulBuilder(
          key: ValueKey(snapshot[index]['mail']),
          builder: (context, setState) {
            return CheckboxListTile(
              dense: true,
              contentPadding: textFormPadding,
              secondary: CircleAvatar(
                radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.0.w : 4.0.w,
                backgroundColor: whiteColor,
                backgroundImage:
                    NetworkImage(snapshot[index]['profilePhoto']),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot[index]['name'].toString() +
                        " " +
                        snapshot[index]['position'].toString(),
                    style: defaultRegularStyle,
                  ),
                  Text(
                    snapshot[index]['team'].toString(),
                    style: hintStyle,
                  ),
                ],
              ),
              value: isChk,
              onChanged: (bool value) {
                setState(() {
                  isChk = value;

                  if (isChk == true) {
                    //TeamLevel.add(level);
                    Map<String, dynamic> map = {
                      "mail": snapshot[index]['mail'],
                      "team": teamName
                    };
                    teamList.add(map);
                  } else {
                    teamList.removeWhere((element) =>
                        snapshot[index]['mail'] == element['mail']);
                  }
                });
              },
            );
          },
        );
      else
        return SizedBox();
    },
    /*children: snapshot.map((data) =>
      _getUserItem(context, data, level, (level == data['level']))).toList(),*/
  );
}

// 팀 유저 삭제 다이얼로그
Future<void> dropTeamUserDialog(
    {BuildContext context,
    String documentID,
    String companyCode,
    String teamName}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          word.deleteMember(),
          style: defaultMediumStyle,
        ),
        content: SingleChildScrollView(
          child: Container(
            height: 50.0.h,
            width: SizerUtil.deviceType == DeviceType.Tablet ? 40.0.w : 30.0.w,
            child: StreamBuilder(
              stream: FirebaseRepository()
                  .getTeamUserDelete(companyCode, teamName),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();

                return _getUserListDelete(context, snapshot.data.documents,
                    teamName, companyCode);
              },
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              word.yes(),
              style: buttonBlueStyle,
            ),
            onPressed: () async {
              print(teamList);
              await FirebaseRepository()
                  .addTeamUser(companyCode: companyCode, user: teamList);
              teamList.clear();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              word.no(),
              style: buttonBlueStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

// 팀 삭제 추가된 사용자 불러오기
Widget _getUserListDelete(BuildContext context, List<DocumentSnapshot> snapshot,
    String teamName, String companyCode) {
  return ListView.builder(
    itemCount: snapshot.length,
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) {
      bool isChk = false;
      return StatefulBuilder(
        key: ValueKey(snapshot[index]['mail']),
        builder: (context, setState) {
          return CheckboxListTile(
            dense: true,
            contentPadding: textFormPadding,
            secondary: CircleAvatar(
              radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.0.w : 4.0.w,
              backgroundColor: whiteColor,
              backgroundImage: NetworkImage(
                  snapshot[index]['profilePhoto']),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot[index]['name'].toString() +
                      " " +
                      snapshot[index]['position'].toString(),
                  style: defaultRegularStyle,
                ),
                Text(
                  snapshot[index]['team'].toString(),
                  style: hintStyle,
                ),
              ],
            ),
            value: isChk,
            onChanged: (bool value) {
              setState(() {
                isChk = value;

                if (isChk == true) {
                  Map<String, dynamic> map = {
                    "mail": snapshot[index]['mail'],
                    "team": ""
                  };
                  teamList.add(map);
                } else {
                  teamList.removeWhere((element) =>
                      snapshot[index]['mail'] ==
                      element['mail']);
                }
              });
            },
          );
        },
      );
    },
    /*children: snapshot.map((data) =>
      _getUserItem(context, data, level, (level == data['level']))).toList(),*/
  );
}

// 팀 추가 다이얼로그
Future<void> addTeamDialog({BuildContext context, String companyCode}) {
  TextEditingController _teamNameController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          word.departmentAdd(),
          style: defaultMediumStyle,
        ),
        content: Container(
          width: SizerUtil.deviceType == DeviceType.Tablet ? 40.0.w : 30.0.w,
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _teamNameController,
                  style: defaultRegularStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: textFormPadding,
                    icon: Icon(
                      Icons.group_add_rounded,
                      size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                    ),
                    labelText: word.departmentAddCon(),
                    labelStyle: defaultRegularStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              word.confirm(),
              style: buttonBlueStyle,
            ),
            onPressed: () {
              FirebaseRepository().addOrganizationChart(
                  companyCode: companyCode,
                  teamName: _teamNameController.text);
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(
              word.cencel(),
              style: buttonBlueStyle,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
