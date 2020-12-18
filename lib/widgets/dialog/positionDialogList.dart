import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:flutter/material.dart';

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
        ),
        content: SingleChildScrollView(
          child: ListBody(children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: position,
              ),
              controller: _positionEditController,
            ),
          ])),
        actions: [
          FlatButton(
            child: Text(word.update()),
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

// 직급 삭제 다이얼로그
Future<void> getPositionDeleteDialog({BuildContext context, String documentID, String companyCode, String position}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          word.departmentDelete(),
        ),
        content: SingleChildScrollView(
          child: ListBody(children: <Widget>[
            Text(word.deletePositionCon()),
            ]
          )
        ),
        actions: [
          FlatButton(
            child: Text(word.yes()),
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

                    return _getUserPositionListAdd(context, snapshot.data.documents, position, companyCode);
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
              await FirebaseRepository().addPositionUser(
                  companyCode: companyCode,
                  user: positionList
              );
              positionList.clear();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(word.no()),
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
              bool isChk = (position == snapshot[index]["position"]);

              if(!isChk)
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
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot[index]['name'].toString() + " " + snapshot[index]['position'].toString(),
                                      style: customStyle(
                                          fontColor: mainColor,
                                          fontSize: 14,
                                          fontWeightName: 'Medium'
                                      ),
                                    ),
                                    Text(
                                      snapshot[index]['team'].toString(),
                                      style: customStyle(
                                          fontColor: grayColor,
                                          fontSize: 12,
                                          fontWeightName: 'Medium'
                                      ),
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

// 직급 유저 삭제 다이얼로그
Future<void> dropPositionUserDialog({BuildContext context, String documentID, String companyCode, String position}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          word.deleteMember(),
        ),
        content: Container(
          height: customHeight(context: context, heightSize: 0.5),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseRepository().getPositionUserDelete(companyCode, position),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();

                    return _getUserListDelete(context, snapshot.data.documents, position, companyCode);
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
              await FirebaseRepository().addPositionUser(
                  companyCode: companyCode,
                  user: positionList
              );
              positionList.clear();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(word.cencel()),
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
              bool isChk = false;

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
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot[index]['name'].toString() + " " + snapshot[index]['position'].toString(),
                                      style: customStyle(
                                          fontColor: mainColor,
                                          fontSize: 14,
                                          fontWeightName: 'Medium'
                                      ),
                                    ),
                                    Text(
                                      snapshot[index]['team'].toString(),
                                      style: customStyle(
                                          fontColor: grayColor,
                                          fontSize: 12,
                                          fontWeightName: 'Medium'
                                      ),
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

// 직급 추가 다이얼로그
Future<void> addPositionDialog({BuildContext context, String companyCode}) {
  TextEditingController _positionController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          height: 50,
          color: mainColor,
          child: Center(
            child: Text(
              word.positionAdd(),
              style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
            ),
          ),
        ),
        titlePadding: EdgeInsets.all(0.0),
        content: Container(
          height: customHeight(context: context, heightSize: 0.2),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.group_add_rounded),
                  labelText: word.positionAddCon(),
                ),
                controller: _positionController,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: mainColor,
                        child: Text(
                          word.confirm(),
                          style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
                        ),
                        onPressed: () {
                          FirebaseRepository().addPosition(
                            companyCode: companyCode,
                            position: _positionController.text
                          );
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
                        style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
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
        ),
      );
    },
  );
}