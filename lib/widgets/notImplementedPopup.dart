import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/material.dart';

final word = Words();

NotImplementedFunction(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(word.updateMessage()),
            content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  Text(word.updateFail()),
                  Text(word.buttonCon()),
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
            title: Text(word.updateMessage()),
            content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  Text(word.updateFail()),
                  Text(word.buttonCon()),
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

