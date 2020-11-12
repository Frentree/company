import 'package:flutter/material.dart';

ChoiceImage(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("업데이트 예정"),
            content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
              Text("사진촬영 또는 갤러리에서 선택"),
              Text("OK 또는 Cancel 버튼 클릭으로 종료"),
            ])),
            actions: <Widget>[
              FlatButton(
                child: Text("ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]);
      });
}
