import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseMethod.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/widgets/dialog/gradeDialogList.dart';
import 'package:MyCompany/widgets/popupMenu/expensePopupMenu.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/widgets/notImplementedPopup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();

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
      backgroundColor: whiteColor,
      /*floatingActionButton:
      FloatingActionButton.extended(
        backgroundColor: mainColor,
        onPressed: (){
          addGradeDialog(context: context, companyCode: _loginUser.companyCode);
        },
        label: Text(
          word.addPermission(),
          style: customStyle(
            fontColor: whiteColor,
            fontWeightName: 'Bold',
            fontSize: 15
          ),
        ),
      ),*/
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
  return CustomScrollView(
    slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => _buildListItem(context, snapshot[index], companyCode),
          childCount: snapshot.length,
        ),
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
                      addGradeDialog(context: context, companyCode: companyCode);
                    },
                  ),
                ),
                emptySpace,
              ],
            ),
            childCount: 1

        ),
      )
    ],
  );
    /*Column(
    children: [
      Expanded(child: ListView(children: snapshot.map((data) => _buildListItem(context, data, companyCode)).toList())),
    ],
  );*/
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data, String companyCode) {
  final grade = GradeData.fromSnapshow(data);

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
    child: _buildUserList(context, grade, companyCode),
  );
  return StreamBuilder<Object>(
    stream: null,
    builder: (context, snapshot) {
      return Column(
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
      );
    }
  );
}

Widget _buildUserList(BuildContext context, GradeData grade, String companyCode) {
  List<Map<String,dynamic>> gradeList = List();
  return DragTarget<Map<String, dynamic>>(
    onAccept: (receivedItem) {
      print(receivedItem);
      //getErrorDialog(context: context, text: word.updateFail());
      NotImplementedFunction(context);
      if(receivedItem["documentID"] == grade.reference.documentID){
        //print("기존 위치");
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
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 20.0.w,
            child: Text(
              grade.gradeName,
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
                getPopupItem(
                    context: context,
                    icons: Icons.update,
                    text: word.gradeNameUpdate(),
                    value: 1
                ),
                (grade.gradeID != 9 && grade.gradeID != 8) ?
                getPopupItem(
                    context: context,
                    icons: Icons.delete,
                    text: word.deleteGrade(),
                    value: 2
                ) : null,
                getPopupItem(
                    context: context,
                    icons: Icons.edit,
                    text: word.permissionDetails(),
                    value: 3
                ),
                getPopupItem(
                    context: context,
                    icons: Icons.add,
                    text: word.addUser(),
                    value: 4
                ),
                getPopupItem(
                    context: context,
                    icons: Icons.delete,
                    text: word.deleteUserPermission(),
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
          cardSpace,
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseRepository().getGreadeUserDetail(companyCode, grade.gradeID),
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
                /*Draggable(
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
                ),*/
                cardSpace,
                Text(
                  snapshot.data['name'],
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
