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


// 유저 직급명 수정 다이얼로그
Future<void> getPositionUpadateDialog({BuildContext context, String position, String documentID, String companyCode}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      TextEditingController _positionEditController = TextEditingController();
      return AlertDialog(
        title: Text(
          word.departmentUpdate(),
          style: defaultMediumStyle,
        ),
        content: Container(
          width: SizerUtil.deviceType == DeviceType.Tablet ? 40.0.w : 30.0.w,
          child: SingleChildScrollView(
            child: ListBody(children: <Widget>[
              TextFormField(
                controller: _positionEditController,
                style: defaultRegularStyle,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: textFormPadding,
                  icon: Icon(
                    Icons.account_circle,
                    size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                  ),
                  labelText: position,
                  labelStyle: defaultRegularStyle,
                ),
              ),
            ])),
        ),
        actions: [
          FlatButton(
            child: Text(
              word.update(),
              style: buttonBlueStyle,
            ),
            onPressed: () {
              FirebaseRepository().modifyPositionName(
                  companyCode: companyCode,
                  documentID: documentID,
                  position: _positionEditController.text
              );
              Navigator.of(context).pop();
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
          )
        ],
      );
    },
  );
}

// 직급 삭제 다이얼로그
Future<void> getPositionDeleteDialog({BuildContext context, String documentID, String companyCode, String position}) {
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
            word.deletePositionCon(),
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
              FirebaseRepository().deleteUserPosition(
                  documentID: documentID,
                  companyCode: companyCode,
                  position: position
              );
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

List<Map<String,dynamic>> positionList = List();
// 직급 유저 추가 다이얼로그
Future<void> addPositionUserDialog({BuildContext context, String documentID, String companyCode, String position}) {
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
                return _getUserPositionListAdd(context, snapshot.data.documents, position, companyCode);
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
              await FirebaseRepository().addPositionUser(
                  companyCode: companyCode,
                  user: positionList
              );
              positionList.clear();
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
          ),
        ],
      );
    },
  );
}

// 직급 추가 안된 사용자 불러오기
Widget _getUserPositionListAdd(BuildContext context, List<DocumentSnapshot> snapshot, String position, String companyCode) {
  return ListView.builder(
    itemCount: snapshot.length,
    itemBuilder: (context, index) {
      bool isChk = (position == snapshot[index]["position"]);
      if(!isChk)
        return StatefulBuilder(
          key: ValueKey(snapshot[index]['mail']),
          builder: (context, setState) {
            return CheckboxListTile(
              dense: true,
              contentPadding: textFormPadding,
              secondary: CircleAvatar(
                radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.0.w : 4.0.w,
                backgroundColor: whiteColor,
                backgroundImage: NetworkImage(snapshot[index]['profilePhoto']),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot[index]['name'].toString() + " " + snapshot[index]['position'].toString(),
                    style: defaultRegularStyle,
                  ),
                  Text(
                    snapshot[index]['team'].toString(),
                    style: hintStyle,
                  ),
                ],
              ),
              value: isChk,
              onChanged: (bool value){
                setState((){
                  isChk = value;

                  if(isChk == true) {
                    //positionLevel.add(level);
                    Map<String, dynamic> map = {
                      "mail" : snapshot[index]['mail'],
                      "position" : position
                    };
                    positionList.add(map);
                  } else {
                    positionList.removeWhere((element) => snapshot[index]['mail'] == element['mail']);
                  }
                });
              },
            );
          },
        );
      else return SizedBox();
    },
    /*children: snapshot.map((data) =>
      _getUserItem(context, data, level, (level == data['level']))).toList(),*/
  );
}

// 직급 유저 삭제 다이얼로그
Future<void> dropPositionUserDialog({BuildContext context, String documentID, String companyCode, String position}) {
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
              stream: FirebaseRepository().getPositionUserDelete(companyCode, position),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();

                return _getUserListDelete(context, snapshot.data.documents, position, companyCode);
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
              await FirebaseRepository().addPositionUser(
                  companyCode: companyCode,
                  user: positionList
              );
              positionList.clear();
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
          ),
        ],
      );
    },
  );
}

// 직급 삭제 추가된 사용자 불러오기
Widget _getUserListDelete(BuildContext context, List<DocumentSnapshot> snapshot, String position, String companyCode) {
  return ListView.builder(
    itemCount: snapshot.length,
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
                backgroundImage: NetworkImage(snapshot[index]['profilePhoto']),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot[index]['name'].toString() + " " + snapshot[index]['position'].toString(),
                    style: defaultRegularStyle,
                  ),
                  Text(
                    snapshot[index]['team'].toString(),
                    style: hintStyle,
                  ),
                ],
              ),
              value: isChk,
              onChanged: (bool value){
                setState((){
                  isChk = value;

                  if(isChk == true) {
                    Map<String, dynamic> map = {
                      "mail" : snapshot[index]['mail'],
                      "position" : ""
                    };
                    positionList.add(map);
                  } else {
                    positionList.removeWhere((element) => snapshot[index]['mail'] == element['mail']);
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

// 직급 추가 다이얼로그
Future<void> addPositionDialog({BuildContext context, String companyCode}) {
  TextEditingController _positionController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          word.positionAdd(),
          style: defaultMediumStyle,
        ),
        content: Container(
          width: SizerUtil.deviceType == DeviceType.Tablet ? 40.0.w : 30.0.w,
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _positionController,
                  style: defaultRegularStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: textFormPadding,
                    icon: Icon(
                      Icons.group_add_rounded,
                      size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                    ),
                    labelText: word.positionAddCon(),
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
              FirebaseRepository().addPosition(
                  companyCode: companyCode,
                  position: _positionController.text
              );
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