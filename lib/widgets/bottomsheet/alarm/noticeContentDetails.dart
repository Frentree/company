import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/commentListModel.dart';
import 'package:MyCompany/models/commentModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();
// 댓글 입력창 포커스
final FocusNode _commnetFocusNode = FocusNode();
// 댓글 입력 타입
int crudType = 0;
String _commentId = "";
String commnetUser = "";
final TextEditingController _noticeComment = TextEditingController();

NoticeContentDetails(
    {BuildContext context,
    String companyCode,
    String noticeUid,
    String noticeTitle,
    String noticeContent,
    String noticeCreateDate,
    String noticeCreateUser}) {
  CommentModel _commnetModel;
  CommentListModel _commentList;

  User _loginUser;

  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(pageRadiusW.w),
          topLeft: Radius.circular(pageRadiusW.w),
        ),
      ),
      builder: (context) {
        LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
        _loginUser = _loginUserInfoProvider.getLoginUser();

        return SingleChildScrollView(
          child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
                height: 90.0.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 3.0.w,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(pageRadiusW.w),
                    topRight: Radius.circular(pageRadiusW.w),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10.0.w,
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: iconSizeW.w,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        FutureBuilder(
                          future: Firestore.instance.collection("company").doc(companyCode).collection("user").doc(noticeCreateUser).get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text("");
                            }

                            return Container(
                              width: 12.0.w,
                              child: Center(
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircleAvatar(
                                    backgroundColor: whiteColor,
                                    backgroundImage: NetworkImage(snapshot.data['profilePhoto']),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Column(
                          children: [
                            Container(
                              width: 50.0.w,
                              child: Text(
                                noticeTitle,
                                style: customStyle(
                                  fontSize: homePageDefaultFontSize.sp,
                                ),
                              ),
                            ),
                            Container(
                              width: 50.0.w,
                              child: Text(
                                noticeCreateDate,
                                style: customStyle(fontSize: 11.0.sp, fontWeightName: 'Regular', fontColor: grayColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 2.0.h),
                            ),
                            Container(
                              height: 65.0.h,
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
                                        stream:
                                            FirebaseRepository().getNoticeCommentList(companyCode: _loginUser.companyCode, documentID: noticeUid),
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
                                                    getCommentList(context: context, document: data, user: _loginUser, noticeID: noticeUid))
                                                .toList(),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                                            crudType == 1 ? commnetUser + " ${word.commentsTo()}" : "${word.commnetsUpate()}",
                                            style: customStyle(fontWeightName: 'Bold', fontColor: whiteColor, fontSize: 12.0.sp),
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
                                                  width: 80.0.w,
                                                  height: 6.0.h,
                                                  child: TextFormField(
                                                    focusNode: _commnetFocusNode,
                                                    textAlignVertical: TextAlignVertical.bottom,
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
                                                      backgroundColor: _noticeComment.text == '' ? Colors.black12 : Colors.blue,
                                                      child: IconButton(
                                                        padding: EdgeInsets.zero,
                                                        icon: Icon(
                                                          Icons.arrow_upward,
                                                          size: iconSizeW.w,
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
                                                                    companyCode: _loginUser.companyCode,
                                                                    noticeDocumentID: noticeUid,
                                                                    comment: _commnetModel);
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
                                                                } else if (crudType == 3) {
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
                      ],
                    ),
                  ],
                )
            );
          }),
        );
      });
}

