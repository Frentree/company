import 'dart:async';

import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/inquireModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SettingInquireDetail extends StatefulWidget {
  @override
  _SettingInquireDetailState createState() => _SettingInquireDetailState();
}

class _SettingInquireDetailState extends State<SettingInquireDetail> {
  User _loginUser;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentControll.text = "";
  }

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();


    Timer(
      Duration(milliseconds: 100),
          () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
    );
    return Scaffold(
      backgroundColor: whiteColor,
      body: _buildInquireBody(context, _loginUser, setState),
    );
  }
}

Widget _buildInquireBody(BuildContext context, User user, setState) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseRepository().getQnA(mail: user.mail),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

      return _buildInquireList(context, snapshot.data.docs, user, setState);
    },
  );
}

final TextEditingController _commentControll = TextEditingController();
final ScrollController _scrollController = ScrollController();

Widget _buildInquireList(BuildContext context, List<DocumentSnapshot> snapshot, User user, setState) {
  return Column(
    children: [
      Expanded(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => Card(
                        elevation: 0,
                        shape: cardShape,
                        child: Padding(
                          padding: cardPadding,
                          child: Container(
                            height: pageNameSizeT.h,
                            alignment: Alignment.center,
                            child: Text(
                              "사적인 광고나 부적절한 내용은 고객지원\n센터에서 답변을 드리지않습니다.\n빠른시간 내에 답변드리도록 노력하겠습니다.",
                              style: cardContentsStyle,
                            ),
                          ),
                        ),
                      ),
                  childCount: 1),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildInquireListItem(context, snapshot[index], user, setState), //_buildListItem(context, snapshot[index], user),
                  childCount: snapshot.length),
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              controller: _commentControll,
              style: defaultRegularStyle,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 4,
              /*textAlignVertical: TextAlignVertical.bottom,*/
              decoration: InputDecoration(
                isDense: true,
                contentPadding: textFormPadding,
                border: OutlineInputBorder(),
                hintText: "1:1 문의 내용을 입력해 주세요",
                hintStyle: hintStyle,
              ),
            ),
          ),
          cardSpace,
          CircleAvatar(
              radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
              backgroundColor: _commentControll.text == '' ? disableUploadBtn : blueColor,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.arrow_upward,
                  color: whiteColor,
                  size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                ),
                onPressed: () async {
                  InquireModel model = InquireModel(
                      chk: 0,
                      name: user.name,
                      mail: user.mail,
                      sender: user.mail,
                      content: _commentControll.text,
                      receiver: "",
                      createDate: Timestamp.now());
                  await FirebaseRepository().createQnA(model: model);
                  setState(() {
                    _commentControll.text = "";
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  });
                },
              ))
        ],
      ),
      emptySpace,
    ],
  );
}

Widget _buildInquireListItem(BuildContext context, DocumentSnapshot data, User user, setState) {
  final inquire = InquireModel.fromSnapshow(data);
  Format _format = Format();

  return (inquire.sender == user.mail)
      ? Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  (inquire.sender == user.mail)
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
                              "문의 삭제",
                              style: defaultMediumStyle,
                            ),
                            content: Text(
                              "문의 내용을 삭제 하시겠습니까?",
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
                                    inquire.reference.delete();
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
                  cardSpace,
                  Text(
                    _format.timeStampToTimes(inquire.createDate),
                    style: timeStyle
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Card(
                        color: Colors.yellow,
                        elevation: 0,
                        shape: converShape,
                        child: Container(
                          padding: EdgeInsets.all(3.0),
                          width: 170.0,
                          child: Text(inquire.content, style: cardContentsStyle),
                        )),
                  ),
                ],
              ),
            ),
          ],
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8.0.h,
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: chipColorPurple,
                radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                child: Image.asset("assets/images/launcher.png"),
              )
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "고객센터",
                        style: cardContentsStyle
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Card(
                        color: chipColorGreen,
                        elevation: 0,
                        shape: converShape,
                        child: Container(
                          padding: EdgeInsets.all(3.0),
                          alignment: Alignment.topLeft,
                          width: 170.0,
                          child: Text(inquire.content, style: cardContentsStyle),
                        ),
                      ),
                    ),

                  ],
                ),
                Text(
                    _format.timeStampToTimes(inquire.createDate),
                    style: timeStyle
                ),
              ],
            ),
          ],
      );
}
