import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/commentListModel.dart';
import 'package:MyCompany/models/commentModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/provider/attendance/attendanceCheck.dart';
import 'package:MyCompany/models/attendanceModel.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

final word = Words();

class AlarmNoticeDetailPage extends StatefulWidget {
  final noticeUid;
  final noticeTitle;
  final noticeContent;
  final noticeCreateDate;
  final noticeCreateUser;

  AlarmNoticeDetailPage(
      {Key key,
      @required this.noticeUid,
      @required this.noticeTitle,
      @required this.noticeContent,
      @required this.noticeCreateDate,
      @required this.noticeCreateUser});

  @override
  AlarmNoticeDetailPageState createState() => AlarmNoticeDetailPageState(
      noticeUid: noticeUid,
      noticeTitle: noticeTitle,
      noticeCreateDate: noticeCreateDate,
      noticeContent: noticeContent,
      noticeCreateUser: noticeCreateUser);
}

class AlarmNoticeDetailPageState extends State<AlarmNoticeDetailPage> {
  final noticeUid;
  final noticeTitle;
  final noticeContent;
  final noticeCreateDate;
  final noticeCreateUser;

  AlarmNoticeDetailPageState(
      {Key key,
      @required this.noticeUid,
      @required this.noticeTitle,
      @required this.noticeContent,
      @required this.noticeCreateDate,
      @required this.noticeCreateUser});

  User _loginUser;

  TextEditingController _noticeComment = TextEditingController();

  String _commentId = "";

  // 댓글 달릴 유저명
  String commnetUser = "";

  // 댓글 입력, 수정 타입
  int crudType = 0;

  CommentModel _commnetModel;

  CommentListModel _commentList;

  // 댓글 입력창 포커스
  FocusNode _commnetFocusNode = FocusNode();

  Attendance _attendance = Attendance();

