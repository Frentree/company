import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/commentListModel.dart';
import 'package:MyCompany/models/commentModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/photo/profilePhoto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();

class NoticeDetailsPage extends StatefulWidget {
  final noticeUid;
  final noticeTitle;
  final noticeContent;
  final noticeCreateDate;
  final noticeCreateUser;
  final commentCount;

  NoticeDetailsPage(
      {Key key,
      @required this.noticeUid,
      @required this.noticeTitle,
      @required this.noticeContent,
      @required this.noticeCreateDate,
      @required this.noticeCreateUser,
      @required this.commentCount,});

  @override
  NoticeDetailsPageState createState() => NoticeDetailsPageState(
      noticeUid: noticeUid,
      noticeTitle: noticeTitle,
      noticeCreateDate: noticeCreateDate,
      noticeContent: noticeContent,
      noticeCreateUser: noticeCreateUser,
      commentCount: commentCount,
  );
}

int crudType = 0;
String _commentId = "";
String commnetUser = "";
final TextEditingController _noticeComment = TextEditingController();
final FocusNode _commnetFocusNode = FocusNode();

class NoticeDetailsPageState extends State<NoticeDetailsPage> {
  final noticeUid;
  final noticeTitle;
  final noticeContent;
  final noticeCreateDate;
  final noticeCreateUser;
  final commentCount;

  NoticeDetailsPageState(
      {Key key,
      @required this.noticeUid,
      @required this.noticeTitle,
      @required this.noticeContent,
      @required this.noticeCreateDate,
      @required this.noticeCreateUser,
      @required this.commentCount,});

  User _loginUser;
  CommentModel _commnetModel;
  CommentListModel _commentList;

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: mainColor,
              height: 6.0.h,
              padding: EdgeInsets.symmetric(
                  horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w
              ),
              child: Row(
                children: [
                  Container(
                    height: 6.0.h,
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                    child: IconButton(
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.keyboard_arrow_left_sharp,
                        size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                        color: whiteColor,
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "${Words.word.comments()} ${commentCount == null ? 0 : commentCount}",
                          style: defaultMediumWhiteStyle,
                        )
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: cardPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 8.0.h,
                    alignment: Alignment.center,
                    child: profilePhoto(loginUser: _loginUser),
                  ),
                  cardSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: SizerUtil.deviceType == DeviceType.Tablet ? 67.0.w : 55.0.w,
                        height: 5.0.h,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          noticeTitle,
                          style: cardTitleStyle,
                        ),
                      ),
                      Container(
                        height: 3.0.h,
                        child: Text(
                          noticeCreateDate,
                          style: cardSubTitleStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            emptySpace,
            Expanded(
              child: Stack(
                children: [
                  Container(
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
                              padding: cardPadding,
                              child: Text(
                                noticeContent,
                                style: cardContentsStyle,
                              ),
                            ),
                            emptySpace,
                            Container(
                              height: 0.1.h,
                              color: grayColor,
                            ),
                            emptySpace,
                            StreamBuilder(
                              stream: FirebaseRepository().getNoticeCommentList(companyCode: _loginUser.companyCode, documentID: noticeUid),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                List<DocumentSnapshot> documents = snapshot.data.documents;
                                return ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: documents
                                      .map((data) =>
                                      getCommentList(context: context, document: data, user: _loginUser, noticeID: noticeUid, setState: setState))
                                      .toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //수정 및 삭제 시 투명창
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: _commentId != "",
                        child: Opacity(
                          opacity: 0.65,
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 5.0.h,
                            decoration: BoxDecoration(
                              color: blueColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  crudType == 1 ? commnetUser + " ${word.commentsTo()}" : "${word.commnetsUpate()}",
                                  style: defaultMediumWhiteStyle,
                                ),
                                cardSpace,
                                InkWell(
                                  child: Text(
                                    word.cencel(),
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizerUtil.deviceType == DeviceType.Tablet ? defaultSizeT.sp : defaultSizeM.sp,
                                      fontFamily: "NotoSansKR",
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
                      //댓글 입력창
                      Container(
                        padding: cardPadding,
                        height: 10.0.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: grayColor,
                            width: 0.1.w,
                          )
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _noticeComment,
                                    style: defaultRegularStyle,
                                    focusNode: _commnetFocusNode,
                                    /*textAlignVertical: TextAlignVertical.bottom,*/
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: textFormPadding,
                                      border: OutlineInputBorder(),
                                      hintText: word.commnetsInput(),
                                      hintStyle: hintStyle,
                                    ),
                                  ),
                                ),
                                cardSpace,
                                CircleAvatar(
                                    radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                    backgroundColor: _noticeComment.text == '' ? disableUploadBtn : blueColor,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.arrow_upward,
                                        color: whiteColor,
                                        size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                      ),
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
                                                  companyCode: _loginUser.companyCode, noticeDocumentID: noticeUid, comment: _commnetModel);
                                            } else {
                                              //print("답글 선택 ====> " + _commentId);

                                              if (crudType == 1) {
                                                // 답글 입력 클릭시
                                                _commentList = CommentListModel(
                                                  comments: _noticeComment.text,
                                                  createDate: Timestamp.now(),
                                                  commentsUser: _commentMap,
                                                );
                                                FirebaseRepository().addNoticeComments(
                                                    companyCode: _loginUser.companyCode,
                                                    noticeDocumentID: noticeUid,
                                                    commntDocumentID: _commentId,
                                                    comment: _commentList);
                                              } else if (crudType == 2) {
                                                // 수정 클릭시
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
                                              } else if (crudType == 3) {}
                                            }
                                            _commentId = "";
                                            _noticeComment.text = "";
                                          }
                                        });
                                      },
                                    ))
                              ],
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
      ),
    );
  }
}

