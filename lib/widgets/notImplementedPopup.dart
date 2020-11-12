import 'package:flutter/material.dart';

NotImplementedFunction(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("업데이트 예정"),
            content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  Text("아직 구현되지 않은 기능입니다."),
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

NotImplementedScreen(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("업데이트 예정"),
            content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  Text("아직 구현되지 않은 화면입니다."),
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

