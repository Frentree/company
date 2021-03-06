import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
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
      backgroundColor: whiteColor,
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
            (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                emptySpace,
                Container(
                  height: buttonSizeH.h,
                  width: SizerUtil.deviceType == DeviceType.Tablet ? 15.0.w : 20.0.w,
                  child: RaisedButton(
                    color: whiteColor,
                    shape: raisedButtonBlueShape,
                    child: Icon(
                      Icons.add,
                      size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                      color: blueColor,
                    ),
                    onPressed: () {
                      addPositionDialog(companyCode: companyCode, context: context);
                    },
                  ),
                ),
                emptySpace,
              ],
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
    padding: cardPadding,
    height: 20.0.h,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: grayColor
        )
      )
    ),
    child: _buildUserList(context, team, companyCode),
  );
}

Widget _buildUserList(BuildContext context, PositionData postion, String companyCode) {
  List<Map<String,dynamic>> gradeList = List();
  return DragTarget<Map<String, dynamic>>(
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
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 20.0.w,
              child: Text(
                postion.position,
                style: defaultMediumStyle,
              ),
            ),
            cardSpace,
            Container(
              height: 5.0.h,
              width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
              alignment: Alignment.topCenter,
              child: PopupMenuButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.more_horiz,
                  size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                ),
                itemBuilder: (context) => [
                  getPopupItem(context: context, icons: Icons.update, text: word.positionUpdate(), value: 1),
                  //getPopupItem(context: context, icons: Icons.edit, text: word.parentDepartmentCreate(), value: 2),
                  //getPopupItem(context: context, icons: Icons.edit, text: word.subDepartmentCreate(), value: 3),
                  getPopupItem(context: context, icons: Icons.delete, text: word.positionDelete(), value: 4),
                  getPopupItem(context: context, icons: Icons.add, text: word.addMember(), value: 5),
                  getPopupItem(context: context, icons: Icons.delete, text: word.deleteMember(), value: 6),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 1:
                      getPositionUpadateDialog(
                          context: context, documentID: postion.reference.id, position: postion.position, companyCode: companyCode);
                      break;
                    case 2: case 3:
                      break;
                    case 4:
                      getPositionDeleteDialog(
                          context: context, documentID: postion.reference.id, position: postion.position, companyCode: companyCode);
                      break;
                    case 5:
                      addPositionUserDialog(
                          context: context, documentID: postion.reference.id, position: postion.position, companyCode: companyCode);
                      break;
                    case 6:
                      dropPositionUserDialog(
                          context: context, documentID: postion.reference.id, position: postion.position, companyCode: companyCode);
                      break;
                    default:

                      break;
                  }
                },
              ),
            ),
            cardSpace,
            Expanded(
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
        );
      });
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
                CircleAvatar(
                  radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.0.w : 4.0.w,
                  backgroundColor: whiteColor,
                  backgroundImage: NetworkImage(snapshot.data['profilePhoto']),
                ),
                /*Draggable(
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
                ),*/
                cardSpace,
                Text(
                  snapshot.data['name'] + " " + snapshot.data['position'],
                  style: defaultRegularStyle,
                ),
              ],
            ),
            emptySpace,
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
