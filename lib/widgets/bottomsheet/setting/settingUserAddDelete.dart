import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/screens/setting/gradeMain.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

settingUserAddDelete(BuildContext context) {
  FirebaseRepository _repository = FirebaseRepository();
  User _loginUser;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
          _loginUser = _loginUserInfoProvider.getLoginUser();
          return Container(
            height: heightRatio(context: context, heightRatio: 0.895),
            padding: EdgeInsets.symmetric(
              horizontal: widthRatio(
                context: context,
                widthRatio: 0.02,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.yellow,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Container(
                  color: Colors.blue,
                  height: heightRatio(
                    context: context,
                    heightRatio: 0.075,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: widthRatio(context: context, widthRatio: 0.1),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: widthRatio(context: context, widthRatio: 0.1),
                        child: Center(
                            child: Icon(Icons.person_add_alt_1_outlined)),
                      ),
                      Container(
                        width: widthRatio(context: context, widthRatio: 0.4),
                        child: font(text: "사용자 추가 요청/삭제"),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widthRatio(
                      context: context,
                      widthRatio: 0.02,
                    ),
                  ),
                  child: StreamBuilder(
                    stream: _repository.getApproval(
                      companyCode: _loginUser.companyCode,
                    ),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.data == null){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      var _approvalData = [];

                      snapshot.data.documents.forEach((element){
                        _approvalData.add(element);
                      });

                      return Column(
                        children: [
                          Container(
                            color: Colors.red,
                            height: heightRatio(
                              context: context,
                              heightRatio: 0.4,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.grey,
                                  height: heightRatio(
                                    context: context,
                                    heightRatio: 0.05,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: widthRatio(
                                            context: context,
                                            widthRatio: 0.3
                                        ),
                                        child: font(
                                            text: "사용자 추가 요청"
                                        ),
                                      ),
                                      Container(
                                        color: Colors.cyan,
                                        width: widthRatio(
                                          context: context,
                                          widthRatio: 0.3
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: widthRatio(
                                              context: context,
                                              widthRatio: 0.15
                                            ),
                                            height: heightRatio(
                                              context: context,
                                              heightRatio: 0.03,
                                            ),
                                            decoration: BoxDecoration(
                                              color: blueColor,
                                              borderRadius: BorderRadius.circular(12)
                                            ),
                                            child: font(
                                              text: "${_approvalData.length} 건",
                                              textStyle: customStyle(
                                                fontColor: whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _approvalData.length == 0 ? Center(
                                  child: Container(),
                                ) : Expanded(
                                  child: ListView.builder(

                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.teal,
                            height: heightRatio(
                              context: context,
                              heightRatio: 0.4,
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                )
              ],
            ),
          );
        },
      );
    },
  );
}
