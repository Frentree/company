//Flutter

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/main.dart';
import 'package:companyplaylist/models/noticeModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';
import 'package:companyplaylist/screens/%20alarm/alarmNoticeComment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AlarmNoticePage extends StatefulWidget {
  @override
  AlarmNoticePageState createState() => AlarmNoticePageState();
}

class AlarmNoticePageState extends State<AlarmNoticePage> {
  int i = 0;
  Stream<QuerySnapshot> currentStream;
  CrudRepository _crudRepository;
  LoginUserInfoProvider _loginUserInfoProvider;


  @override
  Widget build(BuildContext context) {
    _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    User user = _loginUserInfoProvider.getLoginUser();
    _crudRepository =
        CrudRepository.noticeAttendance(companyCode: user.companyCode);
    currentStream = _crudRepository.fetchNoticeAsStream();
    return StreamBuilder(
      stream: currentStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
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
                            color: mainColor,
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
                                child: Text(
                                  "사진",
                                  style: TextStyle(
                                      color: Colors.black
                                  ),
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
                              Text(
                                documents[index].data['noticeTitle'].toString(),
                                /*"6월 10일 월간회의 및 회식 공지",*/
                                style: customStyle(
                                    fontSize: 15,
                                    fontWeightName: 'Regular',
                                    fontColor: mainColor
                                ),
                              ),
                              Text(
                                DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(
                                    DateTime.parse(
                                        documents[index].data['noticeCreateDate'].toDate().toString()
                                    ).add(Duration(hours: 9))
                                ),
                                style: customStyle(
                                    fontSize: 13,
                                    fontWeightName: 'Regular',
                                    fontColor: greyColor
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
                                      child: Text(
                                        documents[index].data['noticeContent'].toString(),
                                        maxLines: 3,
                                        style: customStyle(
                                            fontSize: 14,
                                            fontWeightName: 'Regular',
                                            fontColor: mainColor
                                        ),
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
                                "댓글",
                                style: customStyle(
                                  fontColor: mainColor,
                                  fontWeightName: 'Regular',
                                  fontSize: 13
                                ),
                              )
                            ],
                          ),
                          onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    AlarmNoticeCommentPage(
                                      noticeUid: documents[index].data['noticeUid'].toString(),
                                      noticeTitle: documents[index].data['noticeTitle'].toString(),
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
