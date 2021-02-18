import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/inquireModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseMethod.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/widgets/dialog/organizationChartDialogList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SettingInquireDetail extends StatefulWidget {
  @override
  _SettingInquireDetailState createState() => _SettingInquireDetailState();
}

class _SettingInquireDetailState extends State<SettingInquireDetail> {
  User _loginUser;
  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();
    return Scaffold(
      backgroundColor: whiteColor,
      body: _buildInquireBody(context, _loginUser, setState),
    );
  }
}


Widget _buildInquireBody(BuildContext context, User user, setState) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseRepository().getQnA(
        mail: user.mail
    ),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

      return _buildInquireList(context, snapshot.data.docs, user, setState);
    },
  );
}

final TextEditingController _commentControll = TextEditingController();

Widget _buildInquireList(BuildContext context, List<DocumentSnapshot> snapshot, User user, setState) {
  return Column(
    children: [
      Expanded(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          Card(
                            elevation: 0,
                            shape: cardShape,
                            child: Padding(
                              padding: cardPadding,
                              child: Container(
                                height: popupMenuSizeT.h,
                                alignment: Alignment.center,
                                child: Text(
                                  "사적인 광고나 부적절한 내용은 고객지원\n센터에서 답변을 드리지않습니다.\n빠른시간 내에 답변드리도록 노력하겠습니다.",
                                  style: cardTitleStyle,
                                ),
                              ),
                            ),
                          ),
                  childCount: 1),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildInquireListItem(context, snapshot[index], user),//_buildListItem(context, snapshot[index], user),
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
                    createDate: Timestamp.now()
                  );
                  await FirebaseRepository().createQnA(model: model);
                  setState((){
                    _commentControll.text ="";
                  });
                },
              ))
        ],
      ),
      emptySpace,
    ],
  );
}

Widget _buildInquireListItem(BuildContext context, DocumentSnapshot data, User user) {
  final inquire= InquireModel.fromSnapshow(data);

  return Container(
    padding: cardPadding,
    child: (inquire.sender == user.mail) ?
    Container(
      width: 30.0,
      color: whiteColor,
      child: Card(
          elevation: 0,
          shape: cardShape,
          child: Text(inquire.content
          )
      ),
    ) :
    Container(
      width: 10.0,
      child: Card(
        elevation: 0,
        shape: cardShape,
        child: Container(
          width: 30.0,
          color: chipColorGreen,
          child: Text(inquire.content),
        ),
      ),
    ),

  );
}