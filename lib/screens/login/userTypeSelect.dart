//Flutter
import 'package:companyplaylist/widgets/notImplementedPopup.dart';
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Provider
import 'package:provider/provider.dart';

class UserTypeSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: heightRatio(
              context: context,
              heightRatio: 0.06,
            ),
            child: font(
              text: "사용자 유형 선택",
              textStyle: customStyle(
                fontWeightName: "Medium",
                fontColor: blueColor,
              ),
            ),
          ),
          Container(
            height: heightRatio(
              context: context,
              heightRatio: 0.03,
            ),
          ),
          Container(
            height: heightRatio(
              context: context,
              heightRatio: 0.24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: heightRatio(
                    context: context,
                    heightRatio: 0.13,
                  ),
                  width: widthRatio(
                    context: context,
                    widthRatio: 0.35,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: heightRatio(
                          context: context,
                          heightRatio: 0.045,
                        ),
                        width: widthRatio(
                          context: context,
                          widthRatio: 0.35
                        ),
                        child: font(
                          text: "새로운 회사 생성",
                          textStyle: customStyle(
                            fontWeightName: "Regular",
                            fontColor: grayColor,
                          ),
                        ),
                      ),
                      Container(
                        height: heightRatio(
                          context: context,
                          heightRatio: 0.025,
                        ),
                      ),
                      Container(
                        height: heightRatio(
                          context: context,
                          heightRatio: 0.06,
                        ),
                        width: widthRatio(
                          context: context,
                          widthRatio: 0.35
                        ),
                        child: RaisedButton(
                          color: blueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: whiteColor,
                            ),
                          ),
                          elevation: 0.0,
                          child: font(
                            text: "관리자",
                            textStyle: customStyle(
                              fontWeightName: "Medium",
                              fontColor: whiteColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/CompanyCreate");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: widthRatio(
                    context: context,
                    widthRatio: 0.1,
                  ),
                ),
                Container(
                  height: heightRatio(
                    context: context,
                    heightRatio: 0.13,
                  ),
                  width: widthRatio(
                    context: context,
                    widthRatio: 0.35,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: heightRatio(
                          context: context,
                          heightRatio: 0.045,
                        ),
                        width: widthRatio(
                            context: context,
                            widthRatio: 0.35
                        ),
                        child: font(
                          text: "생성된 회사 합류",
                          textStyle: customStyle(
                            fontWeightName: "Regular",
                            fontColor: grayColor,
                          ),
                        ),
                      ),
                      Container(
                        height: heightRatio(
                          context: context,
                          heightRatio: 0.025,
                        ),
                      ),
                      Container(
                        height: heightRatio(
                          context: context,
                          heightRatio: 0.06,
                        ),
                        width: widthRatio(
                            context: context,
                            widthRatio: 0.35
                        ),
                        child: RaisedButton(
                          color: whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: blueColor,
                            ),
                          ),
                          elevation: 0.0,
                          child: font(
                            text: "직원",
                            textStyle: customStyle(
                              fontWeightName: "Medium",
                              fontColor: blueColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/CompanyJoin");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: heightRatio(
              context: context,
              heightRatio: 0.025,
            ),
          ),
        ],
      ),
    );
  }
}
