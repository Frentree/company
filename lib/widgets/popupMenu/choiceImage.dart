import 'package:flutter/material.dart';

ChoiceImage(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Pop Up message"),
            content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
              Text("Alter Dialog Test"),
              Text("Click OK Button"),
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
