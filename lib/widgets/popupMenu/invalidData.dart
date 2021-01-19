import 'package:flutter/material.dart';

InvalidData(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("데이터가 없습니다."),
            content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  Text("항목과 금액은 필수 입력 사항입니다."),
                  Text("Cancel 버튼을 클릭하여 종료해주세요"),
                ])),
            actions: <Widget>[
              FlatButton(
                child: Text("cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]);
      });
}

FailedData(BuildContext context, String title, String content) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  Text(content),
                ])),
            actions: <Widget>[
              FlatButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]);
      });
}