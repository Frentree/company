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
        @required this.noticeCreateUser
      });

  @override
  AlarmNoticeDetailPageState createState() =>
      AlarmNoticeDetailPageState(
          noticeUid: noticeUid,
          noticeTitle: noticeTitle,
          noticeCreateDate: noticeCreateDate,
          noticeContent: noticeContent,
          noticeCreateUser: noticeCreateUser
      );
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
        @required this.noticeCreateUser
      });

  User _loginUser;

  TextEditingController _noticeComment = TextEditingController();

  String _commentId = "";

  // 댓글 달릴 유저명
  String commnetUser = "";

  // 댓글 입력, 수정 타입
  int crudType = 0;

  CommentModel _commnetModel;

  CommentListModel _commentList;
  // 댓글 높이
  double commentHeight = 0.76;

  // 댓글 입력창 포커스
  FocusNode _commnetFocusNode = FocusNode();

  Attendance _attendance = Attendance();

  _getCommentList(List<DocumentSnapshot> documents, BuildContext context, String documentID){
    List<Widget> widgets = [];
    for (int i = 0; i < documents.length; i++) {
      widgets.add(Column(
        children: [
          SizedBox(
            height: customHeight(
                context: context,
                heightSize: 0.01
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                child: IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.subdirectory_arrow_right),
                ),
              ),
              GestureDetector(
                child: Container(
                  height: customHeight(context: context, heightSize: 0.06),
                  width: customWidth(context: context, widthSize: 0.1),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: whiteColor,
                      border: Border.all(color: whiteColor, width: 2)),
                  child: FutureBuilder(
                    future: FirebaseRepository().photoProfile(_loginUser.companyCode, documents[i].data()['commentsUser']['mail']),
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
              Padding(
                padding: EdgeInsets.only(left: 5),
              ),
              Container(
                width: customWidth(
                    context: context,
                    widthSize: 0.72
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      documents[i].data()['commentsUser']['name'].toString(),
                      style: customStyle(
                        fontColor: blackColor,
                        fontWeightName: 'Bold',
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      documents[i].data()['comments'].toString(),
                      style: customStyle(
                        fontColor: blackColor,
                        fontWeightName: 'Regular',
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          Format().timeStampToDateTimeString(documents[i].data()['createDate']),
                          style:
                          customStyle(fontSize: 12, fontWeightName: 'Regular', fontColor: grayColor),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.topRight,
                          width: customWidth(
                              context: context,
                              widthSize: 0.34
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  child: Text(word.enterComments(),
                                    style: customStyle(
                                        fontColor: blueColor,
                                        fontSize: 11,
                                        fontWeightName: 'Medium'
                                    ),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      crudType = 1;
                                      _commentId = documentID;
                                      print("_commentId >>> " + _commentId);
                                      commnetUser = documents[i].data()['commentsUser']['name'];
                                      _noticeComment.text = commnetUser + " ";
                                      _commnetFocusNode.requestFocus();
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Visibility(
                                  visible: documents[i].data()['commentsUser']['mail'].toString() == _loginUser.mail,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          child: Text(word.delete(),
                                            style: customStyle(
                                                fontColor: redColor,
                                                fontSize: 11,
                                                fontWeightName: 'Medium'
                                            ),
                                          ),
                                          onTap: (){
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog
                                                return AlertDialog(
                                                  title: Text(
                                                    "${word.comments()} ${word.delete()}",
                                                    style: customStyle(
                                                        fontColor: mainColor,
                                                        fontSize: 14,
                                                        fontWeightName: 'Bold'
                                                    ),
                                                  ),
                                                  content: Text(
                                                    word.commentsDeleteCon(),
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
                                                          _commentId = documents[i].documentID;
                                                          FirebaseRepository().deleteNoticeComments(
                                                              companyCode : _loginUser.companyCode,
                                                              noticeDocumentID : noticeUid,
                                                              commntDocumentID : documentID,
                                                              commntsDocumentID : _commentId
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
            height: customHeight(
                context: context,
                heightSize: 0.01
            ),
          ),
        ],
      )
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
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
                        size: customHeight(context: context, heightSize: 0.04),
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
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        _attendanceCheckProvider
                            .attendanceStatus(_attendance.status),
                      ),
                    )
                  ],
                );
              }
            }),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            width: customWidth(context: context, widthSize: 0.2),
            child: GestureDetector(
              child: Container(
                height: customHeight(context: context, heightSize: 0.05),
                width: customWidth(context: context, widthSize: 0.1),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: whiteColor, border: Border.all(color: whiteColor, width: 2)),
                child: FutureBuilder(
                  future: FirebaseRepository().photoProfile(_loginUser.companyCode, _loginUser.mail),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Icon(Icons.person_outline);
                    }
                    return Image.network(snapshot.data['profilePhoto']);
                  },
                )
              ),
              onTap: () {
              },
            ),
          ),
        ],
      ),
      body: Container(
        width: customWidth(context: context, widthSize: 1),
        padding: EdgeInsets.only(
            left: customWidth(
              context: context,
              widthSize: 0.02,
            ),
            right: customWidth(
              context: context,
              widthSize: 0.02,
            )),
        decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), color: whiteColor),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: customHeight(context: context, heightSize: 0.02)),
                ),
                Container(
                  height: customHeight(context: context, heightSize: commentHeight),
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
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5), color: whiteColor, border: Border.all(color: whiteColor, width: 2)),
                                  width: customWidth(context: context, widthSize: 0.16),
                                  child: GestureDetector(
                                    child: Container(
                                      height: customHeight(context: context, heightSize: 0.06),
                                      width: customWidth(context: context, widthSize: 0.1),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5), color: whiteColor, border: Border.all(color: whiteColor, width: 2)),
                                      child: FutureBuilder(
                                        future: FirebaseRepository().photoProfile(_loginUser.companyCode, noticeCreateUser),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          noticeTitle,
                                          style: customStyle(fontColor: mainColor, fontWeightName: 'Bold', fontSize: 15),
                                        ),
                                        /*Text(
                                        _loginUser.name.toString(),
                                        style: customStyle(fontColor: mainColor, fontWeightName: 'Medium', fontSize: 15),
                                      ),*/
                                      ],
                                    ),
                                    Text(
                                      noticeCreateDate,
                                      style: customStyle(fontSize: 12, fontWeightName: 'Regular', fontColor: grayColor),
                                    ),
                                    Container(
                                      width: customWidth(context: context, widthSize: 0.7),
                                      child: Text(
                                        noticeContent,
                                        style: customStyle(fontSize: 13, fontWeightName: 'Regular', fontColor: blackColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: customHeight(context: context, heightSize: 0.02),
                          ),
                          Container(
                            height: customHeight(context: context, heightSize: 0.001),
                            width: double.infinity,
                            color: grayColor,
                          ),
                          SizedBox(
                            height: customHeight(context: context, heightSize: 0.02),
                          ),
                          StreamBuilder(
                            stream: FirebaseRepository().getNoticeCommentList(
                              companyCode: _loginUser.companyCode,
                              documentID: noticeUid
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              List<DocumentSnapshot> documents = snapshot.data.documents;

                              return ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: customHeight(context: context, heightSize: documents.length * 0.11),
                                  maxHeight: customHeight(context: context, heightSize: documents.length * 0.5),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {

                                    return Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: 11),
                                              ),
                                              GestureDetector(
                                                child: Container(
                                                  height: customHeight(context: context, heightSize: 0.06),
                                                  width: customWidth(context: context, widthSize: 0.1),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: whiteColor,
                                                      border: Border.all(color: whiteColor, width: 2)),
                                                  child: FutureBuilder(
                                                    future: FirebaseRepository().photoProfile(_loginUser.companyCode, documents[index].data()['createUser']['mail']),
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
                                              Padding(
                                                padding: EdgeInsets.only(left: 5),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    documents[index].data()['createUser']['name'].toString(),
                                                    style: customStyle(
                                                      fontColor: blackColor,
                                                      fontWeightName: 'Bold',
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    documents[index].data()['comment'].toString(),
                                                    style: customStyle(
                                                      fontColor: blackColor,
                                                      fontWeightName: 'Regular',
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        Format().timeStampToDateTimeString(documents[index].data()['createDate']),
                                                        style: customStyle(fontSize: 12, fontWeightName: 'Regular', fontColor: grayColor),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(left: 10),
                                                        alignment: Alignment.topRight,
                                                        width: 150,
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Expanded(
                                                              flex: 3,
                                                              child: InkWell(
                                                                child: Text(
                                                                  word.enterComments(),
                                                                  style: customStyle(
                                                                      fontColor: blueColor,
                                                                      fontSize: 11,
                                                                      fontWeightName: 'Medium'
                                                                  ),
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
                                                            Expanded(
                                                              flex: 4,
                                                              child: Visibility(
                                                                visible: documents[index].data()['createUser']['mail'].toString() == _loginUser.mail,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: InkWell(
                                                                        child: Text(
                                                                          word.update(),
                                                                          style:
                                                                          customStyle(
                                                                              fontColor: blueColor,
                                                                              fontSize: 11,
                                                                              fontWeightName: 'Medium'
                                                                          ),
                                                                        ),
                                                                        onTap: () {
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
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: InkWell(
                                                                        child: Text(
                                                                          word.delete(),
                                                                          style:
                                                                          customStyle(
                                                                              fontColor: redColor,
                                                                              fontSize: 11,
                                                                              fontWeightName: 'Medium'
                                                                          ),
                                                                        ),
                                                                        onTap: () {
                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (BuildContext context) {
                                                                              // return object of type Dialog
                                                                              return AlertDialog(
                                                                                title: Text(
                                                                                  "${word.comments()} ${word.delete()}",
                                                                                  style: customStyle(
                                                                                      fontColor: redColor,
                                                                                      fontSize: 11,
                                                                                      fontWeightName: 'Bold'
                                                                                  ),
                                                                                ),
                                                                                content: Text(
                                                                                  word.commentsDeleteCon(),
                                                                                  style: customStyle(
                                                                                      fontColor: mainColor, fontSize: 13, fontWeightName: 'Regular'),
                                                                                ),
                                                                                actions: <Widget>[
                                                                                  FlatButton(
                                                                                    child: Text(
                                                                                      word.yes(),
                                                                                      style: customStyle(
                                                                                          fontColor: blueColor, fontSize: 15, fontWeightName: 'Bold'),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        _commentId = documents[index].documentID;
                                                                                        FirebaseRepository().deleteNoticeComment(
                                                                                            companyCode : _loginUser.companyCode,
                                                                                            noticeDocumentID : noticeUid,
                                                                                            commntDocumentID : _commentId,
                                                                                        );
                                                                                        _commentId = "";
                                                                                        Navigator.pop(context);
                                                                                      });
                                                                                    },
                                                                                  ),
                                                                                  FlatButton(
                                                                                    child: Text(
                                                                                      word.no(),
                                                                                      style: customStyle(
                                                                                          fontColor: blueColor, fontSize: 15, fontWeightName: 'Bold'),
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
                                              stream: FirebaseRepository().getNoticeCommentsList(
                                                companyCode: _loginUser.companyCode,
                                                noticeDocumentID: noticeUid,
                                                commntDocumentID: documents[index].documentID
                                              ),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return CircularProgressIndicator();
                                                }
                                                List<DocumentSnapshot> subDocuments = snapshot.data.documents;

                                                if (subDocuments.length != 0) {
                                                  return ConfigurableExpansionTile(
                                                    animatedWidgetFollowingHeader: const Icon(
                                                      Icons.expand_more,
                                                      color: const Color(0xFF707070),
                                                    ),
                                                    headerExpanded: Text(
                                                      "${word.commentsCountHeadCon()} " + subDocuments.length.toString() + " ${word.commentsCountTailCon()}",
                                                      style: customStyle(fontSize: 12, fontWeightName: 'Regular'),
                                                    ),
                                                    header: Container(
                                                        color: Colors.transparent,
                                                        child: Text(
                                                          "${word.commentsCountHeadCon()} " + subDocuments.length.toString() + " ${word.commentsCountTailCon()}",
                                                          style: customStyle(fontSize: 12, fontColor: blueColor, fontWeightName: 'Regular'),
                                                        )),
                                                    children: <Widget>[
                                                      Container(
                                                        width: customWidth(context: context, widthSize: 1),
                                                        child: Column(
                                                          children: _getCommentList(subDocuments, context, documents[index].documentID),
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
                      height: customHeight(context: context, heightSize: 0.04),
                      decoration: BoxDecoration(
                        color: blueColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            crudType == 1 ? commnetUser + " ${word.commentsTo()}" : "${word.commnetsUpate()}",
                            style: customStyle(
                                fontWeightName: 'Bold',
                                fontColor: whiteColor,
                                fontSize: 12
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          InkWell(
                            child: Text(
                              word.cencel(),
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: (){
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
                  height: customHeight(context: context, heightSize: 0.1),
                  child: Column(
                    children: [
                      Container(
                        height: customHeight(context: context, heightSize: 0.001),
                        width: double.infinity,
                        color: grayColor,
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            SizedBox(
                              height: customHeight(context: context, heightSize: 0.02),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    height: customHeight(context: context, heightSize: 0.06),
                                    child: TextFormField(
                                      focusNode: _commnetFocusNode,
                                      textAlignVertical: TextAlignVertical.bottom,
                                      controller: _noticeComment,
                                      style: customStyle(
                                        fontSize: 13,
                                      ),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: word.commnetsInput(),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: customHeight(context: context, heightSize: 0.06),
                                    child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: _noticeComment.text == '' ? Colors.black12 : Colors.blue,
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_upward),
                                          onPressed: () {
                                            Map<String, String> _commentMap = {"name": _loginUser.name, "mail": _loginUser.mail};

                                            setState(() {
                                              if (_noticeComment.text.trim() != "") {
                                                if (_commentId.trim() == "") {
                                                  //print("답글 미선택 ====> " + _commentId);
                                                  _commnetModel = CommentModel(
                                                    comment: _noticeComment.text,
                                                    createUser: _commentMap,
                                                    createDate: Timestamp.now(),
                                                  );
                                                  FirebaseRepository().addNoticeComment(
                                                      companyCode: _loginUser.companyCode,
                                                      noticeDocumentID: noticeUid,
                                                      comment: _commnetModel
                                                  );
                                                } else {
                                                  //print("답글 선택 ====> " + _commentId);

                                                  if(crudType == 1){ // 답글 입력 클릭시
                                                    _commentList = CommentListModel(
                                                      comments: _noticeComment.text,
                                                      createDate: Timestamp.now(),
                                                      commentsUser: _commentMap,
                                                    );
                                                    FirebaseRepository().addNoticeComments(
                                                      companyCode: _loginUser.companyCode,
                                                      noticeDocumentID: noticeUid,
                                                      commntDocumentID: _commentId,
                                                      comment: _commentList
                                                    );
                                                  } else if(crudType == 2) { // 수정 클릭시
                                                    _commentList = CommentListModel(
                                                      comments: _noticeComment.text,
                                                      updateDate: Timestamp.now(),
                                                      commentsUser: _commentMap,
                                                    );
                                                    FirebaseRepository().updateNoticeComment(
                                                      companyCode: _loginUser.companyCode,
                                                      noticeDocumentID: noticeUid,
                                                      commntDocumentID: _commentId,
                                                      comment: _noticeComment.text,
                                                    );
                                                  } else if(crudType == 3) { // 대댓글 수정

                                                  }
                                                }
                                                _commentId = "";
                                                _noticeComment.text = "";
                                              }
                                            }
                                            );
                                          },
                                        )
                                    ),
                                  ),
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
