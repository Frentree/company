import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/material.dart';

final word = Words();

NotImplementedFunction(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          word.updateMessage(),
          style: defaultMediumStyle,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                word.updateFail(),
                style: defaultRegularStyle,
              ),
              Text(
                word.buttonCon(),
                style: defaultRegularStyle,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "cancel",
              style: buttonBlueStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

NotImplementedScreen(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          word.updateMessage(),
          style: defaultMediumStyle,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                word.updateFail(),
                style: defaultRegularStyle,
              ),
              Text(
                word.buttonCon(),
                style: defaultRegularStyle,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "cancel",
              style: buttonBlueStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