Widget getCommentList({BuildContext context, DocumentSnapshot document, User user, noticeID, setState}) {
  final comment = CommentData.fromSnapshow(document);
  return Container(
    padding: cardPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8.0.h,
              alignment: Alignment.center,
              child: profilePhoto(loginUser: user),
            ),
            cardSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.createUser['name'].toString(),
                    style: cardTitleStyle,
                  ),
                  Text(
                    comment.comment.toString(),
                    style: cardContentsStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
        Text(
          Format().timeStampToDateTimeString(comment.createDate),
          style: cardSubTitleStyle,
        ),
        Row(
          children: [
            InkWell(
              child: Text(
                word.enterComments(),
                style: customStyle(
                    fontSize: SizerUtil.deviceType == DeviceType.Tablet ? cardTimeSizeT.sp : cardTimeSizeM.sp,
                    fontWeightName: "Medium",
                    fontColor: blueColor
                ),
              ),
              onTap: () {
                setState(() {
                  crudType = 1;
                  _commentId = comment.reference.id;
                  print("_commentId >>> " + _commentId);
                  commnetUser = comment.createUser['name'];
                  _noticeComment.text = commnetUser + " ";
                  _commnetFocusNode.requestFocus();
                });
              },
            ),
            cardSpace,
            cardSpace,
            (comment.createUser['mail'].toString() == user.mail)
                ? InkWell(
                    child: Text(
                      word.update(),
                      style: customStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.Tablet ? cardTimeSizeT.sp : cardTimeSizeM.sp,
                          fontWeightName: "Medium",
                          fontColor: blueColor
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        crudType = 2;
                        _commentId = comment.reference.id;
                        print("_commentId >>> " + _commentId);
                        _noticeComment.text = comment.comment.toString();
                        _commnetFocusNode.requestFocus();
                      });
                    },
                  )
                : SizedBox(),
            cardSpace,
            cardSpace,
            (comment.createUser['mail'].toString() == user.mail)
                ? InkWell(
                    child: Text(
                      word.delete(),
                      style: customStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.Tablet ? cardTimeSizeT.sp : cardTimeSizeM.sp,
                          fontWeightName: "Medium",
                          fontColor: redColor
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
                                style: defaultMediumStyle,
                            ),
                            content: Text(
                              word.commentsDeleteCon(),
                              style: defaultRegularStyle,
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  word.yes(),
                                  style: buttonBlueStyle,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _commentId = comment.reference.id;
                                    FirebaseRepository().deleteNoticeComment(
                                      companyCode: user.companyCode,
                                      noticeDocumentID: noticeID,
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
                                  style: buttonBlueStyle,
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
                  )
                : SizedBox(),
          ],
        ),
        StreamBuilder(
          stream: FirebaseRepository().getNoticeCommentsList(
            companyCode: user.companyCode,
            commntDocumentID: comment.reference.id,
            noticeDocumentID: noticeID,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            List<DocumentSnapshot> commentsDoc = snapshot.data.documents;
            if (commentsDoc.length != 0) {
              return ConfigurableExpansionTile(
                animatedWidgetFollowingHeader: Icon(
                  Icons.expand_more,
                  size:  SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                  color: grayColor,
                ),
                headerExpanded: Text(
                  "${word.commentsCountHeadCon()} " + commentsDoc.length.toString() + " ${word.commentsCountTailCon()}",
                  style: cardBlueStyle,
                ),
                header: Container(
                    color: Colors.transparent,
                    child: Text(
                      "${word.commentsCountHeadCon()} " + commentsDoc.length.toString() + " ${word.commentsCountTailCon()}",
                      style: cardBlueStyle,
                    )),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 1.0.h),
                    child: Column(
                      children: commentsDoc
                          .map((data) =>
                              getCommentsList(
                                context: context,
                                document: data,
                                noticeID: noticeID,
                                user: user,
                                documentID: comment.reference.id,
                                setState: setState
                              ))
                          .toList(),
                    ),
                  )
                ],
              );
            } else {
              return Text("");
            }
          },
        ),
      ],
    ),
  );
}

