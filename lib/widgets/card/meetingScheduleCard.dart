//Flutter
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/alarmModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/meetingModel.dart';
import 'package:MyCompany/repos/fcm/pushFCM.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
import 'package:MyCompany/widgets/bottomsheet/meeting/meetingMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:MyCompany/i18n/word.dart';

//Const
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:sizer/sizer.dart';

final word = Words();

Card meetingScheduleCard({BuildContext context, String loginUserMail, String companyCode, MeetingModel meetingModel, bool isDetail}) {
  return Card(
    elevation: 0,
    shape: cardShape,
    child: Padding(
        padding: cardPadding,
        child: isDetail
            ? meetingDetailContents(
                context: context,
                loginUserMail: loginUserMail,
                companyCode: companyCode,
                meetingModel: meetingModel,
                isDetail: isDetail,
              )
            : titleCard(
                context: context,
                loginUserMail: loginUserMail,
                companyCode: companyCode,
                meetingModel: meetingModel,
                isDetail: isDetail,
              )
    ),
  );
}

Container titleCard({BuildContext context, String loginUserMail, String companyCode, MeetingModel meetingModel, bool isDetail}) {
  Format _format = Format();

  return Container(
    height: scheduleCardDefaultSizeH.h,
    child: Row(
      children: [
        //시간대
        Container(
          width: SizerUtil.deviceType == DeviceType.Tablet ? 9.0.w : 12.0.w,
          child: Text(
            _format.timeToString(meetingModel.startTime),
            style: cardBlueStyle,
          ),
        ),
        //업무 타입입
        Container(
          width: SizerUtil.deviceType == DeviceType.Tablet ? 13.5.w : 18.0.w,
          height: 4.0.h,
          decoration:containerChipDecoration,
          padding: EdgeInsets.symmetric(
            horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
          ),
          alignment: Alignment.center,
          child: Text(
            word.meeting(),
            style: containerChipStyle,
          ),
        ),
        cardSpace,
        //제목
        Container(
          width: SizerUtil.deviceType == DeviceType.Tablet ? 53.5.w : 37.0.w,
          child: Text(
            meetingModel.title,
            style: containerMediumStyle,
          ),
        ),

        //popup 버튼
        meetingModel.createUid == loginUserMail ? isDetail ? popupMenu(
          context: context,
          meetingModel: meetingModel,
          companyCode: companyCode,
        ) : Container() : Container()
      ],
    ),
  );
}

Column meetingDetailContents({BuildContext context, String loginUserMail, String companyCode, MeetingModel meetingModel, bool isDetail}) {
  Format _format = Format();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      titleCard(context: context, companyCode: companyCode, loginUserMail: loginUserMail, meetingModel: meetingModel, isDetail: isDetail),
      emptySpace,
      Visibility(
        visible: meetingModel.contents != "",
        child: Padding(
          padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 9.75.w : 13.0.w),
          child: Text(
            meetingModel.contents,
            style: cardContentsStyle,
          ),
        ),
      ),
      Visibility(
        visible: meetingModel.contents != "",
        child: emptySpace,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            _format.dateToString(
                _format.timeStampToDateTime(meetingModel.lastModDate)),
            style: cardSubTitleStyle,
          ),
          Text(
            meetingModel.createDate == meetingModel.lastModDate ? " 작성됨" : " 수정됨",
            style: cardSubTitleStyle,
          ),
        ],
      ),
      Visibility(
        visible: meetingModel.createUid != loginUserMail,
        child: emptySpace,
      ),
      Visibility(
        visible: meetingModel.createUid != loginUserMail,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "작성자 : ",
              style: cardSubTitleStyle,
            ),
            Text(
              meetingModel.name,
              style: cardSubTitleStyle,
            )
          ],
        ),
      )
    ],
  );
}

Container popupMenu({BuildContext context, MeetingModel meetingModel, String companyCode}) {
  Format _format = Format();
  Fcm fcm = Fcm();
  FirebaseRepository _repository = FirebaseRepository();
  return Container(
    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
    alignment: Alignment.center,
    child: PopupMenuButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.more_vert_sharp,
        size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
      ),
      onSelected: (value) async {
        if (value == 1) {
          meetingMain(
            context: context,
            meetingModel: meetingModel,
          );
        } else {
          await _repository.deleteMeeting(
            documentID: meetingModel.id,
            companyCode: companyCode,
          ).whenComplete(() async {
            var doc = await FirebaseFirestore.instance.collection("company").doc(companyCode).collection("user").doc(meetingModel.createUid).get();
            CompanyUser loginUserInfo = CompanyUser.fromMap(doc.data(), doc.id);

            notificationPlugin.deleteNotification(alarmId: meetingModel.alarmId);
            Alarm _alarmModel = Alarm(
              alarmId: meetingModel.alarmId,
              createName: meetingModel.name,
              createMail: meetingModel.createUid,
              collectionName: "meetingDelete",
              alarmContents: loginUserInfo.team + " " + loginUserInfo.name + " " + loginUserInfo.position + "님이 " + "${meetingModel.title} 회의 일정을 삭제했습니다.",
              read: false,
              alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
            );

            if(meetingModel.attendees != null){
              List<String> tokens = await _repository.getAttendeesTokens(companyCode: companyCode, mail: meetingModel.attendees.keys.toList());

              await _repository.saveAttendeesUserAlarm(
                alarmModel: _alarmModel,
                companyCode: companyCode,
                mail: meetingModel.attendees.keys.toList(),
              ).whenComplete(() async {
                //동료들에게 알림 보내기
                fcm.sendFCMtoSelectedDevice(
                    alarmId: _alarmModel.alarmId.toString(),
                    tokenList: tokens,
                    name: loginUserInfo.name,
                    team: loginUserInfo.team,
                    position: loginUserInfo.position,
                    collection: "meetingDelete@${meetingModel.title}"
                );
              });
            }
           /* List<String> tokens = await _repository.getTokens(companyCode: companyCode, mail: meetingModel.createUid);

            await _repository.saveAlarm(
              alarmModel: _alarmModel,
              companyCode: companyCode,
              mail: meetingModel.createUid,
            ).whenComplete(() async {
              //동료들에게 알림 보내기
              fcm.sendFCMtoSelectedDevice(
                  alarmId: _alarmModel.alarmId.toString(),
                  tokenList: tokens,
                  name: loginUserInfo.name,
                  team: loginUserInfo.team,
                  position: loginUserInfo.position,
                  collection: "meetingDelete@${meetingModel.title}"
              );
            });*/


          });
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          height: 7.0.h,
          value: 1,
          child: Row(
            children: [
              Container(
                child: Icon(
                  Icons.edit,
                  size: SizerUtil.deviceType == DeviceType.Tablet ? popupMenuIconSizeTW.w : popupMenuIconSizeMW.w,
                ),
              ),
              Padding(padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w)),
              Text(
                word.update(),
                style: popupMenuStyle,
              )
            ],
          ),
        ),
        PopupMenuItem(
          height: 7.0.h,
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.delete,
                size: SizerUtil.deviceType == DeviceType.Tablet ? popupMenuIconSizeTW.w : popupMenuIconSizeMW.w,
              ),
              Padding(padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w)),
              Text(
                word.delete(),
                style: popupMenuStyle,
              )
            ],
          ),
        ),
      ],
    ),
  );
}
