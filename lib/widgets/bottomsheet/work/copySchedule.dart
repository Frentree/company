import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();

CopySchedule({BuildContext context, double statusBarHeight}) async {
  bool result = false;
  Format _format = Format();

  int count = 5;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  User _loginUser;
  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String nowTime = _format.twoDigitsFormat(DateTime.now().hour) + ":" + _format.twoDigitsFormat(DateTime.now().minute);

  FirebaseRepository _repository = FirebaseRepository();

  await showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(pageRadiusW.w),
        topLeft: Radius.circular(pageRadiusW.w),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
      _loginUser = _loginUserInfoProvider.getLoginUser();
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height - 10.0.h - statusBarHeight,
                padding: EdgeInsets.only(
                  left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  top: 2.0.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
                    topRight: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
                  ),
                  color: whiteColor,
                ),
                child: Column(
                  children: [
                    Container(
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
                                color: mainColor,
                              ),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 6.0.h,
                                  decoration: BoxDecoration(
                                    color: chipColorBlue,
                                    borderRadius: BorderRadius.circular(
                                        SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    word.copySchedule(),
                                    style: defaultMediumStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    emptySpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Words.word.copyScheduleCon(),
                          style: hintStyle,
                        )
                      ],
                    ),
                    emptySpace,
                    StreamBuilder(
                      stream: _repository.getColleagueInfo(companyCode: _loginUser.companyCode),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if(snapshot.data == null){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return StreamBuilder(
                          stream: _repository.getCopyMyShedule(companyCode: _loginUser.companyCode, mail: _loginUser.mail, count: count),
                          builder: (BuildContext context, AsyncSnapshot snapshot){
                            if (snapshot.data == null) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            List<DocumentSnapshot> doc = snapshot.data.documents;

                            return Expanded(
                              child: CustomScrollView(
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                            (context, index) => _buildListItem(context, doc[index], _loginUser.companyCode),
                                        childCount: doc.length),
                                  ),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (context, index) => Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                emptySpace,
                                                Container(
                                                  height: 8.0.h,
                                                  width: double.infinity,
                                                  child: RaisedButton(
                                                    color: whiteColor,
                                                    elevation: 0.0,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          Words.word.nowScheduleBring(),
                                                          style: hintStyle,
                                                        ),
                                                        Icon(
                                                          Icons.keyboard_arrow_down_sharp,
                                                          color: grayColor,
                                                        )
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        count += 5;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                        childCount: 1),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
  return result;
}

Widget _buildListItem(BuildContext context, DocumentSnapshot document, String companyCode){
  return Text(document.data()["name"]);
}
