import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
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
    stream: Firestore.instance.collection("company").document(user.companyCode).collection("grade").snapshots(),
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
      height: customHeight(context: context, heightSize: 0.1),
      child: Stack(
        children: [
          Container(
            height: customHeight(context: context, heightSize: 1),
            child: DragTarget<GradeData>(
              key: ValueKey(grade.reference.documentID),
              onAccept: (receivedItem) {
                acceptData = receivedItem.gradeID.toString();
                //Firestore.instance.collection("company").document(companyCode).collection("grade").document(grade.reference.documentID).updateData({'gradeUser' : grade.gradeUser});
              },
              onLeave: (receivedItem) {
                print(receivedItem);
                //Firestore.instance.collection("company").document(companyCode).collection("grade").document(grade.reference.documentID).updateData({'gradeUser' : gradeList});
              },
              onWillAccept: (receivedItem) {
                return true;
              },
              builder: (context, acceptedItems, rejectedItems) {
                 return Container(
                    width: customWidth(context: context, widthSize: 1),
                    height: customHeight(context: context, heightSize: 1),
                    color: Colors.red,
                    child: Center(child: Text(acceptData)),
                );
            }),
          ),
          ListView(
            scrollDirection: Axis.horizontal,
            children: grade.gradeUser
                .map(
                  (data) => FutureBuilder(
                    future: FirebaseStorage.instance.ref().child("profile/${data}").getDownloadURL(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Icon(Icons.person_outline);
                      }
                      return Draggable(
                        data: data,
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data),
                          ),
                        ),
                        feedback: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data),
                          ),
                        ),
                      );
                    },
                  ),
                ).toList(),
          ),
        ],
      ),
    ),
  );
}

Widget _buildUserListItem(BuildContext context, String data) {
  return Draggable(
    data: data,
    child: SizedBox(
      width: 40,
      height: 40,
      child: FutureBuilder(
        future: FirebaseStorage.instance.ref().child("profile/${data}").getDownloadURL(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Icon(Icons.person_outline);
          }
          return CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data),
          );
        },
      ),
    ),
    feedback: SizedBox(
      width: 40,
      height: 40,
      child: FutureBuilder(
        future: FirebaseStorage.instance.ref().child("profile/${data}").getDownloadURL(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Icon(Icons.person_outline);
          }
          return CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data),
          );
        },
      ),
    ),
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
