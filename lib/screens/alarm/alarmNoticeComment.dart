import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlarmNoticeCommentPage extends StatelessWidget {
  final noticeUid;
  final noticeTitle;

  AlarmNoticeCommentPage({Key key, @required this.noticeUid, this.noticeTitle}) :super(key: key);

  User _loginUser;

  TextEditingController _noticeComment = TextEditingController();


  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();

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
                size: customHeight(
                    context: context,
                    heightSize: 0.04
                ),
              ),
              onPressed: (){
                null;
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                  "공지 사항"
              ),
            ),

          ],
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            width: customWidth(
                context: context,
                widthSize: 0.2
            ),
            child: GestureDetector(
              child: Container(
                height: customHeight(
                    context: context,
                    heightSize: 0.05
                ),
                width: customWidth(
                    context: context,
                    widthSize: 0.1
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: whiteColor,
                    border: Border.all(color: whiteColor, width: 2)
                ),
                child: Text(
                  "사진",
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
              ),
              onTap: (){
                _loginUserInfoProvider.logoutUesr();
              },
            ),
          ),
        ],
      ),
      body: Container(
        width: customWidth(
            context: context,
            widthSize: 1
        ),
        padding: EdgeInsets.only(
            left: customWidth(
              context: context,
              widthSize: 0.02,
            ),
            right: customWidth(
              context: context,
              widthSize: 0.02,
            )
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
            ),
            color: whiteColor
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: customHeight(
                      context: context,
                      heightSize: 0.02
                  )
              ),
            ),
            Container(
              height: customHeight(
                context: context,
                heightSize: 0.06
              ),
              child: Row(
                children: [

                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: whiteColor,
                        border: Border.all(color: whiteColor, width: 2)
                    ),
                    width: customWidth(
                        context: context,
                        widthSize: 0.16
                    ),
                    child: GestureDetector(
                      child: Container(
                        height: customHeight(
                            context: context,
                            heightSize: 0.05
                        ),
                        width: customWidth(
                            context: context,
                            widthSize: 0.1
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: whiteColor,
                            border: Border.all(color: blackColor, width: 2)
                        ),
                        child: Text(
                          "사진",
                          style: TextStyle(
                             color: Colors.black
                          ),
                        ),
                      ),
                      onTap: (){
                      },
                    ),
                  ),
                  Text(
                    _loginUser.name.toString(),
                    style: customStyle(
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                      fontSize: 15
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 10
                    ),
                  ),
                  Text(
                    noticeTitle,
                    style: customStyle(
                        fontColor: mainColor,
                        fontWeightName: 'Bold',
                        fontSize: 15
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: customHeight(
                  context: context,
                  heightSize: 0.02
              ),
            ),
            Container(
              height: customHeight(
                  context: context,
                  heightSize: 0.001
              ),
              width: double.infinity,
              color: greyColor,
            ),
            SizedBox(
              height: customHeight(
                  context: context,
                  heightSize: 0.02
              ),
            ),
            Container(
              height: customHeight(
                context: context,
                heightSize: 0.6
              ),
              width: double.infinity,
              child: SingleChildScrollView(
                child:StreamBuilder(
                  stream: null,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    List<DocumentSnapshot> documents =
                        snapshot.data.documents;

                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {

                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              height: customHeight(
                  context: context,
                  heightSize: 0.001
              ),
              width: double.infinity,
              color: greyColor,
            ),
            SizedBox(
              height: customHeight(
                  context: context,
                  heightSize: 0.02
              ),
            ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: customHeight(
                            context: context,
                            heightSize: 0.01
                        ),
                      ),
                      Container(
                        width: customWidth(
                          context: context,
                          widthSize: 0.7
                        ),
                        height: customHeight(
                            context: context,
                            heightSize: 0.1
                        ),
                        child: TextFormField(
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
                    ],
                  ),
                  Container(
                    width: customWidth(
                        context: context,
                        widthSize: 0.2
                    ),
                    height: customHeight(
                        context: context,
                        heightSize: 0.08
                    ),
                    child: CircleAvatar(
                        radius: 20,
                        backgroundColor: _noticeComment.text == ''
                            ? Colors.black12
                            : Colors.blue,
                        child: IconButton(
                          icon: Icon(Icons.arrow_upward),
                          onPressed: () {

                          },
                        )
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
