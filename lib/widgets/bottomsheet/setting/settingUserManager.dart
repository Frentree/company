import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/screens/setting/gradeMain.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

SettingUserManager(BuildContext context){
  User _loginUser;
  // 프로필

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),

    builder: (context) {
      LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
      _loginUser = _loginUserInfoProvider.getLoginUser();

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                    Row(
                      children: [
                        Icon(Icons.badge),
                        Padding(padding: EdgeInsets.only(left: 10),),
                        Text('사용자 권한 관리'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: customHeight(context: context, heightSize: 0.01),),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: customWidth(
                          context: context,
                          widthSize: 0.02
                        ),
                      ),
                      Text(
                          "권한명",
                          style: customStyle(
                            fontSize: 14,
                            fontColor: mainColor,
                            fontWeightName: 'Bold'
                          ),
                        ),
                      SizedBox(
                        width: customWidth(
                            context: context,
                            widthSize: 0.2
                        ),
                      ),
                      Text(
                          "수정",
                          style: customStyle(
                              fontSize: 14,
                              fontColor: mainColor,
                              fontWeightName: 'Bold'
                          ),
                        ),
                      SizedBox(
                        width: customWidth(
                            context: context,
                            widthSize: 0.1
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "사용자",
                          style: customStyle(
                              fontSize: 14,
                              fontColor: mainColor,
                              fontWeightName: 'Bold'
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GradeMainPage(),
                )
                /*getGrade(context, "최고 관리자", 9),
                getGrade(context, "업무 관리자", 8),
                getGrade(context, "회계 담당자", 7),
                getGrade(context, "앱 관리자", 6),*/
              ],
            ),
          );

        }
      );
    }
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

  GradeData.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
