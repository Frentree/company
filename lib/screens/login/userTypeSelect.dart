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
          style: customStyle(
            fontSize: 18,
            fontWeightName: "Medium",
            fontColor: blueColor
          ),
        ),

        //공백
        SizedBox(
          height: customHeight(
            context: context,
            heightSize: 0.05,
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "회사를 생성 할 경우",
                    style: customStyle(
                      fontSize: 14,
                      fontWeightName: "Regular",
                      fontColor: grayColor,
                    ),
                  ),

                  SizedBox(
                    height: customHeight(
                      context: context,
                      heightSize: 0.01
                    ),
                  ),

                  userTypeSelectScreenRaisedBtn(
                    context: context,
                    btnColor: blueColor,
                    btnText:  "관리자",
                    btnTextColor: whiteColor,
                    btnAction: () => _companyScreenChangeProvider.setPageName("companyCreate"),
                  )
                ],
              ),
            ),

            //공백
            SizedBox(
              width: customWidth(
                context: context,
                widthSize: 0.08
              ),
            ),

            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    "생성된 회사에 합류",
                    style: customStyle(
                      fontSize: 14,
                      fontWeightName: "Regular",
                      fontColor: grayColor,
                    ),
                  ),

                  SizedBox(
                    height: customHeight(
                      context: context,
                      heightSize: 0.01,
                    ),
                  ),

                  userTypeSelectScreenRaisedBtn(
                    context: context,
                    btnColor: whiteColor,
                    btnText: "직원",
                    btnTextColor: blueColor,
                    btnAction: () => _companyScreenChangeProvider.setPageName("companyJoin")
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