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
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      width: 1,
                      color: boarderColor,
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: customWidth(
                                context: context,
                                widthSize: 0.02
                            )
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              color: whiteColor,
                              width: customWidth(
                                  context: context,
                                  widthSize: 0.08
                              ),
                              child: GestureDetector(
                                child: Container(
                                    height: customHeight(
                                        context: context,
                                        heightSize: 0.05
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: whiteColor,
                                        border: Border.all(
                                            color: whiteColor, width: 2)
                                    ),
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
                                onTap: () {},
                              ),
                            ),
                            SizedBox(
                              width: customWidth(
                                  context: context,
                                  widthSize: 0.04
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: customWidth(
                                      context: context,
                                      widthSize: 0.72
                                  ),
                                  height: customHeight(
                                      context: context,
                                      heightSize: 0.03
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Text(
                                          documents[index].data()['noticeTitle'].toString(),
                                          /*"6월 10일 월간회의 및 회식 공지",*/
                                          style: customStyle(
                                              fontSize: 15,
                                              fontWeightName: 'Bold',
                                              fontColor: mainColor
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          child: Visibility(
                                            visible: documents[index].data()['noticeCreateUser']['mail'] == _loginUser.mail,
                                            child: PopupMenuButton(
                                              icon: Icon(
                                                  Icons.more_horiz
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
                                                              fontSize: 14,
                                                              fontWeightName: 'Bold'
                                                          ),
                                                        ),
                                                        content: Text(
                                                          word.noticeDeleteCon(),
                                                          style: customStyle(
                                                              fontColor: mainColor,
                                                              fontSize: 13,
                                                              fontWeightName: 'Regular'
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            child: Text(word.yes(),
                                                              style: customStyle(
                                                                  fontColor: blueColor,
                                                                  fontSize: 15,
                                                                  fontWeightName: 'Bold'
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
                                                                  fontSize: 15,
                                                                  fontWeightName: 'Bold'
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
                                                getPopupItem(
                                                    context: context,
                                                    icons: Icons.edit,
                                                    text: word.update(),
                                                    value: 1
                                                ),
                                                getPopupItem(
                                                    context: context,
                                                    icons: Icons.delete,
                                                    text: word.delete(),
                                                    value: 2
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                _format.timeStampToDateTimeString(documents[index].data()['noticeCreateDate']).toString(),
                                  style: customStyle(
                                      fontSize: 12,
                                      fontWeightName: 'Regular',
                                      fontColor: grayColor
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: customHeight(
                                          heightSize: 0.02,
                                          context: context
                                      ),
                                    ),
                                    Container(
                                      width: customWidth(
                                        context: context,
                                        widthSize: 0.7,
                                      ),
                                      padding:  const EdgeInsets.all(0.2),
                                      child: LayoutBuilder(
                                        builder: (context, size) {
                                          final span = TextSpan(text: documents[index].data()['noticeContent'].toString(), style: customStyle(
                                              fontSize: 13,
                                              fontWeightName: 'Medium',
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
                                                      fontSize: 13,
                                                      fontWeightName: 'Medium',
                                                      fontColor: mainColor
                                                  ),
                                                ),
                                                InkWell(
                                                  child: Text(
                                                    word.moreDetails(),
                                                    maxLines: 3,
                                                    style: customStyle(
                                                        fontSize: 13,
                                                        fontWeightName: 'Medium',
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
                                                fontSize: 13,
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
                      ),

                      Row(
                        children: [
                          FlatButton(
                            color: Colors.white,
                            padding: EdgeInsets.all(10.0),
                            child: Row( // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Icon(
                                  Icons.question_answer,
                                  size: 15,
                                ),

                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 5
                                  ),
                                ),
                                Text(
                                  word.comments(),
                                  style: customStyle(
                                      fontColor: mainColor,
                                      fontWeightName: 'Bold',
                                      fontSize: 13
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 5
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
                                            fontWeightName: 'Bold',
                                            fontSize: 13
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
