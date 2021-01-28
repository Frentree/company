import 'package:MyCompany/models/alarmModel.dart';
import 'package:MyCompany/repos/fcm/pushLocalAlarm.dart';
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

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];

      String collection = "";

      if(data["body"] == "work"){
        collection = "일정";
      }

      else if(data["body"] == "meeting"){
        collection = "회의 일정";
      }

      else{
        collection = "공지";
      }

      notificationPlugin.showNotification(
          alarmId: int.parse(data["alarmId"]),
          title: "새로운 알림",
          contents: data["title"] + "님이 새로운 " + collection + "를 등록 했습니다." ,
          payload: "alarm"
      );
    }
  }
}







