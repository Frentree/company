//Flutter
import 'dart:ui';

import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/widgets/bottomsheet/alarm/noticeContentDetails.dart';
import 'package:MyCompany/widgets/photo/profilePhoto.dart';
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
    QuerySnapshot commentCount = await FirebaseFirestore.instance
        .collection('company')
        .doc(_loginUser.companyCode)
        .collection("notice")
        .doc(documentId)
        .collection("comment")
        .get();
    List<DocumentSnapshot> _commentCount = commentCount.docs;

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
                shape: cardShape,
                child: Padding(
                  padding: cardPadding,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 8.0.h,
                            alignment: Alignment.center,
                            child: profilePhoto(loginUser: _loginUser),
                          ),
                          cardSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 8.0.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: SizerUtil.deviceType == DeviceType.Tablet ? 67.0.w : 55.0.w,
                                          height: 5.0.h,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            documents[index].data()['noticeTitle'].toString(),
                                            style: cardTitleStyle,
                                          ),
                                        ),
                                        Visibility(
                                          visible: documents[index].data()['noticeCreateUser']['mail'] == _loginUser.mail,
                                          child: Container(
                                            width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                            height: 5.0.h,
                                            alignment: Alignment.center,
                                            child: PopupMenuButton(
                                              padding: EdgeInsets.zero,
                                              icon: Icon(
                                                Icons.more_vert_sharp,
                                                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                              ),
                                              onSelected: (value) {
                                                if(value == 1){  // 수정하기 버튼 클릭시
                                                  WorkNoticeBottomSheet(context,
                                                      documents[index].id,
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
                                                  height: 7.0.h,
                                                  value: 1,
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
                                                        word.update(),
                                                        style: popupMenuStyle,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  height: 7.0.h,
                                                  value: 2,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete,
                                                        size: SizerUtil.deviceType == DeviceType.Tablet ? popupMenuIconSizeTW.w : popupMenuIconSizeMW.w,
                                                      ),
                                                      Padding(padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w)),
                                                      Text(
                                                        word.delete(),
                                                        style: popupMenuStyle,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 3.0.h,
                                      child: Text(
                                        _format.timeStampToDateTimeString(documents[index].data()['noticeCreateDate']).toString(),
                                        style: cardSubTitleStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  emptySpace,
                                  Container(
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 68.0.w : 57.0.w,
                                    child: LayoutBuilder(
                                      builder: (context, size) {
                                        final span = TextSpan(text: documents[index].data()['noticeContent'].toString(),
                                          style: cardContentsStyle,
                                        );
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
                                                style: cardContentsStyle,
                                              ),
                                              emptySpace,
                                              //더보기 글씨
                                              InkWell(
                                                child: Text(
                                                  word.moreDetails(),
                                                  maxLines: 3,
                                                  style: cardBlueStyle,
                                                ),
                                                onTap: () {
                                                  /*Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) =>
                                                          AlarmNoticeDetailPage(
                                                            noticeUid: documents[index].id,
                                                            noticeTitle: documents[index].data()['noticeTitle'].toString(),
                                                            noticeContent: documents[index].data()['noticeContent'].toString(),
                                                            noticeCreateUser: documents[index].data()['noticeCreateUser']['mail'].toString(),
                                                            noticeCreateDate: _format.timeStampToDateTimeString(documents[index].data()['noticeCreateDate']).toString(),
                                                          ),
                                                      )
                                                  );*/
                                                  NoticeContentDetails(
                                                    context: context,
                                                    noticeUid: documents[index].id,
                                                    companyCode: _loginUser.companyCode,
                                                    noticeTitle: documents[index].data()['noticeTitle'].toString(),
                                                    noticeContent: documents[index].data()['noticeContent'].toString(),
                                                    noticeCreateUser: documents[index].data()['noticeCreateUser']['mail'].toString(),
                                                    noticeCreateDate: _format.timeStampToDateTimeString(documents[index].data()['noticeCreateDate']).toString(),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Text(
                                            documents[index].data()['noticeContent'].toString(),
                                            style: cardContentsStyle,
                                          );
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
                      SizerUtil.deviceType == DeviceType.Tablet ? emptySpace : Container(),
                      Row(
                        children: [
                          Container(
                            child: FlatButton(
                              padding: EdgeInsets.zero,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Icon(
                                      Icons.question_answer,
                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                    ),
                                  ),
                                  cardSpace,
                                  cardSpace,
                                  Text(
                                    word.comments(),
                                    style: cardTitleStyle,
                                  ),
                                  cardSpace,
                                  cardSpace,
                                  FutureBuilder(
                                    future: countDocuments(_loginUser.companyCode, documents[index].id),
                                    builder: (BuildContext context, AsyncSnapshot<String> text) {
                                      if(text.data != "0") {
                                        return Text(
                                          "${text.data}",
                                          style: cardBlueStyle,
                                        );
                                      } else {
                                        return Text("");
                                      }
                                    },
                                  ),
                                ],
                              ),
                              onPressed: () {
                                NoticeContentDetails(
                                  context: context,
                                  noticeUid: documents[index].id,
                                  companyCode: _loginUser.companyCode,
                                  noticeTitle: documents[index].data()['noticeTitle'].toString(),
                                  noticeContent: documents[index].data()['noticeContent'].toString(),
                                  noticeCreateUser: documents[index].data()['noticeCreateUser']['mail'].toString(),
                                  noticeCreateDate: _format.timeStampToDateTimeString(documents[index].data()['noticeCreateDate']).toString(),
                                );
                              },
                            ),
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
