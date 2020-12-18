import 'package:MyCompany/consts/screenSize/style.dart';
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
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          word.alarm(),
          style: defaultMediumStyle,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                text,
                style: defaultRegularStyle,
              )
            ],
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              word.confirm(),
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


// 유저 권한명 수정 다이얼로그
Future<void> getGradeUpadateDialog({BuildContext context, String gradeName, String documentID, String companyCode}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      TextEditingController _gradeNameEditController = TextEditingController();
      return AlertDialog(
        title: Text(
          word.gradeNameUpdate(),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget> [
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: gradeName,
                ),
                controller: _gradeNameEditController,
              ),
            ],
          ),
        ),
        actions: [
          FlatButton(
            child: Text(word.update()),
            onPressed: () {
              FirebaseRepository().updateGradeName(documentID, _gradeNameEditController.text, companyCode);
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(word.cencel()),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

// 권한 삭제 다이얼로그
Future<void> getGradeDeleteDialog({BuildContext context, String documentID, String companyCode, int level}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          word.deleteGrade(),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(word.deleteGradeCon()),
            ],
          ),
        ),
        actions: [
          FlatButton(
            child: Text(word.yes()),
            onPressed: () {
              FirebaseRepository().deleteUserGrade(documentID, companyCode, level);
              FirebaseRepository().deleteGrade(documentID, companyCode);
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(word.no()),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

List<Map<String,dynamic>> gradeList = List();
// 권한 유저 추가 다이얼로그
Future<void> addGradeUserDialog({BuildContext context, String documentID, String companyCode, int level}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          word.addUser(),
        ),
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
        actions: [
          FlatButton(
            child: Text(word.yes()),
            onPressed: () async {
              await FirebaseRepository().addGradeUser(companyCode, gradeList);
              gradeList.clear();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(word.no()),
            onPressed: () {
              gradeList.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// 권한 추가 안된 사용자 불러오기
Widget _getUserListAdd(BuildContext context, List<DocumentSnapshot> snapshot, int level, String companyCode) {
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
                                    backgroundColor: whiteColor,
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
    ],
  );
}

// 권한 유저 삭제 다이얼로그
Future<void> dropGradeUserDialog({BuildContext context, String documentID, String companyCode, int level}) {
  int countGrade;
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          word.deleteUserPermission(),
        ),
        content: Container(
          height: customHeight(context: context, heightSize: 0.5),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseRepository().getGreadeUserDelete(companyCode, level),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();
                    countGrade = snapshot.data.documents.length;
                    return _getUserListDelete(context, snapshot.data.documents, level, companyCode);
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          FlatButton(
            child: Text(word.yes()),
            onPressed: () async {
              if(level == 9) {
                if(countGrade == gradeList.length) {
                  getErrorDialog(context: context, text: word.superAdminCon());
                  return;
                }
              }

              await FirebaseRepository().deleteGradeUser(companyCode, gradeList);
              gradeList.clear();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(word.no()),
            onPressed: () {
              gradeList.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// 권한 삭제 추가된 사용자 불러오기
Widget _getUserListDelete(BuildContext context, List<DocumentSnapshot> snapshot, int level, String companyCode) {
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
                                  width: 30,
                                  height: 30,
                                  child: CircleAvatar(
                                    backgroundColor: whiteColor,
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
                                    } else {
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
            },
            /*children: snapshot.map((data) =>
              _getUserItem(context, data, level, (level == data['level']))).toList(),*/
          ),
        ),
      ),
    ],
  );
}

bool isAccountingChk = false;
bool isTaskChk = false;
// 권한 추가 다이얼로그
Future<void> addGradeDialog({BuildContext context, String companyCode}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title:Text(
          word.addPermission(),
        ),
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
        actions: [
          FlatButton(
            child: Text(word.yes()),
            onPressed: () {
              if(isAccountingChk == true){
                FirebaseRepository().addGrade(companyCode, "회계 담당자", 7);
                isAccountingChk = false;
              }

              if(isTaskChk == true) {
                FirebaseRepository().addGrade(companyCode, "업무 관리자", 6);
                isTaskChk = false;
              }
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(word.no()),
            onPressed: () {
              isAccountingChk = false;
              isTaskChk = false;
              Navigator.of(context).pop();
            },
          )
        ],
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
    ],
  );
}