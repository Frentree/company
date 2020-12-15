import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:flutter/material.dart';

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


// 유저 팀명 수정 다이얼로그
Future<void> getTeamUpadateDialog({BuildContext context, String teamName, String documentID, String companyCode}) {
  return showDialog(
    context: context,
    builder: (context) {
      TextEditingController _teamNameEditController = TextEditingController();
      return AlertDialog(
        title: Container(
          height: 50,
          color: mainColor,
          child: Center(
            child: Text(
              word.departmentUpdate(),
              style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
            ),
          ),
        ),
        titlePadding: EdgeInsets.all(0.0),
        content: Container(
          height: customHeight(context: context, heightSize: 0.2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: teamName,
                ),
                controller: _teamNameEditController,
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
                          style: customStyle(fontColor: whiteColor, fontSize: 15, fontWeightName: 'Bold'),
                        ),
                        onPressed: () {
                          FirebaseRepository().modifyOrganizationChartName(
                            companyCode: companyCode,
                            documentID: documentID,
                            teamName: _teamNameEditController.text
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

// 팀 삭제 다이얼로그
Future<void> getTeamDeleteDialog({BuildContext context, String documentID, String companyCode, String teamName}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          height: 50,
          color: mainColor,
          child: Center(
            child: Text(
              word.departmentDelete(),
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
                  Text(word.deleteTeamCon()),
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
                              FirebaseRepository().deleteUserOrganizationChart(
                                documentID: documentID,
                                companyCode: companyCode,
                                teamName: teamName
                              );
                              /*FirebaseRepository().deleteTeam(documentID, companyCode);*/

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

// 팀 유저 추가 다이얼로그
Future<void> addTeamUserDialog({BuildContext context, String documentID, String companyCode, String teamName}) {
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

                    return _getUserTeamListAdd(context, snapshot.data.documents, teamName, companyCode);
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

// 팀 추가 안된 사용자 불러오기
Widget _getUserTeamListAdd(BuildContext context, List<DocumentSnapshot> snapshot, String teamName, String companyCode) {
  List<Map<String,dynamic>> teamList = List();
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
              bool isChk = (teamName == snapshot[index]["team"]);

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
                                      //TeamLevel.add(level);
                                      Map<String, dynamic> map = {
                                        "mail" : snapshot[index]['mail'],
                                        "team" : teamName
                                      };
                                      teamList.add(map);
                                    } else {
                                      teamList.removeWhere((element) => snapshot[index]['mail'] == element['mail']);
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
                    FirebaseRepository().addTeamUser(
                      companyCode: companyCode,
                      user: teamList
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

// 팀 유저 삭제 다이얼로그
Future<void> dropTeamUserDialog({BuildContext context, String documentID, String companyCode, String teamName}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          height: 50,
          color: mainColor,
          child: Center(
            child: Text(
              word.deleteMember(),
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
                  stream: FirebaseRepository().getTeamUserDelete(companyCode, teamName),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();

                    return _getUserListDelete(context, snapshot.data.documents, teamName, companyCode);
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

// 팀 삭제 추가된 사용자 불러오기
Widget _getUserListDelete(BuildContext context, List<DocumentSnapshot> snapshot, String teamName, String companyCode) {
  List<Map<String,dynamic>> teamList = List();
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
                                        "team" : ""
                                      };
                                      teamList.add(map);
                                    } else {
                                      teamList.removeWhere((element) => snapshot[index]['mail'] == element['mail']);
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
                   FirebaseRepository().addTeamUser(
                     companyCode: companyCode,
                     user: teamList
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

// 팀 추가 다이얼로그
Future<void> addTeamDialog({BuildContext context, String companyCode}) {
  TextEditingController _teamNameController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Container(
          height: 50,
          color: mainColor,
          child: Center(
            child: Text(
              word.departmentAdd(),
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
                  labelText: word.departmentAddCon(),
                ),
                controller: _teamNameController,
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
                          FirebaseRepository().addOrganizationChart(
                            companyCode: companyCode,
                            teamName: _teamNameController.text
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