Widget getCommentList({BuildContext context, DocumentSnapshot document, User user, noticeID}) {
  final comment = CommentData.fromSnapshow(document);
  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: FirebaseRepository().photoProfile(user.companyCode, comment.createUser['mail'].toString()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Icon(Icons.person_outline);
                  }
                  return SizedBox(
                    width: 40,
                    height: 40,
                    child: CircleAvatar(
                      backgroundColor: whiteColor,
                      backgroundImage: NetworkImage(snapshot.data['profilePhoto']),
                    ),
                  );
                },
              ),
              SizedBox(
                width: 1.0.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.createUser['name'].toString(),
                      style: customStyle(
                        fontColor: mainColor,
                        fontWeightName: 'Medium',
                        fontSize: cardTitleFontSize.sp,
                      ),
                    ),
                    Text(
                      comment.comment.toString(),
                      style: customStyle(
                        fontColor: mainColor,
                        fontWeightName: 'Regular',
                        fontSize: 12.0.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            Format().timeStampToDateTimeString(comment.createDate),
            style: customStyle(
              fontSize: 11.0.sp,
              fontWeightName: 'Regular',
              fontColor: grayColor,
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              children: [
                InkWell(
                  child: Text(
                    word.enterComments(),
                    style: customStyle(fontColor: blueColor, fontSize: 10.0.sp, fontWeightName: 'Medium'),
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
                SizedBox(width: 6.0.w),
                (comment.createUser['mail'].toString() == user.mail)
                    ? InkWell(
                        child: Text(
                          word.update(),
                          style: customStyle(fontColor: blueColor, fontSize: 10.0.sp, fontWeightName: 'Medium'),
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
                SizedBox(width: 6.0.w),
                (comment.createUser['mail'].toString() == user.mail)
                    ? InkWell(
                        child: Text(
                          word.delete(),
                          style: customStyle(fontColor: redColor, fontSize: 10.0.sp, fontWeightName: 'Medium'),
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
                      )
                    : SizedBox(),
              ],
            ),
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
                    size: 6.0.w,
                    color: const Color(0xFF707070),
                  ),
                  headerExpanded: Text(
                    "${word.commentsCountHeadCon()} " + commentsDoc.length.toString() + " ${word.commentsCountTailCon()}",
                    style: customStyle(fontSize: 10.0.sp, fontWeightName: 'Regular'),
                  ),
                  header: Container(
                      color: Colors.transparent,
                      child: Text(
                        "${word.commentsCountHeadCon()} " + commentsDoc.length.toString() + " ${word.commentsCountTailCon()}",
                        style: customStyle(fontSize: 10.0.sp, fontColor: blueColor, fontWeightName: 'Regular'),
                      )),
                  children: <Widget>[
                    Container(
                      width: 100.0.w,
                      child: Column(
                        children: commentsDoc
                            .map((data) =>
                                getCommentsList(context: context, document: data, noticeID: noticeID, user: user, documentID: comment.reference.id))
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
          SizedBox(
            height: 1.0.h,
          ),
        ],
      );
    },
  );
}

Widget getCommentsList({BuildContext context, DocumentSnapshot document, String documentID, User user, String noticeID}) {
  final comments = CommentsData.fromSnapshow(document);
  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 1.0.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 10.0.w,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 6.0.w,
                  icon: Icon(Icons.subdirectory_arrow_right),
                ),
              ),
              FutureBuilder(
                future: FirebaseRepository().photoProfile(user.companyCode, comments.commentsUser['mail'].toString()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Icon(Icons.person_outline);
                  }
                  return SizedBox(
                    width: 40,
                    height: 40,
                    child: CircleAvatar(
                      backgroundColor: whiteColor,
                      backgroundImage: NetworkImage(snapshot.data['profilePhoto']),
                    ),
                  );
                },
              ),
              SizedBox(
                width: 1.0.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        comments.commentsUser['name'].toString(),
                        style: customStyle(fontSize: cardTitleFontSize.sp, fontWeightName: 'Medium', fontColor: mainColor),
                      ),
                    ),
                    Text(
                      comments.comments.toString(),
                      style: customStyle(
                        fontColor: mainColor,
                        fontWeightName: 'Regular',
                        fontSize: 12.0.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 10.0.w),
              Column(
                children: [
                  Text(
                    Format().timeStampToDateTimeString(comments.createDate),
                    style: customStyle(
                      fontSize: 11.0.sp,
                      fontWeightName: 'Regular',
                      fontColor: grayColor,
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: Text(
                          word.enterComments(),
                          style: customStyle(fontColor: blueColor, fontSize: 10.0.sp, fontWeightName: 'Medium'),
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
                      SizedBox(width: 6.0.w),
                      (comments.commentsUser['mail'].toString() == user.mail)
                          ? InkWell(
                              child: Text(
                                word.delete(),
                                style: customStyle(fontColor: redColor, fontSize: 10.0.sp, fontWeightName: 'Medium'),
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
                            )
                          : SizedBox(),
                      SizedBox(width: 6.0.w),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: customHeight(context: context, heightSize: 0.01),
          ),
        ],
      );
    },
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
