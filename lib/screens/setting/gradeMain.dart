import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
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
      body: _buildBody(context, _loginUser),
    );
  }
}

Widget _buildBody(BuildContext context, User user) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection("company").document(user.companyCode).collection("grade").orderBy("gradeID", descending: true).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents, user.companyCode);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, String companyCode) {
  return ListView(children: snapshot.map((data) => _buildListItem(context, data, companyCode)).toList());
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data, String companyCode) {
  final grade = GradeData.fromSnapshow(data);

  return Padding(
    key: ValueKey(grade.gradeID),
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: greyColor),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [_buildUserList(context, grade, companyCode)],
      ),
    ),
  );
}

Widget _buildUserList(BuildContext context, GradeData grade, String companyCode) {
  String acceptData = "";
  List<String> gradeList = List();
  return Expanded(
    child: Container(
      height: customHeight(context: context, heightSize: 0.08),
      child: Container(
            height: customHeight(context: context, heightSize: 1),
            child: DragTarget<Map<String, dynamic>>(
              onAccept: (receivedItem) {
                print(receivedItem);
                if(receivedItem["documentID"] == grade.reference.documentID){
                  print("기존 위치");
                }else {
                  List<String> gradeUser = List();
                  List<String> reGradeUser = List();
                  for(int i = 0; i < grade.gradeUser.length; i++){
                    gradeUser.add(grade.gradeUser[i]);
                  }

                  for(int i = 0; i < receivedItem["gradeUser"].length; i++){
                    reGradeUser.add(receivedItem["gradeUser"][i]);
                  }
                  gradeUser.add(receivedItem["mail"]);

                  reGradeUser.remove(receivedItem["mail"]);

                  //var gradeUser = [receivedItem["mail"]];
                  print("바뀐 위치   ===== > " + gradeUser.toString());
                  print(receivedItem["mail"] + "  , " + receivedItem["documentID"]);
                  print(grade.reference.documentID);
                  //gradeUser.add(receivedItem["mail"]);
                  Firestore.instance.collection("company").document(companyCode).collection("grade").document(grade.reference.documentID).updateData({
                    "gradeUser" : gradeUser,
                  });

                  Firestore.instance.collection("company").document(companyCode).collection("grade").document(receivedItem["documentID"]).updateData({
                    "gradeUser" : reGradeUser,
                  });

                  Firestore.instance.collection("company").document(companyCode).collection("user").document(receivedItem["mail"]).updateData({
                    "level" : grade.gradeID,
                  });
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
                        child: IconButton(
                          icon: Icon(Icons.more_horiz),
                          onPressed: () {

                          },
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: grade.gradeUser.map((data) => _buildUserListItem(context, data, grade, companyCode)).toList(),
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

Widget _buildUserListItem(BuildContext context, String data, GradeData grade, String companyCode) {
  Map<String, dynamic> map = ({
    "mail" : data,
    "documentID" : grade.reference.documentID,
    "gradeUser" : grade.gradeUser
  });

  return FutureBuilder(
      future: Firestore.instance
          .collection("company").document(companyCode)
          .collection("user").document(data).get(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return Text("");
        }
        return Draggable(
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
        );
      },
    );

}

class GradeData {
  final int gradeID;
  final String gradeName;
  final List<dynamic> gradeUser;
  final DocumentReference reference;

  GradeData.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['gradeID'] != null),
        assert(map['gradeUser'] != null),
        assert(map['gradeName'] != null),
        gradeID = map['gradeID'],
        gradeName = map['gradeName'],
        gradeUser = map['gradeUser'];

  GradeData.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, reference: snapshot.reference);
}
