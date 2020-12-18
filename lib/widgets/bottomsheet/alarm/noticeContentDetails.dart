import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/attendanceModel.dart';
import 'package:MyCompany/models/commentListModel.dart';
import 'package:MyCompany/models/commentModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();

NoticeContentDetails(
    {BuildContext context,
    String companyCode,
    String noticeUid,
    String noticeTitle,
    String noticeContent,
    String noticeCreateDate,
    String noticeCreateUser}) {
  TextEditingController _noticeComment = TextEditingController();
  String _commentId = "";
  String commnetUser = "";
  int crudType = 0;

  CommentModel _commnetModel;
  CommentListModel _commentList;

  // 댓글 입력창 포커스
  FocusNode _commnetFocusNode = FocusNode();
  Attendance _attendance = Attendance();

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

        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 90.0.h,
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
                Expanded(
                  child: Text("aaa"),
                ),
                Expanded(
                  flex: 9,
                  child: Text("aaa"),
                ),
                Expanded(
                  child: Text("aaa"),
                ),
              ],
            )
          );
        });
      });

  Widget getCommentList({BuildContext context, List<DocumentSnapshot> documents, String documentID}) {}
}