  _getCommentList(List<DocumentSnapshot> documents, BuildContext context,
      String documentID) {
    List<Widget> widgets = [];
    for (int i = 0; i < documents.length; i++) {
      widgets.add(Column(
        children: [
          SizedBox(
            height: 1.0.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 15.0.w,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 6.0.w,
                  icon: Icon(Icons.subdirectory_arrow_right),
                ),
              ),
              GestureDetector(
                child: Container(
                  color: whiteColor,
                  width: 10.0.w,
                  height: 7.0.h,
                  alignment: Alignment.center,
                  child: FutureBuilder(
                    future: FirebaseRepository().photoProfile(
                        _loginUser.companyCode,
                        documents[i].data()['commentsUser']['mail']),
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
              SizedBox(
                width: 4.0.w,
              ),
              Container(
                width: 65.0.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60.0.w,
                      child: Text(
                        documents[i].data()['commentsUser']['name'].toString(),
                        style: customStyle(
                            fontSize: cardTitleFontSize.sp,
                            fontWeightName: 'Medium',
                            fontColor: mainColor
                        ),
                      ),
                    ),
                    Text(
                      documents[i].data()['comments'].toString(),
                      style: customStyle(
                        fontColor: mainColor,
                        fontWeightName: 'Regular',
                        fontSize: 12.0.sp,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Format().timeStampToDateTimeString(
                              documents[i].data()['createDate']),
                          style: customStyle(
                            fontSize: 11.0.sp,
                            fontWeightName: 'Regular',
                            fontColor: grayColor,),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: 65.0.w,
                          child: Row(
                            children: [
                              Container(
                                width: 30.0.w,
                                alignment: Alignment.centerLeft,
                                child: InkWell(
                                  child: Text(
                                    word.enterComments(),
                                    style: customStyle(
                                        fontColor: blueColor,
                                        fontSize: 10.0.sp,
                                        fontWeightName: 'Medium'),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      crudType = 1;
                                      _commentId = documentID;
                                      print("_commentId >>> " + _commentId);
                                      commnetUser = documents[i]
                                          .data()['commentsUser']['name'];
                                      _noticeComment.text = commnetUser + " ";
                                      _commnetFocusNode.requestFocus();
                                    });
                                  },
                                ),
                              ),
                              Container(
                                width: 35.0.w,
                                child: Visibility(
                                  visible: documents[i]
                                          .data()['commentsUser']['mail']
                                          .toString() ==
                                      _loginUser.mail,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 15.0.w,
                                        alignment: Alignment.centerLeft,
                                        child: InkWell(
                                          child: Text(
                                            word.delete(),
                                            style: customStyle(
                                                fontColor: redColor,
                                                fontSize: 10.0.sp,
                                                fontWeightName: 'Medium'),
                                          ),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog
                                                return AlertDialog(
                                                  title: Text(
                                                    "${word.comments()} ${word.delete()}",
                                                    style: customStyle(fontColor: redColor, fontSize: homePageDefaultFontSize.sp, fontWeightName: 'Medium'),
                                                  ),
                                                  content: Text(
                                                    word.commentsDeleteCon(),
                                                    style: customStyle(fontColor: mainColor, fontSize: 12.0.sp, fontWeightName: 'Regular'),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text(
                                                        word.yes(),
                                                        style: customStyle(fontColor: blueColor, fontSize: homePageDefaultFontSize.sp, fontWeightName: 'Medium'),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _commentId =
                                                              documents[i]
                                                                  .documentID;
                                                          FirebaseRepository().deleteNoticeComments(
                                                              companyCode:
                                                                  _loginUser
                                                                      .companyCode,
                                                              noticeDocumentID:
                                                                  noticeUid,
                                                              commntDocumentID:
                                                                  documentID,
                                                              commntsDocumentID:
                                                                  _commentId);
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text(
                                                        word.no(),
                                                        style: customStyle(fontColor: blueColor, fontSize: homePageDefaultFontSize.sp, fontWeightName: 'Medium'),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: customHeight(context: context, heightSize: 0.01),
          ),
        ],
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider =
        Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();
    AttendanceCheck _attendanceCheckProvider =
        Provider.of<AttendanceCheck>(context);

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: FutureBuilder(
            future: _attendanceCheckProvider.attendanceCheck(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                _attendance = snapshot.data;
                return Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                        size: iconSizeW.w,
                        color: Colors.white,
                      ),
                      onPressed: _attendance.status == 0
                          ? () async {
                              await _attendanceCheckProvider.manualOnWork(
                                context: context,
                              );
                            }
                          : _attendance.status != 3
                              ? () async {
                                  await _attendanceCheckProvider.manualOffWork(
                                    context: context,
                                  );
                                }
                              : null,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2.0.w),
                      child: Text(
                        _attendanceCheckProvider
                            .attendanceStatus(_attendance.status),
                        style: customStyle(
                          fontSize: homePageDefaultFontSize.sp,
                          fontColor: Colors.white,
                        ),
                      ),
                    )
                  ],
                );
              }
            }),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            width: 20.0.w,
            child: GestureDetector(
              child: Container(
                  color: whiteColor,
                  width: 10.0.w,
                  height: 7.0.h,
                  alignment: Alignment.center,
                  child: FutureBuilder(
                    future: FirebaseRepository()
                        .photoProfile(_loginUser.companyCode, _loginUser.mail),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Icon(Icons.person_outline);
                      }
                      return Image.network(snapshot.data['profilePhoto']);
                    },
                  )),
              onTap: () {},
            ),
          ),
        ],
      ),
      body: Container(
        height: 90.0.h,
        width: 100.0.w,
        padding: EdgeInsets.only(
          left: 2.0.w,
          right: 2.0.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(pageRadiusW.w),
              topRight: Radius.circular(pageRadiusW.w)),
          color: whiteColor,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.0.h),
                ),
                Container(
                  height: 76.0.h,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanDown: (_) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 20.0.w,
                                  child: GestureDetector(
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: whiteColor,
                                      width: 10.0.w,
                                      height: 7.0.h,
                                      child: FutureBuilder(
                                        future: FirebaseRepository()
                                            .photoProfile(
                                                _loginUser.companyCode,
                                                noticeCreateUser),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Icon(Icons.person_outline);
                                          }
                                          return Image.network(
                                              snapshot.data['profilePhoto']);
                                        },
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          noticeTitle,
                                          style: customStyle(
                                              fontColor: mainColor,
                                              fontWeightName: 'Medium',
                                              fontSize: cardTitleFontSize.sp),
                                        ),
                                        /*Text(
                                        _loginUser.name.toString(),
                                        style: customStyle(fontColor: mainColor, fontWeightName: 'Medium', fontSize: 15),
                                      ),*/
                                      ],
                                    ),
                                    Text(
                                      noticeCreateDate,
                                      style: customStyle(
                                          fontSize: 11.0.sp,
                                          fontWeightName: 'Regular',
                                          fontColor: grayColor),
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 2.0.h,
                                        ),
                                        Container(
                                          width: 70.0.w,
                                          child: Text(
                                            noticeContent,
                                            style: customStyle(
                                              fontSize: 12.0.sp,
                                              fontWeightName: 'Regular',
                                              fontColor: mainColor,
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
                          SizedBox(
                           height: 2.0.h,
                          ),
                          Container(
                            height: 0.1.h,
                            width: double.infinity,
                            color: grayColor,
                          ),
                          SizedBox(
                            height: 2.0.h,
                          ),
                          StreamBuilder(
                            stream: FirebaseRepository().getNoticeCommentList(
                                companyCode: _loginUser.companyCode,
                                documentID: noticeUid),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              List<DocumentSnapshot> documents =
                                  snapshot.data.documents;

                              return ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: documents.length * 11.0.h,
                                  maxHeight: documents.length * 50.0.h,
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: 20.0.w,
                                                child: GestureDetector(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    color: whiteColor,
                                                    width: 10.0.w,
                                                    height: 7.0.h,
                                                    child: FutureBuilder(
                                                      future: FirebaseRepository().photoProfile(_loginUser.companyCode, _loginUser.mail),
                                                      builder: (context, snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return Icon(Icons.person_outline);
                                                        }
                                                        return Image.network(snapshot.data['profilePhoto']);
                                                      },
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    _loginUserInfoProvider.logoutUesr();
                                                  },
                                                ),
                                              ),

                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    documents[index]
                                                        .data()['createUser']
                                                            ['name']
                                                        .toString(),
                                                    style: customStyle(
                                                        fontColor: mainColor,
                                                        fontWeightName: 'Medium',
                                                        fontSize: cardTitleFontSize.sp,
                                                    ),
                                                  ),
                                                  Text(
                                                    documents[index]
                                                        .data()['comment']
                                                        .toString(),
                                                    style: customStyle(
                                                      fontColor: mainColor,
                                                      fontWeightName: 'Regular',
                                                      fontSize: 12.0.sp,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        Format()
                                                            .timeStampToDateTimeString(
                                                                documents[index]
                                                                        .data()[
                                                                    'createDate']),
                                                        style: customStyle(
                                                            fontSize: 11.0.sp,
                                                            fontWeightName: 'Regular',
                                                            fontColor: grayColor,),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        width: 70.0.w,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 30.0.w,
                                                              alignment: Alignment.centerLeft,
                                                              child: InkWell(
                                                                child: Text(
                                                                  word.enterComments(),
                                                                  style: customStyle(
                                                                      fontColor:
                                                                          blueColor,
                                                                      fontSize: 10.0.sp,
                                                                      fontWeightName:
                                                                          'Medium'),
                                                                ),
                                                                onTap: () {
                                                                  setState(() {
                                                                    crudType = 1;
                                                                    _commentId = documents[index].documentID;
                                                                    print("_commentId >>> " + _commentId);
                                                                    commnetUser = documents[index].data()['createUser']['name'];
                                                                    _noticeComment.text = commnetUser + " ";
                                                                    _commnetFocusNode.requestFocus();
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 40.0.w,
                                                              child: Visibility(
                                                                visible: documents[index].data()['createUser']['mail'].toString() == _loginUser.mail,
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      width: 15.0.w,
                                                                      alignment: Alignment.centerLeft,
                                                                      child: InkWell(
                                                                        child: Text(
                                                                          word.update(),
                                                                          style: customStyle(
                                                                              fontColor: blueColor,
                                                                              fontSize: 10.0.sp,
                                                                              fontWeightName: 'Medium'),
                                                                        ),
                                                                        onTap:() {
                                                                          setState(() {
                                                                            crudType = 2;
                                                                            _commentId = documents[index].documentID;
                                                                            print("_commentId >>> " + _commentId);
                                                                            _noticeComment.text = documents[index].data()['comment'].toString();
                                                                            _commnetFocusNode.requestFocus();
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: 15.0.w,
                                                                      alignment: Alignment.centerLeft,
                                                                      child: InkWell(
                                                                        child:Text(
                                                                          word.delete(),
                                                                          style: customStyle(
                                                                              fontColor: redColor,
                                                                              fontSize: 10.0.sp,
                                                                              fontWeightName: 'Medium'),
                                                                        ),
                                                                        onTap:() {
                                                                          showDialog(context: context, builder:(BuildContext context) {
                                                                              // return object of type Dialog
                                                                              return AlertDialog(
                                                                                title: Text(
                                                                                  "${word.comments()} ${word.delete()}",
                                                                                  style: customStyle(fontColor: redColor, fontSize: homePageDefaultFontSize.sp, fontWeightName: 'Medium'),
                                                                                ),
                                                                                content: Text(
                                                                                  word.commentsDeleteCon(),
                                                                                  style: customStyle(fontColor: mainColor, fontSize: 12.0.sp, fontWeightName: 'Regular'),
                                                                                ),
                                                                                actions: <Widget>[
                                                                                  FlatButton(
                                                                                    child: Text(
                                                                                      word.yes(),
                                                                                      style: customStyle(fontColor: blueColor, fontSize: homePageDefaultFontSize.sp, fontWeightName: 'Medium'),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        _commentId = documents[index].documentID;
                                                                                        FirebaseRepository().deleteNoticeComment(
                                                                                          companyCode: _loginUser.companyCode,
                                                                                          noticeDocumentID: noticeUid,
                                                                                          commntDocumentID: _commentId,
                                                                                        );
                                                                                        _commentId = "";
                                                                                        Navigator.pop(context);
                                                                                      });
                                                                                    },
                                                                                  ),
                                                                                  FlatButton(
                                                                                    child: Text(
                                                                                      word.no(),
                                                                                      style: customStyle(fontColor: blueColor, fontSize: homePageDefaultFontSize.sp, fontWeightName: 'Medium'),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          StreamBuilder(
                                              stream: FirebaseRepository()
                                                  .getNoticeCommentsList(
                                                      companyCode: _loginUser
                                                          .companyCode,
                                                      noticeDocumentID:
                                                          noticeUid,
                                                      commntDocumentID:
                                                          documents[index]
                                                              .documentID),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return CircularProgressIndicator();
                                                }
                                                List<DocumentSnapshot>
                                                    subDocuments =
                                                    snapshot.data.documents;

                                                if (subDocuments.length != 0) {
                                                  return ConfigurableExpansionTile(
                                                    animatedWidgetFollowingHeader:
                                                        Icon(
                                                      Icons.expand_more,
                                                      size: 6.0.w,
                                                      color: const Color(
                                                          0xFF707070),
                                                    ),
                                                    headerExpanded: Text(
                                                      "${word.commentsCountHeadCon()} " +
                                                          subDocuments.length
                                                              .toString() +
                                                          " ${word.commentsCountTailCon()}",
                                                      style: customStyle(
                                                          fontSize: 10.0.sp,
                                                          fontWeightName:
                                                              'Regular'),
                                                    ),
                                                    header: Container(
                                                        color:
                                                            Colors.transparent,
                                                        child: Text(
                                                          "${word.commentsCountHeadCon()} " +
                                                              subDocuments
                                                                  .length
                                                                  .toString() +
                                                              " ${word.commentsCountTailCon()}",
                                                          style: customStyle(
                                                              fontSize: 10.0.sp,
                                                              fontColor:
                                                                  blueColor,
                                                              fontWeightName:
                                                                  'Regular'),
                                                        )),
                                                    children: <Widget>[
                                                      Container(
                                                        width: 100.0.w,
                                                        child: Column(
                                                          children:
                                                              _getCommentList(
                                                                  subDocuments,
                                                                  context,
                                                                  documents[
                                                                          index]
                                                                      .documentID),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                } else {
                                                  return Text("");
                                                }
                                              }),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: _commentId != "",
                  child: Opacity(
                    opacity: 0.75,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 4.0.h,
                      decoration: BoxDecoration(
                        color: blueColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            crudType == 1
                                ? commnetUser + " ${word.commentsTo()}"
                                : "${word.commnetsUpate()}",
                            style: customStyle(
                                fontWeightName: 'Bold',
                                fontColor: whiteColor,
                                fontSize: 12.0.sp),
                          ),
                          Padding(padding: EdgeInsets.only(left: 3.0.w)),
                          InkWell(
                            child: Text(
                              word.cencel(),
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 12.0.sp,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _commentId = "";
                                commnetUser = "";
                                _noticeComment.text = "";
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: whiteColor,
                  height: 10.0.h,
                  child: Column(
                    children: [
                      Container(
                        height: 0.1.h,
                        width: double.infinity,
                        color: grayColor,
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 2.0.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 82.0.w,
                                  height: 6.0.h,
                                  child: TextFormField(
                                    focusNode: _commnetFocusNode,
                                    textAlignVertical:
                                    TextAlignVertical.bottom,
                                    controller: _noticeComment,
                                    style: customStyle(
                                      fontSize: 13.0.sp,
                                    ),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: word.commnetsInput(),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 3.0.w,
                                ),
                                Container(
                                  width: 10.0.w,
                                  height: 6.0.h,
                                  child: CircleAvatar(
                                      radius: 4.0.w,
                                      backgroundColor:
                                      _noticeComment.text == ''
                                          ? Colors.black12
                                          : Colors.blue,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(Icons.arrow_upward, size: iconSizeW.w,),
                                        onPressed: () {
                                          Map<String, String> _commentMap = {
                                            "name": _loginUser.name,
                                            "mail": _loginUser.mail
                                          };

                                          setState(() {
                                            if (_noticeComment.text.trim() !=
                                                "") {
                                              if (_commentId.trim() == "") {
                                                //print("답글 미선택 ====> " + _commentId);
                                                _commnetModel = CommentModel(
                                                  comment:
                                                  _noticeComment.text,
                                                  createUser: _commentMap,
                                                  createDate: Timestamp.now(),
                                                );
                                                FirebaseRepository()
                                                    .addNoticeComment(
                                                    companyCode: _loginUser
                                                        .companyCode,
                                                    noticeDocumentID:
                                                    noticeUid,
                                                    comment:
                                                    _commnetModel);
                                              } else {
                                                //print("답글 선택 ====> " + _commentId);

                                                if (crudType == 1) {
                                                  // 답글 입력 클릭시
                                                  _commentList =
                                                      CommentListModel(
                                                        comments:
                                                        _noticeComment.text,
                                                        createDate:
                                                        Timestamp.now(),
                                                        commentsUser: _commentMap,
                                                      );
                                                  FirebaseRepository()
                                                      .addNoticeComments(
                                                      companyCode:
                                                      _loginUser
                                                          .companyCode,
                                                      noticeDocumentID:
                                                      noticeUid,
                                                      commntDocumentID:
                                                      _commentId,
                                                      comment:
                                                      _commentList);
                                                } else if (crudType == 2) {
                                                  // 수정 클릭시
                                                  _commentList =
                                                      CommentListModel(
                                                        comments:
                                                        _noticeComment.text,
                                                        updateDate:
                                                        Timestamp.now(),
                                                        commentsUser: _commentMap,
                                                      );
                                                  FirebaseRepository()
                                                      .updateNoticeComment(
                                                    companyCode: _loginUser
                                                        .companyCode,
                                                    noticeDocumentID:
                                                    noticeUid,
                                                    commntDocumentID:
                                                    _commentId,
                                                    comment:
                                                    _noticeComment.text,
                                                  );
                                                } else if (crudType == 3) {
                                                  // 대댓글 수정

                                                }
                                              }
                                              _commentId = "";
                                              _noticeComment.text = "";
                                            }
                                          });
                                        },
                                      )),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
