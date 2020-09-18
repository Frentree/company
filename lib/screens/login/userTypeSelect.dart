//Flutter
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Widget
import 'package:companyplaylist/widgets/button/raisedButton.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/screen/companyScreenChange.dart';

class UserTypeSelectPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    //화면 이동을 위한 Provider
    CompanyScreenChangeProvider _companyScreenChangeProvider = Provider.of<CompanyScreenChangeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "사용자 유형 선택",
          style: customStyle(18, "Medium", blueColor),
        ),

        //공백
        SizedBox(
          height: customHeight(context, 0.05),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "회사를 생성 할 경우",
                    style: customStyle(14, "Regular", greyColor),
                  ),

                  SizedBox(
                    height: customHeight(context, 0.01),
                  ),

                  userTypeSelectScreenRaisedBtn(
                    context,
                    blueColor,
                    "관리자",
                    whiteColor,
                    () => _companyScreenChangeProvider.setPageName("companyCreate")
                  )
                ],
              ),
            ),

            //공백
            SizedBox(
              width: customWidth(context, 0.08),
            ),

            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "생성된 회사에 합류",
                    style: customStyle(14, "Regular", greyColor),
                  ),

                  SizedBox(
                    height: customHeight(context, 0.01),
                  ),

                  userTypeSelectScreenRaisedBtn(
                    context,
                    whiteColor,
                    "직원",
                    blueColor,
                    null
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}