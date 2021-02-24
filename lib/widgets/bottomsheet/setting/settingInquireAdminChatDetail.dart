import 'dart:async';

import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/inquireAdminModel.dart';
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

class SettingInquireAdminChatDetail extends StatefulWidget {
  @override
  final model;
  SettingInquireAdminChatDetail({
    this.model
  });
  _SettingInquireDetailAdminChatState createState() => _SettingInquireDetailAdminChatState(model: model);
}

class _SettingInquireDetailAdminChatState extends State<SettingInquireAdminChatDetail> {
  final model;
  _SettingInquireDetailAdminChatState({
    this.model
  });
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
      body: _buildInquireBody(context, _loginUser, setState, model),
    );
  }
}

Widget _buildInquireBody(BuildContext context, User user, setState, InquireAdminModel model) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseRepository().getQnA(mail: model.mail),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

      return _buildInquireList(context, snapshot.data.docs, user, setState, model);
    },
  );
}

final TextEditingController _commentControll = TextEditingController();
final ScrollController _scrollController = ScrollController();

Widget _buildInquireList(BuildContext context, List<DocumentSnapshot> snapshot, User user, setState, InquireAdminModel userModel) {
  return Column(
    children: [
      Expanded(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
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
                hintText: "1:1 문의 답변 내용을 입력해주세요",
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
                      mail: userModel.mail,
                      name: userModel.name,
                      sender: user.mail,
                      content: _commentControll.text,
                      receiver: userModel.mail,
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
                  cardSpace,
                  Text(
                    _format.timeStampToTimes(inquire.createDate),
                    style: timeStyle
                  ),
                  GestureDetector(
                    child: Container(
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
                    onLongPress: (){
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              height: 80,
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 40.0.w : 30.0.w,
                              child: Column(
                                children: [
                                  InkWell(
                                    child: Container(
                                      width: double.infinity,
                                      height: 30,
                                      child: Center(child: Text("삭제"))
                                    ),
                                    onTap: () {
                                      inquire.reference.delete();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  emptySpace,
                                  InkWell(
                                    child: Container(
                                        width: double.infinity,
                                        height: 30,
                                        child: Center(child: Text("취소"))
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              )
                            ),
                          );
                        },
                      );
                    },
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
                child: Image.asset("assets/images/personal.png"),
              )
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "사용자",
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

