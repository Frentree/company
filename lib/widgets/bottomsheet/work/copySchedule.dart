import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/meetingModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/bottomsheet/meeting/meetingMain.dart';
import 'package:MyCompany/widgets/bottomsheet/work/workContent.dart';
import 'package:MyCompany/widgets/card/meetingScheduleCard.dart';
import 'package:MyCompany/widgets/card/workScheduleCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();
bool result = false;
CopySchedule({BuildContext context, double statusBarHeight}) async {

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
                      stream: _repository.getCopyMyShedule(companyCode: _loginUser.companyCode, mail: _loginUser.mail, count: count),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                                delegate: SliverChildBuilderDelegate((context, index) => _buildListItem(context, doc[index], _loginUser.companyCode),
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
  final work = WorkData.fromSnapshow(document);
  Format _format = Format();
  bool subResult = false;

  return StatefulBuilder(
    builder: (context, setState) {
      return GestureDetector(
        child: Card(
          elevation: 0,
          shape: cardShape,
          child: Padding(
            padding: cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 9.0.w : 12.0.w,
                      child: Text(
                        _format.timeToString(work.startTime),
                        style: cardBlueStyle,
                      ),
                    ),
                    Container(
                      height: 4.0.h,
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 13.5.w : 18.0.w,
                      decoration: containerChipDecoration,
                      padding: EdgeInsets.symmetric(
                        horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        work.type == "내근" ? word.workIn() : work.type == "외근" ? word.workOut() : Words.word.meeting(),
                        style: containerChipStyle,
                      ),
                    ),
                    cardSpace,
                    Container(
                      width: work.type == "외근" ? SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 22.0.w : SizerUtil.deviceType == DeviceType.Tablet ? 53.5.w : 37.0.w,
                      child: Text(
                        work.title,
                        style: cardTitleStyle,
                      ),
                    ),
                    Visibility(
                      visible: work.type == "외근",
                      child: Container(
                        width: SizerUtil.deviceType == DeviceType.Tablet ? 15.5.w : 15.0.w,
                        child: Text(
                          work.location == "" ? "" : "[${work.location}]",
                          style: cardTitleStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                emptySpace,
                Visibility(
                  visible: work.contents != "",
                  child: Padding(
                    padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 9.75.w : 13.0.w),
                    child: Text(
                      work.contents,
                      style: cardContentsStyle,
                    ),
                  ),
                ),
                Visibility(
                  visible: work.contents != "",
                  child: emptySpace,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "작성일 " + _format.dateToString(_format.timeStampToDateTime(work.createDate)),
                      style: cardSubTitleStyle,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        onTap: () async {
          switch(work.type){
            case '내근':
              subResult = await workContent(context: context, type: 1, workData: work);
              break;

            case '외근':
              subResult = await workContent(context: context, type: 2, workData: work);
              break;

            case '미팅':
              subResult = await meetingMain(context: context, workData: work);
              break;
          }
          if (subResult) {
            result = true;
            Navigator.of(context).pop();
          };
        },
      );
    }
  );
}


class WorkData {
  final String contents;
  final String title;
  final String type;
  final Timestamp createDate;
  final Timestamp lastModDate;
  final Timestamp startDate;
  final Timestamp startTime;
  final String createUid;
  final int level;
  final int timeSlot;
  final String location;
  final String name;
  final DocumentReference reference;

  WorkData.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['contents'] != null),
         assert(map['title'] != null),
         assert(map['type'] != null),
         assert(map['createDate'] != null),
         assert(map['lastModDate'] != null),
         assert(map['startDate'] != null),
         assert(map['startTime'] != null),
         assert(map['createUid'] != null),
         assert(map['level'] != null),
         assert(map['timeSlot'] != null),
         assert(map['location'] != null),
         assert(map['name'] != null),
          contents = map['contents'],
          title = map['title'],
          type = map['type'],
          createDate = map['createDate'],
          lastModDate = map['lastModDate'],
          startDate = map['startDate'],
          startTime = map['startTime'],
          createUid = map['createUid'],
          timeSlot = map['timeSlot'],
          location = map['location'],
          name = map['name'],
          level = map['level'];

  WorkData.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
