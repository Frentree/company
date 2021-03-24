
import 'package:MyCompany/models/alarmModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/meetingModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/repos/fcm/pushFCM.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingFunction {
  FirebaseRepository _repository = FirebaseRepository();
  Fcm fcm = Fcm();
  Format _format = Format();

  int repeatDate;

  MeetingModel model;
  User uesr;
  DateTime startTime;
  DateTime endTime;

  String title;


  MeetingFunction({
    this.model,
    this.repeatDate,
    this.startTime,
    this.endTime,
    this.uesr,
  });

  void updateMeeting() {

  }

  void addMeeting() async {
    var doc = await FirebaseFirestore.instance.collection("company").doc(uesr.companyCode).collection("user").doc(uesr.mail).get();
    CompanyUser loginUserInfo = CompanyUser.fromMap(doc.data(), doc.id);

    await _repository.saveMeeting(
      meetingModel: model,
      companyCode: uesr.companyCode,

    ).whenComplete(() async {
      Alarm _alarmModel = Alarm(
        alarmId: model.alarmId,
        createName: uesr.name,
        createMail: uesr.mail,
        collectionName: "meeting",
        alarmContents: loginUserInfo.team + " " + uesr.name + " " + loginUserInfo.position + "님이 새로운 " + "회의 일정" + "을 등록 했습니다.",
        read: false,
        alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
      );

      //알림 스케줄 등록
      if(startTime.isAfter(DateTime.now())){
        await notificationPlugin.scheduleNotification(
          alarmId: model.alarmId,
          alarmTime: startTime,
          title: "일정이 있습니다.",
          contents: "회의 : ${model.title}",
          payload: model.alarmId.toString(),
        );
      }

      //동료들 토큰 가져오기
      if(model.attendees != null){
        print(model.attendees.keys.toList().runtimeType);
        List<String> tokens = await _repository.getAttendeesTokens(companyCode: uesr.companyCode, mail: model.attendees.keys.toList());

        //알림 DB에 저장
        await _repository.saveAttendeesUserAlarm(
          alarmModel: _alarmModel,
          companyCode: uesr.companyCode,
          mail: model.attendees.keys.toList(),
        ).whenComplete(() async {
          //동료들에게 알림 보내기
          fcm.sendFCMtoSelectedDevice(
              alarmId: _alarmModel.alarmId.toString(),
              tokenList: tokens,
              name: uesr.name,
              team: loginUserInfo.team,
              position: loginUserInfo.position,
              collection: "meeting@${startTime}@${model.title}"
          );
        });
      }
    });
  }


}