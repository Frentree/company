//Flutter

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/main.dart';
import 'package:companyplaylist/models/noticeModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';
import 'package:companyplaylist/screens/alarm/alarmNoticeComment.dart';
import 'package:companyplaylist/screens/alarm/alarmNoticeDetail.dart';
import 'package:companyplaylist/utils/date/dateFormat.dart';
import 'package:companyplaylist/widgets/bottomsheet/work/workNotice.dart';
import 'package:companyplaylist/widgets/popupMenu/expensePopupMenu.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlarmNoticePage extends StatefulWidget {
  @override
  AlarmNoticePageState createState() => AlarmNoticePageState();
}

class AlarmNoticePageState extends State<AlarmNoticePage> {
  int i = 0;
  LoginUserInfoProvider _loginUserInfoProvider;

  final Firestore _db = Firestore.instance;
  Format _format = Format();
  Stream stream;

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

    stream =  _db
        .collection("company")
        .document(_loginUser.companyCode)
        .collection("notice")
        .orderBy("noticeCreateDate", descending: true)
        .snapshots();

    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("");
          }
          List<DocumentSnapshot> documents =
              snapshot.data.documents;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              /*String _createDate = DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(
                  DateTime.parse(
                      documents[index].data()['noticeCreateDate'].toDate().toString()
                  ).add(Duration(hours: 9))
              );*/

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
                                        return Image.network(snapshot.data()['profilePhoto']);
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
                                                          "공지사항 삭제",
                                                          style: customStyle(
                                                              fontColor: mainColor,
                                                              fontSize: 14,
                                                              fontWeightName: 'Bold'
                                                          ),
                                                        ),
                                                        content: Text(
                                                          "공지사항 내용을 지우시겠습니까?",
                                                          style: customStyle(
                                                              fontColor: mainColor,
                                                              fontSize: 13,
                                                              fontWeightName: 'Regular'
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            child: Text("네",
                                                              style: customStyle(
                                                                  fontColor: blueColor,
                                                                  fontSize: 15,
                                                                  fontWeightName: 'Bold'
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                _db.collection("company")
                                                                    .document(_loginUser.companyCode)
                                                                    .collection("notice").document(documents[index].documentID).delete();
                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                          FlatButton(
                                                            child: Text("아니오",
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
                                                    text: "수정하기",
                                                    value: 1
                                                ),
                                                getPopupItem(
                                                    context: context,
                                                    icons: Icons.delete,
                                                    text: "삭제하기",
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
                                      child: /*Text(
                                        documents[index].data()['noticeContent'].toString(),
                                        maxLines: 3,
                                        style: customStyle(
                                            fontSize: 13,
                                            fontWeightName: 'Medium',
                                            fontColor: mainColor
                                        ),
                                      ),*/
                                      LayoutBuilder(
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
                                                    "더보기",
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
                                      /*RichText(
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis, // TextOverflow.clip // TextOverflow.fade
                                        text: TextSpan(
                                          text: documents[index].data()['noticeContent'].toString(),
                                          style: customStyle(
                                              fontSize: 13,
                                              fontWeightName: 'Medium',
                                              fontColor: mainColor
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(text: '더보기',
                                              style: customStyle(
                                                fontSize: 13,
                                                fontWeightName: 'Medium',
                                                fontColor: blueColor
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),*/
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
                                  "댓글",
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
