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

SettingUserAddDelete(BuildContext context) {
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
                    heightRatio: 0.08,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: widthRatio(
                          context: context,
                          widthRatio: 0.1
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                            ),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: widthRatio(
                            context: context,
                            widthRatio: 0.1
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person_add_alt_1_outlined
                          )
                        ),
                      ),
                      Container(
                        width: widthRatio(
                            context: context,
                            widthRatio: 0.4
                        ),
                        child: Center(
                          child: font(
                            text: "사용자 추가 요청/삭제"
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      });
}