Widget getCommentsList({BuildContext context,
  DocumentSnapshot document,
  String documentID,
  User user,
  String noticeID,
  setState
}) {
  final comments = CommentsData.fromSnapshow(document);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 6.0.h,
            width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
            child: IconButton(
              constraints: BoxConstraints(),
              padding: EdgeInsets.zero,
              iconSize: 6.0.w,
              icon: Icon(
                Icons.subdirectory_arrow_right,
                size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
              ),
            ),
          ),
          Container(
            height: 8.0.h,
            alignment: Alignment.center,
            child: profilePhoto(loginUser: user),
          ),
          cardSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comments.commentsUser['name'].toString(),
                  style: cardTitleStyle,
                ),
                Text(
                  comments.comments.toString(),
                  style: cardContentsStyle,
                ),
              ],
            ),
          ),
        ],
      ),
      Container(
        padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,),
        child: Text(
          Format().timeStampToDateTimeString(comments.createDate),
          style: cardSubTitleStyle,
        ),
      ),
      Row(
        children: [
          Container(
            width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
          ),
          InkWell(
            child: Text(
              word.enterComments(),
              style: customStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.Tablet ? cardTimeSizeT.sp : cardTimeSizeM.sp,
                  fontWeightName: "Medium",
                  fontColor: blueColor
              ),
            ),
            onTap: () {
              setState(() {
                crudType = 1;
                _commentId = documentID;
                commnetUser = comments.commentsUser['name'];
                _noticeComment.text = commnetUser + " ";
                _commnetFocusNode.requestFocus();
              });
            },
          ),
          cardSpace,
          cardSpace,
          (comments.commentsUser['mail'].toString() == user.mail)
              ? InkWell(
                  child: Text(
                    word.delete(),
                    style: customStyle(
                        fontSize: SizerUtil.deviceType == DeviceType.Tablet ? cardTimeSizeT.sp : cardTimeSizeM.sp,
                        fontWeightName: "Medium",
                        fontColor: redColor
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
                            style: defaultMediumStyle,
                          ),
                          content: Text(
                            word.commentsDeleteCon(),
                            style: defaultRegularStyle,
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                word.yes(),
                                style: buttonBlueStyle,
                              ),
                              onPressed: () {
                                setState(() {
                                  _commentId = comments.reference.id;
                                  FirebaseRepository().deleteNoticeComments(
                                      companyCode: user.companyCode,
                                      noticeDocumentID: noticeID,
                                      commntDocumentID: documentID,
                                      commntsDocumentID: comments.reference.id);
                                });
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                word.no(),
                                style: buttonBlueStyle,
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
                )
              : SizedBox(),
          SizedBox(width: 6.0.w),
        ],
      ),
      SizedBox(
        height: customHeight(context: context, heightSize: 0.01),
      ),
    ],
  );
}

class CommentData {
  final String comment;
  final Map<String, dynamic> createUser;
  final Timestamp createDate;
  final DocumentReference reference;

  CommentData.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['comment'] != null),
        assert(map['createUser'] != null),
        assert(map['createDate'] != null),
        comment = map['comment'],
        createUser = map['createUser'],
        createDate = map['createDate'];

  CommentData.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class CommentsData {
  final String comments;
  final Map<String, dynamic> commentsUser;
  final Timestamp createDate;
  final DocumentReference reference;

  CommentsData.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['comments'] != null),
        assert(map['commentsUser'] != null),
        assert(map['createDate'] != null),
        comments = map['comments'],
        commentsUser = map['commentsUser'],
        createDate = map['createDate'];

  CommentsData.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
