//Flutter

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/main.dart';
import 'package:MyCompany/models/noticeModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/repos/firebasecrud/crudRepository.dart';
import 'package:MyCompany/screens/alarm/alarmNoticeComment.dart';
import 'package:MyCompany/screens/alarm/alarmNoticeDetail.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/bottomsheet/work/workNotice.dart';
import 'package:MyCompany/widgets/popupMenu/expensePopupMenu.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

final word = Words();

class AlarmNoticePage extends StatefulWidget {
  @override
  AlarmNoticePageState createState() => AlarmNoticePageState();
}

class AlarmNoticePageState extends State<AlarmNoticePage> {
  int i = 0;
  LoginUserInfoProvider _loginUserInfoProvider;

  Format _format = Format();

  User _loginUser;


  // 댓글 카운트
  Future<String> countDocuments(String companyCode, String documentId) async {
    QuerySnapshot commentCount = await Firestore.instance
        .collection('company')
        .document(_loginUser.companyCode)
        .collection("notice")
        .document(documentId)
        .collection("comment")
        .getDocuments();
    List<DocumentSnapshot> _commentCount = commentCount.documents;

    print(_commentCount.length);  // Count of Documents in Collection

    return await _commentCount.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();


    return StreamBuilder(
        stream: FirebaseRepository().getNoticeList(companyCode: _loginUser.companyCode),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("");
          }
          List<DocumentSnapshot> documents =
              snapshot.data.documents;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(cardRadiusW.w),
                    side: BorderSide(
                      width: 1,
                      color: boarderColor,
                    )
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.0.w,
                    vertical: 2.0.h),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            color: whiteColor,
                            width: 10.0.w,
                            height: 7.0.h,
                            child: FutureBuilder(
                              future: FirebaseRepository().photoProfile(_loginUser.companyCode, documents[index].data()['noticeCreateUser']['mail']),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Icon(Icons.person_outline);
                                }
                                return Image.network(snapshot.data['profilePhoto']);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 4.0.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                color: Colors.yellow,
                                width: 70.0.w,
                                height: 5.0.h,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60.0.w,
                                      child: Text(
                                        documents[index].data()['noticeTitle'].toString(),
                                        style: customStyle(
                                            fontSize: cardTitleFontSize.sp,
                                            fontWeightName: 'Medium',
                                            fontColor: mainColor
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 10.0.w,
                                      child: Visibility(
                                        visible: documents[index].data()['noticeCreateUser']['mail'] == _loginUser.mail,
                                        child: PopupMenuButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                              Icons.more_horiz,
                                            size: iconSizeW.w,
                                          ),
                                          onSelected: (value) {
                                            if(value == 1){  // 수정하기 버튼 클릭시
                                              WorkNoticeBottomSheet(context,
                                                  documents[index].documentID,
                                                  documents[index].data()['noticeTitle'],
                                                  documents[index].data()['noticeContent']
                                              );
                                            } else if(value == 2) { // 삭제 버튼 클릭시
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  // return object of type Dialog
                                                  return AlertDialog(
                                                    title: Text(
                                                      word.noticeDelete(),
                                                      style: customStyle(
                                                          fontColor: mainColor,
                                                          fontSize: homePageDefaultFontSize.sp,
                                                          fontWeightName: 'Medium'
                                                      ),
                                                    ),
                                                    content: Text(
                                                      word.noticeDeleteCon(),
                                                      style: customStyle(
                                                          fontColor: mainColor,
                                                          fontSize: 12.0.sp,
                                                          fontWeightName: 'Regular'
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text(word.yes(),
                                                          style: customStyle(
                                                              fontColor: blueColor,
                                                              fontSize: homePageDefaultFontSize.sp,
                                                              fontWeightName: 'Medium'
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            FirebaseRepository().deleteNotice(
                                                              companyCode: _loginUser.companyCode,
                                                              documentID: documents[index].documentID
                                                            );
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child: Text(word.no(),
                                                          style: customStyle(
                                                              fontColor: blueColor,
                                                              fontSize: homePageDefaultFontSize.sp,
                                                              fontWeightName: 'Medium'
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          itemBuilder: (BuildContext context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(
                                                children: [Icon(Icons.edit, size: 7.0.w,), Padding(padding: EdgeInsets.only(left: 2.0.w)),Text(word.update(), style: customStyle(fontSize: 13.0.sp),)],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(
                                                children: [Icon(Icons.delete, size: 7.0.w,), Padding(padding: EdgeInsets.only(left: 2.0.w)),Text(word.delete(), style: customStyle(fontSize: 13.0.sp),)],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                              _format.timeStampToDateTimeString(documents[index].data()['noticeCreateDate']).toString(),
                                style: customStyle(
                                    fontSize: 11.0.sp,
                                    fontWeightName: 'Regular',
                                    fontColor: grayColor
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 2.0.h,
                                  ),
                                  Container(
                                    width: 70.0.w,
                                    child: LayoutBuilder(
                                      builder: (context, size) {
                                        final span = TextSpan(text: documents[index].data()['noticeContent'].toString(), style: customStyle(
                                            fontSize: 12.0.sp,
                                            fontWeightName: 'Regular',
                                            fontColor: mainColor
                                        ),);
                                        final tp = TextPainter(text: span,textDirection:TextDirection.ltr , maxLines: 3);
                                        tp.layout(maxWidth: size.maxWidth);

                                        List<LineMetrics> lines = tp.computeLineMetrics();
                                        int numberOfLines = lines.length;
                                        if (tp.didExceedMaxLines) {
                                          // The text has more than three lines.
                                          // TODO: display the prompt message
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                documents[index].data()['noticeContent'].toString(),
                                                maxLines: 3,
                                                style: customStyle(
                                                    fontSize: 12.0.sp,
                                                    fontWeightName: 'Regular',
                                                    fontColor: mainColor
                                                ),
                                              ),
                                              InkWell(
                                                child: Text(
                                                  word.moreDetails(),
                                                  maxLines: 3,
                                                  style: customStyle(
                                                      fontSize: 11.0.sp,
                                                      fontWeightName: 'Regular',
                                                      fontColor: blueColor
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) =>
                                                      AlarmNoticeDetailPage(
                                                        noticeUid: documents[index].documentID,
                                                        noticeTitle: documents[index].data()['noticeTitle'].toString(),
                                                        noticeContent: documents[index].data()['noticeContent'].toString(),
                                                        noticeCreateUser: documents[index].data()['noticeCreateUser']['mail'].toString(),
                                                        noticeCreateDate: _format.timeStampToDateTimeString(documents[index].data()['noticeCreateDate']).toString(),
                                                      )
                                                      )
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Text(documents[index].data()['noticeContent'].toString(), style: customStyle(
                                              fontSize: 12.0.sp,
                                              fontWeightName: 'Medium',
                                              fontColor: mainColor
                                          ),);
                                        }


                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          FlatButton(
                            color: Colors.white,
                            padding: EdgeInsets.only(right: 10.0.w,),
                            child: Row( // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Icon(
                                  Icons.question_answer,
                                  size: 6.0.w,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 5.0.w,
                                  ),
                                ),
                                Text(
                                  word.comments(),
                                  style: customStyle(
                                      fontColor: mainColor,
                                      fontWeightName: 'Medium',
                                      fontSize: 12.0.sp
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 5.0.w,
                                  ),
                                ),
                                FutureBuilder(
                                  future: countDocuments(_loginUser.companyCode, documents[index].documentID),
                                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                                    if(text.data != "0") {
                                      return Text(
                                        "${text.data}",
                                        style: customStyle(
                                            fontColor: blueColor,
                                            fontWeightName: 'Medium',
                                            fontSize: 12.0.sp
                                        ),
                                      );
                                    } else {
                                      return Text("");
                                    }
                                  },
                                ),
                              ],
                            ),
                            onPressed: () =>{
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                  /*AlarmNoticeCommentPage(
                                      noticeUid: documents[index].data()['noticeUid'].toString(),
                                      noticeTitle: documents[index].data()['noticeTitle'].toString(),
                                      noticeContent: documents[index].data()['noticeContent'].toString(),
                                      noticeCreateDate: _createDate,
                                    )*/
                                  AlarmNoticeDetailPage(
                                    noticeUid: documents[index].documentID,
                                    noticeTitle: documents[index].data()['noticeTitle'].toString(),
                                    noticeContent: documents[index].data()['noticeContent'].toString(),
                                    noticeCreateUser: documents[index].data()['noticeCreateUser']['mail'].toString(),
                                    noticeCreateDate: _format.timeStampToDateTimeString(documents[index].data()['noticeCreateDate']).toString(),
                                  )
                                  )
                              ),
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            // workScheduleCard(context)
          );
        }
    );
  }
}
