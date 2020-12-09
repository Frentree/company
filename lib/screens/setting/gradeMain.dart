import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/firebaseMethod.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/widgets/dialog/dialogList.dart';
import 'package:companyplaylist/widgets/popupMenu/expensePopupMenu.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GradeMainPage extends StatefulWidget {
  @override
  GradeMainPageState createState() => GradeMainPageState();
}

class GradeMainPageState extends State<GradeMainPage> {
  User _loginUser;

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();

    return Scaffold(
      floatingActionButton:
      FloatingActionButton.extended(
        backgroundColor: mainColor,
        onPressed: (){
          addGradeDialog(context: context, companyCode: _loginUser.companyCode);
        },
        label: Text(
          "권한 추가",
          style: customStyle(
            fontColor: whiteColor,
            fontWeightName: 'Bold',
            fontSize: 15
          ),
        ),
      ),
      body: _buildBody(context, _loginUser),
    );
  }
}

Widget _buildBody(BuildContext context, User user) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseMethods().getGrade(user.companyCode),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents, user.companyCode);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, String companyCode) {
  return Column(
    children: [
      Expanded(child: ListView(children: snapshot.map((data) => _buildListItem(context, data, companyCode)).toList())),
    ],
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data, String companyCode) {
  final grade = GradeData.fromSnapshow(data);

  return Padding(
    key: ValueKey(grade.gradeID),
    padding: const EdgeInsets.symmetric(horizontal: 5.0),
    child: Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: grayColor),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            children: [_buildUserList(context, grade, companyCode)],
          ),
        ),
      ],
    ),
  );
}

Widget _buildUserList(BuildContext context, GradeData grade, String companyCode) {
  List<Map<String,dynamic>> gradeList = List();
  return Expanded(
    child: Container(
      height: customHeight(context: context, heightSize: 0.08),
      child: Container(
            height: customHeight(context: context, heightSize: 1),
            child: DragTarget<Map<String, dynamic>>(
              onAccept: (receivedItem) {
                print(receivedItem);
                getErrorDialog(context: context, text: "아직 기능이 구현되지 않았습니다.");

                if(receivedItem["documentID"] == grade.reference.documentID){
                  print("기존 위치");
                }else {
                  //FirebaseRepository().deleteUser(receivedItem["mail"], companyCode, 7);

                  /*List<int> gradeLevel = List();
                  List<dynamic> levelList = receivedItem["level"];
                  //var gradeUser = [receivedItem["mail"]];
                  //gradeUser.add(receivedItem["mail"]);
                  for(int i = 0; i < levelList.length; i++){
                    if(levelList[i] != 0)
                      gradeLevel.add(levelList[i]);
                  }
                  gradeLevel.add(grade.gradeID);
                  Map<String, dynamic> map = {
                    "mail" : receivedItem['mail'],
                    "level" : gradeLevel
                  };
                  gradeList.add(map);
                  print(gradeList);

                  FirebaseRepository().addGradeUser(companyCode, gradeList);*/

                  /*Firestore.instance.collection("company").document(companyCode).collection("user").document(receivedItem["mail"]).updateData({
                    "level" : grade.gradeID,
                  });*/
                }
                //Firestore.instance.collection("company").document(companyCode).collection("grade").document(grade.reference.documentID).updateData({'gradeUser' : grade.gradeUser});
              },
              onLeave: (receivedItem) {
                //Firestore.instance.collection("company").document(companyCode).collection("grade").document(grade.reference.documentID).updateData({'gradeUser' : gradeList});
              },
              onWillAccept: (receivedItem) {
                return true;
              },
              builder: (context, acceptedItems, rejectedItems) {
                return Container(
                  width: customWidth(context: context, widthSize: 1),
                  height: customHeight(context: context, heightSize: 1),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Icon(Icons.grade),
                            Text(
                              grade.gradeName,
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName: 'Medium',
                                  fontColor: mainColor
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: PopupMenuButton(
                          icon: Icon(Icons.more_horiz),
                          itemBuilder: (context) => [
                            getPopupItem(
                                context: context,
                                icons: Icons.edit,
                                text: "권한명 수정하기",
                                value: 1
                            ),
                            (grade.gradeID != 9 && grade.gradeID != 8) ?
                            getPopupItem(
                                context: context,
                                icons: Icons.edit,
                                text: "권한 삭제하기",
                                value: 2
                            ) : null,
                            getPopupItem(
                                context: context,
                                icons: Icons.edit,
                                text: "권한 상세 설정",
                                value: 3
                            ),
                            getPopupItem(
                                context: context,
                                icons: Icons.edit,
                                text: "사용자 추가하기",
                                value: 4
                            ),
                            getPopupItem(
                                context: context,
                                icons: Icons.edit,
                                text: "사용자 삭제하기",
                                value: 5
                            ),
                          ],
                          onSelected: (value){
                            switch(value){
                              case 1:
                                getGradeUpadateDialog(
                                  context: context,
                                  companyCode: companyCode,
                                  documentID: grade.reference.documentID,
                                  gradeName: grade.gradeName
                                );
                                break;
                              case 2:
                                getGradeDeleteDialog(
                                  context: context,
                                  companyCode: companyCode,
                                  documentID: grade.reference.documentID,
                                  level: grade.gradeID,
                                );
                                break;
                              case 3:

                                break;
                              case 4:
                                addGradeUserDialog(
                                  context: context,
                                  companyCode: companyCode,
                                  documentID: grade.reference.documentID,
                                  level: grade.gradeID
                                );
                                break;
                              default:
                                dropGradeUserDialog(
                                  context: context,
                                  companyCode: companyCode,
                                  documentID: grade.reference.documentID,
                                  level: grade.gradeID
                                );
                                break;
                            }
                          },
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseRepository().getGreadeUserDetail(companyCode, grade.gradeID),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return LinearProgressIndicator();

                            return ListView(
                                scrollDirection: Axis.horizontal,
                                children: snapshot.data.documents.map((data) => _buildUserListItem(context, data, companyCode)).toList());
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ),
    ),
  );
}

Widget _buildUserListItem(BuildContext context, DocumentSnapshot data, String companyCode) {
  Map<String, dynamic> map = ({
    "mail" : data['mail'],
    "level" : data['level']
  });

  return FutureBuilder(
      future: Firestore.instance
          .collection("company").document(companyCode)
          .collection("user").document(data['mail']).get(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return Text("");
        }
        return Row(
          children: [
            Draggable(
              data: map,
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data['profilePhoto']),
                ),
              ),
              feedback: SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data['profilePhoto']),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 5),
              child: Text(
                snapshot.data['name'],
                style: customStyle(
                  fontWeightName: 'Medium',
                  fontSize: 13,
                  fontColor: mainColor
                ),
              ),
            ),
          ],
        );
      },
    );

}

class GradeData {
  final int gradeID;
  final String gradeName;
  final DocumentReference reference;

  GradeData.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['gradeID'] != null),
        assert(map['gradeName'] != null),
        gradeID = map['gradeID'],
        gradeName = map['gradeName'];

  GradeData.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
