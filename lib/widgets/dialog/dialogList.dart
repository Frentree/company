import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/repos/firebaseMethod.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/material.dart';

final word = Words();
// 권한 미완성
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
              style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
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
                                  fontWeightName: 'Bold'
                              ),
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


// 유저 권한명 수정 다이얼로그
Future<void> getGradeUpadateDialog({BuildContext context, String gradeName, String documentID, String companyCode}) {
  return showDialog(
    context: context,
    builder: (context) {
      TextEditingController _gradeNameEditController = TextEditingController();
      return AlertDialog(
        title: Container(
          height: 50,
          color: mainColor,
          child: Center(
            child: Text(
              word.gradeNameUpdate(),
              style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
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
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_circle),
                      labelText: gradeName,
                    ),
                    controller: _gradeNameEditController,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: mainColor,
                            child: Text(
                              word.update(),
                              style: customStyle(
                                  fontColor: whiteColor,
                                  fontSize: 15,
                                  fontWeightName: 'Bold'
                              ),
                            ),
                            onPressed: () {
                              FirebaseRepository().updateGradeName(documentID, _gradeNameEditController.text, companyCode);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: mainColor,
                          child: Text(
                            word.cencel(),
                            style: customStyle(
                                fontColor: whiteColor,
                                fontSize: 15,
                                fontWeightName: 'Bold'
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
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

// 권한 삭제 다이얼로그
Future<void> getGradeDeleteDialog({BuildContext context, String documentID, String companyCode, int level}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          height: 50,
          color: mainColor,
          child: Center(
            child: Text(
              word.deleteGrade(),
              style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
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
                  Text(word.deleteGradeCon()),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: mainColor,
                            child: Text(
                              word.yes(),
                              style: customStyle(
                                  fontColor: whiteColor,
                                  fontSize: 15,
                                  fontWeightName: 'Bold'
                              ),
                            ),
                            onPressed: () {
                              FirebaseRepository().deleteUserGrade(documentID, companyCode, level);
                              FirebaseRepository().deleteGrade(documentID, companyCode);

                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: mainColor,
                          child: Text(
                            word.no(),
                            style: customStyle(
                                fontColor: whiteColor,
                                fontSize: 15,
                                fontWeightName: 'Bold'
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
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

// 권한 유저 추가 다이얼로그
Future<void> addGradeUserDialog({BuildContext context, String documentID, String companyCode, int level}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          height: 50,
          color: mainColor,
          child: Center(
            child: Text(
              word.addUser(),
              style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
            ),
          ),
        ),
        titlePadding: EdgeInsets.all(0.0),
        content: Container(
          height: customHeight(context: context, heightSize: 0.5),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseRepository().getGreadeUserAdd(companyCode),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();

                    return _getUserListAdd(context, snapshot.data.documents, level, companyCode);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// 권한 추가 안된 사용자 불러오기
Widget _getUserListAdd(BuildContext context, List<DocumentSnapshot> snapshot, int level, String companyCode) {
  List<Map<String,dynamic>> gradeList = List();
  return Column(
    children: [
      Expanded(
        flex: 9,
        child: Container(
          width: customWidth(context: context, widthSize: 1),
          height: customHeight(context: context, heightSize: 0.1),
          child: ListView.builder(
            itemCount: snapshot.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              bool isChk = (level == snapshot[index]['level']);
              List<dynamic> levelList = snapshot[index]["level"];

              if(!levelList.contains(level))
                return StatefulBuilder(
                  key: ValueKey(snapshot[index]['mail']),
                  builder: (context, setState) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                secondary:SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot[index]['profilePhoto']),
                                  ),
                                ),
                                title: Text(
                                  snapshot[index]['name'].toString(),
                                  style: customStyle(
                                      fontColor: mainColor,
                                      fontSize: 14,
                                      fontWeightName: 'Medium'
                                  ),
                                ),
                                value: isChk,
                                onChanged: (bool value){
                                  setState((){
                                    isChk = value;
                                    /*List<int> gradeLevel = List();

                                    for(int i = 0; i < levelList.length; i++){
                                      if(levelList[i] != 0)
                                        gradeLevel.add(levelList[i]);
                                    }*/

                                    if(isChk == true) {
                                      //gradeLevel.add(level);
                                      Map<String, dynamic> map = {
                                        "mail" : snapshot[index]['mail'],
                                        "level" : level
                                      };
                                      gradeList.add(map);
                                    } else {
                                      //gradeLevel.remove(level);
                                      gradeList.removeWhere((element) => snapshot[index]['mail'] == element['mail']);
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                    );
                  },
                );
              else return SizedBox();
            },
            /*children: snapshot.map((data) =>
              _getUserItem(context, data, level, (level == data['level']))).toList(),*/
          ),
        ),
      ),
      Expanded(
        flex: 2,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: mainColor,
                  child: Text(
                    word.yes(),
                    style: customStyle(
                      fontColor: whiteColor,
                      fontSize: 15,
                      fontWeightName: 'Bold'
                    ),
                  ),
                  onPressed: () {
                    FirebaseRepository().addGradeUser(companyCode, gradeList);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Expanded(
              child: RaisedButton(
                color: mainColor,
                child: Text(
                  word.no(),
                  style: customStyle(
                      fontColor: whiteColor,
                      fontSize: 15,
                      fontWeightName: 'Bold'
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// 권한 유저 삭제 다이얼로그
Future<void> dropGradeUserDialog({BuildContext context, String documentID, String companyCode, int level}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          height: 50,
          color: mainColor,
          child: Center(
            child: Text(
              word.deleteUserPermission(),
              style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
            ),
          ),
        ),
        titlePadding: EdgeInsets.all(0.0),
        content: Container(
          height: customHeight(context: context, heightSize: 0.5),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseRepository().getGreadeUserDelete(companyCode, level),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();

                    return _getUserListDelete(context, snapshot.data.documents, level, companyCode);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// 권한 삭제 추가된 사용자 불러오기
Widget _getUserListDelete(BuildContext context, List<DocumentSnapshot> snapshot, int level, String companyCode) {
  List<Map<String,dynamic>> gradeList = List();
  return Column(
    children: [
      Expanded(
        flex: 9,
        child: Container(
          width: customWidth(context: context, widthSize: 1),
          height: customHeight(context: context, heightSize: 0.1),
          child: ListView.builder(
            itemCount: snapshot.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              bool isChk = (level == snapshot[index]['level']);
              List<dynamic> levelList = snapshot[index]["level"];

                return StatefulBuilder(
                  key: ValueKey(snapshot[index]['mail']),
                  builder: (context, setState) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                secondary:SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot[index]['profilePhoto']),
                                  ),
                                ),
                                title: Text(
                                  snapshot[index]['name'].toString(),
                                  style: customStyle(
                                      fontColor: mainColor,
                                      fontSize: 14,
                                      fontWeightName: 'Medium'
                                  ),
                                ),
                                value: isChk,
                                onChanged: (bool value){
                                  setState((){
                                    isChk = value;

                                    if(isChk == true) {
                                      Map<String, dynamic> map = {
                                        "mail" : snapshot[index]['mail'],
                                        "level" : level
                                      };
                                      gradeList.add(map);
                                      print(gradeList);
                                    } else {
                                      gradeList.removeWhere((element) => snapshot[index]['mail'] == element['mail']);
                                      print(gradeList);
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                    );
                  },
                );
            },
            /*children: snapshot.map((data) =>
              _getUserItem(context, data, level, (level == data['level']))).toList(),*/
          ),
        ),
      ),
      Expanded(
        flex: 2,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: mainColor,
                  child: Text(
                    word.yes(),
                    style: customStyle(
                        fontColor: whiteColor,
                        fontSize: 15,
                        fontWeightName: 'Bold'
                    ),
                  ),
                  onPressed: () {
                    if(level == 9) {
                      if(snapshot.length == gradeList.length) {
                        getErrorDialog(context: context, text: word.superAdminCon());
                        return;
                      }
                    }

                    FirebaseRepository().deleteGradeUser(companyCode, gradeList);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Expanded(
              child: RaisedButton(
                color: mainColor,
                child: Text(
                  word.cencel(),
                  style: customStyle(
                      fontColor: whiteColor,
                      fontSize: 15,
                      fontWeightName: 'Bold'
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// 권한 추가 다이얼로그
Future<void> addGradeDialog({BuildContext context, String companyCode}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          height: 50,
          color: mainColor,
          child: Center(
            child: Text(
              word.addPermission(),
              style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
            ),
          ),
        ),
        titlePadding: EdgeInsets.all(0.0),
        content: Container(
          height: customHeight(context: context, heightSize: 0.5),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseRepository().getGrade(companyCode),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();

                    return _getGradeList(context, snapshot.data.documents,companyCode);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// 권한 추가 불러오기
Widget _getGradeList(BuildContext context, List<DocumentSnapshot> snapshot, String companyCode) {
  List<int> gradeIdList = List();
  for(int i= 0; i < snapshot.length; i++){
    gradeIdList.add(snapshot[i].data()['gradeID']);
  }

  bool isAccountingChk = false;
  bool isTaskChk = false;
  return Column(
    children: [
      Expanded(
        flex: 9,
        child: Container(
          width: customWidth(context: context, widthSize: 1),
          height: customHeight(context: context, heightSize: 0.1),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  (!gradeIdList.contains(7)) ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: Text(
                              "회계 담당자",
                              style: customStyle(
                                  fontColor: mainColor,
                                  fontSize: 14,
                                  fontWeightName: 'Medium'
                              ),
                            ),
                            value: isAccountingChk,
                            onChanged: (bool value){
                              setState((){
                                isAccountingChk = value;
                              });
                            },
                          ),
                        ),
                      ]
                    ),
                  ) : SizedBox(),
                  (!gradeIdList.contains(6)) ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: Text(
                                "업무 관리자",
                                style: customStyle(
                                    fontColor: mainColor,
                                    fontSize: 14,
                                    fontWeightName: 'Medium'
                                ),
                              ),
                              value: isTaskChk,
                              onChanged: (bool value){
                                setState((){
                                  isTaskChk = value;
                                });
                              },
                            ),
                          ),
                        ]
                    ),
                  ) : SizedBox(),
                ],
              );
            },
          )
        ),
      ),
      Expanded(
        flex: 2,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: mainColor,
                  child: Text(
                    word.yes(),
                    style: customStyle(
                        fontColor: whiteColor,
                        fontSize: 15,
                        fontWeightName: 'Bold'
                    ),
                  ),
                  onPressed: () {
                    if(isAccountingChk == true)
                      FirebaseRepository().addGrade(companyCode, "회계 담당자", 7);
                    if(isTaskChk == true)
                      FirebaseRepository().addGrade(companyCode, "업무 관리자", 6);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Expanded(
              child: RaisedButton(
                color: mainColor,
                child: Text(
                  word.no(),
                  style: customStyle(
                      fontColor: whiteColor,
                      fontSize: 15,
                      fontWeightName: 'Bold'
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    ],
  );
}