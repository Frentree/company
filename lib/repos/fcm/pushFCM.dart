import 'package:MyCompany/models/alarmModel.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Fcm {
  final HttpsCallable sendFCM = FirebaseFunctions.instance
      .httpsCallable('sendFCM') // 호출할 Cloud Functions 의 함수명
    ..timeout = const Duration(seconds: 30);

  void sendFCMtoSelectedDevice(
      {List<String> tokenList,
      String team,
      String name,
      String position,
      String collection,
      String alarmId}) async {
    print("함수 실행");
    final HttpsCallableResult result = await sendFCM.call(
      <String, dynamic>{
        "token": tokenList,
        "team": team,
        "name": name,
        "position": position,
        "collection": collection,
        "alarmId": alarmId,
        /*"collection": collection,*/
      },
    );
  }

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];

      String collection = "";

      if(data["body"] == "work"){
        collection = "님이 새로운 일정을 등록했습니다.";
      }

      else if(data["body"].toString().split("@")[0] == "meeting"){
        collection = "님이 새로운 회의 일정을 등록했습니다.";

        if(DateTime.parse(data["body"].toString().split("@")[1]).isAfter(DateTime.now())){
          notificationPlugin.scheduleNotification(
            alarmId: int.parse(data["alarmId"]),
            alarmTime: DateTime.parse(data["body"].toString().split("@")[1]),
            title: "일정이 있습니다.",
            contents: "회의 : ${data["body"].toString().split("@")[2]}",
            payload: data["alarmId"],
          );
        }
      }

      else if(data["body"].toString().split("@")[0] == "meetingUpdate") {
        collection = "님이 회의 일정을 수정 했습니다.";

        await notificationPlugin.deleteNotification(alarmId: int.parse(data["alarmId"]));

        if(DateTime.parse(data["body"].toString().split("@")[1]).isAfter(DateTime.now())){
          notificationPlugin.scheduleNotification(
            alarmId: int.parse(data["alarmId"]),
            alarmTime: DateTime.parse(data["body"].toString().split("@")[1]),
            title: "일정이 있습니다.",
            contents: "회의 : ${data["body"].toString().split("@")[2]}",
            payload: data["alarmId"],
          );
        }
      }

      else if(data["body"].toString().split("@")[0] == "meetingDelete") {
        collection = "님이 ${data["body"].toString().split("@")[1]} 회의 일정을 삭제했습니다.";

        await notificationPlugin.deleteNotification(alarmId: int.parse(data["alarmId"]));
      }

      else if(data["body"] == "notice"){
        collection = "님이 새로운 공지를 등록했습니다.";
      }

      else if(data["body"] == "comment"){
        collection = "님이 공지에 댓글을 남겼습니다.";
      }

      else if(data["body"] == "comment2"){
        collection = "님이 내 댓글에 댓글을 남겼습니다.";
      }

      else if(data["body"] == "approvalWork"){
        collection = "님이 외근일정 결재를 요청하였습니다.";
      }

      else if(data["body"].toString().split("@")[0] == "approvalWorkOk"){
        collection = "님이 외근일정 결재를 수락했습니다.";

        if(DateTime.parse(data["body"].toString().split("@")[1]).isAfter(DateTime.now())){
          notificationPlugin.scheduleNotification(
            alarmId: int.parse(data["alarmId"]),
            alarmTime: DateTime.parse(data["body"].toString().split("@")[1]),
            title: "일정이 있습니다.",
            contents: "일정 내용 : ${data["body"].toString().split("@")[2]}",
            payload: data["alarmId"],
          );
        }
      }

      else if(data["body"] == "approvalWorkNo"){
        collection = "님이 외근일정 결재를 거절했습니다.";
      }

      else if(data["body"] == "expenseRequest"){
        collection = "님이 경비정산 결재를 요청했습니다.";
      }

      else if(data["body"] == "expenseAccept"){
        collection = "님이 경비정산 결재를 승인했습니다.";
      }

      else if(data["body"] == "expenseReject"){
        collection = "님이 경비정산 결재를 거절했습니다.";
      }

      else if(data["body"] == "requestWork"){
        collection = "님이 업무를 요청했습니다.";
      }

      else if(data["body"] == "requestWorkOk"){
        collection = "님이 업무요청을 수락했습니다.";
      }

      else if(data["body"] == "requestWorkNo"){
        collection = "님이 업무요청을 거절했습니다.";
      }

      else if(data["body"].toString().split("@")[0] == "annualLeave"){
        collection = "님이 " + data["body"].toString().split("@")[1] + "를 요청했습니다.";
      }

      else if(data["body"].toString().split("@")[0] == "annualLeaveOk"){
        collection = "님이 " + data["body"].toString().split("@")[1] + "결재를 수락했습니다.";
      }

      else if(data["body"].toString().split("@")[0] == "annualLeaveNo"){
        collection = "님이 " + data["body"].toString().split("@")[1] + "결재를 거절했습니다.";
      }

      notificationPlugin.showNotification(
          alarmId: int.parse(data["alarmId"]),
          title: "새로운 알림",
          contents: data["title"] + collection,
          payload: "alarm"
      );
    }
  }
}







