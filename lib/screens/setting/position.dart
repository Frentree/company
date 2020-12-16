import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseMethod.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/widgets/dialog/positionDialogList.dart';
import 'package:MyCompany/widgets/notImplementedPopup.dart';
import 'package:MyCompany/widgets/popupMenu/expensePopupMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();

class PositionPage extends StatefulWidget {
  @override
  PositionPageState createState() => PositionPageState();
}

class PositionPageState extends State<PositionPage> {
  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();

    return Scaffold(
      body: _buildBody(context, _loginUser),
    );
  }

  User _loginUser;
}

Widget _buildBody(BuildContext context, User user) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseRepository().getPositionList(companyCode: user.companyCode),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents, user.companyCode);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, String companyCode) {
  return CustomScrollView(
    slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate(
                (context, index) => _buildListItem(context, snapshot[index], companyCode),
            childCount: snapshot.length),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
                  alignment: Alignment.centerLeft,
                  child: RaisedButton(
                    color: whiteColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: mainColor)),
                    child: Icon(Icons.add),
                    onPressed: () {
                      addPositionDialog(companyCode: companyCode, context: context);
                    },
                  ),
                ),
            childCount: 1),
      ),
    ],
  );
  /*return ListView.builder(
    itemCount: snapshot.length,
    itemBuilder: (context, index) {
      return _buildListItem(context, snapshot[index], companyCode);
    },
  );*/
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data, String companyCode) {
  final team = PositionData.fromSnapshow(data);

  return Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: grayColor
        )
      )
    ),
    child: Row(
      children: [
        _buildUserList(context, team, companyCode)
      ],
    ),
  );
}

Widget _buildUserList(BuildContext context, PositionData postion, String companyCode) {
  List<Map<String,dynamic>> gradeList = List();
  return Expanded(
    child: Container(
      height: customHeight(context: context, heightSize: 0.15),
      child: Container(
        height: customHeight(context: context, heightSize: 1),
        child: DragTarget<Map<String, dynamic>>(
            onAccept: (receivedItem) {
              print(receivedItem);
              //getErrorDialog(context: context, text: word.updateFail());
              NotImplementedFunction(context);
              if (receivedItem["documentID"] == postion.reference.documentID) {
                //print("기존 위치");
              } else {}
            },
            onLeave: (receivedItem) {},
            onWillAccept: (receivedItem) {
              return true;
            },
            builder: (context, acceptedItems, rejectedItems) {
              return Container(
                width: customWidth(context: context, widthSize: 1),
                height: customHeight(context: context, heightSize: 1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Icon(Icons.web_outlined),
                          Text(
                            postion.position,
                            style: customStyle(fontSize: 14, fontWeightName: 'Medium', fontColor: mainColor),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: PopupMenuButton(
                        icon: Icon(Icons.more_horiz),
                        itemBuilder: (context) => [
                          getPopupItem(context: context, icons: Icons.update, text: word.departmentUpdate(), value: 1),
                          //getPopupItem(context: context, icons: Icons.edit, text: word.parentDepartmentCreate(), value: 2),
                          //getPopupItem(context: context, icons: Icons.edit, text: word.subDepartmentCreate(), value: 3),
                          getPopupItem(context: context, icons: Icons.delete, text: word.departmentDelete(), value: 4),
                          getPopupItem(context: context, icons: Icons.add, text: word.addMember(), value: 5),
                          getPopupItem(context: context, icons: Icons.delete, text: word.deleteMember(), value: 6),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case 1:
                              getPositionUpadateDialog(
                                  context: context, documentID: postion.reference.documentID, position: postion.position, companyCode: companyCode);
                              break;
                            case 2: case 3:
                              break;
                            case 4:
                              getPositionDeleteDialog(
                                  context: context, documentID: postion.reference.documentID, position: postion.position, companyCode: companyCode);
                              break;
                            case 5:
                              addPositionUserDialog(
                                  context: context, documentID: postion.reference.documentID, position: postion.position, companyCode: companyCode);
                              break;
                            case 6:
                              dropPositionUserDialog(
                                  context: context, documentID: postion.reference.documentID, position: postion.position, companyCode: companyCode);
                              break;
                            default:

                              break;
                          }
                        },
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseRepository().getUserPosition(companyCode: companyCode, position: postion.position),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return LinearProgressIndicator();

                          return ListView(
                              scrollDirection: Axis.vertical,
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
        return Column(
          children: [
            Row(
              children: [
                Draggable(
                  data: map,
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data['profilePhoto']),
                    ),
                  ),
                  feedback: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data['profilePhoto']),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 5),
                  child: Text(
                    snapshot.data['name'] + " " + snapshot.data['position'],
                    style: customStyle(
                      fontWeightName: 'Medium',
                      fontSize: 13,
                      fontColor: mainColor
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.0.h,
            )
          ],
        );
      },
    );

}

class PositionData {
  final String position;
  final DocumentReference reference;

  PositionData.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['position'] != null),
        position = map['position'];

  PositionData.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
