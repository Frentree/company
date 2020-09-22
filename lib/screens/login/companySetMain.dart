//Flutter
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:companyplaylist/provider/screen/companyScreenChange.dart';

//Screen
import 'package:companyplaylist/screens/login/userTypeSelect.dart';
import 'package:companyplaylist/screens/login/companyCreate.dart';
import 'package:companyplaylist/screens/login/companyJoin.dart';

class CompanySetMainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    CompanyScreenChangeProvider companyScreenChangeProvider = Provider.of<CompanyScreenChangeProvider>(context);

    Map<String,Widget> _page = {
      "userTypeSelect" : UserTypeSelectPage(),
      "companyCreate" : CompanyCreatePage(),
      "companyJoin" : CompanyJoinPage(),
    };

    return Scaffold(
      backgroundColor: mainColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: <Widget>[
            //상단 로고
            Container(
              width: customWidth(
                context: context,
                widthSize: 1
              ),
              height: customHeight(
                context: context,
                heightSize: 0.25,
              ),
              decoration: BoxDecoration(
                  color: mainColor
              ),

              //앱 이름 및 버전 표시
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: customHeight(
                      context: context,
                      heightSize: 0.1,
                    ),
                  ),
                  Text(
                    "슬기로운 회사생활",
                    style: customStyle(
                      fontSize: 20,
                      fontWeightName: "Bold",
                      fontColor: whiteColor,
                    ),
                  ),
                  SizedBox(
                    height: customHeight(
                      context: context,
                      heightSize: 0.05,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: customWidth(
                          context: context,
                          widthSize: 0.55,
                        ),
                      ),
                      Text(
                        "Release 0.1.0714",
                        style: customStyle(
                          fontSize: 18,
                          fontWeightName: "Regular",
                          fontColor: whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //하단
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: customHeight(
                    context: context,
                    heightSize: 0.03,
                  ),
                  left: customWidth(
                    context: context,
                    widthSize: 0.05
                  ),
                  right: customWidth(
                    context: context,
                    widthSize: 0.05,
                  )
                ),
                width: customWidth(
                  context: context,
                  widthSize: 1
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: whiteColor
                ),
                child: SingleChildScrollView(
                  child: _page[companyScreenChangeProvider.getPageName()],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}