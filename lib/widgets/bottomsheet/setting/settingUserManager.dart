import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
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

          getGrade(BuildContext context, String gradeName, int gradeID){
            return Row(
              children: [
                Icon(Icons.grade_outlined),
                Text(gradeName),
                IconButton(
                  icon: Icon(Icons.more_horiz),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: Firestore.instance.collection("company").document(_loginUser.companyCode).collection("grade").where("gradeID", isEqualTo: gradeID).snapshots(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        return Text("");
                      }
                      List<DocumentSnapshot> documents = snapshot.data.documents;

                      if(documents.length == 0){
                        return Text("");
                      }
                      final grade = GradeData.fromSnapshow(documents[0]);

                      return Container(
                        width: customWidth(
                          context: context,
                          widthSize: 1
                        ),
                        height: customHeight(
                            context: context,
                            heightSize: 0.08
                        ),
                        child: DragTarget(
                          onAccept: (Map<String,dynamic> receivedItem) {
                            setState((){
                              if(receivedItem["documentID"] == documents[0].documentID){
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
                                //gradeUser.add(receivedItem["mail"]);
                                Firestore.instance.collection("company").document(_loginUser.companyCode).collection("grade").document(documents[0].documentID).updateData({
                                  "gradeUser" : gradeUser,
                                });

                                Firestore.instance.collection("company").document(_loginUser.companyCode).collection("grade").document(receivedItem["documentID"]).updateData({
                                  "gradeUser" : reGradeUser,
                                });
                              }
                              /*Firestore.instance.collection("company").document(_loginUser.companyCode).collection("grade").document(documents[0].documentID).updateData({
                                "gradeUser" : gradeUser,
                              });*/
                            });
                          },
                          onWillAccept: (receivedItem) => true,
                          builder : (context, acceptedItems, rejectedItems) {
                           return Container(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: grade.gradeUser.length,
                              itemBuilder: (context, index) {
                                return FutureBuilder(
                                  future: FirebaseStorage.instance.ref().child("profile/${grade.gradeUser[index]}").getDownloadURL(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      Map<String, dynamic> map = ({
                                        "documentID" : grade.reference.documentID,
                                        "mail" : grade.gradeUser[index],
                                        "gradeUser" : grade.gradeUser,
                                      });
                                      return  Draggable(
                                        data: map,
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
                                            backgroundImage: NetworkImage(""),
                                          ),
                                        ),
                                      );
                                    }
                                    Map<String, dynamic> map = ({
                                     "documentID" : grade.reference.documentID,
                                     "mail" : grade.gradeUser[index],
                                     "gradeUser" : grade.gradeUser,
                                    });
                                    return Draggable(
                                      data: map,
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
                                );
                              }
                            ),
                          );
                          }
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

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
                      Expanded(
                        flex: 1,
                        child: Text(
                          "권한명"
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                            "수정"
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                            "사용자"
                        ),
                      ),
                    ],
                  ),
                ),
                /*Expanded(
                  child: GradeMainPage(),
                )*/
                getGrade(context, "최고 관리자", 9),
                getGrade(context, "업무 관리자", 8),
                getGrade(context, "회계 담당자", 7),
                getGrade(context, "앱 관리자", 6),
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

  GradeData.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, reference: snapshot.reference);
}
