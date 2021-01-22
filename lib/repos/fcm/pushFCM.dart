import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Fcm {
  final HttpsCallable sendFCM = FirebaseFunctions.instance
      .httpsCallable('sendFCM') // 호출할 Cloud Functions 의 함수명
    ..timeout = const Duration(seconds: 30);

  void sendFCMtoSelectedDevice(List<String> tokenList, String collection) async {
    print("함수 실행");
    final HttpsCallableResult result = await sendFCM.call(
      <String, dynamic>{
        "token": tokenList,
        "title": "Sample Title",
        "body": "This is a Sample FCM",
        /*"collection": collection,*/
      },
    );
  }
}







