import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/commentListModel.dart';
import 'package:companyplaylist/models/commentModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/firebasecrud/crudRepository.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class AlarmNoticeCommentPage extends StatelessWidget {
  final noticeUid;
  final noticeTitle;
  final noticeContent;
  final noticeCreateDate;

  AlarmNoticeCommentPage(
      {Key key, @required this.noticeUid,
        @required this.noticeTitle,
        @required this.noticeContent,
        @required this.noticeCreateDate});

  User _loginUser;

  TextEditingController _noticeComment = TextEditingController();

  Stream<QuerySnapshot> currentStream;
  CrudRepository _crudRepository;
  final Firestore _db = Firestore.instance;
  String _commentId = "";

  _getCommentList(List<DocumentSnapshot> documents, BuildContext context){
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
              IconButton(
                icon: Icon(Icons.subdirectory_arrow_right),
              ),
              GestureDetector(
                child: Container(
                  height: customHeight(context: context, heightSize: 0.06),
                  width: customWidth(context: context, widthSize: 0.1),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: whiteColor,
                      border: Border.all(color: blackColor, width: 2)),
                  child: Text(
                    "사진",
                    style: TextStyle(color: Colors.black),
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
                      documents[i].data['commentsUser']['name'].toString(),
                      style: customStyle(
                        fontColor: blackColor,
                        fontWeightName: 'Bold',
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(
                          DateTime.parse(documents[i].data['createDate'].toDate().toString())
                              .add(Duration(hours: 9))),
                      style:
                      customStyle(fontSize: 12, fontWeightName: 'Regular', fontColor: grayColor),
                    ),
                    Text(
                      documents[i].data['comments'].toString(),
                      style: customStyle(
                        fontColor: blackColor,
                        fontWeightName: 'Regular',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

    _crudRepository = CrudRepository.noticeCommentAttendance(companyCode: _loginUser.companyCode, documentID: noticeUid);
    currentStream = _crudRepository.fetchNoticeCommentAsStream();


    FocusNode _commnetFocusNode = FocusNode();

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.power_settings_new,
                size: customHeight(context: context, heightSize: 0.04),
              ),
              onPressed: () {
                null;
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("공지 사항"),
            ),
          ],
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            width: customWidth(context: context, widthSize: 0.2),
            child: GestureDetector(
              child: Container(
                height: customHeight(context: context, heightSize: 0.05),
                width: customWidth(context: context, widthSize: 0.1),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: whiteColor, border: Border.all(color: whiteColor, width: 2)),
                child: Text(
                  "사진",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              onTap: () {
                _loginUserInfoProvider.logoutUesr();
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: customHeight(context: context, heightSize: 0.02)),
              ),
              Container(
                height: customHeight(context: context, heightSize: 0.76),
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
                                      borderRadius: BorderRadius.circular(5), color: whiteColor, border: Border.all(color: blackColor, width: 2)),
                                  child: Text(
                                    "사진",
                                    style: TextStyle(color: Colors.black),
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
                        stream: _db.collection("company")
                            .document(_loginUser.companyCode)
                            .collection("notice")
                            .document(noticeUid)
                            .collection("comment")
                            .orderBy("createDate", descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          List<DocumentSnapshot> documents = snapshot.data.documents;

                          return ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: customHeight(
                                context: context,
                                heightSize: documents.length * 0.11
                              ),
                              maxHeight: customHeight(
                                  context: context,
                                  heightSize: documents.length * 0.5
                              ),
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
                                                  border: Border.all(color: blackColor, width: 2)),
                                              child: Text(
                                                "사진",
                                                style: TextStyle(color: Colors.black),
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
                                                documents[index].data['createUser']['name'].toString(),
                                                style: customStyle(
                                                  fontColor: blackColor,
                                                  fontWeightName: 'Bold',
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                documents[index].data['comment'].toString(),
                                                style: customStyle(
                                                  fontColor: blackColor,
                                                  fontWeightName: 'Regular',
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(
                                                        DateTime.parse(
                                                            documents[index].data['createDate'].toDate().toString()).add(Duration(hours: 9)
                                                        )
                                                    ),
                                                    style: customStyle(
                                                        fontSize: 12,
                                                        fontWeightName: 'Regular',
                                                        fontColor: grayColor),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    alignment: Alignment.topRight,
                                                    child: InkWell(
                                                      child: Text("댓글 달기",
                                                        style: customStyle(
                                                            fontColor: mainColor,
                                                            fontSize: 12,
                                                            fontWeightName: 'Medium'
                                                        ),
                                                      ),
                                                      onTap: (){
                                                        _commentId = documents[index].documentID;
                                                        print("_commentId >>> " + _commentId);
                                                        _noticeComment.text = documents[index].data['createUser']['name'].toString() + " ";
                                                        _commnetFocusNode.requestFocus();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      StreamBuilder(
                                        stream: _db.collection("company")
                                            .document(_loginUser.companyCode)
                                            .collection("notice")
                                            .document(noticeUid)
                                            .collection("comment").document(documents[index].documentID).collection("comments")
                                            .orderBy("createDate", descending: false)
                                            .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return CircularProgressIndicator();
                                            }
                                            List<DocumentSnapshot> documents = snapshot.data.documents;

                                            if (documents.length != 0) {
                                              return ConfigurableExpansionTile(
                                                animatedWidgetFollowingHeader: const Icon(
                                                  Icons.expand_more,
                                                  color: const Color(0xFF707070),
                                                ),
                                                headerExpanded: Text(
                                                  "댓글이 " + documents.length.toString() + "개가 있습니다.",
                                                  style: customStyle(fontSize: 12, fontWeightName: 'Regular'),
                                                ),
                                                header: Container(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                      "댓글이 " + documents.length.toString() + "개가 있습니다.",
                                                      style: customStyle(fontSize: 12, fontColor: blueColor, fontWeightName: 'Regular'),
                                                    )),
                                                children: <Widget>[
                                                  Container(
                                                      width: customWidth(context: context, widthSize: 1),
                                                      child: Column(
                                                        children: _getCommentList(documents, context),
                                                      ),
                                                  )

                                                    /*ListView.builder(
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemCount: documents.length,
                                                          itemBuilder: (context, index) {
                                                            return Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: customHeight(context: context, heightSize: 0.01),
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    IconButton(
                                                                      icon: Icon(Icons.subdirectory_arrow_right),
                                                                    ),
                                                                    GestureDetector(
                                                                      child: Container(
                                                                        height: customHeight(context: context, heightSize: 0.06),
                                                                        width: customWidth(context: context, widthSize: 0.1),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(5),
                                                                            color: whiteColor,
                                                                            border: Border.all(color: blackColor, width: 2)),
                                                                        child: Text(
                                                                          "사진",
                                                                          style: TextStyle(color: Colors.black),
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
                                                                            documents[index].data['commentsUser']['name'].toString(),
                                                                            style: customStyle(
                                                                              fontColor: blackColor,
                                                                              fontWeightName: 'Bold',
                                                                              fontSize: 13,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(
                                                                                DateTime.parse(documents[index].data['createDate'].toDate().toString())
                                                                                    .add(Duration(hours: 9))),
                                                                            style:
                                                                            customStyle(fontSize: 12, fontWeightName: 'Regular', fontColor: greyColor),
                                                                          ),
                                                                          Text(
                                                                            documents[index].data['comments'].toString(),
                                                                            style: customStyle(
                                                                              fontColor: blackColor,
                                                                              fontWeightName: 'Regular',
                                                                              fontSize: 13,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                      )*/
                                                ],
                                              );
                                            } else {
                                              return Text("");
                                            }
                                          }
                                      ),
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
              Container(
                height: customHeight(context: context, heightSize: 0.102),
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
                                      hintText: "댓글 입력하세요",
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
                                          Map<String, String> _commentMap = {
                                            "name": _loginUser.name,
                                            "mail": _loginUser.mail
                                          };
                                          if(_noticeComment.text.trim() != "") {
                                            if (_commentId.trim() == "") {
                                              print("답글 미선택 ====> " + _commentId);
                                              CommentModel _commnetModel = CommentModel(
                                                comment: _noticeComment.text,
                                                createUser: _commentMap,
                                                createDate: Timestamp.now(),
                                              );

                                              _db.collection("company")
                                                  .document(_loginUser.companyCode)
                                                  .collection("notice")
                                                  .document(noticeUid)
                                                  .collection("comment").add(_commnetModel.toJson());

                                              _noticeComment.text = "";
                                            } else {
                                              print("답글 선택 ====> " + _commentId);

                                              CommentListModel _commentList = CommentListModel(
                                                comments: _noticeComment.text,
                                                createDate: Timestamp.now(),
                                                commentsUser: _commentMap,
                                              );

                                              _db.collection("company")
                                                  .document(_loginUser.companyCode)
                                                  .collection("notice")
                                                  .document(noticeUid)
                                                  .collection("comment").document(_commentId).collection("comments").add(_commentList.toJson());

                                              _commentId = "";
                                              _noticeComment.text = "";
                                            }
                                          }
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
        ),
      ),
    );
  }
}
