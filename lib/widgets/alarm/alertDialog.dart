import 'package:flutter/material.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/provider/loginScreenChange.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/widgets/button.dart';

void showAlertDialog(BuildContext context, String title, String content){
  showDialog(
      context: context,
      builder: (BuildContext context) {

        LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

        return AlertDialog(
          title: Text(
            title,
            style: customStyle(20, "Bold", mainColor),
          ),
          content: Text(
            content,
            style: customStyle(18, "Regular", mainColor),
          ),
          actions: <Widget>[
            textBtn("Close", customStyle(18, "Regular", mainColor), () => Navigator.pop(context)),
            textBtn("OK", customStyle(18, "Regular", mainColor), () {Navigator.pop(context); loginScreenChangeProvider.setPageIndex(0);})
          ],
        );
      }
  );
}
