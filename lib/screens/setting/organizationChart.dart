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
import 'package:MyCompany/widgets/dialog/organizationChartDialogList.dart';
import 'package:MyCompany/widgets/notImplementedPopup.dart';
import 'package:MyCompany/widgets/popupMenu/expensePopupMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();

class OrganizationChartPage extends StatefulWidget {
  @override
  OrganizationChartPageState createState() => OrganizationChartPageState();
}

class OrganizationChartPageState extends State<OrganizationChartPage> {
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
    stream: FirebaseMethods().getTeamList(user.companyCode),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.docs, user.companyCode);
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
                    elevation: 0.0,
                    child: Icon(
                      Icons.add,
                      size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                      color: blueColor,
                    ),
                    onPressed: () {
                      addTeamDialog(companyCode: companyCode, context: context);
                    },
                  ),
                ),
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
  final team = TeamData.fromSnapshow(data);

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

Widget _buildUserList(BuildContext context, TeamData team, String companyCode) {
  List<Map<String,dynamic>> gradeList = List();
  return DragTarget<Map<String, dynamic>>(
      onAccept: (receivedItem) {
        print(receivedItem);
        //getErrorDialog(context: context, text: word.updateFail());
        NotImplementedFunction(context);
        if (receivedItem["documentID"] == team.reference.documentID) {
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
              width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
              child: Text(
                team.teamName,
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
                  Icons.more_horiz_sharp,
                  size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 1:
                      getTeamUpadateDialog(
                          context: context, documentID: team.reference.documentID, teamName: team.teamName, companyCode: companyCode);
                      break;
                    case 2: case 3:
                    break;
                    case 4:
                      getTeamDeleteDialog(
                          context: context, documentID: team.reference.documentID, teamName: team.teamName, companyCode: companyCode);
                      break;
                    case 5:
                      addTeamUserDialog(
                          context: context, documentID: team.reference.documentID, teamName: team.teamName, companyCode: companyCode);
                      break;
                    case 6:
                      dropTeamUserDialog(
                          context: context, documentID: team.reference.documentID, teamName: team.teamName, companyCode: companyCode);
                      break;
                    default:

                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    height: 7.0.h,
                    value: 1,
                    child: Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.update,
                            size: SizerUtil.deviceType == DeviceType.Tablet ? popupMenuIconSizeTW.w : popupMenuIconSizeMW.w,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w)),
                        Text(
                          word.departmentUpdate(),
                          style: popupMenuStyle,
                        )
                      ],
                    ),
                  ),
                 /* PopupMenuItem(
                    height: 7.0.h,
                    value: 2,
                    child: Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.edit,
                            size: SizerUtil.deviceType == DeviceType.Tablet ? popupMenuIconSizeTW.w : popupMenuIconSizeMW.w,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w)),
                        Text(
                          word.parentDepartmentCreate(),
                          style: popupMenuStyle,
                        )
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    height: 7.0.h,
                    value: 3,
                    child: Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.edit,
                            size: SizerUtil.deviceType == DeviceType.Tablet ? popupMenuIconSizeTW.w : popupMenuIconSizeMW.w,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w)),
                        Text(
                          word.subDepartmentCreate(),
                          style: popupMenuStyle,
                        )
                      ],
                    ),
                  ),*/
                  PopupMenuItem(
                    height: 7.0.h,
                    value: 4,
                    child: Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.delete,
                            size: SizerUtil.deviceType == DeviceType.Tablet ? popupMenuIconSizeTW.w : popupMenuIconSizeMW.w,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w)),
                        Text(
                          word.departmentDelete(),
                          style: popupMenuStyle,
                        )
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    height: 7.0.h,
                    value: 5,
                    child: Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.add,
                            size: SizerUtil.deviceType == DeviceType.Tablet ? popupMenuIconSizeTW.w : popupMenuIconSizeMW.w,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w)),
                        Text(
                          word.addMember(),
                          style: popupMenuStyle,
                        )
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    height: 7.0.h,
                    value: 6,
                    child: Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.delete,
                            size: SizerUtil.deviceType == DeviceType.Tablet ? popupMenuIconSizeTW.w : popupMenuIconSizeMW.w,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w)),
                        Text(
                          word.deleteMember(),
                          style: popupMenuStyle,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            cardSpace,
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseRepository().getUserTeam(companyCode: companyCode, teamName: team.teamName),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();

                  return ListView(
                      scrollDirection: Axis.vertical,
                      children: snapshot.data.docs.map((data) => _buildUserListItem(context, data, companyCode)).toList());
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
      future: FirebaseFirestore.instance
          .collection("company").doc(companyCode)
          .collection("user").doc(data['mail']).get(),
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
               /* Draggable(
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

class TeamData {
  final String teamName;
  final DocumentReference reference;

  TeamData.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['teamName'] != null),
        teamName = map['teamName'];

  TeamData.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
